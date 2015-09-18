//----------------------------------------------------------------------------
//      _____
//     *     *
//    *____   *____
//   * *===*   *==*
//  *___*===*___**  AVNET
//       *======*
//        *====*
//----------------------------------------------------------------------------
//
// This design is the property of Avnet.  Publication of this
// design is not authorized without written consent from Avnet.
//
// Please direct any questions to:  technical.support@avnet.com
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2013 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Jul 01, 2013
// Design Name:         ZedBoard ALI3 Controller Demonstration
// Module Name:         zed_ali3_controller_demo.c
// Project Name:        ZedBoard ALI3 Display Kit
// Target Devices:      Zynq-7000
// Hardware Boards:     ZedBoard + ALI3 Display Kit
//
// Tool versions:       Vivado 2015.2
//
// Description:         ZedBoard ALI3 Controller Demonstration
//
// Dependencies:
//
// Revision:            Jul 01, 2013: 1.00 Initial version
//						Mar 27, 2015: 1.01 Updated to remove
//                                         dependency upon
//                                         xbasic_types.h
//                      Sep 17, 2015: 1.02 Updated to support 2015.2 tools
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "xil_cache.h"

#include "zed_ali3_controller_demo.h"
#include "qspi_flash_polled.h"
#include "ps_gpio_polled.h"
#include "sleep.h"
#include "tmg120.h"
#include "user_interface.h"
#include "video_frame_buffer.h"
#include "xil_cache.h"
#include "zed_dip_case.h"
#include "zed_dip_off.h"
#include "zed_dip_on.h"
#include "zed_draw_pen_black.h"
#include "zed_led_off.h"
#include "zed_led_on.h"
#include "zed_logo_image.h"
#include "zed_pb_off.h"
#include "zed_pb_on.h"
#include "zed_system_config.h"
#include "zed_title_plate.h"
#include "zed_touch_target.h"

void TouchIsr(void *InstancePtr)
{
    // Cast the non-typed instance pointer to a demo instance type
    zed_ali3_controller_demo_t * pDemo = (zed_ali3_controller_demo_t *) InstancePtr;

    // Use the touch controller specific handler, to handle the incoming touch event.
    tmg120_handle_touch_event(pDemo);

    return;
}

/****************************************************************************/
/**
* This function sets up the interrupt system for the example.  The processing
* contained in this function assumes the hardware system was built with
* and interrupt controller.
*
* @param	None.
*
* @return	A status indicating XST_SUCCESS or a value that is contained in
*		xstatus.h.
*
* @note		None.
*
*****************************************************************************/
int zed_ali3_controller_demo_SetupInterruptSystem(zed_ali3_controller_demo_t *pDemo)
{
	int Result;

	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	pDemo->pIntcConfig = XScuGic_LookupConfig(pDemo->uDeviceId_IRQ_Touch);
	if (NULL == pDemo->pIntcConfig) {
		return XST_FAILURE;
	}

	Result = XScuGic_CfgInitialize(&(pDemo->Intc), pDemo->pIntcConfig,
			pDemo->pIntcConfig->CpuBaseAddress);
	if (Result != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XScuGic_SetPriorityTriggerType(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch,
					0xA0, 0x3);

	/*
	 * Connect the interrupt handler that will be called when an
	 * interrupt occurs for the device.
	 */
	Result = XScuGic_Connect(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch,
				 (Xil_ExceptionHandler)TouchIsr, pDemo);
	if (Result != XST_SUCCESS) {
		return Result;
	}

	/*
	 * Enable the PS interrupts for the touch controller hardware device.
	 */
	XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

	/*
	 * Initialize the exception table and register the interrupt
	 * controller handler with the exception table
	 */
	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)XScuGic_InterruptHandler, &(pDemo->Intc));

	/* Enable non-critical exceptions */
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

int zed_ali3_controller_demo_board_process(zed_ali3_controller_demo_t *pDemo)
{
	static int32u cbars_offset = 0;

	/*
     * Check to see if the user is pressing USR (SW1) push button to cycle
     * through demo modes.
     */
    if (ps_gpio_get_mio_state(pDemo, 51) == 1)
    {
        /*
         * If currently in draw mode, then switch to control mode and draw
         * the control panel.
         *
         * If currently in control mode, then switch to draw mode and show
         * the colorbars screen.
         */
        if (pDemo->mode == draw)
        {
            pDemo->mode = control;

            // Draw the control panel.
            zed_ali3_controller_demo_control(pDemo);
        }
        else if (pDemo->mode == control)
        {
            pDemo->mode = draw;

            // Draw the colorbars screen.
            zed_ali3_controller_demo_cbars(pDemo, cbars_offset++);
        }

        /*
         * Force a small wait to debounce the button inputs.
         */
        millisleep(500);
    }

    /*
     * If in control mode, handle the on-screen controls.
     */
    if (pDemo->mode == control)
    {
        // Check board input on BTN1
        if ((pDemo->button0_state == 0) && (ps_gpio_get_button(pDemo, 0) == 1))
        {
            // Old state was off, but new state is on.
            zed_ali3_controller_demo_button(pDemo, 0, 1);
            if (pDemo->bVerbose)
            {
                xil_printf("Registered ON event on BTNC control.\n\r");
            }
        }
        else if ((pDemo->button0_state == 1) && (ps_gpio_get_button(pDemo, 0) == 0))
        {
            // Old state was on, but new state is off.
            zed_ali3_controller_demo_button(pDemo, 0, 0);

            if (pDemo->bVerbose)
            {
                xil_printf("Registered OFF event on BTNC control.\n\r");
            }
        }

        // Check board input on BTN2
        if ((pDemo->button1_state == 0) && (ps_gpio_get_button(pDemo, 1) == 1))
        {
            // Old state was off, but new state is on.
            zed_ali3_controller_demo_button(pDemo, 1, 1);
            if (pDemo->bVerbose)
            {
                xil_printf("Registered ON event on BTND control.\n\r");
            }
        }
        else if ((pDemo->button1_state == 1) && (ps_gpio_get_button(pDemo, 1) == 0))
        {
            // Old state was on, but new state is off.
            zed_ali3_controller_demo_button(pDemo, 1, 0);

            if (pDemo->bVerbose)
            {
                xil_printf("Registered OFF event on BTND control.\n\r");
            }
        }

        // Check board input on BTN3
        if ((pDemo->button2_state == 0) && (ps_gpio_get_button(pDemo, 2) == 1))
        {
            // Old state was off, but new state is on.
            zed_ali3_controller_demo_button(pDemo, 2, 1);
            if (pDemo->bVerbose)
            {
                xil_printf("Registered ON event on BTNL control.\n\r");
            }
        }
        else if ((pDemo->button2_state == 1) && (ps_gpio_get_button(pDemo, 2) == 0))
        {
            // Old state was on, but new state is off.
            zed_ali3_controller_demo_button(pDemo, 2, 0);

            if (pDemo->bVerbose)
            {
                xil_printf("Registered OFF event on BTNL control.\n\r");
            }
        }

        // Check board input on BTN4
        if ((pDemo->button3_state == 0) && (ps_gpio_get_button(pDemo, 3) == 1))
        {
            // Old state was off, but new state is on.
            zed_ali3_controller_demo_button(pDemo, 3, 1);
            if (pDemo->bVerbose)
            {
                xil_printf("Registered ON event on BTNR control.\n\r");
            }
        }
        else if ((pDemo->button3_state == 1) && (ps_gpio_get_button(pDemo, 3) == 0))
        {
            // Old state was on, but new state is off.
            zed_ali3_controller_demo_button(pDemo, 3, 0);

            if (pDemo->bVerbose)
            {
                xil_printf("Registered OFF event on BTNR control.\n\r");
            }
        }

        // Check board input on SW1_1
        if ((pDemo->switch0_state == 0) && (ps_gpio_get_switch(pDemo, 0) == 1))
        {
            // Old state was off, but new state is on.
            zed_ali3_controller_demo_switch(pDemo, 0, 1);
            if (pDemo->bVerbose)
            {
                xil_printf("Registered ON event on SW0 control.\n\r");
            }
        }
        else if ((pDemo->switch0_state == 1) && (ps_gpio_get_switch(pDemo, 0) == 0))
        {
            // Old state was on, but new state is off.
            zed_ali3_controller_demo_switch(pDemo, 0, 0);

            if (pDemo->bVerbose)
            {
                xil_printf("Registered OFF event on SW0 control.\n\r");
            }
        }

        // Check board input on SW1_2
        if ((pDemo->switch1_state == 0) && (ps_gpio_get_switch(pDemo, 1) == 1))
        {
            // Old state was off, but new state is on.
            zed_ali3_controller_demo_switch(pDemo, 1, 1);
            if (pDemo->bVerbose)
            {
                xil_printf("Registered ON event on SW1 control.\n\r");
            }
        }
        else if ((pDemo->switch1_state == 1) && (ps_gpio_get_switch(pDemo, 1) == 0))
        {
            // Old state was on, but new state is off.
            zed_ali3_controller_demo_switch(pDemo, 1, 0);

            if (pDemo->bVerbose)
            {
                xil_printf("Registered OFF event on SW1 control.\n\r");
            }
        }

        // Check board input on SW1_3
        if ((pDemo->switch2_state == 0) && (ps_gpio_get_switch(pDemo, 2) == 1))
        {
            // Old state was off, but new state is on.
            zed_ali3_controller_demo_switch(pDemo, 2, 1);
            if (pDemo->bVerbose)
            {
                xil_printf("Registered ON event on SW2 control.\n\r");
            }
        }
        else if ((pDemo->switch2_state == 1) && (ps_gpio_get_switch(pDemo, 2) == 0))
        {
            // Old state was on, but new state is off.
            zed_ali3_controller_demo_switch(pDemo, 2, 0);

            if (pDemo->bVerbose)
            {
                xil_printf("Registered OFF event on SW2 control.\n\r");
            }
        }

        // Check board input on SW1_4
        if ((pDemo->switch3_state == 0) && (ps_gpio_get_switch(pDemo, 3) == 1))
        {
            // Old state was off, but new state is on.
            zed_ali3_controller_demo_switch(pDemo, 3, 1);
            if (pDemo->bVerbose)
            {
                xil_printf("Registered ON event on SW3 control.\n\r");
            }
        }
        else if ((pDemo->switch3_state == 1) && (ps_gpio_get_switch(pDemo, 3) == 0))
        {
            // Old state was on, but new state is off.
            zed_ali3_controller_demo_switch(pDemo, 3, 0);

            if (pDemo->bVerbose)
            {
                xil_printf("Registered OFF event on SW3 control.\n\r");
            }
        }
    }
    return 0;
}

int zed_ali3_controller_demo_button(zed_ali3_controller_demo_t *pDemo, int button_number, int button_state)
{
    interface_graphic_t graphic;

    // Update the user interface to match the button state change.
    if (button_number == 0)
    {
    	pDemo->button0_state = button_state;

    	graphic.location_x = BUTTON0_POSITION_X;
        graphic.location_y = BUTTON0_POSITION_Y;
    }
    else if (button_number == 1)
    {
        pDemo->button1_state = button_state;

        graphic.location_x = BUTTON1_POSITION_X;
	    graphic.location_y = BUTTON1_POSITION_Y;
    }
    else if (button_number == 2)
    {
        pDemo->button2_state = button_state;

        graphic.location_x = BUTTON2_POSITION_X;
        graphic.location_y = BUTTON2_POSITION_Y;
    }
    else if (button_number == 3)
    {
        pDemo->button3_state = button_state;

        graphic.location_x = BUTTON3_POSITION_X;
        graphic.location_y = BUTTON3_POSITION_Y;
    }
    else
    {
        return -1;
    }

    // Determine the ON/OFF state graphic to be shown.
    if (button_state == 0)
    {
        // Draw the switch off state.
        graphic.default_image_data = avnet_control_pb_off;
        graphic.alternate_image_data = avnet_control_pb_on;

        // All the switch images have the same OFF width.
        graphic.size_x = avnet_control_pb_off_width;
        graphic.size_y = avnet_control_pb_off_height;
    }
    else if (button_state == 1)
    {
        // Draw the switch on state.
        graphic.default_image_data = avnet_control_pb_on;
        graphic.alternate_image_data = avnet_control_pb_off;

        // All the switch images have the same ON width.
        graphic.size_x = avnet_control_pb_on_width;
        graphic.size_y = avnet_control_pb_on_height;
    }
    else
    {
        return -1;
    }

    // Check to see how the touch event should be handled.
    if (pDemo->mode == control)
    {
        // Draw the button graphic to the display.
        draw_image_data(pDemo, &graphic);

        // Wait for DMA to synchronize.
        Xil_DCacheFlush();
    }

    return 0;
}

int zed_ali3_controller_demo_check_calibrate_request(zed_ali3_controller_demo_t *pDemo)
{
    /*
     * Check to see if both MicroZed USR button (SW1) is being held down
     * during startup to request calibration.
     */
    if ((ps_gpio_get_mio_state(pDemo, 51) == 1) ||
        (pDemo->calibration_success == 0))
    {
    	// Force touch calibration to begin.
    	zed_ali3_controller_demo_touch_calibrate(pDemo);
    }

    return 0;
}

int zed_ali3_controller_demo_control(zed_ali3_controller_demo_t *pDemo)
{
    // Fill frame stores with color bars
    uint32_t frame, row, col;
    uint32_t pixel;
    interface_graphic_t graphic;
    volatile uint32_t *pStorageMem = (uint32_t *)pDemo->uBaseAddr_MEM_FrameBuffer;
    for (frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++)
    {
       for (row = 0; row < pDemo->ali3_height; row++)
       {
          for (col = 0; col < pDemo->ali3_width; col++)
          {
             pixel = 0x00373333; // DarkGray
             *pStorageMem++ = pixel;
          }
       }
    }

    // Set the demo mode to control.
    pDemo->mode = control;

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    // Write the control panel background color data to the display.
    pStorageMem = (uint32_t *)pDemo->uBaseAddr_MEM_FrameBuffer;

    // Draw user interface to the display.
    graphic.location_x = 21;
    graphic.location_y = 20;
    graphic.size_x = avnet_control_title_plate_width;
    graphic.size_y = avnet_control_title_plate_height;
    graphic.default_image_data = avnet_control_title_plate;
    draw_image_data(pDemo, &graphic);

    /*
     * Draw the dip switch case.
     */
    graphic.location_x = SWITCH_CASE_POSITION_X;
    graphic.location_y = SWITCH_CASE_POSITION_Y;
    graphic.size_x = avnet_control_dip_case_width;
    graphic.size_y = avnet_control_dip_case_height;
    graphic.default_image_data = avnet_control_dip_case;
    draw_image_data(pDemo, &graphic);
    
    /*
     * Draw the PL push button indicators.
     */
    zed_ali3_controller_demo_button(pDemo, 0, pDemo->button0_state);
    zed_ali3_controller_demo_button(pDemo, 1, pDemo->button1_state);
    zed_ali3_controller_demo_button(pDemo, 2, pDemo->button2_state);
    zed_ali3_controller_demo_button(pDemo, 3, pDemo->button3_state);

    /*
     * Draw the PL LED indicators.
     */
    zed_ali3_controller_demo_led(pDemo, 0, pDemo->led0_state);
	zed_ali3_controller_demo_led(pDemo, 1, pDemo->led1_state);
	zed_ali3_controller_demo_led(pDemo, 2, pDemo->led2_state);
	zed_ali3_controller_demo_led(pDemo, 3, pDemo->led3_state);
	zed_ali3_controller_demo_led(pDemo, 4, pDemo->led4_state);
	zed_ali3_controller_demo_led(pDemo, 5, pDemo->led5_state);
	zed_ali3_controller_demo_led(pDemo, 6, pDemo->led6_state);
	zed_ali3_controller_demo_led(pDemo, 7, pDemo->led7_state);

    /*
     * Draw the PL switch indicators.
     */
    zed_ali3_controller_demo_switch(pDemo, 0, pDemo->switch0_state);
    zed_ali3_controller_demo_switch(pDemo, 1, pDemo->switch1_state);
    zed_ali3_controller_demo_switch(pDemo, 2, pDemo->switch2_state);
    zed_ali3_controller_demo_switch(pDemo, 3, pDemo->switch3_state);

	// Wait for DMA to synchronize.
	Xil_DCacheFlush();

	return 0;
}

int zed_ali3_controller_demo_init(zed_ali3_controller_demo_t *pDemo)
{
    int ret;
    interface_graphic_t graphic;

    xil_printf("\n\r");
    xil_printf("------------------------------------------------------\n\r");
    xil_printf("--                Zed Display Kit                   --\n\r");
    xil_printf("--           ALI3 Controller Demonstration          --\n\r");
    xil_printf("--             Standalone Application               --\n\r");
    xil_printf("------------------------------------------------------\n\r");
    xil_printf("\n\r");

    // Blank the screen,
    draw_blank_screen(pDemo, COLOR_BLACK);

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    // Draw the system configuration graphic to the display.
    graphic.location_x = 400 - (avnet_control_system_config_width / 2);  // Centered on graphic
    graphic.location_y = 240 - (avnet_control_system_config_height / 2);  // Centered on graphic
    graphic.size_x = avnet_control_system_config_width;
    graphic.size_y = avnet_control_system_config_height;
    graphic.default_image_data = avnet_control_system_config;
    draw_image_data(pDemo, &graphic);

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    // Initialize Output Side of AXI VDMA
    xil_printf("Video DMA (Output Side) Initialization ...\n\r");
    vfb_common_init(
        pDemo->uDeviceId_VDMA_FrameBuffer, // uDeviceId
        &(pDemo->vdma_ali3)                // pAxiVdma
        );
    vfb_tx_init(
        &(pDemo->vdma_ali3),               // pAxiVdma
        &(pDemo->vdmacfg_ali3_read),       // pReadCfg
        pDemo->ali3_resolution,            // uVideoResolution
        pDemo->ali3_resolution,            // uStorageResolution
        pDemo->uBaseAddr_MEM_FrameBuffer,  // uMemAddr
        pDemo->uNumFrames_FrameBuffer      // uNumFrames
        );

    /*
     * Initialize the QSPI flash and load any stored touch screen calibration
     * values.
     */
    if (qspi_flash_polled_init() != 0)
    {
        xil_printf("ERROR : Failed to open QSPI driver\n\r");
    }

    /*
     * Load the touch calibration data from flash memory.
     */
    if (qspi_flash_load_calibration_data(pDemo) != 0)
    {
        xil_printf("No Valid Calibration Data Found in Flash\n\r");

        /*
         * Cause touch calibration to occur after init() finishes.
         */
        pDemo->calibration_success = 0;
    }
    else
    {
    	pDemo->calibration_success = 1;
    }

    // IIC Initialization for touch controller
    xil_printf("I2C Touch Controller Initialization ...\n\r");
    ret = zed_iic_axi_init(&(pDemo->touch_iic),"ALI3 Touch I2C Controller", pDemo->uBaseAddr_IIC_Touch);

    if (!ret)
    {
        xil_printf("ERROR : Failed to open ZED-IIC driver\n\r");
        return -1;
    }

    // Initialize the touch controller and prepare the event handler.
    tmg120_initialize(pDemo);

    // Setup the interrupt handling for the touch controller.
    zed_ali3_controller_demo_SetupInterruptSystem(pDemo);

    // Enable the touch controller to begin detecting touch input.
    tmg120_enable_touch(pDemo);

    // Initialize the GPIO interfaces.
    pDemo->button0_state = 0;
    pDemo->button1_state = 0;
    pDemo->button2_state = 0;
    pDemo->button3_state = 0;

    pDemo->led0_state = 0;
    pDemo->led1_state = 0;
    pDemo->led2_state = 0;
    pDemo->led3_state = 0;
    pDemo->led4_state = 0;
    pDemo->led5_state = 0;
    pDemo->led6_state = 0;
    pDemo->led7_state = 0;

    pDemo->switch0_state = 0;
    pDemo->switch1_state = 0;
    pDemo->switch2_state = 0;
    pDemo->switch3_state = 0;

    zed_ali3_controller_demo_button(pDemo, 0, pDemo->button0_state);
    zed_ali3_controller_demo_button(pDemo, 1, pDemo->button1_state);
    zed_ali3_controller_demo_button(pDemo, 2, pDemo->button2_state);
    zed_ali3_controller_demo_button(pDemo, 3, pDemo->button3_state);

    zed_ali3_controller_demo_led(pDemo, 0, pDemo->led0_state);
    zed_ali3_controller_demo_led(pDemo, 1, pDemo->led1_state);
    zed_ali3_controller_demo_led(pDemo, 2, pDemo->led2_state);
    zed_ali3_controller_demo_led(pDemo, 3, pDemo->led3_state);
    zed_ali3_controller_demo_led(pDemo, 4, pDemo->led4_state);
    zed_ali3_controller_demo_led(pDemo, 5, pDemo->led5_state);
    zed_ali3_controller_demo_led(pDemo, 6, pDemo->led6_state);
    zed_ali3_controller_demo_led(pDemo, 7, pDemo->led7_state);

    zed_ali3_controller_demo_switch(pDemo, 0, pDemo->switch0_state);
    zed_ali3_controller_demo_switch(pDemo, 1, pDemo->switch1_state);
    zed_ali3_controller_demo_switch(pDemo, 2, pDemo->switch2_state);
    zed_ali3_controller_demo_switch(pDemo, 3, pDemo->switch3_state);

    // Set the mode to draw by default.
    pDemo->mode = draw;

    return 0;
}

int zed_ali3_controller_demo_cbars(zed_ali3_controller_demo_t *pDemo, int32u offset)
{
    int32u frame, row, col;
    int32u cbar, pixel;
    volatile int32u *pStorageMem = (int32u *)pDemo->uBaseAddr_MEM_FrameBuffer;

    for (frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++)
    {
        for (row = 0; row < pDemo->ali3_height; row++)
        {
            for (col = 0; col < pDemo->ali3_width; col++)
            {
                cbar = (col * 8) / pDemo->ali3_width; // color bar = 0..7
                cbar = (cbar + offset) % 8;

                switch (cbar)
                {
                    case 0: pixel = 0x00000000; // Black
                    break;

                    case 1: pixel = 0x00FF0000; // Red
                    break;

                    case 2: pixel = 0x0000FF00; // Green
                    break;

                    case 3: pixel = 0x000000FF; // Blue
                    break;

                    case 4: pixel = 0x0000FFFF; // Cyan
                    break;

                    case 5: pixel = 0x00FF00FF; // Magenta
                    break;

                    case 6: pixel = 0x00FFFF00; // Yellow
                    break;

                    case 7: pixel = 0x00FFFFFF; // White
                    break;
                }

                *pStorageMem++ = pixel;
            }
        }
    }

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    // Set the mode to draw.
    pDemo->mode = draw;

    return 0;
}

int zed_ali3_controller_demo_led(zed_ali3_controller_demo_t *pDemo, int led_number, int led_state)
{
    interface_graphic_t graphic;

    // Update the LED hardware on the board.
    ps_gpio_set_led(pDemo, led_number, led_state);

    // Update the user interface to match the LED state change.
    if (led_number == 0)
    {
    	pDemo->led0_state = led_state;

    	graphic.location_x = LED0_POSITION_X;
        graphic.location_y = LED0_POSITION_Y;
    }
    else if (led_number == 1)
    {
        pDemo->led1_state = led_state;

        graphic.location_x = LED1_POSITION_X;
	    graphic.location_y = LED1_POSITION_Y;
    }
    else if (led_number == 2)
    {
        pDemo->led2_state = led_state;

        graphic.location_x = LED2_POSITION_X;
        graphic.location_y = LED2_POSITION_Y;
    }
    else if (led_number == 3)
    {
        pDemo->led3_state = led_state;

        graphic.location_x = LED3_POSITION_X;
        graphic.location_y = LED3_POSITION_Y;
    }
    else if (led_number == 4)
    {
        pDemo->led4_state = led_state;

        graphic.location_x = LED4_POSITION_X;
        graphic.location_y = LED4_POSITION_Y;
    }
    else if (led_number == 5)
    {
        pDemo->led5_state = led_state;

        graphic.location_x = LED5_POSITION_X;
        graphic.location_y = LED5_POSITION_Y;
    }
    else if (led_number == 6)
    {
        pDemo->led6_state = led_state;

        graphic.location_x = LED6_POSITION_X;
        graphic.location_y = LED6_POSITION_Y;
    }
    else if (led_number == 7)
    {
        pDemo->led7_state = led_state;

        graphic.location_x = LED7_POSITION_X;
        graphic.location_y = LED7_POSITION_Y;
    }
    else
    {
        return -1;
    }

    // Determine the ON/OFF state graphic to be shown.
    if (led_state == 0)
    {
        // Draw the LED off state.
        graphic.default_image_data = avnet_control_led_off;
        graphic.alternate_image_data = avnet_control_led_on;

        // All the LED images have the same OFF width.
        graphic.size_x = avnet_control_led_off_width;
        graphic.size_y = avnet_control_led_off_height;
    }
    else if (led_state == 1)
    {
        // Draw the LED on state.
        graphic.default_image_data = avnet_control_led_on;
        graphic.alternate_image_data = avnet_control_led_off;

        // All the LED images have the same ON width.
        graphic.size_x = avnet_control_led_on_width;
        graphic.size_y = avnet_control_led_on_height;
    }
    else
    {
        return -1;
    }

    // Check to see how the touch event should be handled.
    if (pDemo->mode == control)
    {
        // Draw the LED graphic to the display.
        draw_image_data(pDemo, &graphic);

        // Wait for DMA to synchronize.
        Xil_DCacheFlush();
    }

    return 0;
}

int zed_ali3_controller_demo_logo(zed_ali3_controller_demo_t *pDemo)
{
    // Fill frame stores with logo image data.
    uint32_t frame, row, col;
    uint32_t pixel;
    volatile uint32_t *pStorageMem = (uint32_t *)pDemo->uBaseAddr_MEM_FrameBuffer;

    for (frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++)
    {
        for (row = 0; row < pDemo->ali3_height; row++)
        {
            for (col = 0; col < pDemo->ali3_width; col++)
            {
                pixel = 0x00000000; // Black
                *pStorageMem++ = pixel;
            }
        }
    }

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    // Write the logo image data to the display.
    pStorageMem = (uint32_t *)pDemo->uBaseAddr_MEM_FrameBuffer;

    for (frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++)
    {
        for (row = 0; row < pDemo->ali3_height; row++)
        {
            for (col = 0; col < pDemo->ali3_width; col++)
            {
                // Grab the next pixel data from the static image array.
                pixel = avnet_logo_image_data[((row * pDemo->ali3_width) + col)];
                // Store the next pixel into the frame buffer space.
                *(volatile uint32_t *) pStorageMem++ = pixel;
            }
        }
    }

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    // Set the mode to draw.
    pDemo->mode = draw;

    return 0;
}

int zed_ali3_controller_demo_touch_calibrate(zed_ali3_controller_demo_t *pDemo)
{
    int result = 0;
    interface_graphic_t graphic;
    touch_calibration_data_t touch_calibration_data;
    touch_calibration_matrix_t touch_calibration_matrix;

    /* This routine must collect three sample points based upon the operators
     * actual touch input.  To do this, three targets are drawn on the display
     * while we await touch input for each target location. The targets should
     * be widely separated but also need to avoid the areas near the edges
     * where touch sensor output tends to become non-linear.
     */
    xil_printf("\n\r");
	xil_printf("-----------------------------------------------------------------------\n\r");
	xil_printf("--                   Zed Display Kit                                 --\n\r");
	xil_printf("--  Starting Calibration Procedure, Touch Targets Shown On Display   --\n\r");
	xil_printf("-----------------------------------------------------------------------\n\r");
	xil_printf("\n\r");

    // Set first target location to 25% display width and 50% display height.
	touch_calibration_data.reference_touch_position1.position_x = (pDemo->ali3_width / 4);
	touch_calibration_data.reference_touch_position1.position_y = (pDemo->ali3_height / 2);

    // Set second target location to 50% display width and 25% display height.
	touch_calibration_data.reference_touch_position2.position_x = (pDemo->ali3_width / 2);
	touch_calibration_data.reference_touch_position2.position_y = (pDemo->ali3_height / 4);

    // Set third target location to 75% display width and 75% display height.
	touch_calibration_data.reference_touch_position3.position_x = (pDemo->ali3_width / 4) * 3;
	touch_calibration_data.reference_touch_position3.position_y = (pDemo->ali3_height / 4) * 3;

	// Blank the screen,
	draw_blank_screen(pDemo, COLOR_BLACK);

	// Wait for DMA to synchronize.
	Xil_DCacheFlush();

	// Draw the first target to the display.
    graphic.location_x = touch_calibration_data.reference_touch_position1.position_x - (avnet_touch_target_width / 2);  // Centered on graphic
    graphic.location_y = touch_calibration_data.reference_touch_position1.position_y - (avnet_touch_target_height / 2);  // Centered on graphic
    graphic.size_x = avnet_touch_target_width;
    graphic.size_y = avnet_touch_target_height;
    graphic.default_image_data = avnet_touch_target;
    draw_image_data(pDemo, &graphic);

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    /*
     * Flush any registered touch events from the queue.  This call must
     * be threadsafe since it operates on the queue itself.
     */
    XScuGic_Disable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

    // Flush any existing touch events.
    tmg120_flush_touch_events(pDemo);

    // Re-enable touch interrupts.
    XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

    result = 0;
    while (result != 1)
    {
		/*
		 * Check to see if any touch events have been registered.  This call
		 * needs to be thread safe with respect to the touch controller
		 * interrupts.  Disable interrupts before the call and re-enable
		 * after the call to process the touch event.
		 */
		XScuGic_Disable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

		// This call must be thread safe in order to maintain queue stability.
		result = tmg120_process_touch_event(pDemo);

		// Re-enable touch interrupts.
		XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

		millisleep(100);
    }

    xil_printf("Processed PCAP Calibration Event: PosX=0x%04X, PoxY=0x%04X\n\r",
        pDemo->touch_posx_raw,
        pDemo->touch_posy_raw
        );

    // Capture the sample information for the calibration matrix.
    touch_calibration_data.raw_touch_position1.position_x = pDemo->touch_posx_raw;
    touch_calibration_data.raw_touch_position1.position_y = pDemo->touch_posy_raw;

    // Blank the screen,
    draw_blank_screen(pDemo, COLOR_BLACK);

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    // Sleep while the display is updated.
    sleep(1);

    // Draw the second target to the display.
    graphic.location_x = touch_calibration_data.reference_touch_position2.position_x - (avnet_touch_target_width / 2);  // Centered on graphic
    graphic.location_y = touch_calibration_data.reference_touch_position2.position_y - (avnet_touch_target_height / 2);  // Centered on graphic
    graphic.size_x = avnet_touch_target_width;
    graphic.size_y = avnet_touch_target_height;
    graphic.default_image_data = avnet_touch_target;
    draw_image_data(pDemo, &graphic);

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    /*
     * Flush any registered touch events from the queue.  This call must
     * be threadsafe since it operates on the queue itself.
     */
    XScuGic_Disable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

    // Flush any existing touch events.
    tmg120_flush_touch_events(pDemo);

    // Re-enable touch interrupts.
    XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

    result = 0;
    while (result != 1)
    {
        /*
         * Check to see if any touch events have been registered.  This call
         * needs to be thread safe with respect to the touch controller
         * interrupts.  Disable interrupts before the call and re-enable
         * after the call to process the touch event.
         */
        XScuGic_Disable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

        // This call must be thread safe in order to maintain queue stability.
        result = tmg120_process_touch_event(pDemo);

        // Re-enable touch interrupts.
        XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

        millisleep(100);
    }

    xil_printf("Processed PCAP Calibration Event: PosX=0x%04X, PoxY=0x%04X\n\r",
        pDemo->touch_posx_raw,
        pDemo->touch_posy_raw
        );

    // Capture the sample information for the calibration matrix.
    touch_calibration_data.raw_touch_position2.position_x = pDemo->touch_posx_raw;
    touch_calibration_data.raw_touch_position2.position_y = pDemo->touch_posy_raw;

    // Blank the screen,
    draw_blank_screen(pDemo, COLOR_BLACK);

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    // Sleep while the display is updated.
    sleep(1);

    // Draw the third target to the display.
    graphic.location_x = touch_calibration_data.reference_touch_position3.position_x - (avnet_touch_target_width / 2);  // Centered on graphic
    graphic.location_y = touch_calibration_data.reference_touch_position3.position_y - (avnet_touch_target_height / 2);  // Centered on graphic
    graphic.size_x = avnet_touch_target_width;
    graphic.size_y = avnet_touch_target_height;
    graphic.default_image_data = avnet_touch_target;
    draw_image_data(pDemo, &graphic);

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    /*
     * Flush any registered touch events from the queue.  This call must
     * be threadsafe since it operates on the queue itself.
     */
    XScuGic_Disable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

    // Flush any existing touch events.
    tmg120_flush_touch_events(pDemo);

    // Re-enable touch interrupts.
    XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

    result = 0;
    while (result != 1)
    {
        /*
         * Check to see if any touch events have been registered.  This call
         * needs to be thread safe with respect to the touch controller
         * interrupts.  Disable interrupts before the call and re-enable
         * after the call to process the touch event.
         */
        XScuGic_Disable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

        // This call must be thread safe in order to maintain queue stability.
        result = tmg120_process_touch_event(pDemo);

        // Re-enable touch interrupts.
        XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

        millisleep(100);
    }

    xil_printf("Processed PCAP Calibration Event: PosX=0x%04X, PoxY=0x%04X\n\r",
        pDemo->touch_posx_raw,
        pDemo->touch_posy_raw
        );

    // Capture the sample information for the calibration matrix.
    touch_calibration_data.raw_touch_position3.position_x = pDemo->touch_posx_raw;
    touch_calibration_data.raw_touch_position3.position_y = pDemo->touch_posy_raw;

    // Blank the screen,
    draw_blank_screen(pDemo, COLOR_BLACK);

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

    /*
     * Calculate the calibration matrix coefficients based upon the three
     * touch points that were just captured.
     */
    result = tmg120_get_calibration_matrix(pDemo, &touch_calibration_data, &touch_calibration_matrix);

    // Update the demo instance with the new calibration coefficients.
    pDemo->calibration_An = touch_calibration_matrix.An;
    pDemo->calibration_Bn = touch_calibration_matrix.Bn;
    pDemo->calibration_Cn = touch_calibration_matrix.Cn;
    pDemo->calibration_Dn = touch_calibration_matrix.Dn;
    pDemo->calibration_En = touch_calibration_matrix.En;
    pDemo->calibration_Fn = touch_calibration_matrix.Fn;
    pDemo->calibration_divisor = touch_calibration_matrix.divisor;

    /*
     * Store the updated calibration matrix coefficients to SPI flash so
     * that they are persisted between power cycles.
     */
    result = qspi_flash_store_calibration_data(pDemo);
    if (result != 0)
    {
    	xil_printf("Calibration not written to Flash due to error.\n\r");
    }

    return result;
}

int zed_ali3_controller_demo_touch_process(zed_ali3_controller_demo_t *pDemo)
{
	int result = 0;
	interface_graphic_t graphic;

	touch_calibration_matrix_t touch_calibration_matrix;
	touch_location_t touch_location_raw;
	touch_location_t touch_location_cal;

	// Set the calibration matrix with the demo instance coefficients.
	touch_calibration_matrix.An = pDemo->calibration_An;
	touch_calibration_matrix.Bn = pDemo->calibration_Bn;
	touch_calibration_matrix.Cn = pDemo->calibration_Cn;
	touch_calibration_matrix.Dn = pDemo->calibration_Dn;
	touch_calibration_matrix.En = pDemo->calibration_En;
	touch_calibration_matrix.Fn = pDemo->calibration_Fn;
	touch_calibration_matrix.divisor = pDemo->calibration_divisor;

	/*
     * Check to see if any touch events have been registered.  This call
     * needs to be thread safe with respect to the touch controller
     * interrupts.  Disable interrupts before the call and re-enable
     * after the call to process the touch event.
     */
	XScuGic_Disable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

	// This call must be thread safe in order to maintain queue stability.
	result = tmg120_process_touch_event(pDemo);

    // Re-enable touch interrupts.
    XScuGic_Enable(&(pDemo->Intc), pDemo->uInterruptId_IRQ_Touch);

    if (result == 1)
    {
        // Update the touch location with the most recent raw touch position.
        touch_location_raw.position_x = pDemo->touch_posx_raw;
        touch_location_raw.position_y = pDemo->touch_posy_raw;

        tmg120_translate_location(pDemo, &touch_location_raw, &touch_location_cal, &touch_calibration_matrix);

        // Update the calibrated touch location with translated location.
		pDemo->touch_posx_cal = touch_location_cal.position_x;
		pDemo->touch_posy_cal = touch_location_cal.position_y;


        /*
         * A little maintenance is needed on the translated points.  Due to
         * the integer math involved, if a point is represented beyond the
         * display dimensions, it should get mapped to 0 because it is an
         * overflow calculation.
         */
        if (pDemo->touch_posx_cal > pDemo->ali3_width)
        {
        	pDemo->touch_posx_cal = 0;
        }

        if (pDemo->touch_posy_cal > pDemo->ali3_height)
        {
            pDemo->touch_posy_cal = 0;
        }

        if (pDemo->bVerbose > 0)
        {
			xil_printf("Processed PCAP Event:Raw PosX=0x%04X,Raw PosY=0x%04X,Cal PosX=%3d,Cal PosY=%3d\n\r",
				pDemo->touch_posx_raw,
				pDemo->touch_posy_raw,
				pDemo->touch_posx_cal,
				pDemo->touch_posy_cal
				);
        }

        // Check to see how the touch event should be handled.
        if (pDemo->mode == draw)
        {
            // Draw the touch location indicator 'dot' to the display.
        	if ((pDemo->touch_posx_cal > avnet_draw_pen_black_width) &&
        		(pDemo->touch_posx_cal < (pDemo->ali3_width - avnet_draw_pen_black_width)))
            {
        	    graphic.location_x = pDemo->touch_posx_cal - (avnet_draw_pen_black_width / 2);  // Centered on graphic
            }
            else if (pDemo->touch_posx_cal >= (pDemo->ali3_width - avnet_draw_pen_black_width))
            {
            	graphic.location_x = pDemo->ali3_width - avnet_draw_pen_black_width;
            }
            else
            {
                graphic.location_x = avnet_draw_pen_black_width;
            }

            if ((pDemo->touch_posy_cal > avnet_draw_pen_black_height) &&
                (pDemo->touch_posy_cal < (pDemo->ali3_height - avnet_draw_pen_black_height)))
            {
        		graphic.location_y = pDemo->touch_posy_cal - (avnet_draw_pen_black_height / 2);  // Centered on graphic
            }
            else if (pDemo->touch_posy_cal >= (pDemo->ali3_height - avnet_draw_pen_black_height))
            {
            	graphic.location_y = pDemo->ali3_height - avnet_draw_pen_black_height;
            }
            else
            {
            	graphic.location_y = avnet_draw_pen_black_height;
            }

        	graphic.size_x = avnet_draw_pen_black_width;
            graphic.size_y = avnet_draw_pen_black_height;
            graphic.default_image_data = avnet_draw_pen_black;
            draw_image_data(pDemo, &graphic);

            // Wait for DMA to synchronize.
            Xil_DCacheFlush();
        }
        else if ((pDemo->mode == control) &&
                 (pDemo->touch_pen_down_transition == 1))
        {
            /*
             * Decode touch location against control positions.
             */
            if ((pDemo->touch_posx_cal >= LED0_POSITION_X) && (pDemo->touch_posx_cal <= (LED0_POSITION_X + avnet_control_led_off_width)) &&
                (pDemo->touch_posy_cal >= LED0_POSITION_Y) && (pDemo->touch_posy_cal <= (LED0_POSITION_Y + avnet_control_led_off_height)))
            {
                // Touch event on LED0 control.
                if (pDemo->bVerbose)
                {
                	xil_printf("Registered touch on LED 0 control.\n\r");
                }

                if (pDemo->led0_state == 0)
                {
                    // Old state was off, so new state should be on.
                    zed_ali3_controller_demo_led(pDemo, 0, 1);
                }
                else
                {
                    // Old state was on, so new state should be off.
                    zed_ali3_controller_demo_led(pDemo, 0, 0);
                }
            }

            if ((pDemo->touch_posx_cal >= LED1_POSITION_X) && (pDemo->touch_posx_cal <= (LED1_POSITION_X + avnet_control_led_off_width)) &&
                (pDemo->touch_posy_cal >= LED1_POSITION_Y) && (pDemo->touch_posy_cal <= (LED1_POSITION_Y + avnet_control_led_off_height)))
            {
                // Touch event on LED1 control.
                if (pDemo->bVerbose)
                {
                	xil_printf("Registered touch on LED 1 control.\n\r");
                }

                if (pDemo->led1_state == 0)
                {
                    // Old state was off, so new state should be on.
                    zed_ali3_controller_demo_led(pDemo, 1, 1);
                }
                else
                {
                    // Old state was on, so new state should be off.
                    zed_ali3_controller_demo_led(pDemo, 1, 0);
                }
            }

            if ((pDemo->touch_posx_cal >= LED2_POSITION_X) && (pDemo->touch_posx_cal <= (LED2_POSITION_X + avnet_control_led_off_width)) &&
                (pDemo->touch_posy_cal >= LED2_POSITION_Y) && (pDemo->touch_posy_cal <= (LED2_POSITION_Y + avnet_control_led_off_height)))
            {
                // Touch event on LED2 control.
                if (pDemo->bVerbose)
                {
                	xil_printf("Registered touch on LED 2 control.\n\r");
                }

                if (pDemo->led2_state == 0)
                {
                    // Old state was off, so new state should be on.
                    zed_ali3_controller_demo_led(pDemo, 2, 1);
                }
                else
                {
                    // Old state was on, so new state should be off.
                    zed_ali3_controller_demo_led(pDemo, 2, 0);
                }
            }

            if ((pDemo->touch_posx_cal >= LED3_POSITION_X) && (pDemo->touch_posx_cal <= (LED3_POSITION_X + avnet_control_led_off_width)) &&
                (pDemo->touch_posy_cal >= LED3_POSITION_Y) && (pDemo->touch_posy_cal <= (LED3_POSITION_Y + avnet_control_led_off_height)))
            {
                // Touch event on LED3 control.
                if (pDemo->bVerbose)
                {
                	xil_printf("Registered touch on LED 3 control.\n\r");
                }

                if (pDemo->led3_state == 0)
                {
                    // Old state was off, so new state should be on.
                    zed_ali3_controller_demo_led(pDemo, 3, 1);
                }
                else
                {
                    // Old state was on, so new state should be off.
                    zed_ali3_controller_demo_led(pDemo, 3, 0);
                }
            }

            if ((pDemo->touch_posx_cal >= LED4_POSITION_X) && (pDemo->touch_posx_cal <= (LED4_POSITION_X + avnet_control_led_off_width)) &&
                (pDemo->touch_posy_cal >= LED4_POSITION_Y) && (pDemo->touch_posy_cal <= (LED4_POSITION_Y + avnet_control_led_off_height)))
            {
                // Touch event on LED4 control.
                if (pDemo->bVerbose)
                {
                	xil_printf("Registered touch on LED 4 control.\n\r");
                }

                if (pDemo->led4_state == 0)
                {
                    // Old state was off, so new state should be on.
                    zed_ali3_controller_demo_led(pDemo, 4, 1);
                }
                else
                {
                    // Old state was on, so new state should be off.
                    zed_ali3_controller_demo_led(pDemo, 4, 0);
                }
            }

            if ((pDemo->touch_posx_cal >= LED5_POSITION_X) && (pDemo->touch_posx_cal <= (LED5_POSITION_X + avnet_control_led_off_width)) &&
                (pDemo->touch_posy_cal >= LED5_POSITION_Y) && (pDemo->touch_posy_cal <= (LED5_POSITION_Y + avnet_control_led_off_height)))
            {
                // Touch event on LED5 control.
                if (pDemo->bVerbose)
                {
                	xil_printf("Registered touch on LED 5 control.\n\r");
                }

                if (pDemo->led5_state == 0)
                {
                    // Old state was off, so new state should be on.
                    zed_ali3_controller_demo_led(pDemo, 5, 1);
                }
                else
                {
                    // Old state was on, so new state should be off.
                    zed_ali3_controller_demo_led(pDemo, 5, 0);
                }
            }

            if ((pDemo->touch_posx_cal >= LED6_POSITION_X) && (pDemo->touch_posx_cal <= (LED6_POSITION_X + avnet_control_led_off_width)) &&
                (pDemo->touch_posy_cal >= LED6_POSITION_Y) && (pDemo->touch_posy_cal <= (LED6_POSITION_Y + avnet_control_led_off_height)))
            {
                // Touch event on LED6 control.
                if (pDemo->bVerbose)
                {
                	xil_printf("Registered touch on LED 6 control.\n\r");
                }

                if (pDemo->led6_state == 0)
                {
                    // Old state was off, so new state should be on.
                    zed_ali3_controller_demo_led(pDemo, 6, 1);
                }
                else
                {
                    // Old state was on, so new state should be off.
                    zed_ali3_controller_demo_led(pDemo, 6, 0);
                }
            }

            if ((pDemo->touch_posx_cal >= LED7_POSITION_X) && (pDemo->touch_posx_cal <= (LED7_POSITION_X + avnet_control_led_off_width)) &&
                (pDemo->touch_posy_cal >= LED7_POSITION_Y) && (pDemo->touch_posy_cal <= (LED7_POSITION_Y + avnet_control_led_off_height)))
            {
                // Touch event on LED7 control.
                if (pDemo->bVerbose)
                {
                	xil_printf("Registered touch on LED 7 control.\n\r");
                }

                if (pDemo->led7_state == 0)
                {
                    // Old state was off, so new state should be on.
                    zed_ali3_controller_demo_led(pDemo, 7, 1);
                }
                else
                {
                    // Old state was on, so new state should be off.
                    zed_ali3_controller_demo_led(pDemo, 7, 0);
                }
            }
        }
    }

    return 0;
}


int zed_ali3_controller_demo_touch_status(zed_ali3_controller_demo_t *pDemo)
{
	int result;

	result = tmg120_read_touch_data(pDemo);

    return result;
}

int zed_ali3_controller_demo_switch(zed_ali3_controller_demo_t *pDemo, int switch_number, int switch_state)
{
    interface_graphic_t graphic;

    // Update the user interface to match the switch state change.
    if (switch_number == 0)
    {
    	pDemo->switch0_state = switch_state;

    	graphic.location_x = SWITCH0_POSITION_X;
        graphic.location_y = SWITCH0_POSITION_Y;
    }
    else if (switch_number == 1)
    {
        pDemo->switch1_state = switch_state;

        graphic.location_x = SWITCH1_POSITION_X;
	    graphic.location_y = SWITCH1_POSITION_Y;
    }
    else if (switch_number == 2)
    {
        pDemo->switch2_state = switch_state;

        graphic.location_x = SWITCH2_POSITION_X;
        graphic.location_y = SWITCH2_POSITION_Y;
    }
    else if (switch_number == 3)
    {
        pDemo->switch3_state = switch_state;

        graphic.location_x = SWITCH3_POSITION_X;
        graphic.location_y = SWITCH3_POSITION_Y;
    }
    else
    {
        return -1;
    }

    // Determine the ON/OFF state graphic to be shown.
    if (switch_state == 0)
    {
        // Draw the switch off state.
        graphic.default_image_data = avnet_control_dip_off;
        graphic.alternate_image_data = avnet_control_dip_on;

        // All the switch images have the same OFF width.
        graphic.size_x = avnet_control_dip_off_width;
        graphic.size_y = avnet_control_dip_off_height;
    }
    else if (switch_state == 1)
    {
        // Draw the switch on state.
        graphic.default_image_data = avnet_control_dip_on;
        graphic.alternate_image_data = avnet_control_dip_off;

        // All the switch images have the same ON width.
        graphic.size_x = avnet_control_dip_on_width;
        graphic.size_y = avnet_control_dip_on_height;
    }
    else
    {
        return -1;
    }

    // Check to see how the touch event should be handled.
    if (pDemo->mode == control)
    {
        // Draw the LED graphic to the display.
        draw_image_data(pDemo, &graphic);

        // Wait for DMA to synchronize.
        Xil_DCacheFlush();
    }

    return 0;
}

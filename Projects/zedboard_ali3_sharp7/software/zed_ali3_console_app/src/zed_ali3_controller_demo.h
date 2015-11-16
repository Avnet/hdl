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
// Module Name:         zed_ali3_controller_demo.h
// Project Name:        ZedBoard ALI3 Display Kit
// Target Devices:      Zynq-7000
// Hardware Boards:     ZedBoard + ALI3 Display Kit
//
// Tool versions:       ISE Design Suite 14.6 / Vivado 2013.2
//
// Description:         ZedBoard ALI3 Controller Demonstration
//
// Dependencies:
//
// Revision:            Jul 01, 2013: 1.00 Initial version
//
//----------------------------------------------------------------------------

#ifndef __ZED_ALI3_CONTROLLER_DEMO_H__
#define __ZED_ALI3_CONTROLLER_DEMO_H__

#include "xparameters.h"
#include "types.h"

#include "sleep.h"

// I2C related.
#include "zed_iic.h"

// Video related
#include "xaxivdma.h"
#include "video_resolution.h"
#include "video_frame_buffer.h"

// Interrupt related.
#include "xscugic.h"
#include "xil_exception.h"

// PS GPIO related.
#include "xgpiops.h"

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define GPIO_DEVICE_ID  	XPAR_XGPIOPS_0_DEVICE_ID

/* User interface positional map. */
#define BUTTON0_POSITION_X                     594 // "BTNC"
#define BUTTON1_POSITION_X                     594 // "BTND"
#define BUTTON2_POSITION_X                     513 // "BTNL"
#define BUTTON3_POSITION_X                     675 // "BTNR"
#define BUTTON4_POSITION_X                     594 // "BTNU"
#define BUTTON0_POSITION_Y                     325 // "BTNC"
#define BUTTON1_POSITION_Y                     406 // "BTND"
#define BUTTON2_POSITION_Y                     325 // "BTNL"
#define BUTTON3_POSITION_Y                     325 // "BTNR"
#define BUTTON4_POSITION_Y                     244 // "BTNU"

#define LED0_POSITION_X                        650
#define LED1_POSITION_X                        569
#define LED2_POSITION_X                        488
#define LED3_POSITION_X                        407
#define LED4_POSITION_X                        326
#define LED5_POSITION_X                        246
#define LED6_POSITION_X                        164
#define LED7_POSITION_X                        83
#define LED0_POSITION_Y                        165
#define LED1_POSITION_Y                        165
#define LED2_POSITION_Y                        165
#define LED3_POSITION_Y                        165
#define LED4_POSITION_Y                        165
#define LED5_POSITION_Y                        165
#define LED6_POSITION_Y                        165
#define LED7_POSITION_Y                        165

#define SWITCH0_POSITION_X                     349
#define SWITCH1_POSITION_X                     306
#define SWITCH2_POSITION_X                     263
#define SWITCH3_POSITION_X                     220
#define SWITCH4_POSITION_X                     177
#define SWITCH5_POSITION_X                     134
#define SWITCH6_POSITION_X                     91
#define SWITCH7_POSITION_X                     48
#define SWITCH0_POSITION_Y                     260
#define SWITCH1_POSITION_Y                     260
#define SWITCH2_POSITION_Y                     260
#define SWITCH3_POSITION_Y                     260
#define SWITCH4_POSITION_Y                     260
#define SWITCH5_POSITION_Y                     260
#define SWITCH6_POSITION_Y                     260
#define SWITCH7_POSITION_Y                     260

/* Defines a demo mode enumeration type. */
enum demo_mode
{
    draw = 0,
    control
};

/* Defines a touch controller enumeration type.  The enumeration values
 * just happen to also be the I2C slave address values. */
enum touch_controller_type
{
    none = 0,
    clicktouch = 0x1F,
    dhelectronic = 0x20
};

/* This structure contains the context for the Zed Display Kit
 * Standalone Demonstration Application. */
struct struct_zed_ali3_controller_demo_t
{
    int32u bVerbose;

    ////////////////////////////////
    // Video DMA related context
    ////////////////////////////////
    int32u uDeviceId_VDMA_FrameBuffer;
    int32u uBaseAddr_MEM_FrameBuffer;  // address of FB in memory
    int32u uNumFrames_FrameBuffer;

    XAxiVdma vdma_ali3;
    XAxiVdma_DmaSetup vdmacfg_ali3_read;
    XAxiVdma_DmaSetup vdmacfg_ali3_write; // not used in this demo

    // ALI3 video resolution
    int32u ali3_width;
    int32u ali3_height;
    int32u ali3_resolution;

    ////////////////////////////////
    // Touch I2C related context
    ////////////////////////////////
    int32u uBaseAddr_IIC_Touch;

    zed_iic_t touch_iic;

    ////////////////////////////////
    // Interrupt related context
    ////////////////////////////////
    int32u uDeviceId_IRQ_Touch;
    int32u uInterruptId_IRQ_Touch;

    XScuGic Intc;
    XScuGic_Config *pIntcConfig;

    ////////////////////////////////
    // Touch calibration coefficients
    ////////////////////////////////
    int32s calibration_success;
    int32s calibration_An;
    int32s calibration_Bn;
    int32s calibration_Cn;
    int32s calibration_Dn;
    int32s calibration_En;
    int32s calibration_Fn;
    int32s calibration_divisor;

    ////////////////////////////////
    // Touch related statistics
    ////////////////////////////////
    int32u touch_duplicates;
    int32u touch_events;
    int32u touch_irqs;
    int32u touch_overflows;
    int16u touch_posx_raw;
    int16u touch_posy_raw;
    int16u touch_posx_cal;
    int16u touch_posy_cal;
    int8u  touch_gesture;
	int8u  touch_pen_down;
	int8u  touch_pen_down_transition;
    int32u touch_valid;

    ////////////////////////////////
	// Touch I2C slave related context
	////////////////////////////////
	int8u slave_touch_data_offset;
	int8u slave_touch_report_length;
	int8u touch_max_finger_count_supported;

	enum touch_controller_type controller_type;

    ////////////////////////////////
    // GPIO related members
    ////////////////////////////////
    int button0_state;
    int button1_state;
    int button2_state;
    int button3_state;
    int button4_state;

    int led0_state;
    int led1_state;
    int led2_state;
    int led3_state;
    int led4_state;
    int led5_state;
    int led6_state;
    int led7_state;

    int switch0_state;
    int switch1_state;
    int switch2_state;
    int switch3_state;
    int switch4_state;
    int switch5_state;
    int switch6_state;
    int switch7_state;

    XGpioPs gpio_driver;	// The driver instance for PS GPIO Device.

    enum demo_mode mode;
};
typedef struct struct_zed_ali3_controller_demo_t zed_ali3_controller_demo_t;

int zed_ali3_controller_demo_board_process(zed_ali3_controller_demo_t *pDemo);
int zed_ali3_controller_demo_button(zed_ali3_controller_demo_t *pDemo, int button_number, int button_state);
int zed_ali3_controller_demo_init(zed_ali3_controller_demo_t *pDemo);
int zed_ali3_controller_demo_cbars(zed_ali3_controller_demo_t *pDemo, int32u offset);
int zed_ali3_controller_demo_check_calibrate_request(zed_ali3_controller_demo_t *pDemo);
int zed_ali3_controller_demo_control(zed_ali3_controller_demo_t *pDemo);
int zed_ali3_controller_demo_led(zed_ali3_controller_demo_t *pDemo, int led_number, int led_state);
int zed_ali3_controller_demo_logo(zed_ali3_controller_demo_t *pDemo);
int zed_ali3_controller_demo_switch(zed_ali3_controller_demo_t *pDemo, int switch_number, int switch_state);
int zed_ali3_controller_demo_touch_calibrate(zed_ali3_controller_demo_t *pDemo);
int zed_ali3_controller_demo_touch_process(zed_ali3_controller_demo_t *pDemo);

#endif // __ZED_ALI3_CONTROLLER_DEMO_H__

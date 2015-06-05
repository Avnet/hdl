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
// Create Date:         May 14, 2013
// Design Name:         ZedBoard ALI3 Controller Demonstration
// Module Name:         zed_ali3_controller_demo.c
// Project Name:        ZedBoard ALI3 Display Kit
// Target Devices:      Zynq-7000
// Hardware Boards:     ZedBoard + ALI3 Display Kit
//
// Tool versions:       ISE Design Suite 14.5 / Vivado 2013.1
//
// Description:         ZedBoard ALI3 Controller Demonstration
//
// Dependencies:
//
// Revision:            May 16, 2013: 1.00 Initial version
//                      May 22, 2015: 1.01 Updated for Vivado 2014.4
//                      Jun  5, 2015: 1.02 Updated for Zynq Mini-ITX
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "xil_cache.h"

#include "zed_ali3_controller_demo.h"
#include "ps_gpio_polled.h"

/* Define the I2C mux slave address here. */
#define I2C_MUX_SLAVE_ADDRESS     0x70

/* Define the I2C mux channel that the touch controller resides upon. */
#define I2C_MUX_TOUCH_CHANNEL     4

void TouchIsr(void *InstancePtr)
{
   int8u ChipAddress = 0x20;
   int8u RegAddress  = 0x07;
   int8u RegData[5];
   int8u ByteCount   = 5;
   int ret;

   zed_ali3_controller_demo_t *pDemo = (zed_ali3_controller_demo_t *)InstancePtr;

   pDemo->touch_irqs++;

   ret = pDemo->touch_iic.fpIicRead( &(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount );
   if ( !ret )
   {
      xil_printf( "ERROR : Failed to read Touch Controller\n\r" );
      return;
   }

   int8u touch_event = RegData[0];
   int16u touch_posx = ((int16u)(RegData[1]) << 8) | ((int16u)(RegData[2]));
   int16u touch_posy = ((int16u)(RegData[3]) << 8) | ((int16u)(RegData[4]));
   // If new touch event
   if ( touch_event && !(touch_posx == pDemo->touch_posx && touch_posy == pDemo->touch_posy) )
   {
      pDemo->touch_events++;
      pDemo->touch_posx = touch_posx;
      pDemo->touch_posy = touch_posy;
   }

   return;
}

/****************************************************************************/
/**
* This function sets up the interrupt system for the example.  The processing
* contained in this function assumes the hardware system was built with
* an interrupt controller.
*
* @param	None.
*
* @return	A status indicating XST_SUCCESS or a value that is contained in
*		xstatus.h.
*
* @note		None.
*
*****************************************************************************/
int zed_ali3_controller_demo_SetupInterruptSystem( zed_ali3_controller_demo_t *pDemo )
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

/*****************************************************************************
*
* This function initializes the mux to set enable the channel that the
* display the touch controller resides upon.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u zed_ali3_controller_demo_initialize_mux(zed_ali3_controller_demo_t *pDemo, int8u slave_address)
{
    int8u RegAddress  = 0x00;
    int8u RegData     = (1 << I2C_MUX_TOUCH_CHANNEL);  // Control data byte to enable I2C channel on mux.
    int32u ret;

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), slave_address, RegAddress, &RegData, 1);
    if (ret == -1)
    {
        xil_printf("Error on writing slave device at address 0x%02X to control I2C channel 0x%02X\n\r", slave_address, RegData);
        return -1;
    }

    return 0;
}

int tmg_120_initialize( zed_ali3_controller_demo_t *pDemo )
{
   int ret = 0;

   int8u ChipAddress = 0x20;
   int8u RegAddress  = 0x00;
   int8u RegData     = 0x11; // [4] = INT enabled, [0] = Touch enabled
   int8u ByteCount   = 1;
   ret = pDemo->touch_iic.fpIicWrite( &(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount );
   if ( !ret )
   {
       xil_printf( "ERROR : Failed to write Touch Controller\n\r" );
       return -1;
   }

   return 0;
}

int zed_ali3_controller_demo_init( zed_ali3_controller_demo_t *pDemo )
{
   int ret;

   xil_printf("\n\r");
   xil_printf("------------------------------------------------------\n\r");
   xil_printf("--             Zynq Mini-ITX Display Kit            --\n\r");
   xil_printf("--           ALI3 Controller Demonstration          --\n\r");
   xil_printf("--         DH TMG120 Diagnostics Application        --\n\r");
   xil_printf("------------------------------------------------------\n\r");
   xil_printf("\n\r");

   // Fill frame stores with color bars
   xil_printf( "Video Frame Buffer Initialization ...\n\r" );
   int32u frame, row, col;
   int32u pixel;
   volatile int32u *pStorageMem = (int32u *)pDemo->uBaseAddr_MEM_FrameBuffer;
   for ( frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++ )
   {
      for ( row = 0; row < pDemo->ali3_height; row++ )
      {
         for ( col = 0; col < pDemo->ali3_width; col++ )
         {
             pixel = 0x00000000; // Black
             *pStorageMem++ = pixel;
          }
       }
    }

    // Wait for DMA to synchronize.
    Xil_DCacheFlush();

   // Initialize Output Side of AXI VDMA
   xil_printf( "Video DMA (Output Side) Initialization ...\n\r" );
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

   // IIC Initialization for touch controller
   xil_printf( "I2C Touch Controller Initialization ...\n\r");
   ret = zed_iic_axi_init(&(pDemo->touch_iic),"ALI3 Touch I2C Controller", pDemo->uBaseAddr_IIC_Touch);
   if ( !ret )
   {
      xil_printf("ERROR : Failed to open ZED-IIC driver\n\r");
      return -1;
   }

   /* For Zynq Mini-ITX, the I2C mux must be set to Channel 4 in order to
    * communicate with the touch controller.
    */
   ret = zed_ali3_controller_demo_initialize_mux(pDemo, I2C_MUX_SLAVE_ADDRESS);

   pDemo->touch_irqs   = 0;
   pDemo->touch_events = 0;
   pDemo->touch_posx   = 0x0000;
   pDemo->touch_posy   = 0x0000;

   zed_ali3_controller_demo_SetupInterruptSystem( pDemo );

   tmg_120_initialize( pDemo );

   return 0;

}

int zed_ali3_controller_demo_cbars( zed_ali3_controller_demo_t *pDemo, int32u offset )
{
   int32u frame, row, col;
   int32u cbar, pixel;
   volatile int32u *pStorageMem = (int32u *)pDemo->uBaseAddr_MEM_FrameBuffer;
   for ( frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++ )
   {
      for ( row = 0; row < pDemo->ali3_height; row++ )
      {
         for ( col = 0; col < pDemo->ali3_width; col++ )
         {
            cbar = (col * 8) / pDemo->ali3_width; // color bar = 0..7
            cbar = (cbar + offset) % 8;
            switch ( cbar )
            {
            case 0: pixel = 0x00000000; break; // Black
            case 1: pixel = 0x00FF0000; break; // Red
            case 2: pixel = 0x0000FF00; break; // Green
            case 3: pixel = 0x000000FF; break; // Blue
            case 4: pixel = 0x0000FFFF; break; // Cyan
            case 5: pixel = 0x00FF00FF; break; // Purple
            case 6: pixel = 0x00FFFF00; break; // Yellow
            case 7: pixel = 0x00FFFFFF; break; // White
            }
            *pStorageMem++ = pixel;
         }
      }
   }

   // Wait for DMA to synchronize.
   Xil_DCacheFlush();

   return 0;
}

int zed_ali3_controller_demo_status( zed_ali3_controller_demo_t *pDemo )
{
   int8u ChipAddress = 0x20;
   int8u RegAddress  = 0x00;
   int8u RegData[16];
   int8u ByteCount   = 16;
   int ret;
   ret = pDemo->touch_iic.fpIicRead( &(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount );
   if ( !ret )
   {
      xil_printf( "ERROR : Failed to read Touch Controller\n\r" );
      return -1;
   }

   xil_printf("PCAP: DH Electronic TMG120 Touch Controller Detected\n\r");

   xil_printf("PCAP: Command=0x%02X, Status=0x%02X, FWVersion=%d.%d, TouchDetect=%d, PosX=0x%02X%02X, PoxY=0x%02X%02X\n\r",
		   RegData[ 0], RegData[ 1],
		   RegData[ 2], RegData[ 3],
           RegData[ 7],
		   RegData[ 8], RegData[ 9],
		   RegData[10], RegData[11]
		   );

   return 0;
}

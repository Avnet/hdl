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
// Create Date:         May 23, 2013
// Design Name:         Zed Display Kit Getting Started Demo
// Module Name:         zed_ali3_controller_demo.h
// Project Name:        Zed Display Kit Getting Started Demo
// Target Devices:      Zynq-7
// Hardware Boards:     ZedBoard
// 
//
// Tool versions:       ISE 14.5
//
// Description:         Zed Display Kit Demo
//                      This application will configure the display kit for
//                      480*800 display output.
//
// Dependencies:
//
// Revision:            Nov 15, 2011: 1.00 Initial version
//                      May 23, 2013: 1.02 Updated for Zed Display Kit - 14.5
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

// Interrupt related
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

// This structure contains the context for the
// Zed Display Kit Demonstration
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
   XAxiVdma_DmaSetup vdmacfg_ali3_read; // not used in this demo
   XAxiVdma_DmaSetup vdmacfg_ali3_write;

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

   // The driver instance for PS GPIO Device.
   XGpioPs gpio_driver;

   int32u touch_irqs;
   int32u touch_events;
   int16u touch_posx;
   int16u touch_posy;
};
typedef struct struct_zed_ali3_controller_demo_t zed_ali3_controller_demo_t;

int zed_ali3_controller_demo_init( zed_ali3_controller_demo_t *pDemo );
int zed_ali3_controller_demo_cbars( zed_ali3_controller_demo_t *pDemo, int32u offset );
int zed_ali3_controller_demo_status( zed_ali3_controller_demo_t *pDemo );

#endif // __ZED_ALI3_CONTROLLER_DEMO_H__

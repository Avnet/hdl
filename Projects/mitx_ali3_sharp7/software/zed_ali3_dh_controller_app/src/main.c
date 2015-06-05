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
// Module Name:         main.c
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
// Revision:            May 16, 2013: 1.00 Initial version
//						Mar 27, 2015: 1.01 Updated to accommodate 2014.4
//                                         F2P interrupt mapping strategy
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "platform.h"

#include "zed_ali3_controller_demo.h"
#include "ps_gpio_polled.h"
#include "video_resolution.h"

//void print(char *str);
void print(const char *str);

// This is the top level demo instance.
zed_ali3_controller_demo_t demo;

int main()
{
    init_platform();

    // Specify configuration for hardware design
    demo.ali3_resolution = VIDEO_RESOLUTION_WVGA;
    demo.ali3_width  = 800;
    demo.ali3_height = 480;
    demo.uDeviceId_VDMA_FrameBuffer = XPAR_AXIVDMA_0_DEVICE_ID;
    demo.uBaseAddr_MEM_FrameBuffer  = XPAR_DDR_MEM_BASEADDR + 0x10000000;
    demo.uNumFrames_FrameBuffer     = XPAR_AXIVDMA_0_NUM_FSTORES;
    //
    demo.uBaseAddr_IIC_Touch        = XPAR_IIC_0_BASEADDR;
    //
    demo.uDeviceId_IRQ_Touch        = XPAR_PS7_SCUGIC_0_DEVICE_ID;
    demo.uInterruptId_IRQ_Touch     = XPS_FPGA0_INT_ID;

    // Initialize the PS GPIO controls.
     if (ps_gpio_polled_init(&demo) != 0)
     {
     	xil_printf("Failed to initialize PS GPIO driver\n\r");
     }

    // Initialize hardware design
    zed_ali3_controller_demo_init( &demo );

    xil_printf("Display Colorbars Pattern...\n\r");

    // Display color bars
    zed_ali3_controller_demo_cbars( &demo, 0 );

    // Display touch events on serial output
    int prev_touch_events = 0;
    
    xil_printf("Begin capturing Touch Data...\n\r");
    xil_printf("\n\r");
    
    while ( 1 )
    {
        if ( prev_touch_events != demo.touch_events )
        {
            prev_touch_events = demo.touch_events;
            xil_printf( "PCAP Touch : IRQs=%4d, EVENTs=%4d, PosX=%4d, PosY=%4d\n\r",
                        demo.touch_irqs, demo.touch_events, demo.touch_posx, demo.touch_posy );
        }
    }

    cleanup_platform();

    return 0;
}

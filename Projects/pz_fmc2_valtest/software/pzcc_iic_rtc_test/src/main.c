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
// Please direct any questions or issues to the MicroZed Community Forums:
//     http://www.microzed.org
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2015 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Jul 21, 2015
// Design Name:         MicroZed Real Time Clock Demonstration
// Module Name:         main.c
// Project Name:        MicroZed + Real Time Clock Pmod
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     MicroZed + Real Time Clock Pmod
//
// Tool versions:       Xilinx Vivado 2014.4
//
// Description:         MicroZed Real Time Clock Demonstration
//
// Dependencies:
//
// Revision:            Jul 21, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "platform.h"
#include "zed_rtc_demo.h"

// Number of times an interrupt is received before the test passes.
#define TEST_INTERRUPT_COUNT                     10

// This is the top level demo instance.
zed_rtc_demo_t demo;

int run_rtc_test()
{
	int ret;

    // Used to know when to display RTC events on the serial console.
    int prev_rtc_events = 0;

    xil_printf("\n\r");

    xil_printf("---------------------------------------------------------------------------\n\r");
    xil_printf("--                                                                       --\n\r");
    xil_printf("--                PZCC-FMC2 Real Time Clock Test Application             --\n\r");
    xil_printf("--                                                                       --\n\r");
    xil_printf("---------------------------------------------------------------------------\n\r");
    xil_printf("\n\r");

    /* Assign the address for the IIC controller which comes from the address
     * map for hardware peripherals on this platform.
     */
    demo.uBaseAddr_IIC_RTC        = XPAR_AXI_IIC_0_BASEADDR;

    /* Locate the details of the interrupt assigned to the RTC alarm
     * functions.  These will be used to setup the RTC alarm ISR.
     */
    demo.uDeviceId_IRQ_RTC        = XPAR_PS7_SCUGIC_0_DEVICE_ID;
    demo.uInterruptId_IRQ_RTC     = XPS_FPGA0_INT_ID;

    // Initialize event and time tracking variables.
    demo.rtc_date = 0;
    demo.rtc_day = 0;
    demo.rtc_events = 0;
    demo.rtc_hours = 0;
    demo.rtc_irqs = 0;
    demo.rtc_minutes = 0;
    demo.rtc_month = 0;
    demo.rtc_seconds = 0;
    demo.rtc_status = 0;
    demo.rtc_temp_lower = 0;
    demo.rtc_temp_upper = 0;
    demo.rtc_temp = 0;
    demo.rtc_year = 0;

    // Initialize hardware design and prepare devices for normal operation.
    prev_rtc_events = 0;
    ret = zed_rtc_demo_init(&demo);
    if (ret != 0){
    	 xil_printf("zed_rtc_demo_init failed! Test ABORT!\n\r");
    	return -1;
    }

    xil_printf("Begin capturing RTC reported one second alarm events...\n\r");
    xil_printf("\n\r");

    /* During the main execution loop, monitor for occurrence of new RTC
     * event reports.
     */
    while (demo.rtc_events < TEST_INTERRUPT_COUNT)
    {
        if (prev_rtc_events != demo.rtc_events)
        {
            prev_rtc_events = demo.rtc_events;

            /* Raw date and time data is retrieved from the RTC by the ISR
             * so it needs to be converted into a decimal format first.
             */
            ret = zed_rtc_demo_calculate_datetime(&demo);
            if (ret != 0){
				 xil_printf("zed_rtc_demo_calculate_datetime failed! Test ABORT!\n\r");
				return -1;
			}
            /* Now that the time exists in decimal format, it can be printed
             * for human consumption at the terminal.
             */
            xil_printf("RTC: IRQs:%4d, ", demo.rtc_irqs);
            xil_printf("Events: %4d, ", demo.rtc_events);
            xil_printf("Status: 0x%02X, ", demo.rtc_status);
            xil_printf("Temp: %02d.%02d, ", (char) demo.rtc_temp_upper, (((demo.rtc_temp_lower >> 6) & 0x03) * 25));
            xil_printf("Date: %02d-%02d-%02d, ", demo.rtc_month, demo.rtc_date, demo.rtc_year);
            xil_printf("Time: %02d:%02d:%02d, ", demo.rtc_hours, demo.rtc_minutes, demo.rtc_seconds);

            xil_printf("Day: ");

            switch (demo.rtc_day)
            {
            case (1):
               xil_printf("Sunday");
               break;
            case (2):
               xil_printf("Monday");
               break;
            case (3):
               xil_printf("Tuesday");
               break;
            case (4):
               xil_printf("Wednesday");
               break;
            case (5):
               xil_printf("Thursday");
               break;
            case (6):
               xil_printf("Friday");
               break;
            case (7):
               xil_printf("Saturday");
               break;
            default:
               xil_printf("Mayday!");
            }

            xil_printf("\n\r");
        }
    }

    /* Determine overall test result and print results to test operator.
     */
    xil_printf("\r\n");
    xil_printf("RTC Test: ");

    if (demo.rtc_events >= TEST_INTERRUPT_COUNT)
    {
        xil_printf("\033[32mPASSED\033[0m\r\n");
        return 0;
    }
    else
    {
        xil_printf("\033[5mFAILED\033[0m\r\n");
        return -1;
    }

    return 0;
}

int main()
{
	int ret;

    init_platform();

    ret = run_rtc_test();

    cleanup_platform();

    return ret;
}

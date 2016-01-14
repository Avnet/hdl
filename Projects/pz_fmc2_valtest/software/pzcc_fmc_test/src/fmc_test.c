//----------------------------------------------------------------------------
//      _____
//     *     *
//    *____   *____
//   * *===*   *==*
//  *___*===*___**  AVNET Design Resource Center
//       *======*         www.em.avnet.com/drc
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
// Create Date:         Mar 14, 2013
// Tool versions:       SDK 14.4
// File Name:           fmc_test.c
// Description:         FMC LPC loopback test application.
//
//----------------------------------------------------------------------------


// ---------------------------------------------------------------------------
// System Includes.
// xstatus.h - Contains Xilinx software status codes.  Status codes have
//           their own data type called int.  These codes are used
//           throughout the Xilinx device drivers.
#include <xstatus.h>

// ---------------------------------------------------------------------------
// Local includes.
#include "fmc_lpc.h"
#include "platform.h"

int run_fmc_test()
{
	int32u verbosity = 1;
	XStatus final_result = XST_SUCCESS;
	XStatus unit_result = XST_SUCCESS;

    xil_printf("\n\r");

    xil_printf("---------------------------------------------------------------------------\n\r");
    xil_printf("--                                                                       --\n\r");
    xil_printf("--                  PZCC-FMC2 FMC Loopback Test Application              --\n\r");
    xil_printf("--                                                                       --\n\r");
    xil_printf("---------------------------------------------------------------------------\n\r");
    xil_printf("\n\r");

    /*
     * Setup for the FMC LPC test by initializing the corresponding GPIO
     * peripherals.
     */
    unit_result = fmc_lpc_setup(verbosity);
    if (unit_result != XST_SUCCESS)
	{
		final_result = XST_FAILURE;
	}

    /*
     * Perform the FMC LPC all zeros test, this rules out any stuck at 0 pins.
     */
    unit_result = fmc_lpc_all_zeros(verbosity);
    if (unit_result != XST_SUCCESS)
	{
		final_result = XST_FAILURE;
	}

    /*
     * Perform the FMC LPC all ones test, this rules out any stuck at 1 pins.
     */
    unit_result = fmc_lpc_all_ones(verbosity);
    if (unit_result != XST_SUCCESS)
	{
		final_result = XST_FAILURE;
	}

    /*
	 * Perform the FMC LPC walking zeros test, this rules out any unexpected
	 * shorted together nets.
	 */
    unit_result = fmc_lpc_walking_zeros(verbosity);
    if (unit_result != XST_SUCCESS)
	{
		final_result = XST_FAILURE;
	}

    /*
	 * Perform the FMC LPC walking ones test, this rules out any unexpected
	 * shorted together nets.
	 */
    unit_result = fmc_lpc_walking_ones(verbosity);
    if (unit_result != XST_SUCCESS)
	{
		final_result = XST_FAILURE;
	}

    /*
     * Determine overall test result and print results to test operator.
     */
    xil_printf("FMC LPC Loopback Test: ");

    if (final_result == XST_SUCCESS)
	{
		xil_printf("\033[32mPASSED\033[0m\r\n");
	}
    else
    {
    	xil_printf("\033[5mFAILED\033[0m\r\n");
	}

    return final_result;
}

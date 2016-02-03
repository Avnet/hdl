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
// File Name:           fmc_lpc.c
// Description:         FMC LPC loopback test routines.
//
//----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Local includes.
#include "fmc_lpc.h"

/*
 * The following constant maps to the name of the hardware instances that
 * were created in the XPS system.
 */
#define FMC_LPC_HIGH_DEVICE_ID  XPAR_AXI_GPIO_1_DEVICE_ID
#define FMC_LPC_LOW_DEVICE_ID  XPAR_AXI_GPIO_0_DEVICE_ID

/************************** Variable Definitions *****************************/

/*
 * The following are declared globally so they are zeroed and so they are
 * easily accessible from a debugger
 */

XGpio xgpio_fmc_lpc_high; /* The Instance of the GPIO for the high LA pair loopback instance. */
XGpio xgpio_fmc_lpc_low; /* The Instance of the GPIO for the low LA pair loopback instance. */

// ----------------------------------------------------------------
XStatus fmc_lpc_setup(int32u verbosity)
{
	XStatus final_result = XST_SUCCESS;
	XStatus unit_result = XST_SUCCESS;

	/*
	 * Initialize the GPIO driver instances.
	 */
	unit_result = XGpio_Initialize(&xgpio_fmc_lpc_high, FMC_LPC_HIGH_DEVICE_ID);
	if (unit_result != XST_SUCCESS)
	{
		final_result = XST_FAILURE;
	}

	unit_result = XGpio_Initialize(&xgpio_fmc_lpc_low, FMC_LPC_LOW_DEVICE_ID);
	if (unit_result != XST_SUCCESS)
	{
		final_result = XST_FAILURE;
	}
    
    return final_result;
}

// ---------------------------------------------------------------------------
XStatus fmc_lpc_test(int32u test_pattern, int32u verbosity)
{
    int32u delay_wait = 1;
    int32u fail = 0;
    int32u test_pattern_high_channel1;
    int32u test_pattern_high_channel2;
    int32u test_pattern_low_channel1;
    int32u test_pattern_low_channel2;
    XStatus result = XST_SUCCESS;

    /*
	 * Set the direction for both of the channel1 IOs to output.
	 */
	XGpio_SetDataDirection(&xgpio_fmc_lpc_high, GPIO_CHANNEL1, ~FMC_LPC_BIT_MASK);
	XGpio_SetDataDirection(&xgpio_fmc_lpc_low, GPIO_CHANNEL1, ~FMC_LPC_BIT_MASK);

	/*
	 * Set the direction for both of the channel2 IOs to input.
	 */
	XGpio_SetDataDirection(&xgpio_fmc_lpc_high, GPIO_CHANNEL2, FMC_LPC_BIT_MASK);
	XGpio_SetDataDirection(&xgpio_fmc_lpc_low, GPIO_CHANNEL2, FMC_LPC_BIT_MASK);

	/*
	 * Set the values of each of the output channels.
	 */
	test_pattern_high_channel1 = (test_pattern & FMC_LPC_BIT_MASK);
	test_pattern_low_channel1 = (test_pattern & FMC_LPC_BIT_MASK);
	XGpio_DiscreteWrite(&xgpio_fmc_lpc_high, GPIO_CHANNEL1, test_pattern_high_channel1 & FMC_LPC_BIT_MASK);
	XGpio_DiscreteWrite(&xgpio_fmc_lpc_low, GPIO_CHANNEL1, test_pattern_low_channel1 & FMC_LPC_BIT_MASK);

    /*
     * Wait for some time to get the loopback propagation latched.
     */
    while (delay_wait-- > 0);

    /*
	 * Get the values of each of the input channels.
	 */
    test_pattern_high_channel2 = (XGpio_DiscreteRead(&xgpio_fmc_lpc_high, GPIO_CHANNEL2) & FMC_LPC_BIT_MASK);
    test_pattern_low_channel2 = (XGpio_DiscreteRead(&xgpio_fmc_lpc_low, GPIO_CHANNEL2) & FMC_LPC_BIT_MASK);

    /*
     * Compare the values of each of the result registers to determine if the
     * test pattern propagated successfully.
     */
    if (test_pattern_high_channel1 != test_pattern_high_channel2)
    {       
        xil_printf("   \033[5mFAILURE\033[0m on FMC LPC high bank: expected 0x%08X, actual 0x%08X\r\n", test_pattern_high_channel1, test_pattern_high_channel2);

        fail = 1;
    }
    else if (verbosity)
	{
    	xil_printf("   SUCCESS on FMC LPC high bank: expected 0x%08X, actual 0x%08X\r\n", test_pattern_high_channel1, test_pattern_high_channel2);
	}

    if (test_pattern_low_channel1 != test_pattern_low_channel2)
    {
    	xil_printf("   \033[5mFAILURE\033[0m on FMC LPC low  bank: expected 0x%08X, actual 0x%08X\r\n", test_pattern_low_channel1, test_pattern_low_channel2);

        fail = 1;
    }
    else if (verbosity)
    {
    	xil_printf("   SUCCESS on FMC LPC low  bank: expected 0x%08X, actual 0x%08X\r\n", test_pattern_low_channel1, test_pattern_low_channel2);
    }

    if (fail == 0)
    {
        return result;
    }

    return XST_FAILURE;
}


// ---------------------------------------------------------------------------
XStatus fmc_lpc_walking_ones(int32u verbosity)
{
    int bit_under_test;
    int32u fail = 0;
    int32u wones = 0x00000001;
    XStatus result = XST_SUCCESS;
    
    for (bit_under_test = 0; bit_under_test < FMC_LPC_BIT_WIDTH; bit_under_test++)
    {
		// Perform the test result comparison.
        result = fmc_lpc_test(wones, verbosity);
        
        if (result == XST_FAILURE)
        {
            fail = 1;
        }

		// If this is a deep debug mode, prompt the operator before continuing
		// the test sequence.
		if (verbosity > 1)
		{
			xil_printf("Bits currently under test: %d\r\n\r\n", bit_under_test);
		}
		
        // Shift the one in the test pattern to prepare for the next test 
        // iteration.
        wones = wones << 1;
    }
    
    // Show the result of the test as either pass or fail.
    if (verbosity > 0)
	{
		xil_printf("Walking ones FMC LPC Test...");
	}
    
    if (fail == 0)
    {
        if (verbosity > 0)
        {
            xil_printf("\033[32mPASSED\033[0m\r\n\r\n");
        }
        
        return result;
    }
    
    if (verbosity > 0)
    {
        xil_printf("\033[5mFAILED\033[0m\r\n\r\n");
    }
    
    return XST_FAILURE;
}


// ---------------------------------------------------------------------------
XStatus fmc_lpc_walking_zeros(int32u verbosity)
{
    int bit_under_test;
    int32u fail = 0;
    int32u wzeros = 0xFFFFFFFE;
    XStatus result = XST_SUCCESS;   
    
    for (bit_under_test = 0; bit_under_test < FMC_LPC_BIT_WIDTH; bit_under_test++)
    {   
        // Perform the test result comparison.
        result = fmc_lpc_test(wzeros, verbosity);
        
        if (result == XST_FAILURE)
        {
            fail = 1;
        }

		// If this is a deep debug mode, prompt the operator before continuing
		// the test sequence.
		if (verbosity > 1)
		{
			xil_printf("Bits currently under test: %d\r\n\r\n", bit_under_test);
		}
		
        // Shift the zero in the test pattern to prepare for the next test 
        // iteration.
        wzeros = ~(wzeros);
        wzeros = wzeros << 1;
        wzeros = ~(wzeros);        
    }

    // Show the result of the test as either pass or fail.
    if (verbosity > 0)
	{
		xil_printf("Walking zeros FMC LPC Test...");
	}
    
    if (fail == 0)
    {
        if (verbosity > 0)
        {
            xil_printf("\033[32mPASSED\033[0m\r\n\r\n");
        }
        
        return result;
    }

    if (verbosity > 0)
    {
        xil_printf("\033[5mFAILED\033[0m\r\n\r\n");
    }
    
    return XST_FAILURE;    
}

// ---------------------------------------------------------------------------
XStatus fmc_lpc_all_zeros(int32u verbosity)
{
    int32u fail = 0;
    int32u zeros = 0x00000000;
    XStatus result = XST_SUCCESS;       
    
    // Perform the test result comparison.
    result = fmc_lpc_test(zeros, verbosity);
    
    if (result == XST_FAILURE)
    {
        fail = 1;
    }
    
    // Show the result of the test as either pass or fail.
    if (verbosity > 0)
	{
		xil_printf("All zeros FMC LPC Test...");
	}
    
    if (fail == 0)
    {
        if (verbosity > 0)
        {
            xil_printf("\033[32mPASSED\033[0m\r\n\r\n");
        }
        
        return result;
    }

    if (verbosity > 0)
    {
        xil_printf("\033[5mFAILED\033[0m\r\n\r\n");
    }
    
    return XST_FAILURE;    
}


// ---------------------------------------------------------------------------
XStatus fmc_lpc_all_ones(int32u verbosity)
{
    int32u fail = 0;
    int32u ones = 0xFFFFFFFF;
    XStatus result = XST_SUCCESS;       
    
    // Perform the test result comparison.
    result = fmc_lpc_test(ones, verbosity);
    
    if (result == XST_FAILURE)
    {
        fail = 1;
    }
    
    // Show the result of the test as either pass or fail.
    if (verbosity > 0)
	{
		xil_printf("All ones FMC LPC Test...");
	}
    
    if (fail == 0)
    {
        if (verbosity > 0)
        {
            xil_printf("\033[32mPASSED\033[0m\r\n\r\n");
        }
        
        return result;
    }

    if (verbosity > 0)
    {
        xil_printf("\033[5mFAILED\033[0m\r\n\r\n");
    }
    
    return XST_FAILURE;    
}


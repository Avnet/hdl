//----------------------------------------------------------------------------
//
//       ** **        **          **  ****      **  **********  ********** �
//      **   **        **        **   ** **     **  **              **
//     **     **        **      **    **  **    **  **              **
//    **       **        **    **     **   **   **  *********       **
//   **         **        **  **      **    **  **  **              **
//  **           **        ****       **     ** **  **              **
// **  .........  **        **        **      ****  **********      **
//    ...........
//                                    Reach Further�
//
//----------------------------------------------------------------------------
//
// This design is the property of Avnet.  Publication of this
// design is not authorized without written consent from Avnet.
//
// Please direct any questions to the UltraZed community support forum:
//    http://www.ultrazed.org/forum
//
// Product information is available at:
//    http://www.ultrazed.org/product/ultrazed
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2017 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Oct 02, 2017
// Design Name:         UltraZed PCIe Carrier TPM Pmod Test
// Module Name:         main.c
// Project Name:        UltraZed PCIe Carrier TPM Pmod Test
// Target Devices:      Xilinx Zynq UltraScale+
// Hardware Boards:     UltraZed, UltraZed PCIe Carrier
//
// Tool versions:       Xilinx Vivado 2017.2
//
// Description:         TPM Pmod test for UltraZed PCIe Carrier
//
// Dependencies:
//
// Revision:            Oct 02, 2017: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "platform.h"
#include "tpm_pmod_demo.h"
#include "slb9670_tpm_spi.h"
#include "xgpiops.h"

#define TPM_DID_VID_9670 0x001B15D1L

extern int startup_tpm_get_random();
extern int tpm_spi_read_bytes (u32 addr, u8 len, u8 *result);
extern int tpm_request_locality();
extern int tpm_get_accessreg();

// This is the top level demo instance.
tpm_pmod_demo_t demo;


int test_tpm(tpm_pmod_demo_t *pDemo)
{
	u32 status = 0;
	u32 didvid = 0;

	if (XSpiPS_SLB9670_INIT(SPI_BASEADDR) != 0)
	{
		xil_printf("\n\rFailed to initialize SPI controller, check TPM Pmod connection\n\r");
		return -1;
	}
	else
	{
		xil_printf("\n\rSpi Controller Init Done, Not Resetting TPM\n\r\n");
	}

    xil_printf("\n\rAccess reg in the beginning of time is 0x%x\n\r", tpm_get_accessreg());

    tpm_request_locality();

    if ((tpm_get_accessreg() & TPM_ACTIVE_LOCALITY) != TPM_ACTIVE_LOCALITY)
    {
        xil_printf("Failed to get TPM access\r\n");
        return -1;
    }
    else
    {
    	print("TPM Access Granted!\r\n");
    }

	if (tpm_spi_read_bytes(TPM_DIDVID, 4, (u8*)&didvid) != 0)
	{
		xil_printf("Failed to read TPM DID/VID\n\r");
		return -1;
	}

	if (didvid != TPM_DID_VID_9670)
	{

		xil_printf("Unknown DID-VID: 0x%08X, expected 0x%08X, check TPM Pmod\n\r", didvid, TPM_DID_VID_9670);
		return -1;
	}
	else
	{
		xil_printf("Detected SLB9670 DID-VID: 0x%08X\n\r", didvid);
	}

	/* Perform the get_random() function with the TPM to see if it really is
	 * providing some random data;
	 */
	startup_tpm_get_random();

	return status;
}


int run_tpm_pmod_test(void)
{
	int ret;
	int pass_fail = 0;

	xil_printf("\n\r");

	xil_printf("---------------------------------------------------------------------------\n\r");
	xil_printf("--                                                                       --\n\r");
	xil_printf("--                   TPM 1.2 and 2.0 Pmod Test Application               --\n\r");
	xil_printf("--                                                                       --\n\r");
	xil_printf("---------------------------------------------------------------------------\n\r");
	xil_printf("\n\r");

    ret = test_tpm(&demo);

    if (ret != 0)
    {
    	 xil_printf("test_tpm failed! Test ABORT!\n\r");
    	 pass_fail = -1;
    }

    /* Determine overall test result and print results to test operator.
     */
    xil_printf("\r\n");
    xil_printf("\r\n");
    xil_printf("\r\n");
    xil_printf("TPM Pmod Test: ");

    if (pass_fail == 0)
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
    init_platform();

    run_tpm_pmod_test();

    cleanup_platform();

    return 0;
}

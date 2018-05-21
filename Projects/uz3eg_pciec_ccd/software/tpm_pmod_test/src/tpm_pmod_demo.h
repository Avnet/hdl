//----------------------------------------------------------------------------
//
//       ** **        **          **  ****      **  **********  ********** ®
//      **   **        **        **   ** **     **  **              **
//     **     **        **      **    **  **    **  **              **
//    **       **        **    **     **   **   **  *********       **
//   **         **        **  **      **    **  **  **              **
//  **           **        ****       **     ** **  **              **
// **  .........  **        **        **      ****  **********      **
//    ...........
//                                    Reach Further™
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
// Module Name:         tpm_pmod_demo.h
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

#ifndef TPM_PMOD_DEMO_H_
#define TPM_PMOD_DEMO_H_

#include "xparameters.h"
#include "types.h"

// This structure contains the context for the
// TPM Pmod Demonstration
struct struct_tpm_pmod_demo_t
{
   int32u bVerbose;
};

typedef struct struct_tpm_pmod_demo_t tpm_pmod_demo_t;

int run_tpm_pmod_test(void);
int test_tpm(tpm_pmod_demo_t *pDemo);

#endif /* TPM_PMOD_DEMO_H_ */

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
// Please direct any questions to the PicoZed community support forum:
//    http://www.picozed.org/forum
//
// Product information is available at:
//    http://www.picozed.org/product/picozed
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
// Design Name:         PicoZed FMC Loopback Test
// Module Name:         main.c
// Project Name:        PicoZed + FMC2 Carrier
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     PicoZed + FMC2 Carrier
//
// Tool versions:       Xilinx Vivado 2015.2
//
// Description:         PicoZed FMC Loopback
//
// Dependencies:
//
// Revision:            Jul 21, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "platform.h"

void print(const char *str);

int run_fmc_test();

int main()
{
    int ret;

    init_platform();

    ret = run_fmc_test();

    cleanup_platform();

    return ret;
}

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
// Target Devices:      Zynq-7000
// Hardware Boards:     MicroZed + Real Time Clock Pmod
//
// Tool versions:       Vivado 2014.4
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
#include "unio_eeprom.h"
#include "unio_eeprom_test.h"

int main()
{
    int ret;

    init_platform();

    ret = run_unio_eeprom_test();

    cleanup_platform();

    return ret;
}

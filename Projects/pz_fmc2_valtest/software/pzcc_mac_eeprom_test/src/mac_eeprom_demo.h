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
// Create Date:         Nov 24, 2015
// Design Name:         PicoZed IIC MAC EEPROM Demonstration
// Module Name:         mac_eeprom_demo.h
// Project Name:        PicoZed + FMC2 Carrier
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     PicoZed + FMC2 Carrier
//
// Tool versions:       Xilinx Vivado 2015.2
//
// Description:         PicoZed IIC MAC EEPROM Demonstration
//
// Dependencies:
//
// Revision:            Nov 24, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#ifndef __MAC_EEPROM_DEMO_H__
#define __MAC_EEPROM_DEMO_H__

#include "xparameters.h"
#include "types.h"

#include "sleep.h"

// I2C related.
#include "zed_iic.h"

// Interrupt related
#include "xscugic.h"
#include "xil_exception.h"

// This structure contains the context for the
// Zed Real Time Clock Demonstration
struct struct_iic_eeprom_demo_t
{
   int32u bVerbose;

   ////////////////////////////////
   // RTC I2C related context
   ////////////////////////////////
   int32u uBaseAddr_IIC_RTC;

   zed_iic_t eeprom_iic;
};

typedef struct struct_iic_eeprom_demo_t iic_eeprom_demo_t;

int zed_mac_eeprom_demo_init(iic_eeprom_demo_t *pDemo);
int dump_mac_eeprom_memory(iic_eeprom_demo_t *pDemo);
int validate_mac_eeprom_memory(iic_eeprom_demo_t *pDemo);
int erase_mac_eeprom_memory(iic_eeprom_demo_t *pDemo);

#endif // __MAC_EEPROM_DEMO_H__

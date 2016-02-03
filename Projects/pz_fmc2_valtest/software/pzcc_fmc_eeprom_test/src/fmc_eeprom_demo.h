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
// Create Date:         Nov 03, 2015
// Design Name:         PicoZed FMC IIC EEPROM Demonstration
// Module Name:         fmc_eeprom_demo.h
// Project Name:        PicoZed + FMC2 Carrier
// Target Devices:      Xilinx Zynq-7000
// Hardware Boards:     PicoZed + FMC2 Carrier
//
// Tool versions:       Xilinx Vivado 2015.2
//
// Description:         PicoZed FMC IIC EEPROM Demonstration
//
// Dependencies:
//
// Revision:            Nov 03, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#ifndef __FMC_EEPROM_DEMO_H__
#define __FMC_EEPROM_DEMO_H__

#include "xparameters.h"
#include "types.h"

#include "sleep.h"

// I2C related.
#include "zed_iic.h"

// Interrupt related
#include "xscugic.h"
#include "xil_exception.h"

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
//#define GPIO_DEVICE_ID  	XPAR_XGPIOPS_0_DEVICE_ID

// This structure contains the context for the
// FMC IIC EEPROM Demonstration
struct struct_iic_eeprom_demo_t
{
   int32u bVerbose;

   ////////////////////////////////
   // FMC I2C related context
   ////////////////////////////////
   int32u uBaseAddr_IIC_FMC;

   zed_iic_t eeprom_iic;
};
typedef struct struct_iic_eeprom_demo_t iic_eeprom_demo_t;

int zed_iic_eeprom_demo_init(iic_eeprom_demo_t *pDemo);
int dump_iic_eeprom_memory(iic_eeprom_demo_t *pDemo);
int validate_iic_eeprom_memory(iic_eeprom_demo_t *pDemo);
int erase_iic_eeprom_memory(iic_eeprom_demo_t *pDemo);
int default_iic_eeprom_memory(iic_eeprom_demo_t *pDemo);

#endif // __FMC_EEPROM_DEMO_H__

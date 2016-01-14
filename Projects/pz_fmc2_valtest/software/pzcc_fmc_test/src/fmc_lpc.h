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
// File Name:           fmc_lpc.h
// Description:         FMC LPC loopback test routines.
//
//----------------------------------------------------------------------------

#ifndef FMC_LPC_H
#define FMC_LPC_H

// ---------------------------------------------------------------------------
// System Includes.
// xbasic_types.h - Contains basic types for Xilinx software IP.  These 
//           types do not follow the standard naming convention with respect 
//           to using the component name in front of each name because they 
//           are considered to be primitives.
// xgpio.h - Used to access the general purpose I/O.
// xparameters.h - General purpose definitions.  Must always be included
//           when any drivers/print routines are accessed.  This defines
//           physical addresses of all peripherals, declares the interrupt 
//           service routines, declare STDIN/STDOUT devices etc.
// xstatus.h - Contains Xilinx software status codes.  Status codes have 
//           their own data type called int.  These codes are used 
//           throughout the Xilinx device drivers.
#include <xbasic_types.h>
#include <xgpio.h>
#include <xparameters.h>
#include <xstatus.h>

// ---------------------------------------------------------------------------
// Local include Files.
#include "types.h"

// Constant definitions.
// ---------------------------------------------------------------------------
#define FMC_LPC_BIT_MASK					0x0003FFFF
#define FMC_LPC_BIT_WIDTH					18
#define GPIO_CHANNEL1						1
#define GPIO_CHANNEL2						2

// ---------------------------------------------------------------------------
// Function prototype declarations.
XStatus fmc_lpc_setup(int32u verbosity);
XStatus fmc_lpc_test(int32u test_pattern, int32u verbosity);
XStatus fmc_lpc_walking_ones(int32u verbosity);
XStatus fmc_lpc_walking_zeros(int32u verbosity);
XStatus fmc_lpc_all_zeros(int32u verbosity);
XStatus fmc_lpc_all_ones(int32u verbosity);

#endif // FMC_LPC_H

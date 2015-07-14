//----------------------------------------------------------------
//      _____
//     /     \
//    /____   \____
//   / \===\   \==/
//  /___\===\___\/  AVNET
//       \======/
//        \====/    
//---------------------------------------------------------------
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
//                     Copyright(c) 2010 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------
//
// Create Date:         Jan 08, 2010
// Design Name:         FMC IPMI
// Module Name:         fmc_ipmi.h
// Project Name:        FMC IPMI
// Target Devices:      Spartan-6, Virtex-6, Kintex-7
// Avnet Boards:        FMC-IMAGEOV, FMC-DVI/DP, FMC-ISM
//                      FMC-IMAGEON, FMC-MOTORTI
//
// Tool versions:       ISE 13.2
//
// Description:         FMC IPMI FRU Management
//
// Dependencies:        
//
// Revision:            Jan 08, 2010: 1.01 Initial version
//                      Aug 31, 2011: 2.01 Fix issue related to write timeout
//                                         when code running in BRAM
//                      Feb 20, 2012: 2.02 Include "xbasic_types.h" for Xuint data types
//
//----------------------------------------------------------------

#ifndef __FMC_IPMI_H__
#define __FMC_IPMI_H__

#include <stdio.h>

#include "xbasic_types.h" // required for Xuint data types

#define FMC_ID_SLOT1 1  // defined to be 0xA0
#define FMC_ID_SLOT2 2  // defined to be 0xA2 or 0xA4
#define FMC_ID_ALL   0  // defined to be 0xA0, 0xA2, 0xA4, or 0xA6

Xuint8 detect_ipmi_address( fmc_iic_t *pIIC, int fmcId );
int fmc_ipmi_detect( fmc_iic_t *pIIC, char *szExpected, int fmcId );
int fmc_ipmi_enable( fmc_iic_t *pIIC, int fmcId );
int fmc_ipmi_disable( fmc_iic_t *pIIC, int fmcId );

#endif // __FMC_IPMI_H__

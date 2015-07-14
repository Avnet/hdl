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
// Create Date:         Nov 26, 2009
// Design Name:         FMC_IPMI_FRU
// Module Name:         fmc_ipmi_fru.h
// Project Name:        FMC_IPMI_FRU
// Target Devices:      Spartan-6, Virtex-6, Kintex-7
// Avnet Boards:        FMC-IMAGEOV, FMC-DVI/DP, FMC-ISM
//                      FMC-IMAGEON, FMC-MOTORTI
//
// Tool versions:       ISE 13.4
//
// Description:         FMC IPMI FRU Management
//
// Dependencies:        
//
// Revision:            Nov 26, 2009: 1.00 Initial version
//                      Aug 31, 2011: 2.01 Fix issue related to write timeout
//                                         when code running in BRAM
//                      Feb 20, 2012: 2.02 Include "xbasic_types.h" for Xuint data types
//
//----------------------------------------------------------------

#ifndef __FMC_IPMI_FRU_H__
#define __FMC_IPMI_FRU_H__

#include <stdio.h>

#include "xbasic_types.h" // required for Xuint data types

// Error codes
#define FRU_SUCCESS           0
#define FRU_CHECKSUM_ERROR    -1
#define FRU_VERSION_ERROR     -2
#define FRU_I2C_ERROR         -3
#define FRU_I2C_TIMEOUT       -4

// This define should be set local to project
// (I just don't know how to do this in EDK ...)
#define FMC_IPMI_PRODUCTION

// FRU Management Data Types

// Common Header
struct fru_header
{
	Xuint8 version;
	struct
   {
		Xuint8 internal;
		Xuint8 chassis;
		Xuint8 board;
		Xuint8 product;
		Xuint8 multi;
	} offset;
	Xuint8 pad;
	Xuint8 checksum;
};

// Board Info Area
struct fru_area_board
{
	Xuint8 area_ver;
	Xuint32 mfg_date_time;
	Xuint8 lang;
	char * mfg;
	char * prod;
	char * serial;
	char * part;
	char * fru;
   //
	Xuint16 area_len;
   Xuint8 area_data[120]; // for now, fixed length
};

// Multi-Record Info Area
struct fru_multirec_header
{
#define FRU_RECORD_TYPE_POWER_SUPPLY_INFORMATION 0x00
#define FRU_RECORD_TYPE_DC_OUTPUT 0x01
#define FRU_RECORD_TYPE_DC_LOAD 0x02
#define FRU_RECORD_TYPE_MANAGEMENT_ACCESS 0x03
#define FRU_RECORD_TYPE_BASE_COMPATIBILITY 0x04
#define FRU_RECORD_TYPE_EXTENDED_COMPATIBILITY 0x05
#define FRU_RECORD_TYPE_OEM_EXTENSION	0xc0
	Xuint8 type;
	Xuint8 format;
	Xuint8 len;
	Xuint8 record_checksum;
	Xuint8 header_checksum;
};

struct fru_multirec_powersupply
{
#if WORDS_BIGENDIAN
	Xuint16 capacity;
#else
	Xuint16 capacity:12;
	Xuint16 __reserved1:4;
#endif
	Xuint16 peak_va;
	Xuint8 inrush_current;
	Xuint8 inrush_interval;
	Xuint16 lowend_input1;
	Xuint16 highend_input1;
	Xuint16 lowend_input2;
	Xuint16 highend_input2;
	Xuint8 lowend_freq;
	Xuint8 highend_freq;
	Xuint8 dropout_tolerance;
#if WORDS_BIGENDIAN
	Xuint8 __reserved2:3;
	Xuint8 tach:1;
	Xuint8 hotswap:1;
	Xuint8 autoswitch:1;
	Xuint8 pfc:1;
	Xuint8 predictive_fail:1;
#else
	Xuint8 predictive_fail:1;
	Xuint8 pfc:1;
	Xuint8 autoswitch:1;
	Xuint8 hotswap:1;
	Xuint8 tach:1;
	Xuint8 __reserved2:3;
#endif
	Xuint16 peak_cap_ht;
#if WORDS_BIGENDIAN
	Xuint8 combined_voltage1:4;
	Xuint8 combined_voltage2:4;
#else
	Xuint8 combined_voltage2:4;
	Xuint8 combined_voltage1:4;
#endif
	Xuint16 combined_capacity;
	Xuint8 rps_threshold;
} __attribute__ ((packed));

static const char * combined_voltage_desc[] __attribute__((unused)) = {
"12 V", "-12 V", "5 V", "3.3 V"};

struct fru_multirec_dcoutput {
#if WORDS_BIGENDIAN
	Xuint8 standby:1;
	Xuint8 __reserved:3;
	Xuint8 output_number:4;
#else
	Xuint8 output_number:4;
	Xuint8 __reserved:3;
	Xuint8 standby:1;
#endif
	short nominal_voltage;
	short max_neg_dev;
	short max_pos_dev;
	Xuint16 ripple_and_noise;
	Xuint16 min_current;
	Xuint16 max_current;
} __attribute__ ((packed));

struct fru_multirec_dcload {
#if WORDS_BIGENDIAN
	Xuint8 __reserved:4;
	Xuint8 output_number:4;
#else
	Xuint8 output_number:4;
	Xuint8 __reserved:4;
#endif
	short nominal_voltage;
	short min_voltage;
	short max_voltage;
	Xuint16 ripple_and_noise;
	Xuint16 min_current;
	Xuint16 max_current;
} __attribute__ ((packed));

#define SECS_FROM_1970_1996   820450800

#include "fmc_iic.h"

// FRU Managenement Functions (Read)
int fmc_ipmi_get_common_info( fmc_iic_t *pIIC, Xuint8 iic_address, struct fru_header *common_info );
int fmc_ipmi_get_board_info ( fmc_iic_t *pIIC, Xuint8 iic_address, struct fru_area_board *board_info );

// FRU Managenement Functions (Write)
#if defined(FMC_IPMI_PRODUCTION)
int fmc_ipmi_set_common_info( fmc_iic_t *pIIC, Xuint8 iic_address, struct fru_header *common_info );
int fmc_ipmi_set_board_info ( fmc_iic_t *pIIC, Xuint8 iic_address, struct fru_area_board *board_info );
#endif // defined(FMC_IPMI_PRODUCTION)

#endif // __FMC_IPMI_FRU_H__

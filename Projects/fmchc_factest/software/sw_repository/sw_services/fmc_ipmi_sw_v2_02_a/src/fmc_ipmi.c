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
//                     Copyright(c) 2009 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------
//
// Create Date:         Nov 11, 2009
// Design Name:         FMC IPMI
// Module Name:         fmc_ipmi.c
// Project Name:        FMC IPMI
// Target Devices:      Spartan-6, Virtex-6, Kintex-7
// Avnet Boards:        FMC-IMAGEOV, FMC-DVI/DP, FMC-ISM
//                      FMC-IMAGEON, FMC-MOTORTI
//
// Tool versions:       ISE 13.2
//
// Description:         FMC IPMI
//
// Dependencies:        
//
// Revision:            Nov 11, 2009: 1.00 Initial version
//                      Aug 31, 2011: 2.01 Fix issue related to write timeout
//                                         when code running in BRAM
//                      Feb 20, 2012: 2.02 Include "xbasic_types.h" for Xuint data types
//
//----------------------------------------------------------------

#include <stdio.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "fmc_iic.h"
#include "fmc_ipmi.h"
#include "fmc_ipmi_fru.h"

Xuint8 detect_ipmi_address( fmc_iic_t *pIIC, int fmcId )
{
   Xuint8 ipmi_address = 0x00;
   Xuint8 min_address;
   Xuint8 max_address;

   Xuint8 iic_address;
   Xuint8 iic_data;

   switch (fmcId)
   {
      case FMC_ID_SLOT1:
         min_address = 0xA0;
		 max_address = 0xA0;
         break;
      case FMC_ID_SLOT2:
         min_address = 0xA2;
		 max_address = 0xA4;
         break;
      case FMC_ID_ALL:
         min_address = 0xA0;
		 max_address = 0xA6;
         break;
      default:
         min_address = 0xA0;
		 max_address = 0xA6;
         break;
   }

   for ( ipmi_address = min_address; ipmi_address <= max_address; ipmi_address += 2 )
   {
      //xil_printf( "Checking IPMI EEPROM at Address = 0x%02X\n\r", ipmi_address );
	  iic_address = ipmi_address>>1;
      if ( pIIC->fpIicRead( pIIC, iic_address, 0, &iic_data, 1 ) )
	  {
         //xil_printf( "Detected IPMI EEPROM at Address = 0x%02X\n\r", ipmi_address );
         break;
	  }
   }
   // If none were detected in range, use the max value
   if ( ipmi_address > max_address )
   {
	   ipmi_address = max_address;
   }

   return ipmi_address;
}

int fmc_ipmi_detect( fmc_iic_t *pIIC, char *szExpected, int fmcId )
{
   Xuint8 ipmi_eeprom_address;
   struct fru_area_board board_info;
   int retval;

   xil_printf("FMC Module Validation\n\r" );

   // I2C Address of IPMI EEPROM
   ipmi_eeprom_address = detect_ipmi_address( pIIC, fmcId );
   //xil_printf( "IPMI EEPROM Address = 0x%02X\n\r", ipmi_eeprom_address );

   // Read FRU Board Info from IPMI EEPROM
   retval = fmc_ipmi_get_board_info( pIIC, ipmi_eeprom_address, &board_info );
   if ( retval == FRU_SUCCESS )
   {
      // Display Board Information
      xil_printf( "Board Information:\n\r" );
      xil_printf( "\tManufacturer    = %s\n\r", board_info.mfg    );
      xil_printf( "\tProduct Name    = %s\n\r", board_info.prod   );
      xil_printf( "\tSerial Number   = %s\n\r", board_info.serial );
      xil_printf( "\tPart Number     = %s\n\r", board_info.part   );

      // Validate presence of FMC module
      if ( !strcmp( board_info.prod, szExpected ) )
      {
         xil_printf( "SUCCESS : Detected %s module!\n\r", board_info.prod );
         //fmc_ipmi_enable( pIIC, fmcId );
		 return 1;
      }
      else
      {
         // Error due to unexpected FMC module
         xil_printf( "ERROR : Unexpected %s module, Expected %s module\n\r",
                     board_info.prod, szExpected );
         //fmc_ipmi_disable( pIIC, fmcId );
		 return 0;
      }
   }
   else if ( retval == FRU_I2C_ERROR )
   {
      // Error due to unpopulated FMC slot
      xil_printf( "ERROR : No FMC module detected\n\r" );
      //fmc_ipmi_disable( pIIC, fmcId );
      return 0;
   }
   else
   {
      // Error due to invalid IPMI EEPROM
      xil_printf( "ERROR : FMC module does not have valid FRU content in its IPMI EEPROM\n\r" );
      //fmc_ipmi_disable( pIIC, fmcId );
      return 0;
   }
}

int fmc_ipmi_enable( fmc_iic_t *pIIC, int fmcId )
{
   Xuint32 value;

   pIIC->fpGpoRead( pIIC, &value );
   if ( fmcId == FMC_ID_SLOT1 )
   {
      value = value | 0x00000001; // Force bit 0 to 1
   }
   else if ( fmcId == FMC_ID_SLOT2 )
   {
      value = value | 0x00000002; // Force bit 1 to 1
   }
   else
   {
      value = value | 0x00000003; // Force bits 1:0 to 1
   }
   pIIC->fpGpoWrite( pIIC, value );

   return 1;
}

int fmc_ipmi_disable( fmc_iic_t *pIIC, int fmcId )
{
   Xuint32 value;

   pIIC->fpGpoRead( pIIC, &value );
   if ( fmcId == FMC_ID_SLOT1 )
   {
      value = value & 0xFFFFFFFE; // Force bit 0 to 0
   }
   else if ( fmcId == FMC_ID_SLOT2 )
   {
      value = value & 0xFFFFFFFD; // Force bit 1 to 0
   }
   else
   {
      value = value & 0xFFFFFFFC; // Force bits 1:0 to 0
   }
   pIIC->fpGpoWrite( pIIC, value );

   return 1;
}

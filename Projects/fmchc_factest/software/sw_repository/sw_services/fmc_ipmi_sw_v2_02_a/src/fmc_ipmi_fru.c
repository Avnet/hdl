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
// Create Date:         Nov 11, 2009
// Design Name:         FMC_IPMI_FRU
// Module Name:         fmc_ipmi_fru.c
// Project Name:        FMC_IPMI_FRU
// Target Devices:      Spartan-6, Virtex-6, Kintex-7
// Avnet Boards:        FMC-IMAGEOV, FMC-DVI/DP, FMC-ISM
//                      FMC-IMAGEON, FMC-MOTORTI
//
// Tool versions:       ISE 13.4
//
// Description:         FMC IPMI FRU Management
//
//                      Currently supports:
//                      - Common Header (located at offset 0 in EEPROM)
//                      - Board Info Area (located at offset 8 in EEPROM)
//                      - Multi-Record Info Area (located at offset 128 in EEPROM)
//
// Limitations/Issues:  Limitations:
//                      - Board Info Area always written to fixed offset of 8 bytes
//
//                      Not implemented yet (required as per FMC specification, Section 5.5.1):
//                      - Multi-Record Info:
//                         - OEM record type 0xFA (FMC specific VITA record)
//                         - DC Load for each of : VADJ, 2P2V, 12P0V
//                         - DC Output for each of : VIO_B_M2C, VREF_A_M2C, VREF_B_M2C
//
// References:          FMC Specification:
//                      - http://www.vita.com/fmc.html
//
//                      Platform Management FRU Information Storage Definition V1.0
//                      - http://download.intel.com/design/servers/ipmi/FRU1011.pdf
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
#include <malloc.h>
#include <string.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "fmc_ipmi_fru.h"

// IPMITOOL routines (reused from ipmi_fru.c)
#define uint8_t  Xuint8
#define uint16_t Xuint16
#define uint32_t Xuint32
static char *buf2str( char *buf, int len );
static char *get_fru_area_str(uint8_t * data, uint32_t * offset);

////////////////////////////////////////////////////////////////////////
// FRU Management Functions (Read)
////////////////////////////////////////////////////////////////////////

int fmc_ipmi_get_common_info( fmc_iic_t *pIIC, Xuint8 iic_address, struct fru_header *common_info )
{
   Xuint8 num_bytes;
   Xuint8 data[8];
   Xuint8 checksum;
   int idx;
   
   // Read area from EEPROM via I2C   
   for ( idx = 0; idx < 8; idx++ )
   {
      num_bytes = pIIC->fpIicRead( pIIC, (Xint8)(iic_address>>1), idx, &data[idx], 1 ); 
      if ( num_bytes != 1 )
      {
         // I2C error, abort
         xil_printf( "[fmc_ipmi_get_common_info] FRU_I2C_ERROR (idx=%d)\n\r", idx );
         return FRU_I2C_ERROR;
      }
   }
   
   // Verify checksum
   checksum = 0;
   for ( idx = 0; idx < 8; idx++ )
   {
      checksum += data[idx];
   }
   if ( checksum != 0x00 )
   {
      // Checksum error, abort
      xil_printf( "[fmc_ipmi_get_common_info] FRU_CHECKSUM_ERROR\n\r" );
      return FRU_CHECKSUM_ERROR;
   }

   // Decode data   
   common_info->version         = data[0];
   common_info->offset.internal = data[1];
   common_info->offset.chassis  = data[2];
   common_info->offset.board    = data[3];
   common_info->offset.product  = data[4];
   common_info->offset.multi    = data[5];
	common_info->pad             = data[6];
   common_info->checksum        = data[7];
   
   // Verify version
   if ( common_info->version != 0x01 )
   {
      // Version error, abort
      xil_printf( "[fmc_ipmi_get_common_info] FRU_VERSION_ERROR\n\r" );
      return FRU_VERSION_ERROR;
   }
   
   return FRU_SUCCESS;
}


int fmc_ipmi_get_board_info( fmc_iic_t *pIIC, Xuint8 iic_address, struct fru_area_board *board_info )
{
   struct fru_header common_info;
   int retval;
   Xuint8 num_bytes;
   Xuint8 data;
   Xuint8 checksum;
   int offset = 0x08; // fixed offset of board_info in IPMI EEPROM
   int idx;
   int timeout;
   
   retval = fmc_ipmi_get_common_info( pIIC, iic_address, &common_info );
   if ( retval != FRU_SUCCESS )
   {
         // error, abort
         return retval;
   }
   offset = common_info.offset.board << 3;

   // Read area from EEPROM via I2C   
   board_info->area_len = sizeof(board_info->area_data);
   for ( idx = 0; idx < board_info->area_len; idx++ )
   {
      num_bytes = pIIC->fpIicRead( pIIC, (Xint8)(iic_address>>1), offset+idx, &board_info->area_data[idx], 1 ); 
      if ( num_bytes != 1 )
      {
         // I2C error, abort
         xil_printf( "[fmc_ipmi_get_board_info] FRU_I2C_ERROR (idx=%d)\n\r", idx );
         return FRU_I2C_ERROR;
      }
   }
   
   // Verify checksum
   checksum = 0;
   for ( idx = 0; idx < board_info->area_len; idx++ )
   {
      checksum += board_info->area_data[idx];
   }
   if ( checksum != 0x00 )
   {
      // Checksum error, abort
      xil_printf( "[fmc_ipmi_get_board_info] FRU_CHECKSUM_ERROR\n\r" );
      return FRU_CHECKSUM_ERROR;
   }

   #if 0
   // Verify contents of area
   //    using code from  IPMITOOL ipmi_fru.c fru_area_print_board()
   {
      char * fru_area;
      uint8_t * fru_data = board_info->area_data;
      uint32_t fru_len, area_len, i;
      //time_t tval;
      Xuint32 tval;

      i = 0;
      
      i++;	/* skip fru area version */
      area_len = fru_data[i++] * 8; /* fru area length */
      i++;	/* skip fru board language */
      tval=((fru_data[i+2] << 16) + (fru_data[i+1] << 8) + (fru_data[i]));
      xil_printf(" Board Mfg Date        : 0x%08X\n\r", tval);
      tval=tval * 60;
      xil_printf(" Board Mfg Date        : 0x%08X\n\r", tval);
      tval=tval + SECS_FROM_1970_1996;
      //xil_printf(" Board Mfg Date        : %s", asctime(localtime(&tval)));
      xil_printf(" Board Mfg Date        : 0x%08X\n\r", tval);
      i += 3;  /* skip mfg. date time */

      fru_area = get_fru_area_str(fru_data, &i);
      if (fru_area != NULL && strlen(fru_area) > 0) {
         xil_printf(" Board Mfg             : %s\n\r", fru_area);
         free(fru_area);
      }

      fru_area = get_fru_area_str(fru_data, &i);
      if (fru_area != NULL && strlen(fru_area) > 0) {
         xil_printf(" Board Product         : %s\n\r", fru_area);
         free(fru_area);
      }

      fru_area = get_fru_area_str(fru_data, &i);
      if (fru_area != NULL && strlen(fru_area) > 0) {
         xil_printf(" Board Serial          : %s\n\r", fru_area);
         free(fru_area);
      }

      fru_area = get_fru_area_str(fru_data, &i);
      if (fru_area != NULL && strlen(fru_area) > 0) {
         xil_printf(" Board Part Number     : %s\n\r", fru_area);
         free(fru_area);
      }

      fru_area = get_fru_area_str(fru_data, &i);
      if (fru_area != NULL && strlen(fru_area) > 0) {
      //   if (verbose > 0)
            xil_printf(" Board FRU ID          : %s\n\r", fru_area);
         free(fru_area);
      }

      /* read any extra fields */
      while ((fru_data[i] != 0xc1) && (i < offset + area_len))
      {
         int j = i;
         fru_area = get_fru_area_str(fru_data, &i);
         if (fru_area != NULL && strlen(fru_area) > 0) {
            xil_printf(" Board Extra           : %s\n\r", fru_area);
            free(fru_area);
         }
         if (i == j)
            break;
      }

   }
   #endif

   // Decode data
   idx = 0;
   // Version
   board_info->area_ver = board_info->area_data[idx++];
   // Area length (multiples of 8 bytes)
   board_info->area_len = board_info->area_data[idx++] << 3;
   // Language (english)
   board_info->lang = board_info->area_data[idx++];
   // Mrg. Data / Time - (little endian)
   board_info->mfg_date_time = (board_info->area_data[idx+0])
                             | (board_info->area_data[idx+1] <<  8)
                             | (board_info->area_data[idx+2] << 16);
   idx += 3;
   // Board Manufacturer (8 bit ASCII)
   board_info->mfg = &board_info->area_data[idx+1];
   idx += 1 + (board_info->area_data[idx] & 0x3F);
   // Board Product Name (8 bit ASCII)
   board_info->prod = &board_info->area_data[idx+1];
   idx += 1 + (board_info->area_data[idx] & 0x3F);
   // Board Serial Number (8 bit ASCII)
   board_info->serial = &board_info->area_data[idx+1];
   idx += 1 + (board_info->area_data[idx] & 0x3F);
   // Board Part Number (8 bit ASCII)
   board_info->part = &board_info->area_data[idx+1];
   idx += 1 + (board_info->area_data[idx] & 0x3F);
   // FRU File (8 bit ASCII)
   board_info->fru = &board_info->area_data[idx+1];
   idx += 1 + (board_info->area_data[idx] & 0x3F);
   
   // Verify version
   if ( board_info->area_ver != 0x01 )
   {
      // Version error, abort
      xil_printf( "[fmc_ipmi_get_board_info] FRU_VERSION_ERROR\n\r" );
      return FRU_VERSION_ERROR;
   }
   
   return FRU_SUCCESS;
}

////////////////////////////////////////////////////////////////////////
// FRU Management Functions (Write)
////////////////////////////////////////////////////////////////////////

#if defined(FMC_IPMI_PRODUCTION)

int fmc_ipmi_set_common_info( fmc_iic_t *pIIC, Xuint8 iic_address, struct fru_header *common_info )
{
   Xuint8 num_bytes;
   Xuint8 data[8];
   Xuint8 checksum;
   int idx;
   int timeout;
   
   // Verify version
   if ( common_info->version != 0x01 )
   {
      // Version error, abort
      xil_printf( "[fmc_ipmi_set_common_info] FRU_VERSION_ERROR\n\r" );
      return FRU_VERSION_ERROR;
   }
   
   // Encode area
   data[0] = common_info->version;
   data[1] = common_info->offset.internal;
   data[2] = common_info->offset.chassis;
   data[3] = common_info->offset.board;
   data[4] = common_info->offset.product;
   data[5] = common_info->offset.multi;
	data[6] = common_info->pad;
   data[7] = common_info->checksum;

   // Calculate checksum
   checksum = 0;
   for ( idx = 0; idx < 8-1; idx++ )
   {
      checksum += data[idx];
   }
   checksum = ~checksum + 1;
   common_info->checksum = checksum;
   data[7] = checksum;

   // Write area to EEPROM via I2C
   for ( idx = 0; idx < 8; idx++ )
   {
      num_bytes = pIIC->fpIicWrite( pIIC, (Xint8)(iic_address>>1), idx, &data[idx], 1 ); 
      if ( num_bytes != 1 )
      {
         // I2C error, abort
         xil_printf( "[fmc_ipmi_set_common_info] FRU_I2C_ERROR (idx=%d)\n\r", idx );
         return FRU_I2C_ERROR;
      }
      
      // Wait for write to complete ...
      timeout = 0;
      do
      {
         timeout++;
         if ( timeout > 100 )
         {
            // I2C error, abort
            xil_printf( "[fmc_ipmi_set_common_info] FRU_I2C_TIMEOUT (idx=%d)\n\r", idx );
            return FRU_I2C_TIMEOUT;
         }
         
         num_bytes = pIIC->fpIicRead( pIIC, (Xint8)(iic_address>>1), idx, &data[idx], 1 );
      } while (!num_bytes);
   }
   
   return FRU_SUCCESS;
}

int fmc_ipmi_set_board_info( fmc_iic_t *pIIC, Xuint8 iic_address, struct fru_area_board *board_info )
{
   Xuint8 num_bytes;
   Xuint8 data;
   Xuint8 checksum;
   int offset = 0x08; // fixed offset of board_info in IPMI EEPROM
   int idx;
   int timeout;
   
   // Verify version
   if ( board_info->area_ver != 0x01 )
   {
      // Version error, abort
      xil_printf( "[fmc_ipmi_set_board_info] FRU_VERSION_ERROR\n\r" );
      return FRU_VERSION_ERROR;
   }
   
   // Clear area
   board_info->area_len = sizeof(board_info->area_data);
   for ( idx = 0; idx < board_info->area_len-1; idx++ )
   {
      board_info->area_data[idx] = 0x00;
   }

   // Encode area
   idx = 0;
   // Version
   board_info->area_data[idx++] = board_info->area_ver;
   // Area length (multiples of 8 bytes)
   board_info->area_data[idx++] = (Xuint8)((board_info->area_len)>>3);
   // Language
   board_info->area_data[idx++] = board_info->lang;
   // Mrg. Data / Time - (little endian)
   board_info->area_data[idx++] = (Xuint8)(board_info->mfg_date_time>> 0 & 0xFF); 
   board_info->area_data[idx++] = (Xuint8)(board_info->mfg_date_time>> 8 & 0xFF); 
   board_info->area_data[idx++] = (Xuint8)(board_info->mfg_date_time>>16 & 0xFF); 
   // Board Manufacturer (8 bit ASCII)
   board_info->area_data[idx++] = 0xC0 | (strlen(board_info->mfg)+1); // type / length byte
   memcpy( &board_info->area_data[idx], board_info->mfg, strlen(board_info->mfg)+1 ); // data bytes
   idx += strlen(board_info->mfg)+1;
   // Board Product Name (8 bit ASCII)
   board_info->area_data[idx++] = 0xC0 | (strlen(board_info->prod)+1); // type / length byte
   memcpy( &board_info->area_data[idx], board_info->prod, strlen(board_info->prod)+1 ); // data bytes
   idx += strlen(board_info->prod)+1;
   // Board Serial Number (8 bit ASCII)
   board_info->area_data[idx++] = 0xC0 | (strlen(board_info->serial)+1); // type / length byte
   memcpy( &board_info->area_data[idx], board_info->serial, strlen(board_info->serial)+1 ); // data bytes
   idx += strlen(board_info->serial)+1;
   // Board Part Number (8 bit ASCII)
   board_info->area_data[idx++] = 0xC0 | (strlen(board_info->part)+1); // type / length byte
   memcpy( &board_info->area_data[idx], board_info->part, strlen(board_info->part)+1 ); // data bytes
   idx += strlen(board_info->part)+1;
   // FRU File (8 bit ASCII)
   board_info->area_data[idx++] = 0xC0 | (strlen(board_info->fru)+1); // type / length byte
   memcpy( &board_info->area_data[idx], board_info->fru, strlen(board_info->fru)+1 ); // data bytes
   idx += strlen(board_info->fru)+1;
   // End of fields
   board_info->area_data[idx++] = 0xC1;

   // Calculate checksum (last byte)
   checksum = 0;
   for ( idx = 0; idx < board_info->area_len-1; idx++ )
   {
      checksum += board_info->area_data[idx];
   }
   checksum = ~checksum + 1;
   board_info->area_data[board_info->area_len-1] = checksum;

   // Write area to EEPROM via I2C
   for ( idx = 0; idx < board_info->area_len; idx++ )
   {
      num_bytes = pIIC->fpIicWrite( pIIC, (Xint8)(iic_address>>1), offset+idx, &board_info->area_data[idx], 1 ); 
      if ( num_bytes != 1 )
      {
         // I2C error, abort
         xil_printf( "[fmc_ipmi_set_board_info] FRU_I2C_ERROR (idx=%d)\n\r", idx );
         return FRU_I2C_ERROR;
      }

      // Wait for write to complete ...
      timeout = 0;
      do
      {
         timeout++;
         if ( timeout > 100 )
         {
            // I2C error, abort
            xil_printf( "[fmc_ipmi_set_board_info] FRU_I2C_TIMEOUT (idx=%d)\n\r", idx );
            return FRU_I2C_TIMEOUT;
         }
         
         num_bytes = pIIC->fpIicRead( pIIC, (Xint8)(iic_address>>1), offset+idx, &data, 1 );
      } while (!num_bytes);
   }

   return FRU_SUCCESS;
}

#endif // defined(FMC_IPMI_PRODUCTION)


////////////////////////////////////////////////////////////////////////
// IPMITOOL routines (reused from ipmi_fru.c)
////////////////////////////////////////////////////////////////////////

static char *buf2str( char *buf, int len )
{
   buf[len] = '\0';
   return buf;
}

/* get_fru_area_str	-	Parse FRU area string from raw data
 *
 * @data:	raw FRU data
 * @offset:	offset into data for area
 *
 * returns pointer to FRU area string
 */
static char *get_fru_area_str(uint8_t * data, uint32_t * offset)
{
	static const char bcd_plus[] = "0123456789 -.:,_";
	char * str;
	int len, off, size, i, j, k, typecode;
	union {
		uint32_t bits;
		char chars[4];
	} u;

	size = 0;
	off = *offset;

	/* bits 6:7 contain format */
	typecode = ((data[off] & 0xC0) >> 6);

	/* bits 0:5 contain length */
	len = data[off++];
	len &= 0x3f;

	switch (typecode) {
	case 0:				/* 00b: binary/unspecified */
		/* hex dump -> 2x length */
		size = (len*2);
		break;
	case 2:				/* 10b: 6-bit ASCII */
		/* 4 chars per group of 1-3 bytes */
		size = ((((len+2)*4)/3) & ~3);
		break;
	case 3:				/* 11b: 8-bit ASCII */
	case 1:				/* 01b: BCD plus */
		/* no length adjustment */
		size = len;
		break;
	}

	if (size < 1) {
		*offset = off;
		return NULL;
	}
	str = malloc(size+1);
	if (str == NULL)
		return NULL;
	memset(str, 0, size+1);

	if (len == 0) {
		str[0] = '\0';
		*offset = off;
		return str;
	}

	switch (typecode) {
	case 0:			/* Binary */
		strncpy(str, buf2str(&data[off], len), len*2);
		break;

	case 1:			/* BCD plus */
		for (k=0; k<len; k++)
			str[k] = bcd_plus[(data[off+k] & 0x0f)];
		str[k] = '\0';
		break;

	case 2:			/* 6-bit ASCII */
		for (i=j=0; i<len; i+=3) {
			u.bits = 0;
			k = ((len-i) < 3 ? (len-i) : 3);
#if WORDS_BIGENDIAN
			u.chars[3] = data[off+i];
			u.chars[2] = (k > 1 ? data[off+i+1] : 0);
			u.chars[1] = (k > 2 ? data[off+i+2] : 0);
#define CHAR_IDX 3
#else
			memcpy((void *)&u.bits, &data[off+i], k);
#define CHAR_IDX 0
#endif
			for (k=0; k<4; k++) {
				str[j++] = ((u.chars[CHAR_IDX] & 0x3f) + 0x20);
				u.bits >>= 6;
			}
		}
		str[j] = '\0';
		break;

	case 3:
		memcpy(str, &data[off], len);
		str[len] = '\0';
		break;
	}

	off += len;
	*offset = off;
   

	return str;
}

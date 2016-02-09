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
//                     Copyright(c) 2011 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------
//
// Create Date:         Jan 07, 2016
// Design Name:         PicoZed FMC Carrier V2
// Module Name:         pzfmc2_hdmi.c
// Project Name:        PicoZed FMC Carrier V2 - HDMI output driver
// Target Devices:      Zynq
// Avnet Boards:        PicoZed FMC Carrier V2
//
// Tool versions:       Vivado 2015.2
//
// Description:         PicoZed FMC Carrier V2 HDMI output driver
//
// Dependencies:        
//
// Revision:            Jan 07, 2016: 1.01 First Version
//
//----------------------------------------------------------------

#include <stdio.h>
#include <string.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "fmc_iic.h"
#include "pzfmc2_hdmi.h"

static int bVerbose = 1;
static Xuint8 pzfmc2_adv7511_addr = (IIC_ADV7511_BASE_ADDR1>>1);

////////////////////////////////////////////////////////////////////////
// Generic I2C Configuration Functions
////////////////////////////////////////////////////////////////////////

/******************************************************************************
* This function sends an I2C configuration sequence.
*
* @param    pIIC contains a pointer to the IIC driver's context.
* @param    ChipAddress contains the I2C device address
* @param    ConfigData[][2] contains the I2C register/value config data
* @param    ConfigLength contains the number of I2C register/value config data
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void pzfmc2_iic_config2( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 ConfigData[][2], Xuint32 ConfigLength )
{
   Xuint8 num_bytes;
   Xuint8 read_data;
   int i;

   for ( i = 0; i < ConfigLength; i++ )
   {
      //xil_printf( "[pzfmc2_iic_config2] IIC Write - Device = 0x%02X, Address = 0x%02X, Data = 0x%02X\n\r", ChipAddress<<1, ConfigData[i][0], ConfigData[i][1] );
      num_bytes = pIIC->fpIicWrite( pIIC, ChipAddress, ConfigData[i][0], &(ConfigData[i][1]), 1);
      xil_printf("\t0x%02X[0x%02X] <= 0x%02X\n\r", ChipAddress<<1, ConfigData[i][0], ConfigData[i][1]);

      //num_bytes = pIIC->fpIicRead( pIIC, ChipAddress, ConfigData[i][0], &read_data, 1);
      //if ( read_data != ConfigData[i][1])
      //{
      //   xil_printf("\tERROR occurred during I2C transaction ! (wrote = 0x%02X, read = 0x%02X)\n\r", ConfigData[i][1], read_data );
      //}

   }
}

/******************************************************************************
* This function sends an I2C configuration sequence.
*
* @param    pIIC contains a pointer to the IIC driver's context.
* @param    ConfigData[][3] contains the I2C device/register/value config data
* @param    ConfigLength contains the number of I2C device/register/value config data
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void pzfmc2_iic_config3( fmc_iic_t *pIIC, Xuint8 ConfigData[][3], Xuint32 ConfigLength )
{
   Xuint8 num_bytes;
   Xuint8 read_data;
   int i;

   for ( i = 0; i < ConfigLength; i++ )
   {
      //xil_printf( "[pzfmc2_iic_config3] IIC Write - Device = 0x%02X, Address = 0x%02X, Data = 0x%02X\n\r", ConfigData[i][0]<<1, ConfigData[i][1], ConfigData[i][2] );
      num_bytes = pIIC->fpIicWrite( pIIC, ConfigData[i][0], ConfigData[i][1], &(ConfigData[i][2]), 1);
      xil_printf("\t0x%02X[0x%02X] <= 0x%02X\n\r", ConfigData[i][0]<<1, ConfigData[i][1], ConfigData[i][2]);

      //num_bytes = pIIC->fpIicRead( pIIC, ConfigData[i][0], ConfigData[i][1], &read_data, 1);
      //if ( read_data != ConfigData[i][2])
      //{
      //   xil_printf("\tERROR occurred during I2C transaction ! (wrote = 0x%02X, read = 0x%02X)\n\r", ConfigData[i][2], read_data );
      //}
   }
}

////////////////////////////////////////////////////////////////////////
// HDMI Output Configuration Functions
////////////////////////////////////////////////////////////////////////

#define IIC_PZFMC2_HDMI_OUT_CONFIG_LEN  (37)
Xuint8 iic_pzfmc2_hdmi_out_config[IIC_PZFMC2_HDMI_OUT_CONFIG_LEN][2] =
{
      //
      // Power-up the Tx (HPD must be high)
      //
      0x41, 0x10, // Power down control
                                            //    R0x41[  6] = PowerDown = 0 (power-up)
      //
      // Fixed registers that must be set on power up
      //
      0x98, 0x03, // ADI Recommended Write
      0x99, 0x02, // ADI Recommended Write
      0x9A, 0xE0, // ADI Recommended Write
      0x9C, 0x30, // PLL Filter R1 Value
      0x9D, 0x61, // Set clock divide
      0xA2, 0xA4, // ADI Recommended Write
      0xA3, 0xA4, // ADI Recommended Write
      0xA5, 0x44, // ADI Recommended Write
      0xAB, 0x40, // ADI Recommended Write
      //0xBA, 0x00, // Programmable delay for input video clock = 000 = -1.2ns
      0xBA, 0x60, // Programmable delay for input video clock = 011 = no delay
      //0xBA, 0xA0, // Programmable delay for input video clock = 101 = +0.8ns
      //0xBA, 0xE0, // Programmable delay for input video clock = 111 = +1.2ns
      0xD0, 0x00, // Delay adjust for negative DDR capture = disabled
      0xD1, 0xFF, // ADI Recommended Write
      0xDE, 0x9C, // ADI Recommended Write
      0xE0, 0xD0, // ADI Recommended Write
      0xE4, 0x60, // VCO_Swing_Reference_Voltage
      0xF9, 0x00, // VCO_Swing_Reference_Voltage
      //
      // Set up the video input mode
      //
      0x15, 0x02, // Input YCbCr 4:2:2 with embedded syncs
      0x16, 0x38, // Output format 444, Input Color Depth = 8
                  //    R0x16[  7] = Output Video Format = 0 (444)
                  //    R0x16[5:4] = Input Video Color Depth = 11 (8 bits/color)
                  //    R0x16[3:2] = Input video Style = 10 (style 1) or 01 (style 2)
                  //    R0x16[  1] = DDR Input Edge = 0 (falling edge)
                  //    ROx16[  0] = Output Color Space = 0 (RGB)
      //
      // Set up the video output mode
      //
      //0x16, 0x38, // Output format 444, Input Color Depth = 8
      0x18, 0xC6, // CSC
                  //    R0x18[  7] = CSC enable = 1 (CSC enabled)
                  //    R0x18[6:5] = CSC Scaling Factor = 10 (+/- 4.0, -16384 - 16380)
                  //    R0x18[4:0] = CSC coefficient A1[12:8]
      0x40, 0x80, // General Control packet enable
      0x48, 0x10, // Video Input Justification
                                            //    R0x48[8:7] = Video Input Justification = 10 (left justified)
      0x49, 0xA8, // Bit trimming mode = 101010 (truncate)
      0x4C, 0x00, // Color Depth = 0000 (color depth not indicated)
      0x55, 0x00, // Set RGB in AVinfo Frame
                  //    R0x55[6:5] = Output Format = 00 (RGB)
      //0x55, 0x40, // Set YCrCb 444 in AVinfo Frame
      //0x55, 0x20, // Set YCrCb 422 in AVinfo Frame
      0x56, 0x08, // Aspect Ratio
                  //    R0x56[5:4] = Picture Aspect Ratio = 00 (no data)
                  //    R0x56[3:0] = Active Format Aspect Ratio = 1000 (Same as Aspect Ratio)
      //0xAF, 0x06, // Set HDMI Mode
                  //    R0xAF[  7] = HDCP Enable = 0 (HDCP disabled)
                  //    R0xAF[  4] = Frame Encryption = 0 (Current frame NOT HDCP encrypted)
                  //    R0xAF[3:2] = 01 (fixed)
                  //    R0xAF[  1] = HDMI/DVI Mode Select = 1 (HDMI Mode)
      0xAF, 0x04, // Set DVI Mode
                  //    R0xAF[  1] = HDMI/DVI Mode Select = 0 (DVI Mode)
      //
      // SPDIF Audio Setup
      //
      0x01, 0x00, // Set N Value = 6144 (0x001800) for 48 kHz
      0x02, 0x18,
      0x03, 0x00,
      //
	  0x0A, 0x10,
      0x0B, 0x8E,
      0x0C, 0x00,
      0x73, 0x01,
      0x14, 0x02,
      //
      // HPD Interrupt clear
      //
      0x96, 0x20, // HPD Interrupt clear
      //
      // ???
      //
      0xFA, 0x00  // Nbr of times to search for good phase
};

#define IIC_PZFMC2_HDMI_OUT_EMBEDDED_SYNC_CONFIG_LEN  (6)
Xuint8 iic_pzfmc2_hdmi_out_embedded_sync_config[IIC_PZFMC2_HDMI_OUT_EMBEDDED_SYNC_CONFIG_LEN][2] =
{
   //
   // Configure for 1080p60 16-bit bus embedded syncs
   //
   0x30, 0x16, // Hsync placement = 0001011000 (0x58) = 88
   0x31, 0x02, // Hsync duration  = 0000101100 (0x2C) = 44
   0x32, 0xC0, //
   0x33, 0x10, // Vsync placement = 0000000100 (0x04) =  4
   0x34, 0x05, // Vsync duration  = 0000000101 (0x05) =  5
   0x17, 0x02  // VSync Polarity = 0(high), HSync Polarity = 0(high)
};

/******************************************************************************
* This function initializes the HDMI Output Interface.
*
* @param    pIIC contains a pointer to the IIC driver's context.
* @param    Enable will activate the ADV7511 device (when 0, the device is powered-down).
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int pzfmc2_hdmio_init( fmc_iic_t *pIIC, Xuint32 Enable, pzfmc2_video_timing_t *pTiming, Xuint32 WaitForHPD )
{
   Xuint8 i2c_dev;
   Xuint8 i2c_addr;
   Xuint8 i2c_data;
   Xuint8 num_bytes;
   Xuint32 timeout;

   if ( !Enable )
   {
      xil_printf( "\tAsserting PowerDown\n\r" );
      pzfmc2_hdmio_set_pd( pIIC, 1 );

      // Wait 100msec.
      usleep(100000);
   }
   else
   {
      xil_printf( "\tDe-asserting PowerDown\n\r" );
      pzfmc2_hdmio_set_pd( pIIC, 0 );

      // Wait 100msec.
      usleep(100000);

      pzfmc2_adv7511_addr = (IIC_ADV7511_BASE_ADDR1>>1);
      i2c_addr = 0x00;
      i2c_data = 0x00;
      num_bytes = pIIC->fpIicRead( pIIC, pzfmc2_adv7511_addr, i2c_addr, &i2c_data, 1);
      if (num_bytes < 1)
      {
         pzfmc2_adv7511_addr = (IIC_ADV7511_BASE_ADDR2>>1);
      }
      xil_printf("ADV7511 detected at address 0x%02X\n\r", pzfmc2_adv7511_addr<<1 );


	  // Adjust HDMI/DVI mode based on specified video timing info
	  {
	     int i;
		 for ( i = 0; i < IIC_PZFMC2_HDMI_OUT_CONFIG_LEN; i++ )
		 {
		    if ( iic_pzfmc2_hdmi_out_config[i][1] == 0xAF )
			{
				if ( pTiming->IsHDMI )
				{
                   if ( bVerbose ) xil_printf( "\tSetting I2C config sequence for HDMI Mode\n\r" );
                   iic_pzfmc2_hdmi_out_config[i][2] = 0x06; // Set HDMI Mode
                                                     //    R0xAF[  1] = HDMI/DVI Mode Select = 1 (HDMI Mode)
				}
				else
				{
                   if ( bVerbose ) xil_printf( "\tSetting I2C config sequence for DVI Mode\n\r" );
                   iic_pzfmc2_hdmi_out_config[i][2] = 0x04; // Set DVI Mode
                                                     //    R0xAF[  1] = HDMI/DVI Mode Select = 0 (DVI Mode)
				}
			} // if ( iic_pzfmc2_hdmi_out_config[i][1] == 0xAF )
		 } // for ( i = 0; i < IIC_PZFMC2_HDMI_OUT_CONFIG_LEN; i++ )
	  }

      pzfmc2_iic_config2( pIIC, pzfmc2_adv7511_addr, iic_pzfmc2_hdmi_out_config, IIC_PZFMC2_HDMI_OUT_CONFIG_LEN);

      // Adjust Embedded Sync Generation based on specified video timing
      iic_pzfmc2_hdmi_out_embedded_sync_config[0][1] = (Xuint8)((pTiming->HFrontPorch >> 2) & 0xFF);
      iic_pzfmc2_hdmi_out_embedded_sync_config[1][1] = (Xuint8)((pTiming->HFrontPorch << 6) & 0xC0) |
                                                       (Xuint8)((pTiming->HSyncWidth  >> 4) & 0x3F);
      iic_pzfmc2_hdmi_out_embedded_sync_config[2][1] = (Xuint8)((pTiming->HSyncWidth  << 4) & 0xF0) |
                                                       (Xuint8)((pTiming->VFrontPorch >> 6) & 0x0F);
      iic_pzfmc2_hdmi_out_embedded_sync_config[3][1] = (Xuint8)((pTiming->VFrontPorch << 2) & 0xFC) |
                                                       (Xuint8)((pTiming->VSyncWidth  >> 8) & 0x03);
      iic_pzfmc2_hdmi_out_embedded_sync_config[4][1] = (Xuint8)((pTiming->VSyncWidth  >> 0) & 0xFF);
      iic_pzfmc2_hdmi_out_embedded_sync_config[5][1] = 0x00; // (Xuint8)( ... pTiming->HSyncPolarity .. pTiming->VSyncPolarity ... )

      if ( bVerbose )
	  {
         int i;
         for ( i = 0; i < 6; i++ )
         {
            xil_printf("\tembedded_sync_config[%d] = 0x%02X, 0x%02X, 0x%02X\n\r",
               i,
               (pzfmc2_adv7511_addr)<<1,
               iic_pzfmc2_hdmi_out_embedded_sync_config[i][0],
               iic_pzfmc2_hdmi_out_embedded_sync_config[i][1]
               );
         }
      }

      pzfmc2_iic_config2( pIIC, pzfmc2_adv7511_addr, iic_pzfmc2_hdmi_out_embedded_sync_config, IIC_PZFMC2_HDMI_OUT_EMBEDDED_SYNC_CONFIG_LEN);

      // sleep 100ms
      usleep(100000);

      i2c_dev = pzfmc2_adv7511_addr; // ADV7511
      i2c_addr = 0x96;
      num_bytes = pIIC->fpIicRead( pIIC, i2c_dev, i2c_addr, &i2c_data, 1);
      if (num_bytes < 1)
      {
         xil_printf("\t\tERROR occurred during I2C transaction !\n\r");
      }
      else
      {
         xil_printf("\t0x%02X[0x%02X] => 0x%02X\n\r", (i2c_dev << 1), i2c_addr, i2c_data);
      }

      i2c_data = 0x00;
      if ( WaitForHPD )
      {
         timeout = 99;
         while (((i2c_data & 0xC0) != 0xC0) && (--timeout))
         {
            num_bytes = pIIC->fpIicRead( pIIC, i2c_dev, i2c_addr, &i2c_data, 1);
            if (num_bytes < 1)
            {
               xil_printf( "[pzfmc2_hdmio_init] ERROR occurred during I2C transaction !\n\r");
               timeout = 0;
               return 0;
            }
            xil_printf("\t0x%02X[0x%02X] => 0x%02X\n\r", (i2c_dev << 1), i2c_addr, i2c_data);
         }
         if (!timeout)
         {
            xil_printf( "[pzfmc2_hdmio_init] ERROR - Timeout waiting for internal HotPlugDetect !\n\r");
            return 0;
         }
      } // if ( WaitForHPD )
   }

   return 1;
}

/******************************************************************************
* This function drives the PowerDown signal on the HDMI Output Interface.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    PowerDown
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int pzfmc2_hdmio_set_pd( fmc_iic_t *pIIC, Xuint32 PowerDown )
{
	Xuint8 gpio_data;

   // I2C GPIO bits uses as follows:
   //  [7] = unused
   //  [6] = unused
   //  [5] = unused
   //  [4] = unused
   //  [3] = unused
   //  [2] = unused
   //  [1] = unused
   //  [0] = HDMIO_PD
   gpio_data = PowerDown ? 0x01 : 0x00;;
   pIIC->fpGpoWrite( pIIC, gpio_data );

   return 1;
}

/******************************************************************************
* This function reads the state of HotPlugDetect on the HDMI Input Interface.
*
* @param    pHotPlugDetect contains a pointer for the return value of the HotPlugDetect status
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int pzfmc2_hdmio_get_hpd( Xuint32 *pHotPlugDetect )
{
   int hdmio_hpd;

   if ( 1 /* TODO */ )
      hdmio_hpd = 1;
   else
     hdmio_hpd = 0;
   
   *pHotPlugDetect = hdmio_hpd;
   return 1;
}



int pzfmc2_hdmio_set_clk_delay( Xuint8 clk_delay )
{
    xil_printf("\tBefore : clk_delay = %02X\n\r", clk_delay );
	clk_delay = (clk_delay & 0x7) << 5;
    xil_printf("\tAfter  : clk_delay = %02X\n\r", clk_delay );

    xil_printf("\tBefore : iic_pzfmc2_hdmi_out_config[%d] = 0x%02X, 0x%02X\n\r", 10, iic_pzfmc2_hdmi_out_config[10][0], iic_pzfmc2_hdmi_out_config[10][1] );
	iic_pzfmc2_hdmi_out_config[10][1] = clk_delay;
    xil_printf("\tAfter  : iic_pzfmc2_hdmi_out_config[%d] = 0x%02X, 0x%02X\n\r", 10, iic_pzfmc2_hdmi_out_config[10][0], iic_pzfmc2_hdmi_out_config[10][1] );

	return 1;
}





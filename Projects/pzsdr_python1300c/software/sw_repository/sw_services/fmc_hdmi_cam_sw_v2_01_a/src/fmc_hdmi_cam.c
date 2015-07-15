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
// Create Date:         June 16, 2015
// Design Name:         FMC-HDMI-CAM
// Module Name:         fmc_hdmi_cam.c
// Project Name:        FMC-HDMI-CAM
// Target Devices:      Artix-7, Kintex-7, Virtex-7, Zynq
// Avnet Boards:        FMC-HDMI-CAM
//
// Tool versions:       Vivado 2014.4
//
// Description:         FMC-HDMI-CAM Software Library.
//                      - I2C Multiplexer
//                      - I2C I/O Expander
//                      - HDMI Input Configuration
//                      - HDMI Output Configuration
//
// Dependencies:        
//
// Revision:            Jun 16, 2015: 2.01 Copied from FMC-IMAGEON
//
//----------------------------------------------------------------

#include <stdio.h>
#include <string.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "fmc_iic.h"
#include "fmc_hdmi_cam.h"

////////////////////////////////////////////////////////////////////////
// Driver Initialization
////////////////////////////////////////////////////////////////////////

/******************************************************************************
* This function initializes the FMC-IMAGEON driver.
*
* @param    pContext contains a pointer to the new FMC-IMAGEON instance's context.
* @param    szName contains a string describing the new FMC-IMAGEON instance.
* @param    pIIC contains a pointer to a FMC-IIC instance's context.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_init( fmc_hdmi_cam_t *pContext, char szName[], fmc_iic_t *pIIC )
{
   Xuint8 reg_addr;
   Xuint8 reg_data;
   Xuint8 num_bytes;

   pContext->pIIC = pIIC;
   strcpy( pContext->szName, szName );

   // Initialize the GPIO bits to known state
   //  [7] = unused
   //  [6] = unused
   //  [5] = unused
   //  [4] = unused
   //  [3] = unused
   //  [2] = unused
   //  [1] = unused
   //  [0] = fmc_hdmi_cam_iic_rst#
   pContext->GpioData = 0x01;
   pContext->pIIC->fpGpoWrite( pContext->pIIC, pContext->GpioData );

   // Verbose
   pContext->bVerbose = 0;

   // Initialize the IIC Multiplexer
   fmc_hdmi_cam_iic_mux_reset( pContext );

#if 1
   // Initialize the I/O Expander to default state
   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_IO_EXP );

   // Configure direction of I/O Expander's Px GPIO pins
   reg_addr = 0x03;
   //num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
   //xil_printf( "[fmc_hdmi_cam_init] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   reg_data = 0xEA; // P0 => HDMII_RST#  = 0 (output)
                    // P1 => HDMII_INT1  = 1 (input)
                    // P2 => HDMII_HPD   = 0 (output)
                    // P3 => HDMIO_HPD   = 1 (input)
                    // P4 => HDMIO_PD    = 0 (output)
                    // P5 => unused      = 1 (input)
                    // P6 => unused      = 1 (input)
                    // P7 => unused      = 1 (input)
   //xil_printf( "[fmc_hdmi_cam_init] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
   
   // Configure output values of I/O Expander's Px GPIO pins
   reg_addr = 0x01;
   //num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
   //xil_printf( "[fmc_hdmi_cam_init] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   reg_data = 0x01; // P0 => HDMII_RST#  = 1 (output)
                    // P1 => HDMII_INT1  = x (input)
                    // P2 => HDMII_HPD   = 0 (output)
                    // P3 => HDMIO_HPD   = x (input)
                    // P4 => HDMIO_PD    = 0 (output)
                    // P5 => unused      = x (input)
                    // P6 => unused      = x (input)
                    // P7 => unused      = x (input)
   //xil_printf( "[fmc_hdmi_cam_init] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
#endif

   return 1;
}

////////////////////////////////////////////////////////////////////////
// I2C MUX Functions
////////////////////////////////////////////////////////////////////////

/******************************************************************************
* This function applies a reset to the I2C MUX.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void fmc_hdmi_cam_iic_mux_reset( fmc_hdmi_cam_t *pContext )
{   
   // Apply reset to I2C mux
   //xil_printf( "Apply reset to I2C mux ...\n\r" );
   // Modify appropriate GPIO bits
   //  [0] = fmc_hdmi_cam_iic_rst# = 0
   pContext->GpioData &= ~0x01;
   pContext->pIIC->fpGpoWrite( pContext->pIIC, pContext->GpioData );
   
   // sleep 1sec
   fmc_hdmi_cam_wait_usec(1000000); 
   
   // Release reset from I2C mux
   //xil_printf( "Release reset from I2C mux ...\n\r" );
   // Modify appropriate GPIO bits
   //  [0] = fmc_hdmi_cam_iic_rst# = 1
   pContext->GpioData |= 0x01;
   pContext->pIIC->fpGpoWrite( pContext->pIIC, pContext->GpioData );
}

/******************************************************************************
* This function configures the I2C multiplexer.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    MuxSelect specified which of the I2C mux's outputs to enable.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void fmc_hdmi_cam_iic_mux( fmc_hdmi_cam_t *pContext, Xuint32 MuxSelect )
{
   Xuint8 mux_data;
   Xuint8 num_bytes;
   
   switch ( MuxSelect )
   {
      //
      // Single Mux Selections
      //
      case FMC_HDMI_CAM_I2C_SELECT_DDCEDID:
      {
         mux_data = 0x01;
         num_bytes =  pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_I2C_MUX_ADDR, mux_data, &mux_data, 1); 
         break;
      }
      case FMC_HDMI_CAM_I2C_SELECT_HDMI_OUT:
      {
         mux_data = 0x02;
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_I2C_MUX_ADDR, mux_data, &mux_data, 1); 
         break;
      }
      case FMC_HDMI_CAM_I2C_SELECT_HDMI_IN:
      {
         mux_data = 0x04;
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_I2C_MUX_ADDR, mux_data, &mux_data, 1); 
         break;
      }
      case FMC_HDMI_CAM_I2C_SELECT_IO_EXP:
      //case FMC_HDMI_CAM_I2C_SELECT_VID_CLK:
      {
         mux_data = 0x08;
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_I2C_MUX_ADDR, mux_data, &mux_data, 1); 
         break;
      }
	  case FMC_HDMI_CAM_I2C_SELECT_CAM:
	  {
         mux_data = 0x10;
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_I2C_MUX_ADDR, mux_data, &mux_data, 1); 
         break;
	  }
      //
      // Multiple Mux Selections
      //
      case FMC_HDMI_CAM_I2C_SELECT_HDMI:
      {
         mux_data = 0x02 | 0x04;
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_I2C_MUX_ADDR, mux_data, &mux_data, 1); 
         break;
      }
   }
   //xil_printf("[fmc_imageov_iic_mux] I2C_MUX=%d\n\r", MuxSelect );

}

////////////////////////////////////////////////////////////////////////
// Generic I2C Configuration Functions
////////////////////////////////////////////////////////////////////////

/******************************************************************************
* This function sends an I2C configuration sequence.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    ChipAddress contains the I2C device address
* @param    ConfigData[][2] contains the I2C register/value config data
* @param    ConfigLength contains the number of I2C register/value config data
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void fmc_hdmi_cam_iic_config2( fmc_hdmi_cam_t *pContext, Xuint8 ChipAddress, 
                              Xuint8 ConfigData[][2], Xuint32 ConfigLength )
{
   Xuint8 num_bytes;
   int i;

   for ( i = 0; i < ConfigLength; i++ )
   {
      //xil_printf( "[fmc_hdmi_cam_iic_config2] IIC Write - Device = 0x%02X, Address = 0x%02X, Data = 0x%02X\n\r", ChipAddress<<1, ConfigData[i][0], ConfigData[i][1] );
      num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, ChipAddress, ConfigData[i][0], &(ConfigData[i][1]), 1); 
   }
}

/******************************************************************************
* This function sends an I2C configuration sequence.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    ConfigData[][3] contains the I2C device/register/value config data
* @param    ConfigLength contains the number of I2C device/register/value config data
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void fmc_hdmi_cam_iic_config3( fmc_hdmi_cam_t *pContext, 
                              Xuint8 ConfigData[][3], Xuint32 ConfigLength )
{
   Xuint8 num_bytes;
   int i;

   for ( i = 0; i < ConfigLength; i++ )
   {
      //xil_printf( "[fmc_hdmi_cam_iic_config3] IIC Write - Device = 0x%02X, Address = 0x%02X, Data = 0x%02X\n\r", ConfigData[i][0]<<1, ConfigData[i][1], ConfigData[i][2] );
      num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, ConfigData[i][0], ConfigData[i][1], &(ConfigData[i][2]), 1); 
   }
}

////////////////////////////////////////////////////////////////////////
// Video Clock Synthesizer Functions
////////////////////////////////////////////////////////////////////////

// CDCE913 
#define MAX_IIC_CDCE913 32
static Xuint8 iic_cdce913[MAX_IIC_CDCE913][2]=
{
   0x00, 0x81, // Byte 00 - 10000001
   0x01, 0x01, // Byte 01 - 00000000
               // [1:0] - Slave Address A[1:0]=01b
   //0x02, 0xB4, // Byte 02 - 10110100
   //0x03, 0x01, // Byte 03 - 00000001
   0x02, 0xB4, // [  7] = M1 = 1 (PLL1 Clock)
               // [1:0] = PDIV1[9:8] = 
   0x03, 0x02, // [7:0] = PDIV1[7:0] = 2
   0x04, 0x02, // Byte 04 - 00000010
   0x05, 0x50, // Byte 05 - 01010000
   0x06, 0x60, // Byte 06 - 01100000
   0x07, 0x00, // Byte 07 - 00000000
   0x08, 0x00, // Byte 08 - 00000000
   0x09, 0x00, // Byte 09 - 00000000
   0x0A, 0x00, // Byte 10 - 00000000
   0x0B, 0x00, // Byte 11 - 00000000
   0x0C, 0x00, // Byte 12 - 00000000
   0x0D, 0x00, // Byte 13 - 00000000
   0x0E, 0x00, // Byte 14 - 00000000
   0x0F, 0x00, // Byte 15 - 00000000
   0x10, 0x00, // Byte 16 - 00000000
   0x11, 0x00, // Byte 17 - 00000000
   0x12, 0x00, // Byte 18 - 00000000
   0x13, 0x00, // Byte 19 - 00000000
   //0x14, 0xED, // Byte 20 - 11101101
   0x14, 0x6D, // [  7] = MUX1 = 0 (PLL1)
               // [  6] = M2 = 1 (PDIV2)
               // [5:4] = M3 = 2 (PDIV3)
   0x15, 0x02, // Byte 21 - 00000010
   //0x16, 0x01, // Byte 22 - 00000001
   //0x17, 0x01, // Byte 23 - 00000001
   0x16, 0x00, // [6:0] = PDIV2 = 0 (reset and stand-by)
   0x17, 0x00, // [6:0] = PDIV3 = 0 (reset and stand-by)
   //0x18, 0x00, // Byte 24 - 00000000
   //0x19, 0x40, // Byte 25 - 01000000
   //0x1A, 0x02, // Byte 26 - 00000010
   //0x1B, 0x08, // Byte 27 - 00001000
               // PLL1 : Fin=27MHz, M=2, N=11, PDIV=2 Fout=74.25MHz
               //        Fvco = 148.5 MHz
               //        P = 4 - int(log2(11/2)) = 4 - 2 = 2
               //        N'= 11 * 2^2 = 44
               //        Q = int(44/2) = 22
               //        R = 44 - 2*22 = 0
   0x18, 0x00, // [7:0] = PLL1_0N[11:4] = 00000000
   0x19, 0xB0, // [7:4] = PLL1_0N[3:0] = 1011
               // [3:0] = PLL1_0R[8:5] = 0000
   0x1A, 0x02, // [7:3] = PLL1_0R[4:0] = 00000
               // [2:0] = PLL1_0Q[5:3] = 010
   0x1B, 0xC9, // [7:5] = PLL1_0Q[2:0] = 110
               // [4:2] = PLL1_0P[2:0] = 010
               // [1:0] = VC01_0_RANGE[1:0] = 01 (125 MHz < Fvco1 < 150 MHz)
   //0x1C, 0x00, // Byte 28 - 00000000
   //0x1D, 0x40, // Byte 29 - 01000000
   //0x1E, 0x02, // Byte 30 - 00000010
   //0x1F, 0x08, // Byte 31 - 00001000
               // PLL1 : Fin=27MHz, M=2, N=11, PDIV=2 Fout=74.25MHz
               //        Fvco = 148.5 MHz
               //        P = 4 - int(log2(11/2)) = 4 - 2 = 2
               //        N'= 11 * 2^2 = 44
               //        Q = int(44/2) = 22
               //        R = 44 - 2*22 = 0
   0x1C, 0x00, // [7:0] = PLL1_1N[11:4] = 00000000
   0x1D, 0xB0, // [7:4] = PLL1_1N[3:0] = 1011
               // [3:0] = PLL1_1R[8:5] = 0000
   0x1E, 0x02, // [7:3] = PLL1_1R[4:0] = 00000
               // [2:0] = PLL1_1Q[5:3] = 010
   0x1F, 0xC9  // [7:5] = PLL1_1Q[2:0] = 110
               // [4:2] = PLL1_1P[2:0] = 010
               // [1:0] = VC01_1_RANGE[1:0] = 01 (125 MHz < Fvco1 < 150 MHz)
};

//////////////////////////////////////////
// 25.175000 MHz
//////////////////////////////////////////
// PLL1: M = 270, N = 1007, Pdiv = 4
//       Fin  = 27.000000MHz
//       Fvco = Fin * N/M = 100.700000MHz
//       Range = 0 (Fvco < 125 MHz)
//       Fout = Fvco / Pdiv = 25.175000MHz
//       P = 4 - int(log2(M/N)) = 3
//       Np = N * 2^P = 8056
//       Q = int(Np/M) = 29
//       R = Np - M*Q = 226
static Xuint8 iic_cdce913_y1_config_25_175_000[6][2] = 
{
   0x02, 0xB4,   // [  7] = M1 = 1 (PLL1 clock) 
                 // [1:0] = Pdiv1[9:8] 
   0x03, 0x04,   // [7:0] = Pdiv1[7:0] 
   0x18, 0x3E,   // [7:0] = PLL1_0N[11:4] 
   0x19, 0xF7,   // [7:4] = PLL1_0N[3:0]  
                 // [3:0] = PLL1_0R[8:5]  
   0x1A, 0x13,   // [7:3] = PLL1_0R[4:0]  
                 // [2:0] = PLL1_0Q[5:3]  
   0x1B, 0xAC    // [7:5] = PLL1_0Q[2:0] 
                 // [4:2] = PLL1_0P[2:0]  
                 // [1:0] = VCO1_0_RANGE[1:0] 
};

//////////////////////////////////////////
// 27.000000 MHz
//////////////////////////////////////////
// PLL1: M = 1, N = 1, Pdiv = 1
//       Fin  = 27.000000MHz
//       Fvco = Fin * N/M = 27.000000MHz
//       Range = 0 (Fvco < 125 MHz)
//       Fout = Fvco / Pdiv = 27.000000MHz
//       P = 4 - int(log2(M/N)) = 4
//       Np = N * 2^P = 16
//       Q = int(Np/M) = 16
//       R = Np - M*Q = 0
static Xuint8 iic_cdce913_y1_config_27_000_000[6][2] = 
{
   0x02, 0x34,   // [  7] = M1 = 0 (PLL1 bypassed) 
                 // [1:0] = Pdiv1[9:8] 
   0x03, 0x01,   // [7:0] = Pdiv1[7:0] 
   0x18, 0x00,   // [7:0] = PLL1_0N[11:4] 
   0x19, 0x10,   // [7:4] = PLL1_0N[3:0]  
                 // [3:0] = PLL1_0R[8:5]  
   0x1A, 0x02,   // [7:3] = PLL1_0R[4:0]  
                 // [2:0] = PLL1_0Q[5:3]  
   0x1B, 0x10    // [7:5] = PLL1_0Q[2:0] 
                 // [4:2] = PLL1_0P[2:0]  
                 // [1:0] = VCO1_0_RANGE[1:0] 
};

//ERROR => Fvco = 80.000000MHz <= 100MHz !
//////////////////////////////////////////
// 40.000000 MHz
//////////////////////////////////////////
// PLL1: M = 27, N = 80, Pdiv = 2
//       Fin  = 27.000000MHz
//       Fvco = Fin * N/M = 80.000000MHz
//       Range = 0 (Fvco < 125 MHz)
//       Fout = Fvco / Pdiv = 40.000000MHz
//       P = 4 - int(log2(M/N)) = 3
//       Np = N * 2^P = 640
//       Q = int(Np/M) = 23
//       R = Np - M*Q = 19
static Xuint8 iic_cdce913_y1_config_40_000_000[6][2] = 
{
   0x02, 0xB4,   // [  7] = M1 = 1 (PLL1 clock) 
                 // [1:0] = Pdiv1[9:8] 
   0x03, 0x02,   // [7:0] = Pdiv1[7:0] 
   0x18, 0x05,   // [7:0] = PLL1_0N[11:4] 
   0x19, 0x00,   // [7:4] = PLL1_0N[3:0]  
                 // [3:0] = PLL1_0R[8:5]  
   0x1A, 0x9A,   // [7:3] = PLL1_0R[4:0]  
                 // [2:0] = PLL1_0Q[5:3]  
   0x1B, 0xEC    // [7:5] = PLL1_0Q[2:0] 
                 // [4:2] = PLL1_0P[2:0]  
                 // [1:0] = VCO1_0_RANGE[1:0] 
};

//////////////////////////////////////////
// 65.000000 MHz
//////////////////////////////////////////
// PLL1: M = 27, N = 130, Pdiv = 2
//       Fin  = 27.000000MHz
//       Fvco = Fin * N/M = 130.000000MHz
//       Range = 1 (125 MHz <= Fvco < 150 MHz)
//       Fout = Fvco / Pdiv = 65.000000MHz
//       P = 4 - int(log2(M/N)) = 2
//       Np = N * 2^P = 520
//       Q = int(Np/M) = 19
//       R = Np - M*Q = 7
static Xuint8 iic_cdce913_y1_config_65_000_000[6][2] = 
{
   0x02, 0xB4,   // [  7] = M1 = 1 (PLL1 clock) 
                 // [1:0] = Pdiv1[9:8] 
   0x03, 0x02,   // [7:0] = Pdiv1[7:0] 
   0x18, 0x08,   // [7:0] = PLL1_0N[11:4] 
   0x19, 0x20,   // [7:4] = PLL1_0N[3:0]  
                 // [3:0] = PLL1_0R[8:5]  
   0x1A, 0x3A,   // [7:3] = PLL1_0R[4:0]  
                 // [2:0] = PLL1_0Q[5:3]  
   0x1B, 0x69    // [7:5] = PLL1_0Q[2:0] 
                 // [4:2] = PLL1_0P[2:0]  
                 // [1:0] = VCO1_0_RANGE[1:0] 
};

//////////////////////////////////////////
// 74.250000 MHz
//////////////////////////////////////////
// PLL1: M = 2, N = 11, Pdiv = 2
//       Fin  = 27.000000MHz
//       Fvco = Fin * N/M = 148.500000MHz
//       Range = 1 (125 MHz <= Fvco < 150 MHz)
//       Fout = Fvco / Pdiv = 74.250000MHz
//       P = 4 - int(log2(M/N)) = 2
//       Np = N * 2^P = 44
//       Q = int(Np/M) = 22
//       R = Np - M*Q = 0
static Xuint8 iic_cdce913_y1_config_74_250_000[6][2] = 
{
   0x02, 0xB4,   // [  7] = M1 = 1 (PLL1 clock) 
                 // [1:0] = Pdiv1[9:8] 
   0x03, 0x02,   // [7:0] = Pdiv1[7:0] 
   0x18, 0x00,   // [7:0] = PLL1_0N[11:4] 
   0x19, 0xB0,   // [7:4] = PLL1_0N[3:0]  
                 // [3:0] = PLL1_0R[8:5]  
   0x1A, 0x02,   // [7:3] = PLL1_0R[4:0]  
                 // [2:0] = PLL1_0Q[5:3]  
   0x1B, 0xC9    // [7:5] = PLL1_0Q[2:0] 
                 // [4:2] = PLL1_0P[2:0]  
                 // [1:0] = VCO1_0_RANGE[1:0] 
};

//////////////////////////////////////////
// 110.000000 MHz
//////////////////////////////////////////
// PLL1: M = 27, N = 110, Pdiv = 1
//       Fin  = 27.000000MHz
//       Fvco = Fin * N/M = 110.000000MHz
//       Range = 0 (Fvco < 125 MHz)
//       Fout = Fvco / Pdiv = 110.000000MHz
//       P = 4 - int(log2(M/N)) = 2
//       Np = N * 2^P = 440
//       Q = int(Np/M) = 16
//       R = Np - M*Q = 8
static Xuint8 iic_cdce913_y1_config_110_000_000[6][2] = 
{
   0x02, 0xB4,   // [  7] = M1 = 1 (PLL1 clock) 
                 // [1:0] = Pdiv1[9:8] 
   0x03, 0x01,   // [7:0] = Pdiv1[7:0] 
   0x18, 0x06,   // [7:0] = PLL1_0N[11:4] 
   0x19, 0xE0,   // [7:4] = PLL1_0N[3:0]  
                 // [3:0] = PLL1_0R[8:5]  
   0x1A, 0x42,   // [7:3] = PLL1_0R[4:0]  
                 // [2:0] = PLL1_0Q[5:3]  
   0x1B, 0x08    // [7:5] = PLL1_0Q[2:0] 
                 // [4:2] = PLL1_0P[2:0]  
                 // [1:0] = VCO1_0_RANGE[1:0] 
};

//////////////////////////////////////////
// 148.500000 MHz
//////////////////////////////////////////
// PLL1: M = 2, N = 11, Pdiv = 1
//       Fin  = 27.000000MHz
//       Fvco = Fin * N/M = 148.500000MHz
//       Range = 1 (125 MHz <= Fvco < 150 MHz)
//       Fout = Fvco / Pdiv = 148.500000MHz
//       P = 4 - int(log2(M/N)) = 2
//       Np = N * 2^P = 44
//       Q = int(Np/M) = 22
//       R = Np - M*Q = 0
static Xuint8 iic_cdce913_y1_config_148_500_000[6][2] = 
{
   0x02, 0xB4,   // [  7] = M1 = 1 (PLL1 clock) 
                 // [1:0] = Pdiv1[9:8] 
   0x03, 0x01,   // [7:0] = Pdiv1[7:0] 
   0x18, 0x00,   // [7:0] = PLL1_0N[11:4] 
   0x19, 0xB0,   // [7:4] = PLL1_0N[3:0]  
                 // [3:0] = PLL1_0R[8:5]  
   0x1A, 0x02,   // [7:3] = PLL1_0R[4:0]  
                 // [2:0] = PLL1_0Q[5:3]  
   0x1B, 0xC9    // [7:5] = PLL1_0Q[2:0] 
                 // [4:2] = PLL1_0P[2:0]  
                 // [1:0] = VCO1_0_RANGE[1:0] 
};

//////////////////////////////////////////
// 162.000000 MHz
//////////////////////////////////////////
// PLL1: M = 1, N = 6, Pdiv = 1
//       Fin  = 27.000000MHz
//       Fvco = Fin * N/M = 162.000000MHz
//       Range = 2 (150 MHz <= Fvco < 175 MHz)
//       Fout = Fvco / Pdiv = 162.000000MHz
//       P = 4 - int(log2(M/N)) = 2
//       Np = N * 2^P = 24
//       Q = int(Np/M) = 24
//       R = Np - M*Q = 0
static Xuint8 iic_cdce913_y1_config_162_000_000[6][2] = 
{
   0x02, 0xB4,   // [  7] = M1 = 1 (PLL1 clock) 
                 // [1:0] = Pdiv1[9:8] 
   0x03, 0x01,   // [7:0] = Pdiv1[7:0] 
   0x18, 0x00,   // [7:0] = PLL1_0N[11:4] 
   0x19, 0x60,   // [7:4] = PLL1_0N[3:0]  
                 // [3:0] = PLL1_0R[8:5]  
   0x1A, 0x03,   // [7:3] = PLL1_0R[4:0]  
                 // [2:0] = PLL1_0Q[5:3]  
   0x1B, 0x0A    // [7:5] = PLL1_0Q[2:0] 
                 // [4:2] = PLL1_0P[2:0]  
                 // [1:0] = VCO1_0_RANGE[1:0] 
};


/******************************************************************************
* This function initializes the Video Clock Synthesizer.
* The CDCE913 has 3 outputs which are configured as follows:
*    Y1 => 74.25 MHz
*    Y2 => off
*    Y3 => off
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void fmc_hdmi_cam_vclk_init( fmc_hdmi_cam_t *pContext )
{
   int dev;
   Xuint8 xdata;
   Xuint8 num_bytes;
   int i;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_VID_CLK );

   /*
    * Send I2C config sequence
    */
   for ( i = 0; i < MAX_IIC_CDCE913; i++ )
   {
      num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC,
         FMC_HDMI_CAM_VID_CLK_ADDR, 
         (0x80 | iic_cdce913[i][0]), &(iic_cdce913[i][1]), 1); 
      //xil_printf("[fmc_hdmi_cam_config_vclk] CDCE913[0x%02X] <= 0x%02X\n\r",(0x80 | iic_cdce913[i][0]), (iic_cdce913[i][1]));
      //num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC,
      //   FMC_HDMI_CAM_VID_CLK_ADDR, 
      //   (0x80 | iic_cdce913[i][0]), &xdata, 1); 
      //xil_printf("[fmc_hdmi_cam_config_vclk] CDCE913[0x%02X] => 0x%02X\n\r",(0x80 | iic_cdce913[i][0]), xdata);
   }
}

/******************************************************************************
* This function configures the Video Clock Synthesizer's Y1 output.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    FreqId contains the id of the frequency to configure.
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
void fmc_hdmi_cam_vclk_config( fmc_hdmi_cam_t *pContext, Xuint32 FreqId )
{
   int dev;
   Xuint8 num_bytes;
   int i;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_VID_CLK );

   switch ( FreqId )
   {
   case FMC_HDMI_CAM_VCLK_FREQ_25_175_000:
      for ( i = 0; i < 6; i++ )
      {
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_VID_CLK_ADDR, 
            (0x80 | iic_cdce913_y1_config_25_175_000[i][0]), &(iic_cdce913_y1_config_25_175_000[i][1]), 1); 
      }
      break;
   case FMC_HDMI_CAM_VCLK_FREQ_27_000_000:
      for ( i = 0; i < 6; i++ )
      {
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_VID_CLK_ADDR, 
            (0x80 | iic_cdce913_y1_config_27_000_000[i][0]), &(iic_cdce913_y1_config_27_000_000[i][1]), 1); 
      }
      break;
   case FMC_HDMI_CAM_VCLK_FREQ_40_000_000:
      for ( i = 0; i < 6; i++ )
      {
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_VID_CLK_ADDR, 
            (0x80 | iic_cdce913_y1_config_40_000_000[i][0]), &(iic_cdce913_y1_config_40_000_000[i][1]), 1); 
      }
      break;
   case FMC_HDMI_CAM_VCLK_FREQ_65_000_000:
      for ( i = 0; i < 6; i++ )
      {
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_VID_CLK_ADDR, 
            (0x80 | iic_cdce913_y1_config_65_000_000[i][0]), &(iic_cdce913_y1_config_65_000_000[i][1]), 1); 
      }
      break;
   case FMC_HDMI_CAM_VCLK_FREQ_74_250_000:
      for ( i = 0; i < 6; i++ )
      {
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_VID_CLK_ADDR, 
            (0x80 | iic_cdce913_y1_config_74_250_000[i][0]), &(iic_cdce913_y1_config_74_250_000[i][1]), 1); 
      }
      break;
   case FMC_HDMI_CAM_VCLK_FREQ_110_000_000:
      for ( i = 0; i < 6; i++ )
      {
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_VID_CLK_ADDR, 
            (0x80 | iic_cdce913_y1_config_110_000_000[i][0]), &(iic_cdce913_y1_config_110_000_000[i][1]), 1); 
      }
      break;
   case FMC_HDMI_CAM_VCLK_FREQ_148_500_000:
      for ( i = 0; i < 6; i++ )
      {
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_VID_CLK_ADDR, 
            (0x80 | iic_cdce913_y1_config_148_500_000[i][0]), &(iic_cdce913_y1_config_148_500_000[i][1]), 1); 
      }
      break;
   case FMC_HDMI_CAM_VCLK_FREQ_162_000_000:
      for ( i = 0; i < 6; i++ )
      {
         num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_VID_CLK_ADDR, 
            (0x80 | iic_cdce913_y1_config_162_000_000[i][0]), &(iic_cdce913_y1_config_162_000_000[i][1]), 1); 
      }
      break;
   }
}

////////////////////////////////////////////////////////////////////////
// HDMI Input Configuration Functions
////////////////////////////////////////////////////////////////////////

#define IIC_HDMI_IN_RESET_LEN  1
Xuint8 iic_hdmi_in_reset[IIC_HDMI_IN_RESET_LEN][3] =
{
      IIC_ADV7611_BASE_ADDR>>1, 0xFF, 0x80  // I2C reset
};

#define IIC_HDMI_IN_MAPPING_LEN  7
Xuint8 iic_hdmi_in_mapping[IIC_HDMI_IN_MAPPING_LEN][3] =
{
      IIC_ADV7611_BASE_ADDR>>1, 0xF4, IIC_ADV7611_CEC_ADDR, // CEC
      IIC_ADV7611_BASE_ADDR>>1, 0xF5, IIC_ADV7611_INFOFRAME_ADDR, // INFOFRAME
      IIC_ADV7611_BASE_ADDR>>1, 0xF8, IIC_ADV7611_DPLL_ADDR, // DPLL
      IIC_ADV7611_BASE_ADDR>>1, 0xF9, IIC_ADV7611_KSV_ADDR, // KSV
      IIC_ADV7611_BASE_ADDR>>1, 0xFA, IIC_ADV7611_EDID_ADDR, // EDID
      IIC_ADV7611_BASE_ADDR>>1, 0xFB, IIC_ADV7611_HDMI_ADDR, // HDMI
      IIC_ADV7611_BASE_ADDR>>1, 0xFD, IIC_ADV7611_CP_ADDR  // CP
};


#define IIC_HDMI_IN_EDID_PRE_LEN  (1)
Xuint8 iic_hdmi_in_edid_pre[IIC_HDMI_IN_EDID_PRE_LEN][3] =
{
      IIC_ADV7611_KSV_ADDR>>1, 0x77, 0x00  // Disable the Internal EDID
};
#define IIC_HDMI_IN_EDID_POST_LEN  (5)
Xuint8 iic_hdmi_in_edid_post[IIC_HDMI_IN_EDID_POST_LEN][3] =
{
      IIC_ADV7611_KSV_ADDR>>1, 0x77, 0x00, // Set the Most Significant Bit of the SPA location to 0
      IIC_ADV7611_KSV_ADDR>>1, 0x52, 0x20, // Set the SPA for port B.
      IIC_ADV7611_KSV_ADDR>>1, 0x53, 0x00, // Set the SPA for port B.
      IIC_ADV7611_KSV_ADDR>>1, 0x70, 0x9E, // Set the Least Significant Byte of the SPA location
      IIC_ADV7611_KSV_ADDR>>1, 0x74, 0x03  // Enable the Internal EDID for Ports
};

#define IIC_HDMI_IN_CONFIG_LEN  42
Xuint8 iic_hdmi_in_config[IIC_HDMI_IN_CONFIG_LEN][3] =
{
      IIC_ADV7611_BASE_ADDR>>1, 0x01, 0x06, // Prim_Mode =110b HDMI-GR
      IIC_ADV7611_BASE_ADDR>>1, 0x02, 0xF5, // Auto CSC, YCrCb out, Set op_656 bit
      IIC_ADV7611_BASE_ADDR>>1, 0x03, 0x80, // 16-Bit SDR ITU-R BT.656 4:2:2 Mode 0
      IIC_ADV7611_BASE_ADDR>>1, 0x04, 0x62, // OP_CH_SEL[2:0] = 011b - (P[15:8] Y, P[7:0] CrCb), XTAL_FREQ[1:0] = 01b (28.63636 MHz)
      IIC_ADV7611_BASE_ADDR>>1, 0x05, 0x2C, // AV Codes on

      IIC_ADV7611_CP_ADDR  >>1, 0x7B, 0x05, //

      IIC_ADV7611_BASE_ADDR>>1, 0x0B, 0x44, // Power up part
      IIC_ADV7611_BASE_ADDR>>1, 0x0C, 0x42, // Power up part
      IIC_ADV7611_BASE_ADDR>>1, 0x14, 0x7F, // Max Drive Strength
      IIC_ADV7611_BASE_ADDR>>1, 0x15, 0x80, // Disable Tristate of Pins
      IIC_ADV7611_BASE_ADDR>>1, 0x06, 0xA1, // LLC polarity (INV_LLC_POL = 1)
      IIC_ADV7611_BASE_ADDR>>1, 0x19, 0x80, // LLC DLL phase (delay = 0)
      IIC_ADV7611_BASE_ADDR>>1, 0x33, 0x40, // LLC DLL enable

      IIC_ADV7611_CP_ADDR  >>1, 0xBA, 0x01, // Set HDMI FreeRun

      IIC_ADV7611_KSV_ADDR >>1, 0x40, 0x81, // Disable HDCP 1.1 features

      IIC_ADV7611_HDMI_ADDR>>1, 0x9B, 0x03, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC1, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC2, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC3, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC4, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC5, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC6, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC7, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC8, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xC9, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xCA, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xCB, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0xCC, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0x00, 0x08, // Set HDMI Input Port A  (BG_MEAS_PORT_SEL = 001b)
      IIC_ADV7611_HDMI_ADDR>>1, 0x02, 0x03, // Enable Ports A & B in background mode
      IIC_ADV7611_HDMI_ADDR>>1, 0x83, 0xFC, // Enable clock terminators for port A & B
      IIC_ADV7611_HDMI_ADDR>>1, 0x6F, 0x0C, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0x85, 0x1F, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0x87, 0x70, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0x8D, 0x04, // LFG Port A
      IIC_ADV7611_HDMI_ADDR>>1, 0x8E, 0x1E, // HFG Port A
      IIC_ADV7611_HDMI_ADDR>>1, 0x1A, 0x8A, // Unmute audio
      IIC_ADV7611_HDMI_ADDR>>1, 0x57, 0xDA, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0x58, 0x01, // ADI recommended setting
      IIC_ADV7611_HDMI_ADDR>>1, 0x75, 0x10, // DDC drive strength
      IIC_ADV7611_HDMI_ADDR>>1, 0x90, 0x04, // LFG Port B
      IIC_ADV7611_HDMI_ADDR>>1, 0x91, 0x1E  // HFG Port B
};

#define IIC_HDMI_IN_SPDIF_CONFIG_LEN  2
Xuint8 iic_hdmi_in_spdif_config[IIC_HDMI_IN_SPDIF_CONFIG_LEN][3] =
{
      // For reference, default values are:
      //   ADV7611-HDMI[0x03] => 0x18
      //   ADV7611-HDMI[0x6E] => 0x04
      IIC_ADV7611_HDMI_ADDR>>1, 0x03, 0x78, // Raw SPDIF Mode
      IIC_ADV7611_HDMI_ADDR>>1, 0x6E, 0x0C  // 0x6E[3]=MUX_SPDIF_TO_I2S_ENABLE
};

/******************************************************************************
* This function initializes the HDMI Input Interface.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    Enable will activate the ADV7611 device (when 0, the device is powered-down).
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmii_init2( fmc_hdmi_cam_t *pContext, Xuint32 Enable, Xuint32 edidInit, Xuint8 pEdid[256], Xuint32 llc_polarity, Xuint32 llc_delay )
{
   //xil_printf( "LLC polarity = %d\n\r", llc_polarity );
   //xil_printf( "   iic_hdmi_in_config[10] => { 0x%02X, 0x%02X, 0x%02X }\n\r", iic_hdmi_in_config[10][0], iic_hdmi_in_config[10][1], iic_hdmi_in_config[10][2] );
   iic_hdmi_in_config[10][2] &= 0xFE;
   iic_hdmi_in_config[10][2] |= (llc_polarity & 0x01);
   //xil_printf( "   iic_hdmi_in_config[10] <= { 0x%02X, 0x%02X, 0x%02X }\n\r", iic_hdmi_in_config[10][0], iic_hdmi_in_config[10][1], iic_hdmi_in_config[10][2] );

   //xil_printf( "LLC delay = %d\n\r", llc_delay );
   //xil_printf( "   iic_hdmi_in_config[11] => { 0x%02X, 0x%02X, 0x%02X }\n\r", iic_hdmi_in_config[11][0], iic_hdmi_in_config[11][1], iic_hdmi_in_config[11][2] );
   iic_hdmi_in_config[11][2] &= 0x80;
   iic_hdmi_in_config[11][2] |= (llc_delay & 0x1F);
   //xil_printf( "   iic_hdmi_in_config[11] <= { 0x%02X, 0x%02X, 0x%02X }\n\r", iic_hdmi_in_config[11][0], iic_hdmi_in_config[11][1], iic_hdmi_in_config[11][2] );

   fmc_hdmi_cam_hdmii_init( pContext, Enable, edidInit, pEdid );
}
int fmc_hdmi_cam_hdmii_init( fmc_hdmi_cam_t *pContext, Xuint32 Enable, Xuint32 edidInit, Xuint8 pEdid[256] )
{
   Xuint8 i2c_address;
   Xuint8 i2c_data;
   Xuint8 num_bytes;
   Xuint32 reg;

   if ( !Enable )
   {
      //xil_printf("\tDe-asserting HotPlugDetect\n\r");
      fmc_hdmi_cam_hdmii_set_hpd( pContext, 0 );
      fmc_hdmi_cam_wait_usec(1000000);

      //xil_printf("\tAsserting Reset\n\r");
      fmc_hdmi_cam_hdmii_set_rst( pContext, 1 );
      fmc_hdmi_cam_wait_usec(1000000);
   }
   else
   {
      // Do not allow HDMI source do "see" the HDMI receiver until the EDID has been programmed
      //xil_printf("\tDe-asserting HotPlugDetect\n\r");
      fmc_hdmi_cam_hdmii_set_hpd( pContext, 0 );
      fmc_hdmi_cam_wait_usec(1000000);

      //xil_printf("\tDe-asserting Reset\n\r");
      fmc_hdmi_cam_hdmii_set_rst( pContext, 0 );
      fmc_hdmi_cam_wait_usec(1000000);


#if 0
      //xil_printf( "I2C Initializing - Reset\n\r" );
      fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );
      fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_in_reset, IIC_HDMI_IN_RESET_LEN );
      fmc_hdmi_cam_wait_usec(1000000);
#endif

      //xil_printf("I2C Initializing - Mapping\n\r");
      fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );
      fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_in_mapping, IIC_HDMI_IN_MAPPING_LEN);
      if (edidInit)
      {
         fmc_hdmi_cam_hdmii_write_edid( pContext, pEdid );
      }
      fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_in_edid_post, IIC_HDMI_IN_EDID_POST_LEN );

      // Now that the EDID has been programmed, allow HDMI source do "see" the HDMI receiver
      //xil_printf("\tAsserting HotPlugDetect\n\r");
      fmc_hdmi_cam_hdmii_set_hpd( pContext, 1 );
      fmc_hdmi_cam_wait_usec(1000000);

      //xil_printf("I2C Initializing - Config\n\r");
      fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );
      fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_in_config, IIC_HDMI_IN_CONFIG_LEN);

      //xil_printf("I2C Initializing - SPDIF Config\n\r");
      fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );
      fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_in_spdif_config, IIC_HDMI_IN_SPDIF_CONFIG_LEN);

      // sleep 100ms
      fmc_hdmi_cam_wait_usec(100000);
   }

   return 1;
}

/******************************************************************************
* This function drives the HotPlugDetect signal on the HDMI Input Interface.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    HotPlugStatus
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmii_set_hpd( fmc_hdmi_cam_t *pContext, Xuint32 HotPlugStatus )
{
   Xuint8 reg_addr;
   Xuint8 reg_data;
   Xuint8 num_bytes;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_IO_EXP );

   // Configure output values of I/O Expander's P2 GPIO pins
   reg_addr = 0x01;
   num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
   //xil_printf( "[fmc_hdmi_cam_hdmii_set_hpd] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   if ( HotPlugStatus )
      reg_data |=  0x04; // // P2 => HDMII_HPD   = 1 (output)
   else
      reg_data &= ~0x04; // // P2 => HDMII_HPD   = 0 (output)
   //xil_printf( "[fmc_hdmi_cam_hdmii_set_hpd] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1);

   return 1;
}

/******************************************************************************
* This function drives the Reset signal on the HDMI Input Interface.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    Reset
*
* @return   None.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmii_set_rst( fmc_hdmi_cam_t *pContext, Xuint32 Reset )
{
   Xuint8 reg_addr;
   Xuint8 reg_data;
   Xuint8 num_bytes;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_IO_EXP );

   // Configure output values of I/O Expander's P0 GPIO pins
   reg_addr = 0x01;
   num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
   //xil_printf( "[fmc_hdmi_cam_hdmii_set_rst] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   if ( Reset )
      reg_data &= ~0x01; // // P0 => HDMII_RST#  = 0 (output)
   else
      reg_data |=  0x01; // // P0 => HDMII_RST#  = 1 (output)
   //xil_printf( "[fmc_hdmi_cam_hdmii_set_rst] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1);

   return 1;
}

/******************************************************************************
* This function reads the state of INT1 on the HDMI Input Interface.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    pIntStatus contains a pointer for the return value of the Int status
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmii_get_int( fmc_hdmi_cam_t *pContext, Xuint32 *pIntStatus )
{
   Xuint8 reg_addr;
   Xuint8 reg_data;
   Xuint8 num_bytes;
   Xuint32 hdmii_int;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_IO_EXP );

   // Read input value of I/O Expander's P1 GPIO pin
   reg_addr = 0x00;
   num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
   //xil_printf( "[fmc_hdmi_cam_hdmii_get_int] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   
   if ( reg_data & 0x02 )
      hdmii_int = 1;
   else
     hdmii_int = 0;
   
   *pIntStatus = hdmii_int;
   return 1;
}

int fmc_hdmi_cam_hdmii_get_lock( fmc_hdmi_cam_t *pContext )
{
   Xuint8 reg_addr = 0x07;
   Xuint8 reg_data;
   Xuint8 num_bytes;
   Xuint32 lock;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );

   num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, (IIC_ADV7611_HDMI_ADDR>>1), reg_addr, &reg_data, 1);
   //xil_printf( "[fmc_hdmi_cam_hdmii_get_lock] ADV7611-HDMI4[0x%02X] <= 0x%02X\n\r", reg_addr, reg_0x07);

   // Get lock status based on
   //    ADV7611-HDMI[0x07][7] = vertical lock
   //    ADV7611-HDMI[0x07][5] = de regen lock)
   lock = ((reg_data & 0xA0) == 0xA0) ? 1 : 0;

   return lock;
}

int fmc_hdmi_cam_hdmii_get_timing( fmc_hdmi_cam_t *pContext, fmc_hdmi_cam_video_timing_t *pTiming )
{
   int i;
   Xuint8 reg_addr;
   Xuint8 reg_data[256];
   Xuint8 num_bytes;

   Xuint32 IsHDMI;
   Xuint32 IsEncrypted;
   Xuint32 IsInterlaced;
   Xuint32 DeepColorMode;
   Xuint32 LineWidth;
   Xuint32 HFrontPorch;
   Xuint32 HSyncWidth;
   Xuint32 HBackPorch;
   Xuint32 HSyncPolarity;
   Xuint32 TotalLineWidth;
   Xuint32 Field0Height;
   Xuint32 Field0FrontPorch;
   Xuint32 Field0SyncWidth;
   Xuint32 Field0BackPorch;
   Xuint32 Field0TotalHeight;
   Xuint32 Field1Height;
   Xuint32 Field1FrontPorch;
   Xuint32 Field1SyncWidth;
   Xuint32 Field1BackPorch;
   Xuint32 Field1TotalHeight;
   Xuint32 VSyncPolarity;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );

   for ( i = 0; i < 256; i++ )
   {
      reg_addr = (Xuint8)i;
      num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, (IIC_ADV7611_HDMI_ADDR>>1), reg_addr, &reg_data[i], 1);
   }
   
   // Get Video Input information
   IsHDMI        = (reg_data[0x05] >> 7) & 0x01;
   IsEncrypted   = (reg_data[0x05] >> 6) & 0x01;
   IsInterlaced  = (reg_data[0x0B] >> 5) & 0x01;
   DeepColorMode = (reg_data[0x0B] >> 6) & 0x03;
   //
   LineWidth      = ((Xuint32)(reg_data[0x07] & 0x1F) << 8) | ((Xuint32)reg_data[0x08]);
   HFrontPorch    = ((Xuint32)(reg_data[0x20] & 0x1F) << 8) | ((Xuint32)reg_data[0x21]);
   HSyncWidth     = ((Xuint32)(reg_data[0x22] & 0x1F) << 8) | ((Xuint32)reg_data[0x23]);
   HBackPorch     = ((Xuint32)(reg_data[0x24] & 0x1F) << 8) | ((Xuint32)reg_data[0x25]);
   TotalLineWidth = ((Xuint32)(reg_data[0x1E] & 0x3F) << 8) | ((Xuint32)reg_data[0x1F]);
   HSyncPolarity  = (reg_data[0x05] >> 5) & 0x01;
   //
   Field0Height      = ((Xuint32)(reg_data[0x09] & 0x1F) << 8) | ((Xuint32)reg_data[0x0A]);
   Field0FrontPorch  = ((Xuint32)(reg_data[0x2A] & 0x3F) << 8) | ((Xuint32)reg_data[0x2B]);
   Field0SyncWidth   = ((Xuint32)(reg_data[0x2E] & 0x3F) << 8) | ((Xuint32)reg_data[0x2F]);
   Field0BackPorch   = ((Xuint32)(reg_data[0x32] & 0x3F) << 8) | ((Xuint32)reg_data[0x33]);
   Field0TotalHeight = ((Xuint32)(reg_data[0x26] & 0x3F) << 8) | ((Xuint32)reg_data[0x27]);
   Field1Height      = ((Xuint32)(reg_data[0x0B] & 0x1F) << 8) | ((Xuint32)reg_data[0x0C]);
   Field1FrontPorch  = ((Xuint32)(reg_data[0x2C] & 0x3F) << 8) | ((Xuint32)reg_data[0x2D]);
   Field1SyncWidth   = ((Xuint32)(reg_data[0x30] & 0x3F) << 8) | ((Xuint32)reg_data[0x31]);
   Field1BackPorch   = ((Xuint32)(reg_data[0x34] & 0x3F) << 8) | ((Xuint32)reg_data[0x35]);
   Field1TotalHeight = ((Xuint32)(reg_data[0x28] & 0x3F) << 8) | ((Xuint32)reg_data[0x29]);
   VSyncPolarity     = (reg_data[0x05] >> 4) & 0x01;

   memset( pTiming, 0x00, sizeof(fmc_hdmi_cam_video_timing_t) );

   pTiming->IsHDMI = IsHDMI;
   pTiming->IsEncrypted = IsEncrypted;
   pTiming->IsInterlaced = IsInterlaced;
   pTiming->ColorDepth = (DeepColorMode==3) ? 16 : (8 + (DeepColorMode*2));
   
   pTiming->HActiveVideo  = LineWidth;
   pTiming->HFrontPorch   = HFrontPorch;
   pTiming->HSyncWidth    = HSyncWidth;
   pTiming->HBackPorch    = HBackPorch;
   pTiming->HSyncPolarity = HSyncPolarity;

   if ( IsInterlaced )
   {
      // TBD
   }
   else // Progressive
   {
      pTiming->VActiveVideo  = Field0Height;
      pTiming->VFrontPorch   = Field0FrontPorch >> 1;
      pTiming->VSyncWidth    = Field0SyncWidth  >> 1;
      pTiming->VBackPorch    = Field0BackPorch  >> 1;
      pTiming->VSyncPolarity = VSyncPolarity;
   }

   return 1;
}

////////////////////////////////////////////////////////////////////////
// HDMI Output Configuration Functions
////////////////////////////////////////////////////////////////////////

#define IIC_HDMI_OUT_CONFIG_LEN  (37)
Xuint8 iic_hdmi_out_config[IIC_HDMI_OUT_CONFIG_LEN][3] =
{
      //
      // Power-up the Tx (HPD must be high)
      //
      IIC_ADV7511_BASE_ADDR>>1, 0x41, 0x10, // Power down control
                                            //    R0x41[  6] = PowerDown = 0 (power-up)
      //
      // Fixed registers that must be set on power up
      //
      IIC_ADV7511_BASE_ADDR>>1, 0x98, 0x03, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0x99, 0x02, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0x9A, 0xE0, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0x9C, 0x30, // PLL Filter R1 Value
      IIC_ADV7511_BASE_ADDR>>1, 0x9D, 0x61, // Set clock divide
      IIC_ADV7511_BASE_ADDR>>1, 0xA2, 0xA4, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0xA3, 0xA4, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0xA5, 0x44, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0xAB, 0x40, // ADI Recommended Write
      //IIC_ADV7511_BASE_ADDR>>1, 0xBA, 0x00, // Programmable delay for input video clock = 000 = -1.2ns
      //IIC_ADV7511_BASE_ADDR>>1, 0xBA, 0x60, // Programmable delay for input video clock = 011 = no delay
      IIC_ADV7511_BASE_ADDR>>1, 0xBA, 0xA0, // Programmable delay for input video clock = 101 = +0.8ns
      IIC_ADV7511_BASE_ADDR>>1, 0xD0, 0x00, // Delay adjust for negative DDR capture = disabled
      IIC_ADV7511_BASE_ADDR>>1, 0xD1, 0xFF, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0xDE, 0x9C, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0xE0, 0xD0, // ADI Recommended Write
      IIC_ADV7511_BASE_ADDR>>1, 0xE4, 0x60, // VCO_Swing_Reference_Voltage
      IIC_ADV7511_BASE_ADDR>>1, 0xF9, 0x00, // VCO_Swing_Reference_Voltage
      //
      // Set up the video input mode
      //
      IIC_ADV7511_BASE_ADDR>>1, 0x15, 0x02, // Input YCbCr 4:2:2 with embedded syncs
      IIC_ADV7511_BASE_ADDR>>1, 0x16, 0x38, // Output format 444, Input Color Depth = 8
                                            //    R0x16[  7] = Output Video Format = 0 (444)
                                            //    R0x16[5:4] = Input Video Color Depth = 11 (8 bits/color)
                                            //    R0x16[3:2] = Input video Style = 10 (style 1) or 01 (style 2)
                                            //    R0x16[  1] = DDR Input Edge = 0 (falling edge)
                                            //    ROx16[  0] = Output Color Space = 0 (RGB)
      //
      // Set up the video output mode
      //
      //IIC_ADV7511_BASE_ADDR>>1, 0x16, 0x38, // Output format 444, Input Color Depth = 8
      IIC_ADV7511_BASE_ADDR>>1, 0x18, 0xC6, // CSC
                                            //    R0x18[  7] = CSC enable = 1 (CSC enabled)
                                            //    R0x18[6:5] = CSC Scaling Factor = 10 (+/- 4.0, -16384 - 16380)
                                            //    R0x18[4:0] = CSC coefficient A1[12:8]
      IIC_ADV7511_BASE_ADDR>>1, 0x40, 0x80, // General Control packet enable
      IIC_ADV7511_BASE_ADDR>>1, 0x48, 0x10, // Video Input Justification
                                            //    R0x48[8:7] = Video Input Justification = 10 (left justified)
      IIC_ADV7511_BASE_ADDR>>1, 0x49, 0xA8, // Bit trimming mode = 101010 (truncate)
      IIC_ADV7511_BASE_ADDR>>1, 0x4C, 0x00, // Color Depth = 0000 (color depth not indicated)
      IIC_ADV7511_BASE_ADDR>>1, 0x55, 0x00, // Set RGB in AVinfo Frame
                                            //    R0x55[6:5] = Output Format = 00 (RGB)
      //IIC_ADV7511_BASE_ADDR>>1, 0x55, 0x40, // Set YCrCb 444 in AVinfo Frame
      //IIC_ADV7511_BASE_ADDR>>1, 0x55, 0x20, // Set YCrCb 422 in AVinfo Frame
      IIC_ADV7511_BASE_ADDR>>1, 0x56, 0x08, // Aspect Ratio
                                            //    R0x56[5:4] = Picture Aspect Ratio = 00 (no data)
                                            //    R0x56[3:0] = Active Format Aspect Ratio = 1000 (Same as Aspect Ratio)
      //IIC_ADV7511_BASE_ADDR>>1, 0xAF, 0x06, // Set HDMI Mode
                                            //    R0xAF[  7] = HDCP Enable = 0 (HDCP disabled)
                                            //    R0xAF[  4] = Frame Encryption = 0 (Current frame NOT HDCP encrypted)
                                            //    R0xAF[3:2] = 01 (fixed)
                                            //    R0xAF[  1] = HDMI/DVI Mode Select = 1 (HDMI Mode)
      IIC_ADV7511_BASE_ADDR>>1, 0xAF, 0x04, // Set DVI Mode
                                            //    R0xAF[  1] = HDMI/DVI Mode Select = 0 (DVI Mode)
      //
      // SPDIF Audio Setup
      //
      IIC_ADV7511_BASE_ADDR>>1, 0x01, 0x00, // Set N Value = 6144 (0x001800) for 48 kHz
      IIC_ADV7511_BASE_ADDR>>1, 0x02, 0x18,
      IIC_ADV7511_BASE_ADDR>>1, 0x03, 0x00,
      //
	  IIC_ADV7511_BASE_ADDR>>1, 0x0A, 0x10,
      IIC_ADV7511_BASE_ADDR>>1, 0x0B, 0x8E,
      IIC_ADV7511_BASE_ADDR>>1, 0x0C, 0x00,
      IIC_ADV7511_BASE_ADDR>>1, 0x73, 0x01,
      IIC_ADV7511_BASE_ADDR>>1, 0x14, 0x02,
      //
      // HPD Interrupt clear
      //
      IIC_ADV7511_BASE_ADDR>>1, 0x96, 0x20, // HPD Interrupt clear
      //
      // ???
      //
      IIC_ADV7511_BASE_ADDR>>1, 0xFA, 0x00  // Nbr of times to search for good phase
};

#define IIC_HDMI_OUT_EMBEDDED_SYNC_CONFIG_LEN  (6)
Xuint8 iic_hdmi_out_embedded_sync_config[IIC_HDMI_OUT_EMBEDDED_SYNC_CONFIG_LEN][3] =
{
   //
   // Configure for 1080p60 16-bit bus embedded syncs
   //
   IIC_ADV7511_BASE_ADDR>>1, 0x30, 0x16, // Hsync placement = 0001011000 (0x58) = 88
   IIC_ADV7511_BASE_ADDR>>1, 0x31, 0x02, // Hsync duration  = 0000101100 (0x2C) = 44
   IIC_ADV7511_BASE_ADDR>>1, 0x32, 0xC0, //
   IIC_ADV7511_BASE_ADDR>>1, 0x33, 0x10, // Vsync placement = 0000000100 (0x04) =  4
   IIC_ADV7511_BASE_ADDR>>1, 0x34, 0x05, // Vsync duration  = 0000000101 (0x05) =  5
   IIC_ADV7511_BASE_ADDR>>1, 0x17, 0x02  // VSync Polarity = 0(high), HSync Polarity = 0(high)
};

/******************************************************************************
* This function initializes the HDMI Output Interface.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    Enable will activate the ADV7511 device (when 0, the device is powered-down).
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmio_init( fmc_hdmi_cam_t *pContext, Xuint32 Enable, fmc_hdmi_cam_video_timing_t *pTiming, Xuint32 WaitForHPD )
{
   Xuint8 i2c_dev;
   Xuint8 i2c_addr;
   Xuint8 i2c_data;
   Xuint8 num_bytes;
   Xuint32 timeout;

   if ( !Enable )
   {
      //xil_printf( "\tAsserting PowerDown\n\r" );
      fmc_hdmi_cam_hdmio_set_pd( pContext, 1 );

      // Wait 100msec.
      fmc_hdmi_cam_wait_usec(100000);
   }
   else
   {
      //xil_printf( "\tDe-asserting PowerDown\n\r" );
      fmc_hdmi_cam_hdmio_set_pd( pContext, 0 );

      // Wait 100msec.
      fmc_hdmi_cam_wait_usec(100000);

      fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_OUT );

	  // Adjust HDMI/DVI mode based on specified video timing info
	  {
	     int i;
		 for ( i = 0; i < IIC_HDMI_OUT_CONFIG_LEN; i++ )
		 {
		    if ( iic_hdmi_out_config[i][1] == 0xAF )
			{
				if ( pTiming->IsHDMI )
				{
                   if ( pContext->bVerbose ) xil_printf( "\tSetting I2C config sequence for HDMI Mode\n\r" );
                   iic_hdmi_out_config[i][2] = 0x06; // Set HDMI Mode
                                                     //    R0xAF[  1] = HDMI/DVI Mode Select = 1 (HDMI Mode)
				}
				else
				{
                   if ( pContext->bVerbose ) xil_printf( "\tSetting I2C config sequence for DVI Mode\n\r" );
                   iic_hdmi_out_config[i][2] = 0x04; // Set DVI Mode
                                                     //    R0xAF[  1] = HDMI/DVI Mode Select = 0 (DVI Mode)
				}
			} // if ( iic_hdmi_out_config[i][1] == 0xAF )
		 } // for ( i = 0; i < IIC_HDMI_OUT_CONFIG_LEN; i++ )
	  }

      fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_out_config, IIC_HDMI_OUT_CONFIG_LEN);

      // Adjust Embedded Sync Generation based on specified video timing
      iic_hdmi_out_embedded_sync_config[0][2] = (Xuint8)((pTiming->HFrontPorch >> 2) & 0xFF);
      iic_hdmi_out_embedded_sync_config[1][2] = (Xuint8)((pTiming->HFrontPorch << 6) & 0xC0) |
                                                (Xuint8)((pTiming->HSyncWidth  >> 4) & 0x3F);
      iic_hdmi_out_embedded_sync_config[2][2] = (Xuint8)((pTiming->HSyncWidth  << 4) & 0xF0) |
                                                (Xuint8)((pTiming->VFrontPorch >> 6) & 0x0F);
      iic_hdmi_out_embedded_sync_config[3][2] = (Xuint8)((pTiming->VFrontPorch << 2) & 0xFC) |
                                                (Xuint8)((pTiming->VSyncWidth  >> 8) & 0x03);
      iic_hdmi_out_embedded_sync_config[4][2] = (Xuint8)((pTiming->VSyncWidth  >> 0) & 0xFF);
      iic_hdmi_out_embedded_sync_config[5][2] = 0x00; // (Xuint8)( ... pTiming->HSyncPolarity .. pTiming->VSyncPolarity ... )

      if ( pContext->bVerbose )
	  {
         int i;
         for ( i = 0; i < 6; i++ )
         {
            xil_printf("\tembedded_sync_config[%d] = 0x%02X, 0x%02X, 0x%02X\n\r",
               i,
               (iic_hdmi_out_embedded_sync_config[i][0])<<1,
               iic_hdmi_out_embedded_sync_config[i][1],
               iic_hdmi_out_embedded_sync_config[i][2]
               );
         }
      }

      fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_out_embedded_sync_config, IIC_HDMI_OUT_EMBEDDED_SYNC_CONFIG_LEN);

      // sleep 100ms
      fmc_hdmi_cam_wait_usec(100000);

      i2c_dev = FMC_HDMI_CAM_HDMI_OUT_ADDR; // ADV7511
      i2c_addr = 0x96;
      num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, i2c_dev, i2c_addr, &i2c_data, 1);
      if (num_bytes < 1)
      {
         //xil_printf("\t\tERROR occurred during I2C transaction !\n\r");
      }
      //xil_printf("\t0x%02X[0x%02X] => 0x%02X\n\r", (i2c_dev << 1), i2c_addr, i2c_data);

      if ( WaitForHPD )
      {
         timeout = 99;
         while (((i2c_data & 0xC0) != 0xC0) && (--timeout))
         {
            num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, i2c_dev, i2c_addr, &i2c_data, 1);
            if (num_bytes < 1)
            {
               xil_printf( "[fmc_hdmi_cam_hdmio_init] ERROR occurred during I2C transaction !\n\r");
               timeout = 0;
               return 0;
            }
            //xil_printf("\t0x%02X[0x%02X] => 0x%02X\n\r", (i2c_dev << 1), i2c_addr, i2c_data);
         }
         if (!timeout)
         {
            xil_printf( "[fmc_hdmi_cam_hdmio_init] ERROR - Timeout waiting for internal HotPlugDetect !\n\r");
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
int fmc_hdmi_cam_hdmio_set_pd( fmc_hdmi_cam_t *pContext, Xuint32 PowerDown )
{
   Xuint8 reg_addr;
   Xuint8 reg_data;
   Xuint8 num_bytes;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_IO_EXP );

   // Configure output values of I/O Expander's P4 GPIO pins
   reg_addr = 0x01;
   num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
   //xil_printf( "[fmc_hdmi_cam_hdmio_set_pd] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   if ( PowerDown )
      reg_data |=  0x10; // // P4 => HDMIO_PD   = 1 (output)
   else
      reg_data &= ~0x10; // // P4 => HDMIO_PD   = 0 (output)
   //xil_printf( "[fmc_hdmi_cam_hdmio_set_pd] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   num_bytes = pContext->pIIC->fpIicWrite( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1);

   return 1;
}

/******************************************************************************
* This function reads the state of HotPlugDetect on the HDMI Input Interface.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    pHotPlugDetect contains a pointer for the return value of the HotPlugDetect status
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmio_get_hpd( fmc_hdmi_cam_t *pContext, Xuint32 *pHotPlugDetect )
{
   Xuint8 reg_addr;
   Xuint8 reg_data;
   Xuint8 num_bytes;
   int hdmio_hpd;

   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_IO_EXP );

   // Read input value of I/O Expander's P3 GPIO pin
   reg_addr = 0x00;
   num_bytes = pContext->pIIC->fpIicRead( pContext->pIIC, FMC_HDMI_CAM_IO_EXP_ADDR, reg_addr, &reg_data, 1); 
   //xil_printf( "[fmc_hdmi_cam_hdmio_get_hpd] PCA9534[0x%02X] <= 0x%02X\n\r", reg_addr, reg_data );
   
   if ( reg_data & 0x08 )
      hdmio_hpd = 1;
   else
     hdmio_hpd = 0;
   
   *pHotPlugDetect = hdmio_hpd;
   return 1;
}


////////////////////////////////////////////////////////////////////////
// DDC/EDID Functions
////////////////////////////////////////////////////////////////////////

/******************************************************************************
* This function reads the contents of the HDMI input's EDID EEPROM.
*
* @param    pContext contains a pointer to a FMC-IMAGEON instance's context.
* @param    pData contains a vector where the EDID EEPROM are stored.
*
* @return   Number of bytes read.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmii_read_edid( fmc_hdmi_cam_t *pContext, Xuint8 pData[256] )
{
   Xuint8 num_bytes = 0;
   int    idx;
   
   // Mux Selection
   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );

   // Read contents of EDID EEPROM
   for ( idx = 0; idx < 256; idx++ )
   {
      num_bytes += pContext->pIIC->fpIicRead( pContext->pIIC, (IIC_ADV7611_EDID_ADDR>>1), idx, &pData[idx], 1);
   }
   
   return num_bytes;
}

/******************************************************************************
* This function writes the contents of the HDMI input's EDID EEPROM.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    pData contains a vector containing new EDID EEPROM data.
*
* @return   Number of bytes written.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmii_write_edid( fmc_hdmi_cam_t *pContext, Xuint8 pData[256] )
{
   Xuint8 num_bytes = 0;
   //Xuint8 dummy_data;
   int    idx;
   
   // Mux Selection
   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );

   //xil_printf("I2C Initializing - EDID\n\r");

   fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_in_edid_pre, IIC_HDMI_IN_EDID_PRE_LEN);
   //
   for ( idx = 0; idx < 256; idx++ )
   {
      num_bytes += pContext->pIIC->fpIicWrite( pContext->pIIC, (IIC_ADV7611_EDID_ADDR>>1), idx, &pData[idx], 1 );
   }
   //
   fmc_hdmi_cam_iic_config3( pContext, iic_hdmi_in_edid_post, IIC_HDMI_IN_EDID_POST_LEN);

   return num_bytes;
}

/******************************************************************************
* This function reads the contents of the DVI output's EDID EEPROM.
*
* @param    pContext contains a pointer to the FMC-IMAGEON instance's context.
* @param    pData contains a vector where the EDID EEPROM are stored.
*
* @return   Number of bytes read.
*
* @note     None.
*
******************************************************************************/
int fmc_hdmi_cam_hdmio_read_edid( fmc_hdmi_cam_t *pContext, Xuint8 pData[256] )
{
   Xuint8 num_bytes = 0;
   int    idx;
   
   // Mux Selection
   fmc_hdmi_cam_iic_mux( pContext, FMC_HDMI_CAM_I2C_SELECT_DDCEDID );

   // Read contents of EDID EEPROM
   for ( idx = 0; idx < 256; idx++ )
   {
      num_bytes += pContext->pIIC->fpIicRead( pContext->pIIC, FMC_HDMI_CAM_DDCEDID_ADDR, idx, &pData[idx], 1); 
   }
   
   return num_bytes;
}

////////////////////////////////////////////////////////////////////////
// Delay Functions
////////////////////////////////////////////////////////////////////////

/***********************************************************************
* Wait the specified number of microseconds
*
* @param    delay specifies the number of microseconds to wait.
*
* @return   None. 
*
* @note     Call external usleep() function, supplied by user application
*
***********************************************************************/
extern void usleep(unsigned int useconds);
void fmc_hdmi_cam_wait_usec(unsigned int delay)
{
#if SIM
  // no delay for simulation
  return;
#endif

  usleep(delay);
}


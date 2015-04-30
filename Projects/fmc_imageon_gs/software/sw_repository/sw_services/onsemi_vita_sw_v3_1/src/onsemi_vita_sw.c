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
// Create Date:         Sep 19, 2011
// Design Name:         ON Semiconductor VITA Receiver
// Module Name:         onsemi_vita_sw.c
// Project Name:        ON Semiconductor VITA Receiver
// Target Devices:      Spartan-6, Virtex-6, Kintex-7, Zynq-7000
// Avnet Boards:        FMC-IMAGEON
//
// Tool versions:       Vivado 2014.4
//
// Description:         VITA Receiver Software Library.
//                      Initial version generated with EDK Create Peripheral Wizard
//                      - contained generic macros to access 32 registers
//                      Driver modified to add:
//                      - Data structure for driver context
//                      - Init routine
//                      - SPI Read routine
//                      - SPI Write routine
//
// Dependencies:        
//
// Revision:            Sep 19, 2011: 1.00 Initial version
//                      Sep 22, 2011: 1.01 Added:
//                                         - ISERDES interface
//                      Sep 28, 2011: 1.02 Added:
//                                         - sync channel decoder
//                                         - crc checker
//                                         - data remapper
//                      Oct 20, 2011: 1.03 Modify:
//                                         - iserdes (use BUFR)
//                      Oct 21, 2011: 1.04 Added:
//                                         - fpn prnu correction
//                      Nov 03, 2011: 1.05 Added:
//                                         - trigger generator
//                      Dec 19, 2011: 1.06 Modified:
//                                         - port to Kintex-7
//                      Feb 09, 2011: 1.08 Add VITA configuration functions
//                                         - init
//                                         - get_status
//                                         - set_exposure
//                                         - set_analog_gain
//                                         - set_digital_gain
//                      Jun 01, 2012: 1.12 Change syncgen configuration code
//                      Dec 17, 2013: 2.01 Port to Vivado 2013.3
//----------------------------------------------------------------
//                      Jan 29, 2015: 3.01 Rename to onsemi_vita_sw
//                                         Now uses two cores:
//                                         - onsemi_vita_spi
//                                         - onsemi_vita_cam
//
//----------------------------------------------------------------

/***************************** Include Files *******************************/

#include "onsemi_vita_sw.h"

/************************** Function Definitions ***************************/

/*****************************************************************************
*
* User Content Added Here
*
*****************************************************************************/

#include <stdio.h>
#include <string.h>

/*****************************************************************************
*
* SPI Configuration Sequences
*
*****************************************************************************/

#define VITA_SPI_SEQ1_QTY  8
Xuint16 vita_spi_seq1[VITA_SPI_SEQ1_QTY][3] =
{
   // Enable Clock Management - Part 1
   //    V1/SN/SE 10-bit mode with PLL
   {  2, 0xFFFF, 0x0000}, // Monochrome Sensor
// {  2, 0xFFFF, 0x0001}, // Color Sensor
   { 32, 0xFFFF, 0x2004}, // Configure clock management
   { 20, 0xFFFF, 0x0000}, // Configure clock management
   { 17, 0xFFFF, 0x2113}, // Configure PLL
   { 26, 0xFFFF, 0x2280}, // Configure PLL lock detector
   { 27, 0xFFFF, 0x3D2D}, // Configure PLL lock detector
   {  8, 0xFFFF, 0x0000}, // Release PLL soft reset
   { 16, 0xFFFF, 0x0003}  // Enable PLL
};

#define VITA_SPI_SEQ3_QTY  3
Xuint16 vita_spi_seq3[VITA_SPI_SEQ3_QTY][3] =
{
   // Enable Clock Management - Part 2
   //    V1/SN/SE 10-bit mode with PLL
   {  9, 0xFFFF, 0x0000}, // Release clock generator soft reset
   { 32, 0xFFFF, 0x2006}, // Enable logic clock
   { 34, 0xFFFF, 0x0001}  // Enable logic blocks
};

#define VITA_SPI_SEQ4_QTY  17
Xuint16 vita_spi_seq4[VITA_SPI_SEQ4_QTY][3] =
{
   // Required Register Upload
   //    V1/SN/SE 10-bit mode with PLL
   { 41, 0xFFFF, 0x0000}, // Configure image core
   {129, 0x2000, 0x0000}, // [13] 10-bit mode
   { 65, 0xFFFF, 0x288B}, // Configure CP biasing
   { 66, 0xFFFF, 0x53C6}, // Configure AFE biasing
   { 67, 0xFFFF, 0x0344}, // Configure MUX biasing
   { 68, 0xFFFF, 0x0085}, // Configure LVDS biasing
   { 70, 0xFFFF, 0x4888}, // Configure reserved register
   { 81, 0xFFFF, 0x86A1}, // Configure reserved register
   {128, 0xFFFF, 0x460F}, // Configure  calibration
   {176, 0xFFFF, 0x00F5}, // Configure AEC
   {180, 0xFFFF, 0x00FD}, // Configure AEC
   {181, 0xFFFF, 0x0144}, // Configure AEC
   {194, 0xFFFF, 0x0404}, // Configure sequencer
   {218, 0xFFFF, 0x160B}, // Configure sequencer
   {224, 0xFFFF, 0x3E13}, // Configure sequencer
   {391, 0xFFFF, 0x1010}, // Configure sequencer
   {456, 0xFFFF, 0x0386}  // Configure sequencer
};

#define VITA_SPI_SEQ5_QTY  7
Xuint16 vita_spi_seq5[VITA_SPI_SEQ5_QTY][3] =
{
   // Soft Power-Up
   //    V1/SN/SE 10-bit mode with PLL
   { 32, 0xFFFF, 0x2007}, // Enable analog clock distribution
   { 10, 0xFFFF, 0x0000}, // Release soft reset state
   { 64, 0xFFFF, 0x0001}, // Enable biasing block
   { 72, 0xFFFF, 0x0203}, // Enable charge pump
   { 40, 0xFFFF, 0x0003}, // Enable column multiplexer
   { 48, 0xFFFF, 0x0001}, // Enable AFE
   {112, 0xFFFF, 0x0007}  // Enable LVDS transmitters
};

//#define VITA_SPI_SEQ6_QTY  1
#define VITA_SPI_SEQ6_QTY  2
Xuint16 vita_spi_seq6[VITA_SPI_SEQ6_QTY][3] =
{
   // Enable Sequencer
// {192, 0x0001, 0x0001}  // [0] Enable Sequencer
#if defined(TRIGGERED_MASTER_MODE)
   {192, 0x0051, 0x0011}, // [0] Enable Sequencer
                          // [4] triggered_mode = on
                          // [6] xsm_delay_enable = off
   {193, 0xFF00, 0x0000}  // [15:8] xsm_delay = 0x00
#elif defined(STRETCH_VITA_HTIMING)
   {192, 0x3841, 0x3841},
// {192, 0x0041, 0x0041}, // [0] Enable Sequencer
                          // [6] xsm_delay_enable = on
   {193, 0xFF00, 0x0400}  // [15:8] xsm_delay = 0x04
#else
   {192, 0x0001, 0x0001}, // [0] Enable Sequencer
                        // [6] xsm_delay_enable = off
   {193, 0xFF00, 0x0000}  // [15:8] xsm_delay = 0x00
#endif
};

#define VITA_SPI_SEQ7_QTY  1
Xuint16 vita_spi_seq7[VITA_SPI_SEQ7_QTY][3] =
{
   // Disable Sequencer
   {192, 0x0001, 0x0000}  // [0] Disable Sequencer
};

#define VITA_SPI_SEQ8_QTY  6
Xuint16 vita_spi_seq8[VITA_SPI_SEQ8_QTY][3] =
{
   // Soft Power-Down
   {112, 0xFFFF, 0x0000},  // Disable LVDS transmitters
   { 48, 0xFFFF, 0x0000},  // Disable AFE
   { 40, 0xFFFF, 0x0000},  // Disable column multiplexer
   { 72, 0xFFFF, 0x0200},  // Disable charge pump
   { 64, 0xFFFF, 0x0000},  // Disable biasing block
   { 10, 0xFFFF, 0x0999}   // Soft Reset
};

#define VITA_SPI_SEQ9_QTY  3
Xuint16 vita_spi_seq9[VITA_SPI_SEQ9_QTY][3] =
{
   // Disable Clock Management - Part 2
   //    V1/SN/SE 10-bit mode with PLL
   { 34, 0xFFFF, 0x0000}, // Disable logic blocks
   { 32, 0xFFFF, 0x2008}, // Disable logic clock
   {  9, 0xFFFF, 0x0009}  // Soft reset clock generator
};

#define VITA_SPI_SEQA_QTY  3
Xuint16 vita_spi_seqA[VITA_SPI_SEQA_QTY][3] =
{
   // Disable Clock Management - Part 1
   { 16, 0xFFFF, 0x0000}, // Disable PLL
   {  8, 0xFFFF, 0x0099}, // Soft reset PLL
   { 20, 0xFFFF, 0x0000}  // Configure clock management
};

#define VITA_AUTOEXP_ON_QTY  1
Xuint16 vita_autoexp_on_seq[VITA_AUTOEXP_ON_QTY][3] = {
   // Auto-Exposure ON
   {160, 0x0001, 0x0001} // [4] Auto Exposure enable
   };

#define VITA_AUTOEXP_OFF_QTY  1
Xuint16 vita_autoexp_off_seq[VITA_AUTOEXP_OFF_QTY][3] = {
   // Auto-Exposure OFF
   {160, 0x0001, 0x0000} // [4] Auto Exposure enable
   };

#define VITA_IMAGE_ON_QTY  2
Xuint16 vita_image_on_seq[VITA_IMAGE_ON_QTY][3] = {
   // Black Image ON
   {219, 0xFFFF, 0x3E3E},
   {220, 0xFFFF, 0x674F}
};

#define VITA_IMAGE_OFF_QTY  2
Xuint16 vita_image_off_seq[VITA_IMAGE_OFF_QTY][3] = {
   // Black Image OFF
   {219, 0xFFFF, 0x3E2E},
   {220, 0xFFFF, 0x6767}
};

#define VITA_GRAYIMAGE_ON_QTY  14
Xuint16 vita_grayimage_on1_seq[VITA_GRAYIMAGE_ON_QTY][3] = {
   // Gray Image ON (for vita_refclk in 55-62MHz range)
   {219, 0xFFFF, 0x3E2D},
   {220, 0xFFFF, 0x674F},
   {429, 0xFFFF, 0x0100},
   {430, 0xFFFF, 0x1BF1},
   {431, 0xFFFF, 0x1BC3},
   {432, 0xFFFF, 0x1BC2},
   {435, 0xFFFF, 0x2142},
   {436, 0xFFFF, 0x2142},
   {463, 0xFFFF, 0x0100},
   {464, 0xFFFF, 0x0FE4},
   {465, 0xFFFF, 0x0BC2},
   {472, 0xFFFF, 0x0B46},
   {475, 0xFFFF, 0x2142},
   {476, 0xFFFF, 0x2142}
};
Xuint16 vita_grayimage_on2_seq[VITA_GRAYIMAGE_ON_QTY][3] = {
   // Gray Image ON (for vita_refclk in 45-55MHz range)
   {219, 0xFFFF, 0x3E2D},
   {220, 0xFFFF, 0x674F},
   {429, 0xFFFF, 0x0100},
   {430, 0xFFFF, 0x1BF1},
   {431, 0xFFFF, 0x1BC3},
   {432, 0xFFFF, 0x1BC2},
   {435, 0xFFFF, 0x2141},
   {436, 0xFFFF, 0x2142},
   {463, 0xFFFF, 0x0100},
   {464, 0xFFFF, 0x0FE4},
   {465, 0xFFFF, 0x0BC2},
   {472, 0xFFFF, 0x0B46},
   {475, 0xFFFF, 0x2141},
   {476, 0xFFFF, 0x2141}
};
Xuint16 vita_grayimage_on3_seq[VITA_GRAYIMAGE_ON_QTY][3] = {
   // Gray Image ON (for vita_refclk in 30-45MHz range)
   {219, 0xFFFF, 0x3E2D},
   {220, 0xFFFF, 0x674F},
   {429, 0xFFFF, 0x0100},
   {430, 0xFFFF, 0x1BF1},
   {431, 0xFFFF, 0x1BC3},
   {432, 0xFFFF, 0x1BC2},
   {435, 0xFFFF, 0x2141},
   {436, 0xFFFF, 0x2141},
   {463, 0xFFFF, 0x0100},
   {464, 0xFFFF, 0x0FE4},
   {465, 0xFFFF, 0x0BC2},
   {472, 0xFFFF, 0x0B46},
   {475, 0xFFFF, 0x2141},
   {476, 0xFFFF, 0x2141}
};

#define VITA_GRAYIMAGE_OFF_QTY  14
Xuint16 vita_grayimage_off_seq[VITA_GRAYIMAGE_OFF_QTY][3] = {
   // Gray Image OFF
   {219, 0xFFFF, 0x3E2E},
   {220, 0xFFFF, 0x6750},
   {429, 0xFFFF, 0x7150},
   {430, 0xFFFF, 0x0100},
   {431, 0xFFFF, 0x03F1},
   {432, 0xFFFF, 0x03C5},
   {435, 0xFFFF, 0x214F},
   {436, 0xFFFF, 0x2145},
   {463, 0xFFFF, 0x0000},
   {464, 0xFFFF, 0x0100},
   {465, 0xFFFF, 0x0BE6},
   {472, 0xFFFF, 0x1346},
   {475, 0xFFFF, 0x214F},
   {476, 0xFFFF, 0x2145}
};

#define VITA_GLOBAL_RESET_ON_QTY  14
Xuint16 vita_global_reset_on_seq[VITA_GLOBAL_RESET_ON_QTY][3] = {
   // Global Reset
   // reference : App Note AND9049/D
   {384, 0xFFFF, 0x1010}, // reserved
   {385, 0xFFFF, 0x729F}, // reserved
   {386, 0xFFFF, 0x729F}, // reserved
   {387, 0xFFFF, 0x729F}, // reserved
   {388, 0xFFFF, 0x729F}, // reserved
   {389, 0xFFFF, 0x701F}, // reserved
   {390, 0xFFFF, 0x701F}, // reserved
   {391, 0xFFFF, 0x549F}, // reserved
   {392, 0xFFFF, 0x549F}, // reserved
   {393, 0xFFFF, 0x541F}, // reserved
   {394, 0xFFFF, 0x541F}, // reserved
   {395, 0xFFFF, 0x101F}, // reserved
   {396, 0xFFFF, 0x101F}, // reserved
   {397, 0xFFFF, 0x1110}  // reserved
};

#define VITA_GLOBAL_RESET_OFF_QTY  14
Xuint16 vita_global_reset_off_seq[VITA_GLOBAL_RESET_OFF_QTY][3] = {
   // Global Reset
   // reference : default values of image sensor after config
   {384, 0xFFFF, 0x1010}, // reserved
   {385, 0xFFFF, 0x729F}, // reserved
   {386, 0xFFFF, 0x729F}, // reserved
   {387, 0xFFFF, 0x729F}, // reserved
   {388, 0xFFFF, 0x729F}, // reserved
   {389, 0xFFFF, 0x701F}, // reserved
   {390, 0xFFFF, 0x701F}, // reserved
   {391, 0xFFFF, 0x549F}, // reserved
   {392, 0xFFFF, 0x549F}, // reserved
   {393, 0xFFFF, 0x541F}, // reserved
   {394, 0xFFFF, 0x541F}, // reserved
   {395, 0xFFFF, 0x101F}, // reserved
   {396, 0xFFFF, 0x101F}, // reserved
   {397, 0xFFFF, 0x1110}  // reserved
};

#define VITA_ROI0_CROP_1080P_QTY  2
Xuint16 vita_roi0_crop_1080p_seq[VITA_ROI0_CROP_1080P_QTY][3] = {
   // Crop ROI0 from 1920x1200 to 1920x1080
   //   R257[10:0] y_start = 60 (0x3C)
   //   R258[10:0] y_end   = 60+1080 = 1140 (0x474)
   {257, 0xFFFF, 0x003C},
   {258, 0xFFFF, 0x0474}
};

#define VITA_MULT_TIMER_LINE_RESOLUTION_QTY  1
Xuint16 vita_mult_timer_line_resolution_seq[VITA_MULT_TIMER_LINE_RESOLUTION_QTY][3] = {
   // R199[15:0] mult_timer = (1920+88+44+148)/4 = 2200/4 = 550 (0x0226)
   //199, 0xFFFF, 0x0226
   // R199[15:0] mult_timer = (1920+88+44+132)/4 = 2184/4 = 546 (0x0222)
   {199, 0xFFFF, 0x0222}
};

#define VITA_SPI_AGAIN_QTY  11
Xuint16 vita_spi_again_values[VITA_SPI_AGAIN_QTY][3] =
{
   {204, 0xFFFF, 0x01E2}, // 1.00 : gain_state1=0x02(1.00), gain_stage2=0xF(1.00)
   {204, 0xFFFF, 0x00E2}, // 1.14 : gain_state1=0x02(1.00), gain_stage2=0x7(1.14)
   {204, 0xFFFF, 0x0062}, // 1.33 : gain_state1=0x02(1.00), gain_stage2=0x3(1.33)
   {204, 0xFFFF, 0x00A2}, // 1.60 : gain_state1=0x02(1.00), gain_stage2=0x5(1.60)
   {204, 0xFFFF, 0x0022}, // 2.00 : gain_state1=0x02(1.00), gain_stage2=0x1(2.00)
   {204, 0xFFFF, 0x00E1}, // 2.29 : gain_state1=0x01(2.00), gain_stage2=0x7(1.14)
   {204, 0xFFFF, 0x0061}, // 2.67 : gain_state1=0x01(2.00), gain_stage2=0x3(1.33)
   {204, 0xFFFF, 0x00A1}, // 3.20 : gain_state1=0x01(2.00), gain_stage2=0x5(1.60)
   {204, 0xFFFF, 0x0021}, // 4.00 : gain_state1=0x01(2.00), gain_stage2=0x1(2.00)
   {204, 0xFFFF, 0x00C1}, // 5.33 : gain_state1=0x01(2.00), gain_stage2=0x6(2.67)
   {204, 0xFFFF, 0x0041}  // 8.00 : gain_state1=0x01(2.00), gain_stage2=0x2(4.00)
};

#define VITA_SPI_DGAIN_QTY  1
Xuint16 vita_spi_dgain_values[VITA_SPI_DGAIN_QTY][3] =
{
   {205, 0xFFFF, 0x0080}  // 1.00
};

#define VITA_SPI_EXPOSURE_QTY 1
Xuint16 vita_spi_exposure_values[VITA_SPI_EXPOSURE_QTY][3] =
{
   {201, 0xFFFF, 0x0000}  // 0
};

/******************************************************************************
* This function initializes the FMC-IMAGEON VITA Receiver.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    szName contains a string describing the new VITA instance.
* @param    uBaseAddr_SPI contains the base address of the ONSEMI_VITA_SPI pcore.
* @param    uBaseAddr_CAM contains the base address of the ONSEMI_VITA_CAM pcore.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_init( onsemi_vita_t *pContext, char szName[], Xuint32 uBaseAddr_SPI, Xuint32 uBaseAddr_CAM )
{
   Xuint32 uCoreVersion, uCoreID;
   
   pContext->uBaseAddr_SPI = uBaseAddr_SPI;
   pContext->uBaseAddr_CAM = uBaseAddr_CAM;
   strcpy( pContext->szName, szName );

   pContext->uManualTap = 25;

   pContext->uAnalogGain = 0; // 1.0
   pContext->uDigitalGain = 128; // 1.0
   pContext->uExposureTime = 90;

   // Detection of onsemi_vita_spi core
   uCoreVersion = onsemi_vita_spi_reg_read( pContext, ONSEMI_VITA_SPI_CORE_VERSION_REG );
   uCoreID      = onsemi_vita_spi_reg_read( pContext, ONSEMI_VITA_SPI_CORE_ID_REG );
   if ( uCoreID == ONSEMI_VITA_SPI_CORE_ID_VAL )
   {
      if ( ((uCoreVersion&0xFF000000)>>24) == ((ONSEMI_VITA_SPI_CORE_VERSION_VAL&0xFF000000)>>24) )
      {
         //xil_printf( "[onsemi_vita_init] Detected Compatible Version %d.%d.%d of ONSEMI_VITA_SPI core\n\r", ((uCoreVersion&0xFF000000)>>24), ((uCoreVersion&0x00FF0000)>>16), (uCoreVersion&0x0000FFFF) );
      }
      else
      {
         //xil_printf( "[onsemi_vita_init] Detected Incompatible Version %d.%d.%d of ONSEMI_VITA_SPI core\n\r", ((uCoreVersion&0xFF000000)>>24), ((uCoreVersion&0x00FF0000)>>16), (uCoreVersion&0x0000FFFF) );
         return 0;
      }
   }
   else
   {
      //xil_printf( "[onsemi_vita_init] Failed to detect ONSEMI_VITA_SPI core\n\r" );
      return 0;
   }
   
   // Detection of onsemi_vita_cam core
   uCoreVersion = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_CORE_VERSION_REG );
   uCoreID      = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_CORE_ID_REG );
   if ( uCoreID == ONSEMI_VITA_CAM_CORE_ID_VAL )
   {
      if ( ((uCoreVersion&0xFF000000)>>24) == ((ONSEMI_VITA_CAM_CORE_VERSION_VAL&0xFF000000)>>24) )
      {
         //xil_printf( "[onsemi_vita_init] Detected Compatible Version %d.%d.%d of ONSEMI_VITA_CAM core\n\r", ((uCoreVersion&0xFF000000)>>24), ((uCoreVersion&0x00FF0000)>>16), (uCoreVersion&0x0000FFFF) );
      }
      else
      {
         //xil_printf( "[onsemi_vita_init] Detected Incompatible Version %d.%d.%d of ONSEMI_VITA_CAM core\n\r", ((uCoreVersion&0xFF000000)>>24), ((uCoreVersion&0x00FF0000)>>16), (uCoreVersion&0x0000FFFF) );
         return 0;
      }
   }
   else
   {
      //xil_printf( "[onsemi_vita_init] Failed to detect ONSEMI_VITA_CAM core\n\r" );
      return 0;
   }

   return 1;
}

/******************************************************************************
* This function performs an register read transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uRegOffset contains the register offset (in bytes)
*
* @return   32 bit register value.
*
* @note     None.
*
******************************************************************************/
Xuint32 onsemi_vita_spi_reg_read( onsemi_vita_t *pContext, Xuint32 uRegOffset )
{
	Xuint32 uData;

	uData = ONSEMI_VITA_SPI_mReadSlaveReg0(pContext->uBaseAddr_SPI, uRegOffset );

	return uData;
}
Xuint32 onsemi_vita_cam_reg_read( onsemi_vita_t *pContext, Xuint32 uRegOffset )
{
	Xuint32 uData;

	uData = ONSEMI_VITA_CAM_mReadSlaveReg0(pContext->uBaseAddr_CAM, uRegOffset );

	return uData;
}

/******************************************************************************
* This function performs an register write transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uRegOffset contains the register offset (in bytes)
* @param    uData contains the 32 bit register value
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
void onsemi_vita_spi_reg_write( onsemi_vita_t *pContext, Xuint32 uRegOffset, Xuint32 uData )
{
	ONSEMI_VITA_SPI_mWriteSlaveReg0(pContext->uBaseAddr_SPI, uRegOffset, uData );
}
void onsemi_vita_cam_reg_write( onsemi_vita_t *pContext, Xuint32 uRegOffset, Xuint32 uData )
{
	ONSEMI_VITA_CAM_mWriteSlaveReg0(pContext->uBaseAddr_CAM, uRegOffset, uData );
}

/******************************************************************************
* This function resets the VITA image sensor.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uReset contains the value of the reset.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_reset( onsemi_vita_t *pContext, Xuint32 uReset )
{
	//ONSEMI_VITA_CAM_mWriteSlaveReg3(pContext->uBaseAddr_CAM, 0, uReset);
	onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_CONTROL_REG, uReset );
	
   return 1;
}

/******************************************************************************
* This function configures the SPI controller.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uTiming contains the 16 bit value to adjust the SPI timing.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_config( onsemi_vita_t *pContext, Xuint16 uTiming )
{
	//ONSEMI_VITA_SPI_mWriteSlaveReg5(pContext->uBaseAddr_SPI, 0, (Xuint32)uTiming);
	onsemi_vita_spi_reg_write( pContext, ONSEMI_VITA_SPI_TIMING_REG, (Xuint32)uTiming );

	return 1;
}

/******************************************************************************
* This function performs an SPI read transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uAddr contains the 10 bit SPI address.
* @param    pData contains a pointer to the 16 SPI data value.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_read( onsemi_vita_t *pContext, Xuint16 uAddr, Xuint16 *pData )
{
   Xuint32 uRequest;
   Xuint32 uResponse;
   Xuint32 uStatus;
   int timeout;

   // Make sure the RXFIFO is empty
   //uStatus = ONSEMI_VITA_SPI_mReadSlaveReg4(pContext->uBaseAddr_SPI, 0);
   uStatus = onsemi_vita_spi_reg_read(pContext, ONSEMI_VITA_SPI_STATUS_REG);

   //xil_printf( "[onsemi_vita_spi_read ] Status   = 0x%08X\n\r", uStatus );
   while ( !(uStatus & ONSEMI_VITA_SPI_RXFIFO_EMPTY_BIT) )
   {
     // Pop (previous) Response from RXFIFO
     //ONSEMI_VITA_SPI_mWriteSlaveReg7(pContext->uBaseAddr_SPI, 0, 0xABBAABBA );
   	 onsemi_vita_spi_reg_write( pContext, ONSEMI_VITA_SPI_RXFIFO_REG, 0xABBAABBA );

     //uStatus = ONSEMI_VITA_SPI_mReadSlaveReg4(pContext->uBaseAddr_SPI, 0);
     uStatus = onsemi_vita_spi_reg_read(pContext, ONSEMI_VITA_SPI_STATUS_REG);
     //xil_printf( "[onsemi_vita_spi_read ] Status   = 0x%08X\n\r", uStatus );
   }

   // Wait until TXFIFO is not full
   timeout = 99;
   do
   {
      //uStatus = ONSEMI_VITA_SPI_mReadSlaveReg4(pContext->uBaseAddr_SPI, 0);
      uStatus = onsemi_vita_spi_reg_read(pContext, ONSEMI_VITA_SPI_STATUS_REG);
	  //xil_printf( "[onsemi_vita_spi_read ] Status   = 0x%08X\n\r", uStatus );
   }
   while ( (uStatus & ONSEMI_VITA_SPI_TXFIFO_FULL_BIT) && (--timeout) );

   // Send Request
   uRequest = (ONSEMI_VITA_SPI_READ_BIT) | (((Xuint32)uAddr) << 16) | 0x0000;
   //xil_printf( "[onsemi_vita_spi_read ] Request  = 0x%08X\n\r", uRequest );
   //ONSEMI_VITA_SPI_mWriteSlaveReg6(pContext->uBaseAddr_SPI, 0, uRequest);
   onsemi_vita_spi_reg_write(pContext, ONSEMI_VITA_SPI_TXFIFO_REG, uRequest);
   
   if ( !timeout )
   {
	   xil_printf( "[onsemi_vita_spi_read ] Timed out waiting for !TXFIFO_FULL\n\r" );
	   return 0;
   }

   // Wait until RXFIFO is not empty
   timeout = 999;
   do
   {
      //uStatus = ONSEMI_VITA_SPI_mReadSlaveReg4(pContext->uBaseAddr_SPI, 0);
      uStatus = onsemi_vita_spi_reg_read(pContext, ONSEMI_VITA_SPI_STATUS_REG);
	  //xil_printf( "[onsemi_vita_spi_read ] Status   = 0x%08X\n\r", uStatus );
   }
   while ( (uStatus & ONSEMI_VITA_SPI_RXFIFO_EMPTY_BIT) && (--timeout) );

   if ( !timeout )
   {
	   xil_printf( "[onsemi_vita_spi_read ] Timed out waiting for !RXFIFO_EMPTY\n\r" );
	   *pData = 0x0000;
	   return 0;
   }

   // Pop Response from RXFIFO
   //ONSEMI_VITA_SPI_mWriteSlaveReg7(pContext->uBaseAddr_SPI, 0, 0xABBAABBA );
   onsemi_vita_spi_reg_write( pContext, ONSEMI_VITA_SPI_RXFIFO_REG, 0xABBAABBA );
   

   // Get Response
   //uResponse = ONSEMI_VITA_SPI_mReadSlaveReg7(pContext->uBaseAddr_SPI, 0);
   uResponse = onsemi_vita_spi_reg_read(pContext, ONSEMI_VITA_SPI_RXFIFO_REG);

   //xil_printf( "[onsemi_vita_spi_read ] Response = 0x%08X\n\r", uResponse );

   *pData = (Xuint16)(uResponse & 0x0000FFFF);

   return 1;
}

/******************************************************************************
* This function performs an SPI write transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uAddr contains the 10 bit SPI address.
* @param    uData contains the 16 bit SPI data value.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_write( onsemi_vita_t *pContext, Xuint16 uAddr, Xuint16 uData )
{
   Xuint32 uRequest;
   Xuint32 uResponse;
   Xuint32 uStatus;
   int timeout;

   // Wait until TXFIFO is not full
   timeout = 99;
   do
   {
      //uStatus = ONSEMI_VITA_SPI_mReadSlaveReg4(pContext->uBaseAddr_SPI, 0);
	  uStatus = onsemi_vita_spi_reg_read(pContext, ONSEMI_VITA_SPI_STATUS_REG);
	  //xil_printf( "[onsemi_vita_spi_write] Status   = 0x%08X\n\r", uStatus );
   }
   while ( (uStatus & ONSEMI_VITA_SPI_TXFIFO_FULL_BIT) && !(--timeout) );

   if ( !timeout )
   {
	   xil_printf( "[onsemi_vita_spi_write] Timed out waiting for !TXFIFO_FULL\n\r" );
	   return 0;
   }

   // Send Request
   uRequest = (ONSEMI_VITA_SPI_WRITE_BIT) | (((Xuint32)uAddr) << 16) | ((Xuint16)uData);
   //xil_printf( "[onsemi_vita_spi_write] Request  = 0x%08X\n\r", uRequest );
   //ONSEMI_VITA_SPI_mWriteSlaveReg6(pContext->uBaseAddr_SPI, 0, uRequest);
   onsemi_vita_spi_reg_write(pContext, ONSEMI_VITA_SPI_TXFIFO_REG, uRequest);

   return 1;
}

/******************************************************************************
* This function performs an SPI nop transaction.
*
* @param    pContext contains a pointer to the new VITA instance's context.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_nop( onsemi_vita_t *pContext )
{
   Xuint32 uRequest;
   Xuint32 uResponse;
   Xuint32 uStatus;
   int timeout;

   // Wait until TXFIFO is not full
   timeout = 99;
   do
   {
      //uStatus = ONSEMI_VITA_SPI_mReadSlaveReg4(pContext->uBaseAddr_SPI, 0);
	  uStatus = onsemi_vita_spi_reg_read(pContext, ONSEMI_VITA_SPI_STATUS_REG);
	  //xil_printf( "[onsemi_vita_spi_nop  ] Status   = 0x%08X\n\r", uStatus );
   }
   while ( (uStatus & ONSEMI_VITA_SPI_TXFIFO_FULL_BIT) && !(--timeout) );

   if ( !timeout )
   {
	   xil_printf( "[onsemi_vita_spi_nop  ] Timed out waiting for !TXFIFO_FULL\n\r" );
	   return 0;
   }

   // Send Request
   uRequest = (ONSEMI_VITA_SPI_NOP_BIT) | 0x00000000;
   //xil_printf( "[onsemi_vita_spi_nop  ] Request  = 0x%08X\n\r", uRequest );
   //ONSEMI_VITA_SPI_mWriteSlaveReg6(pContext->uBaseAddr_SPI, 0, uRequest);
   onsemi_vita_spi_reg_write(pContext, ONSEMI_VITA_SPI_TXFIFO_REG, uRequest);

   return 1;
}

/******************************************************************************
* This function performs a sequence of SPI write transactions.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    pConfig contains a sequence of address/mask/value sets.
* @param    uLength contains the number of address/mask/value sets in sequence.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_write_sequence( onsemi_vita_t *pContext, Xuint16 pConfig[][3], Xuint32 uLength )
{
   Xuint16 uData;
   int i;
   int j;

   for ( i = 0; i < uLength; i++ )
   {
      if ( pConfig[i][1] == 0xFFFF )
	  {
         uData = pConfig[i][2];
	  }
	  else
	  {
         onsemi_vita_spi_read( pContext, pConfig[i][0], &uData );
         //xil_printf( "\tVITA_SPI[0x%04X] => 0x%04X\n\r", pConfig[i][0], uData );
		 uData &= ~pConfig[i][1];
         uData |=  pConfig[i][2];
	  }
      onsemi_vita_spi_write( pContext, pConfig[i][0], uData );
      //xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", pConfig[i][0], uData );

	  // Insert NOPs between transactions to respect following requirement:
	  //    "bursts of SPI commands can be issued by leaving at least two SPI clock periods between two register uploads"
	  //for ( j = 0; j < 10; j++ )
	  //{
	  //   onsemi_vita_spi_nop( pContext );
	  //}

      usleep(100); // 100 usec
   }

   return 1;
}

/******************************************************************************
* This function performs a sequence of SPI write transactions.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    pConfig contains a sequence of address/mask/value sets.
* @param    uLength contains the number of address/mask/value sets in sequence.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_spi_display_sequence( onsemi_vita_t *pContext, Xuint16 pConfig[][3], Xuint32 uLength )
{
   Xuint16 uData;
   int i;
   int j;

   for ( i = 0; i < uLength; i++ )
   {
      if ( pConfig[i][1] == 0xFFFF )
     {
         uData = pConfig[i][2];
     }
     else
     {
         onsemi_vita_spi_read( pContext, pConfig[i][0], &uData );
         xil_printf( "\tVITA_SPI[0x%04X] => 0x%04X\n\r", pConfig[i][0], uData );
         uData &= ~pConfig[i][1];
         xil_printf( "\t                    0x%04X\n\r", pConfig[i][1] );
         uData |=  pConfig[i][2];
     }
      //onsemi_vita_spi_write( pContext, pConfig[i][0], uData );

      xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", pConfig[i][0], uData );

   }

   return 1;
}


/******************************************************************************
* This function performs VITA initialization sequences.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    initId identifies which portion of the initialization is to be performed.
*              The initialization sequences correspond to the VITA datasheet
*
*              - SENSOR_INIT_SEQ00 => Assert/Deassert RESET_N pin
*              - SENSOR_INIT_SEQ01 => Enable Clock Management - Part 1
*              - SENSOR_INIT_SEQ02 => Verify PLL Lock Indicator
*              - SENSOR_INIT_SEQ03 => Enable Clock Management - Part 2
*              - SENSOR_INIT_SEQ04 => Required Register Upload
*              - SENSOR_INIT_SEQ05 => Soft Power-Up
*              - SENSOR_INIT_SEQ06 => Enable Sequencer
*
*              - SENSOR_INIT_SEQ07 => Disable Sequencer
*              - SENSOR_INIT_SEQ08 => Soft Power-Down
*              - SENSOR_INIT_SEQ09 => Disable Clock Management - Part 2
*              - SENSOR_INIT_SEQ10 => Disable Clock Management - Part 1
*
*              - SENSOR_INIT_ENABLE  => perform SEQ00 to SEQ06
*              - SENSOR_INIT_DISABLE => perform SEQ06 to SEQ10
*
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_sensor_initialize(  onsemi_vita_t *pContext, int initID, int bVerbose )
{
  int i;
   Xuint16 uAddr;
   Xuint16 uData;
   Xuint32 uStatus;
   Xuint32 uControl;
   int timeout;


   if ( (initID == SENSOR_INIT_SEQ00) || (initID == SENSOR_INIT_ENABLE) )
   {
      // Configure Sync Generator
      {
         Xuint32 h_active;
         Xuint32 h_fporch;
         Xuint32 h_syncpol;
         Xuint32 h_syncwidth;
         Xuint32 h_bporch;
         Xuint32 v_active;
         Xuint32 v_fporch;
         Xuint32 v_syncpol;
         Xuint32 v_syncwidth;
         Xuint32 v_bporch;

         //   vav,  vfp,  vsw,  vbp,  vsp,  hav,  hfp,  hsw,  hbp,  hsp
         //{ 1080,    4,    5,   36,    1, 1920,   88,   44,  148,    1 }, // VIDEO_RESOLUTION_1080P

         h_active    = 1920;
         h_fporch    =   88;
         h_syncwidth =   44;
	   #if defined(STRETCH_VITA_HTIMING)
         h_bporch    =  148;
	   #else
         h_bporch    =  132;
	   #endif
         h_syncpol   =    1;

         //v_active    = 1080;
         v_active    = 1080+1;
         v_fporch    =    4;
         v_syncwidth =    5;
         //v_bporch    =   36;
         v_bporch    =  300;
         v_syncpol   =    1;

         if ( bVerbose )
         {
        	 xil_printf( "VITA SYNCGEN - Setting Video Timing\n\r" );
        	 xil_printf( "\tHSYNC Timing     = hav=%04d, hfp,=%02d, hsw=%02d (hsp=%d), hbp=%03d (x4)\n\r",
               h_active, h_fporch, h_syncwidth, h_syncpol, h_bporch);
        	 xil_printf( "\tVSYNC Timing     = hav=%04d, hfp,=%02d, hsw=%02d (hsp=%d), hbp=%03d (x4)\n\r",
               v_active, v_fporch, v_syncwidth, v_syncpol, v_bporch);
         }

         // Horizontal settings
         onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_SYNCGEN_DELAY_REG,
        		                   ((1920+88+44+148)>>2)*6 ); // approx. 6 lines of delay
         onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_SYNCGEN_HTIMING1_REG,
                                  (h_active)<<0 | (h_fporch)<<16 );
         onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_SYNCGEN_HTIMING2_REG,
             (h_syncpol)<<15 | (h_syncwidth)<<0 | (h_bporch)<<16 );
         // Vertical settings
         onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_SYNCGEN_VTIMING1_REG,
                                 (v_active )<<0 | (v_fporch)<<16 );
         onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_SYNCGEN_VTIMING2_REG,
             (v_syncpol)<<15 | (v_syncwidth)<<0 | (v_bporch)<<16 );
      }

      if ( bVerbose ) xil_printf( "VITA ISERDES - Setting Training Sequence to 0x000003A6\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_ISERDES_TRAINING_REG, 0x000003A6);

      if ( bVerbose ) xil_printf( "VITA ISERDES - Setting Manual Tap to 0x%08X\n\r", pContext->uManualTap );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_ISERDES_MANUAL_TAP_REG, pContext->uManualTap);

      if ( bVerbose ) xil_printf( "VITA DECODER - Configuring Sync Codes\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_DECODER_STARTODDEVEN_REG, 0x00000000 );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_DECODER_CODES_LS_LE_REG , (0x00AA) | (0x012A << 16) );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_DECODER_CODES_FS_FE_REG , (0x02AA) | (0x032A << 16) );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_DECODER_CODES_BL_IMG_REG, (0x0015) | (0x0035 << 16) );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_DECODER_CODES_TR_CRC_REG, (0x03A6) | (0x0059 << 16) );

      if ( bVerbose ) xil_printf( "VITA REMAPPER - Configuring for image lines in normal mode\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_REMAPPER_CONTROL_REG, 0x00000001 );
      uControl = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_REMAPPER_CONTROL_REG );
      if ( bVerbose ) xil_printf( "VITA REMAPPER - Control = 0x%08X\n\r", uControl );

      if ( bVerbose ) xil_printf( "VITA ISERDES - Asserting Reset\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_ISERDES_CONTROL_REG, ONSEMI_VITA_CAM_ISERDES_RESET_BIT );
      if ( bVerbose ) xil_printf( "VITA DECODER - Asserting Reset\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_DECODER_CONTROL_REG, ONSEMI_VITA_CAM_DECODER_RESET_BIT );
      if ( bVerbose ) xil_printf( "VITA CRC - Asserting Reset\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_CRC_CONTROL_REG, ONSEMI_VITA_CAM_CRC_INITVALUE_BIT | ONSEMI_VITA_CAM_CRC_RESET_BIT );

      usleep(10); // 10 usec

      if ( bVerbose ) xil_printf("VITA SPI Sequence 0 - Assert RESET_N pin\n\r" );
      onsemi_vita_reset( pContext, ONSEMI_VITA_CAM_VITA_RESET_BIT );

      usleep(10); // 10 usec

      if ( bVerbose ) xil_printf( "VITA ISERDES - Releasing Reset\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_ISERDES_CONTROL_REG, 0x00000000 );
      if ( bVerbose ) xil_printf( "VITA DECODER - Releasing Reset\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_DECODER_CONTROL_REG, 0x00000000 );
      if ( bVerbose ) xil_printf( "VITA CRC - Releasing Reset\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_CRC_CONTROL_REG, ONSEMI_VITA_CAM_CRC_INITVALUE_BIT );

      sleep(1); // 1 sec (time to get clocks to lock)

      if ( bVerbose ) xil_printf("VITA SPI Sequence 0 - Releasing RESET_N pin\n\r" );
      onsemi_vita_reset( pContext, 0 );

      usleep(20); // 20 usec

      uAddr = 0;
      onsemi_vita_spi_read( pContext, uAddr, &uData );
      if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] => 0x%04X\n\r", uAddr, uData );
	  if ( bVerbose )
	  {
         switch ( uData )
		 {
		 case 0x0000:
			 xil_printf( "\tVITA Sensor absent\n\r" );
			 break;
		 case 0x560D:
			 xil_printf( "\tVITA-1300 Sensor detected\n\r" );
			 break;
		 case 0x5614:
			 xil_printf( "\tVITA-2000 Sensor detected\n\r" );
			 break;
		 case 0x5632:
			 xil_printf( "\tVITA-5000 Sensor detected\n\r" );
			 break;
		 case 0x56FA:
			 xil_printf( "\tVITA-25K Sensor detected\n\r" );
			 break;
		 default:
			 xil_printf( "\tERROR: Unknown CHIP_ID !!!\n\r" );
			 break;
		 }
	  }
      if ( uData != 0x5614 )
      {
         if ( bVerbose ) xil_printf( "\tERROR: Absent or unsupported VITA sensor !!!\n\r" );
         return 0;
      }
   }

   if ( (initID == SENSOR_INIT_SEQ01) || (initID == SENSOR_INIT_ENABLE) )
   {
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 1 - Enable Clock Management - Part 1\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seq1, VITA_SPI_SEQ1_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seq1, VITA_SPI_SEQ1_QTY );
   }

   if ( (initID == SENSOR_INIT_SEQ02) || (initID == SENSOR_INIT_ENABLE) )
   {
      Xuint16 uLock = 0;

      if ( bVerbose ) xil_printf("VITA SPI Sequence 2 - Verify PLL Lock Indicator\n\r" );
      uAddr = 24;

      timeout = 10;
      while ( !(uLock) && --timeout  )
      {
         millisleep(100);
         onsemi_vita_spi_read( pContext, uAddr, &uLock );
         if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] => 0x%04X\n\r", uAddr, uLock );
      }
      if ( !timeout )
      {
		  if ( bVerbose ) xil_printf( "\tERROR: Timed Out while waiting for PLL lock to assert !!!\n\r" );
         return 0;
      }
   }

   if ( (initID == SENSOR_INIT_SEQ03) || (initID == SENSOR_INIT_ENABLE) )
   {
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 3 - Enable Clock Management - Part 2\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seq3, VITA_SPI_SEQ3_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seq3, VITA_SPI_SEQ3_QTY );
   }

   if ( (initID == SENSOR_INIT_SEQ04) || (initID == SENSOR_INIT_ENABLE) )
   {
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 4 - Required Register Upload\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seq4, VITA_SPI_SEQ4_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seq4, VITA_SPI_SEQ4_QTY );
   }

   if ( (initID == SENSOR_INIT_SEQ05) || (initID == SENSOR_INIT_ENABLE) )
   {
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 5 - Soft Power-Up\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seq5, VITA_SPI_SEQ5_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seq5, VITA_SPI_SEQ5_QTY );
      //
      uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
      if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );

      uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
      if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );

      if ( bVerbose ) xil_printf( "VITA ISERDES - Waiting for CLK_RDY to assert\n\r");
      uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
      if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );
      timeout = 9;
      while ( !(uStatus & 0x00000100) && --timeout  )
      {
	     uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
         if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );
         usleep(1);
      }
      if ( !timeout )
      {
         if ( bVerbose ) xil_printf( "\tTimed Out !!!\n\r" );
         return 0;
      }

      if ( bVerbose ) xil_printf( "VITA ISERDES - Align Start\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_ISERDES_CONTROL_REG, ONSEMI_VITA_CAM_ISERDES_ALIGN_START_BIT );

      if ( bVerbose ) xil_printf( "VITA ISERDES - Waiting for ALIGN_BUSY to assert\n\r");
      uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
      if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );
      timeout = 9;
      while ( !(uStatus & 0x00000200) && --timeout  )
      {
         uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
         if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );
         usleep(1);
      }
      if ( !timeout )
      {
         if ( bVerbose ) xil_printf( "\tTimed Out !!!\n\r" );
         return 0;
      }

      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_ISERDES_CONTROL_REG, 0x00000000);

      if ( bVerbose ) xil_printf( "VITA ISERDES - Waiting for ALIGN_BUSY to de-assert\n\r");
      uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
      if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );
      timeout = 9;
      while ( (uStatus & 0x00000200) && --timeout )
      {
         uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
         if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );
         usleep(1);
      }
      if ( !timeout )
      {
         if ( bVerbose ) xil_printf( "\tTimed Out !!!\n\r" );
      }

      uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_ISERDES_STATUS_REG );
      if ( bVerbose ) xil_printf( "VITA ISERDES - Status = 0x%08X\n\r", uStatus );

   }

   if ( (initID == SENSOR_INIT_SEQ06) || (initID == SENSOR_INIT_ENABLE) )
   {
#if 1
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence   - Crop ROI0 to 1920x1080\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_roi0_crop_1080p_seq, VITA_ROI0_CROP_1080P_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_roi0_crop_1080p_seq, VITA_ROI0_CROP_1080P_QTY );
      //
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence   - Set mult_timer to line resolution\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_mult_timer_line_resolution_seq, VITA_MULT_TIMER_LINE_RESOLUTION_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_mult_timer_line_resolution_seq, VITA_MULT_TIMER_LINE_RESOLUTION_QTY );
      //
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence   - Set auto-exposure to ON\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_autoexp_on_seq, VITA_AUTOEXP_ON_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_autoexp_on_seq, VITA_AUTOEXP_ON_QTY );
#endif

      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 6 - Enable Sequencer\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seq6, VITA_SPI_SEQ6_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seq6, VITA_SPI_SEQ6_QTY );

      if ( bVerbose ) xil_printf( "VITA ISERDES - Enabling FIFO enable\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_ISERDES_CONTROL_REG, ONSEMI_VITA_CAM_ISERDES_FIFO_ENABLE_BIT );
      if ( bVerbose ) xil_printf( "VITA DECODER - Enabling Sync Channel Decoder\n\r" );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_DECODER_CONTROL_REG,ONSEMI_VITA_CAM_DECODER_ENABLE_BIT );
      uControl = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CONTROL_REG );
      if ( bVerbose ) xil_printf( "VITA DECODER - Control = 0x%08X\n\r", uControl );

      uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_CRC_STATUS_REG );
      if ( bVerbose ) xil_printf( "VITA CRC - Status = 0x%08X\n\r", uStatus );

      usleep(100);
      uStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_CRC_STATUS_REG );
      if ( bVerbose ) xil_printf( "VITA CRC - Status = 0x%08X\n\r", uStatus );
   }

   if ( (initID == SENSOR_INIT_SEQ07) || (initID == SENSOR_INIT_DISABLE) )
   {
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 7 - Disable Sequencer\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seq7, VITA_SPI_SEQ7_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seq7, VITA_SPI_SEQ7_QTY );
   }

   if ( (initID == SENSOR_INIT_SEQ08) || (initID == SENSOR_INIT_DISABLE) )
   {
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 8 - Soft Power-Down\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seq8, VITA_SPI_SEQ8_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seq8, VITA_SPI_SEQ8_QTY );
   }

   if ( (initID == SENSOR_INIT_SEQ09) || (initID == SENSOR_INIT_DISABLE) )
   {
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 9 - Disable Clock Management - Part 2\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seq9, VITA_SPI_SEQ9_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seq9, VITA_SPI_SEQ9_QTY );

   }

   if ( (initID == SENSOR_INIT_SEQ10) || (initID == SENSOR_INIT_DISABLE) )
   {
      if ( bVerbose )
      {
         xil_printf("VITA SPI Sequence 10 - Disable Clock Management - Part 1\n\r" );
         onsemi_vita_spi_display_sequence( pContext, vita_spi_seqA, VITA_SPI_SEQA_QTY );
      }
      onsemi_vita_spi_write_sequence( pContext, vita_spi_seqA, VITA_SPI_SEQA_QTY );
   }


   return 1;
}

/******************************************************************************
* This function returns the status of the VITA receiver.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    pStatus contains a pointer to the VITA's status.
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_get_status( onsemi_vita_t *pContext, onsemi_vita_status_t *pStatus, int bVerbose )
{

   pStatus->cntBlackLines  = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_BLACK_LINES_REG );
   pStatus->cntImageLines  = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_IMAGE_LINES_REG );
   pStatus->cntBlackPixels = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_BLACK_PIXELS_REG );
   pStatus->cntImagePixels = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_IMAGE_PIXELS_REG );
   pStatus->cntFrames      = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_FRAMES_REG );
   pStatus->cntWindows     = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_WINDOWS_REG );
   pStatus->cntStartLines  = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_START_LINES_REG );
   pStatus->cntEndLines    = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_END_LINES_REG );
   pStatus->cntClocks      = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_DECODER_CNT_CLOCKS_REG );

   if ( bVerbose )
   {
      xil_printf( "VITA DECODER - Reading Statistics\n\r" );
      xil_printf( "\tBlack Lines  = %d\n\r", pStatus->cntBlackLines );
      xil_printf( "\tImage Lines  = %d\n\r", pStatus->cntImageLines );
      xil_printf( "\tBlack Pixels = %d\n\r", pStatus->cntBlackPixels*4 );
      xil_printf( "\tImage Pixels = %d\n\r", pStatus->cntImagePixels*4 );
      xil_printf( "\tFrames       = %d\n\r", pStatus->cntFrames );
      xil_printf( "\tWindows      = %d\n\r", pStatus->cntWindows );
      xil_printf( "\tStart Lines  = %d\n\r", pStatus->cntStartLines );
      xil_printf( "\tEnd Lines    = %d\n\r", pStatus->cntEndLines );
      xil_printf( "\t(End-Start)  = %d\n\r", pStatus->cntEndLines - pStatus->cntStartLines );

      xil_printf( "\tClocks       = %d\n\r", pStatus->cntClocks );
   }

   pStatus->crcStatus = onsemi_vita_cam_reg_read( pContext, ONSEMI_VITA_CAM_CRC_STATUS_REG );
   if ( bVerbose )
   {
      xil_printf( "VITA CRC - Status = 0x%08X\n\r", pStatus->crcStatus );
   }

   return 0;
}

/******************************************************************************
* This function configures the VITA-2000 to generate 1080P60 timing.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_sensor_1080P60( onsemi_vita_t *pContext, int bVerbose )
{
   Xuint16 vspi_data;

//# Disable sequencer
//vspi write 192 0x0000
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Disable Sequencer\n\r");
   onsemi_vita_spi_write( pContext, 192, 0x0000 );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 192, 0x0000 );
   usleep(100); // 100 usec


//# Adjust line spacing in VITA
//#   R193[15:8] xsm_delay = 0x04
//#   R192[4] xsm_enable = 1
//vspi rmw 193 0x0400 0x0400
//vspi rmw 192 0x0040 0x0040
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Adjust line spacing in VITA\n\r");
   onsemi_vita_spi_write( pContext, 193, 0x0400 );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 193, 0x0400 );
   usleep(100); // 100 usec
   onsemi_vita_spi_write( pContext, 192, 0x0040 );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 192, 0x0040 );
   usleep(100); // 100 usec

//# Tolerate 6 lines of jitter (required for programmable exposure)
//#   VREG-0x5C[15: 0] DELAY      = ((1920+88+44+128)/4) * 6 = 3300 (0x0CE4)
//vreg write 0x5C 0x00000CE4
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Tolerate 6 lines of jitter (required for programmable exposure)\n\r");
   onsemi_vita_cam_reg_write( pContext, 0x5C, 0x00000CE4 );
   if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", 0x5C, 0x00000CE4 );

//# Adjust line spacing in sync generator
//#   VREG-0x60[15: 0] HACTIVE    = 1920  (0x0780)
//#   VREG-0x60[31:16] HFPORCH    =   88  (0x0058)
//#   VREG-0x64[14: 0] HSYNCWIDTH =   44  (0x002C)
//#   VREG-0x64[   15] HSYNCPOL   =    1
//#   VREG-0x64[30:16] HBPORCH    =  148  (0x0094)
//vreg write 0x60 0x00580780
//vreg write 0x64 0x0094802C
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Adjust line spacing in sync generator\n\r");
   onsemi_vita_cam_reg_write( pContext, 0x60, 0x00580780 );
   if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", 0x60, 0x00580780 );
   onsemi_vita_cam_reg_write( pContext, 0x64, 0x0094802C );
   if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", 0x64, 0x0094802C );

//# Adjust frame spacing in VITA
//#   R199[15:0] mult_time = 1
//#   R200[15:0] fr_length = 0
//#   R194[   2] fr_mode   = 0 (frame length)
//vspi write 199 0x0001
//vspi write 200 0x0000
//vspi rmw   194 0x0000 0x0000
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Adjust frame spacing in VITA\n\r");
   onsemi_vita_spi_write( pContext, 199, 0x0001 );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 199, 0x0001 );
   usleep(100); // 100 usec
   onsemi_vita_spi_write( pContext, 200, 0x0000 );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 200, 0x0000 );
   usleep(100); // 100 usec
   onsemi_vita_spi_write( pContext, 194, 0x0000 );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 194, 0x0000 );
   usleep(100); // 100 usec

#if 1
   //# Adjust frame spacing in sync generator
   //#   VREG-0x68[15: 0] VACTIVE    = 1080   (0x0438)
   //#   VREG-0x68[31:16] VFPORCH    =    4   (0x0004)
   //#   VREG-0x6C[14: 0] VSYNCWIDTH =    5   (0x0005)
   //#   VREG-0x6C[   15] VSYNCPOL   =    1
   //#   VREG-0x6C[30:16] VBPORCH    =   36   (0x0024)
   //vreg write 0x68 0x00040438
   //vreg write 0x6C 0x00248005
      if ( bVerbose ) xil_printf( "VITA 1080P60 - Adjust frame spacing in sync generator\n\r");
      onsemi_vita_cam_reg_write( pContext, 0x68, 0x00040438 );
      if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", 0x68, 0x00040438 );
      onsemi_vita_cam_reg_write( pContext, 0x6C, 0x00248005 );
      if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", 0x6C, 0x00248005 );
#else
//# Adjust frame spacing in sync generator
//#   VREG-0x68[15: 0] VACTIVE    = 1080+1 (0x0439)
//#   VREG-0x68[31:16] VFPORCH    =    4   (0x0004)
//#   VREG-0x6C[14: 0] VSYNCWIDTH =    5   (0x0005)
//#   VREG-0x6C[   15] VSYNCPOL   =    1
//#   VREG-0x6C[30:16] VBPORCH    =   36   (0x0024)
//vreg write 0x68 0x00040439
//vreg write 0x6C 0x00248005
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Adjust frame spacing in sync generator\n\r");
   onsemi_vita_cam_reg_write( pContext, 0x68, 0x00040439 );
   if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", 0x68, 0x00040439 );
   onsemi_vita_cam_reg_write( pContext, 0x6C, 0x00248005 );
   if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", 0x6C, 0x00248005 );
#endif

//# Crop ROI0 from 1920x1200 to 1920x1080
//#   R257[10:0] y_start = 60 (0x3C)
//#   R258[10:0] y_end   = 60+1080 = 1140 (0x474)
//vspi write 257 0x003C
//vspi write 258 0x0474
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Crop ROI0 from 1920x1200 to 1920x1080\n\r");
   onsemi_vita_spi_write( pContext, 257, 0x003C );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 257, 0x003C );
   usleep(100); // 100 usec
   onsemi_vita_spi_write( pContext, 258, 0x0474 );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 258, 0x0474 );
   usleep(100); // 100 usec

//# disable auto exposure
//vspi write 160 0x0010
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Disable auto-exposure\n\r");
   onsemi_vita_spi_write( pContext, 160, 0x0010 );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 160, 0x0010 );
   usleep(100); // 100 usec

//# Enable trig generator
//trig internal 60 10
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Enable trig generator\n\r");
   {
      Xuint32 vitaTrigGenControl;
      Xuint32 vitaTrigGenDefaultFreq;
      Xuint32 vitaTrigGenTrig0High;
      Xuint32 vitaTrigGenTrig0Low;
      Xuint32 trigFramesPerSec = 60;
      Xuint32 trigDutyCycle    = 90; // exposure time is 90% of frame time (ie. 15msec)
      vitaTrigGenDefaultFreq = (((1920+88+44+148)*(1080+4+5+36))>>2) - 2;

      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG, vitaTrigGenDefaultFreq );
      if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG, vitaTrigGenDefaultFreq );
      //vitaTrigGenTrig0High   = (vitaTrigGenDefaultFreq * trigDutyCycle)/100; // positive polarity
      vitaTrigGenTrig0High   = (vitaTrigGenDefaultFreq * (100-trigDutyCycle))/100; // negative polarity

      vitaTrigGenTrig0Low    = 1;
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG  , vitaTrigGenTrig0High   );
      if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG  , vitaTrigGenTrig0High   );
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG   , vitaTrigGenTrig0Low    );
      if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG   , vitaTrigGenTrig0Low    );

      vitaTrigGenControl     = 0x31000011; // invert trigger[2:0], internal trigger, enable trigger[0], update triggen_cnt registers
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
      if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
      vitaTrigGenControl     = 0x30000011; // invert trigger[2:0], internal trigger, enable trigger[0]
      onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
      if ( bVerbose ) xil_printf( "\tVITA_REG[0x%04X] <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
   }

#if 0
//# Enable sequencer
//vspi rmw 192 0x0011 0x0011
   if ( bVerbose ) xil_printf( "VITA 1080P60 - Enable sequencer\n\r");
   onsemi_vita_spi_read( pContext, 192, &vspi_data );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] => 0x%04X\n\r", 192, vspi_data );
   usleep(100); // 100 usec
   vspi_data |= 0x0011;
   onsemi_vita_spi_write( pContext, 192, vspi_data );
   if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 192, vspi_data );
   usleep(100); // 100 usec
#else
  if ( bVerbose ) xil_printf( "VITA 1080P60 - Exposure related settings\n\r");
  onsemi_vita_spi_write( pContext, 194, 0x0400 );
  if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 194, 0x0400 );
  onsemi_vita_spi_write( pContext, 0x29, 0x0700 );
  if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 0x29, 0x0700 );

//# Enable sequencer
//vspi rmw 192 0x0071 0x0071
  if ( bVerbose ) xil_printf( "VITA 1080P60 - Enable sequencer\n\r");
  onsemi_vita_spi_read( pContext, 192, &vspi_data );
  if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] => 0x%04X\n\r", 192, vspi_data );
  usleep(100); // 100 usec
  vspi_data |= 0x0071;
  onsemi_vita_spi_write( pContext, 192, vspi_data );
  if ( bVerbose ) xil_printf( "\tVITA_SPI[0x%04X] <= 0x%04X\n\r", 192, vspi_data );
  usleep(100); // 100 usec
#endif

  pContext->uExposureTime = 90;

   return 1;
}

/******************************************************************************
* This function configures the VITA-2000's analog gain.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uAnalogGain contains the value of the analog gain.
*              00 => 1.00 : gain_state1=0x02(1.00), gain_stage2=0xF(1.00)
*              01 => 1.14 : gain_state1=0x02(1.00), gain_stage2=0x7(1.14)
*              02 => 1.33 : gain_state1=0x02(1.00), gain_stage2=0x3(1.33)
*              03 => 1.60 : gain_state1=0x02(1.00), gain_stage2=0x5(1.60)
*              04 => 2.00 : gain_state1=0x02(1.00), gain_stage2=0x1(2.00)
*              05 => 2.29 : gain_state1=0x01(2.00), gain_stage2=0x7(1.14)
*              06 => 2.67 : gain_state1=0x01(2.00), gain_stage2=0x3(1.33)
*              07 => 3.20 : gain_state1=0x01(2.00), gain_stage2=0x5(1.60)
*              08 => 4.00 : gain_state1=0x01(2.00), gain_stage2=0x1(2.00)
*              09 => 5.33 : gain_state1=0x01(2.00), gain_stage2=0x6(2.67)
*              10 => 8.00 : gain_state1=0x01(2.00), gain_stage2=0x2(4.00)
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_set_analog_gain( onsemi_vita_t *pContext, Xuint32 uAnalogGain, int bVerbose )
{
   int id;
   Xuint16 **seqData;
   int seqLen;

   if ( uAnalogGain > 10 )
	   uAnalogGain = 10;

   pContext->uAnalogGain = uAnalogGain;

   id = uAnalogGain;
   seqData = &(vita_spi_again_values[id][0]);
   seqLen  = 1;

   if ( bVerbose )
   {
      xil_printf( "VITA-2000 SPI Sequency - Analog Gain\n\r" );
      onsemi_vita_spi_display_sequence( pContext, seqData, seqLen );
   }
   onsemi_vita_spi_write_sequence( pContext, seqData, seqLen );

   return 0;
}

/******************************************************************************
* This function configures the VITA-2000's digital gain.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    uDigitalGain contains the value of the digital gain.
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_set_digital_gain( onsemi_vita_t *pContext, Xuint32 uDigitalGain, int bVerbose )
{
   Xuint16 **seqData;
   int seqLen;

   if ( uDigitalGain > 4095  )
	   uDigitalGain = 4095 ;

   pContext->uDigitalGain = uDigitalGain;

   vita_spi_dgain_values[0][2] = uDigitalGain;

   seqData = &(vita_spi_dgain_values[0][0]);
   seqLen  = 1;

   if ( bVerbose )
   {
	  xil_printf( "VITA-2000 SPI Sequency - Digital Gain\n\r" );
	  onsemi_vita_spi_display_sequence( pContext, seqData, seqLen );
   }
   onsemi_vita_spi_write_sequence( pContext, seqData, seqLen );

   return 0;

}

/******************************************************************************
* This function configures the VITA-2000's exposure time.
*
* @param    pContext contains a pointer to the new VITA instance's context.
* @param    analogGain contains the value of the exposure time (in usec)
* @param    bVerbose identified wether or not to display verbose information.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int onsemi_vita_set_exposure_time( onsemi_vita_t *pContext, Xuint32 exposureTime, int bVerbose )
{
   Xuint32 vitaTrigGenControl;
   Xuint32 vitaTrigGenDefaultFreq;
   Xuint32 vitaTrigGenTrig0High;
   Xuint32 vitaTrigGenTrig0Low;

   Xuint32 trigFramesPerSec = 60;
   Xuint32 trigDutyCycle    = exposureTime;
   vitaTrigGenDefaultFreq = (((1920+88+44+148)*(1080+4+5+36))>>2) - 2;
   if ( bVerbose ) xil_printf( "\tTrigger = internal (%d fps, duty cycle = %d \%, period = %d cycles)...\r\n", trigFramesPerSec, trigDutyCycle, vitaTrigGenDefaultFreq+2 );

   onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG, vitaTrigGenDefaultFreq );
   if ( bVerbose ) xil_printf( "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG, vitaTrigGenDefaultFreq );
   //vitaTrigGenTrig0High   = (vitaTrigGenDefaultFreq * trigDutyCycle)/100; // positive polarity
   vitaTrigGenTrig0High   = (vitaTrigGenDefaultFreq * (100-trigDutyCycle))/100; // negative polarity
   vitaTrigGenTrig0Low    = 1;
   onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG  , vitaTrigGenTrig0High   );
   onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG   , vitaTrigGenTrig0Low    );
   if ( bVerbose ) xil_printf( "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG, vitaTrigGenTrig0High );
   if ( bVerbose ) xil_printf( "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG , vitaTrigGenTrig0Low  );

   vitaTrigGenControl     = 0x31000011; // invert trigger[2:0], internal trigger, enable trigger[0], update triggen_cnt registers
   onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
   if ( bVerbose ) xil_printf( "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
   vitaTrigGenControl     = 0x30000011; // invert trigger[2:0], internal trigger, enable trigger[0]
   onsemi_vita_cam_reg_write( pContext, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
   if ( bVerbose ) xil_printf( "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );


   return 0;
}

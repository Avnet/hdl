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
// Module Name:         fmc_hdmi_cam.h
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

#ifndef __FMC_HDMI_CAM_H__
#define __FMC_HDMI_CAM_H__

#include <stdio.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "fmc_iic.h"

// Detailed ADV7611 I2C addresses
#define IIC_ADV7611_BASE_ADDR        0x98
#define IIC_ADV7611_CEC_ADDR         0x80
//#define IIC_ADV7611_INFOFRAME_ADDR   0x7C  => I2C Address conflict with ADV7511 (Fixed I2C Address at 0x7C)
#define IIC_ADV7611_INFOFRAME_ADDR   0x6A
#define IIC_ADV7611_DPLL_ADDR        0x4C
#define IIC_ADV7611_KSV_ADDR         0x64
#define IIC_ADV7611_EDID_ADDR        0x6C
#define IIC_ADV7611_HDMI_ADDR        0x68
#define IIC_ADV7611_CP_ADDR          0x44

// Detailed ADV7511 I2C addresses
#define IIC_ADV7511_BASE_ADDR        0x72


// FMC-HDMI-CAM I2C addresses
#define FMC_HDMI_CAM_I2C_MUX_ADDR  0x70 // 0xE0/0xE1 (PCA9546A)
#define FMC_HDMI_CAM_IO_EXP_ADDR   0x20 // 0x40/0x41 (PCA9534)
#define FMC_HDMI_CAM_VID_CLK_ADDR  0x65 // 0xCA/0xCB (CDCE913)
#define FMC_HDMI_CAM_HDMI_IN_ADDR  (IIC_ADV7611_BASE_ADDR>>1) // 0x98/0x99 (ADV7611)
#define FMC_HDMI_CAM_HDMI_OUT_ADDR (IIC_ADV7511_BASE_ADDR>>1) // 0x72/0x73 (ADV7511)
#define FMC_HDMI_CAM_DDCEDID_ADDR  0x50 // 0xA0/0xA1


struct struct_fmc_hdmi_cam_t
{
   // software library version
   Xuint32 uVersion;

   // instantiation-specific name
   char szName[32];

   // pointer to FMC-IIC instance
   fmc_iic_t *pIIC;

   // GPIO value
   Xuint32 GpioData;

   // Verblse
   Xuint32 bVerbose;
};
typedef struct struct_fmc_hdmi_cam_t fmc_hdmi_cam_t;

struct struct_fmc_hdmi_cam_video_timing_t
{
   //char *pName;
   
   // General info
   Xuint32 IsHDMI;
   Xuint32 IsEncrypted;
   Xuint32 IsInterlaced;
   Xuint32 ColorDepth;

   // Horizontal Timing
   Xuint32 HActiveVideo;
   Xuint32 HFrontPorch;
   Xuint32 HSyncWidth;
   Xuint32 HBackPorch;
   Xuint32 HSyncPolarity;

   // Vertical Timing   
   Xuint32 VActiveVideo;
   Xuint32 VFrontPorch;
   Xuint32 VSyncWidth;
   Xuint32 VBackPorch;
   Xuint32 VSyncPolarity;
};
typedef struct struct_fmc_hdmi_cam_video_timing_t fmc_hdmi_cam_video_timing_t;


int fmc_hdmi_cam_init( fmc_hdmi_cam_t *pContext, char szName[], fmc_iic_t *pIIC );

// I2C MUX Functions
void fmc_hdmi_cam_iic_mux_reset( fmc_hdmi_cam_t *pContext );
void fmc_hdmi_cam_iic_mux( fmc_hdmi_cam_t *pContext, Xuint32 MuxSelect );
// Single Mux Selections
#define FMC_HDMI_CAM_I2C_MIN               0
#define FMC_HDMI_CAM_I2C_MAX               7
#define FMC_HDMI_CAM_I2C_SELECT_DDCEDID    0
#define FMC_HDMI_CAM_I2C_SELECT_HDMI_OUT   1
#define FMC_HDMI_CAM_I2C_SELECT_HDMI_IN    2
#define FMC_HDMI_CAM_I2C_SELECT_IO_EXP     3
#define FMC_HDMI_CAM_I2C_SELECT_VID_CLK    3
#define FMC_HDMI_CAM_I2C_SELECT_CAM        4
// Multiple Mux Selections
#define FMC_HDMI_CAM_I2C_SELECT_HDMI       8 // select both HDMI_IN and HDMI_OUT

// General I2C Configuration Functions
void fmc_hdmi_cam_iic_config2( fmc_hdmi_cam_t *pContext, Xuint8 ChipAddress, 
                              Xuint8 ConfigData[][2], Xuint32 ConfigLength );
void fmc_hdmi_cam_iic_config3( fmc_hdmi_cam_t *pContext, 
                              Xuint8 ConfigData[][3], Xuint32 ConfigLength );

// Video Clock Synthesizer Functions
void fmc_hdmi_cam_vclk_init( fmc_hdmi_cam_t *pContext );
void fmc_hdmi_cam_vclk_config( fmc_hdmi_cam_t *pContext, Xuint32 FreqId );
#define FMC_HDMI_CAM_VCLK_FREQ_25_175_000       0
#define FMC_HDMI_CAM_VCLK_FREQ_27_000_000       1
#define FMC_HDMI_CAM_VCLK_FREQ_40_000_000       2
#define FMC_HDMI_CAM_VCLK_FREQ_65_000_000       3
#define FMC_HDMI_CAM_VCLK_FREQ_74_250_000       4
#define FMC_HDMI_CAM_VCLK_FREQ_110_000_000      5
#define FMC_HDMI_CAM_VCLK_FREQ_148_500_000      6
#define FMC_HDMI_CAM_VCLK_FREQ_162_000_000      7

// HDMI Input Functions
int fmc_hdmi_cam_hdmii_init( fmc_hdmi_cam_t *pContext, Xuint32 Enable, Xuint32 edidInit, Xuint8 pEdid[256] );
int fmc_hdmi_cam_hdmii_init2( fmc_hdmi_cam_t *pContext, Xuint32 Enable, Xuint32 edidInit, Xuint8 pEdid[256], Xuint32 llc_polarity, Xuint32 llc_delay );
int fmc_hdmi_cam_hdmii_set_hpd( fmc_hdmi_cam_t *pContext, Xuint32 HotPlugStatus );
int fmc_hdmi_cam_hdmii_set_rst( fmc_hdmi_cam_t *pContext, Xuint32 Reset );
int fmc_hdmi_cam_hdmii_get_int( fmc_hdmi_cam_t *pContext, Xuint32 *pIntStatus );
int fmc_hdmi_cam_hdmii_get_lock( fmc_hdmi_cam_t *pContext );
int fmc_hdmi_cam_hdmii_get_timing( fmc_hdmi_cam_t *pContext, fmc_hdmi_cam_video_timing_t *pTiming );

// HDMI Output Functions
int fmc_hdmi_cam_hdmio_init( fmc_hdmi_cam_t *pContext, Xuint32 Enable, fmc_hdmi_cam_video_timing_t *pTiming, Xuint32 WaitForHPD );
int fmc_hdmi_cam_hdmio_set_pd( fmc_hdmi_cam_t *pContext, Xuint32 PowerDown );
int fmc_hdmi_cam_hdmio_get_hpd( fmc_hdmi_cam_t *pContext, Xuint32 *pHotPlugDetect );

// DDC/EDID Functions
int fmc_hdmi_cam_hdmii_read_edid( fmc_hdmi_cam_t *pContext, Xuint8 data[256] );
int fmc_hdmi_cam_hdmii_write_edid( fmc_hdmi_cam_t *pContext, Xuint8 data[256] );
int fmc_hdmi_cam_hdmio_read_edid( fmc_hdmi_cam_t *pContext, Xuint8 data[256] );

// Delay Functions
void fmc_hdmi_cam_wait_usec(unsigned int delay);

#endif // __FMC_HDMI_CAM_H__

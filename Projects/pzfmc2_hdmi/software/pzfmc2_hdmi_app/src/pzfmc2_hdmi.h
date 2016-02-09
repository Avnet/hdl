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
//                     Copyright(c) 2016 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------
//
// Create Date:         Jan 07, 2016
// Design Name:         PicoZed FMC Carrier V2
// Module Name:         pzfmc2_hdmi.h
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

#ifndef __PZFMC2_HDMI_H__
#define __PZFMC2_HDMI_H__

#include <stdio.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "fmc_iic.h"

// Detailed ADV7511 I2C addresses
#define IIC_ADV7511_BASE_ADDR1        0x72
#define IIC_ADV7511_BASE_ADDR2        0x7A

struct struct_pzfmc2_video_timing_t
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
typedef struct struct_pzfmc2_video_timing_t pzfmc2_video_timing_t;

// General I2C Configuration Functions
void pzfmc2_iic_config2( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 ConfigData[][2], Xuint32 ConfigLength );
void pzfmc2_iic_config3( fmc_iic_t *pIIC, Xuint8 ConfigData[][3], Xuint32 ConfigLength );

// HDMI Output Functions
int pzfmc2_hdmio_init( fmc_iic_t *pIIC, Xuint32 Enable, pzfmc2_video_timing_t *pTiming, Xuint32 WaitForHPD );
int pzfmc2_hdmio_set_pd( fmc_iic_t *pIIC, Xuint32 PowerDown );
int pzfmc2_hdmio_get_hpd( Xuint32 *pHotPlugDetect );

int pzfmc2_hdmio_set_clk_delay( Xuint8 clk_delay );

#endif // __PZFMC2_HDMI_H__

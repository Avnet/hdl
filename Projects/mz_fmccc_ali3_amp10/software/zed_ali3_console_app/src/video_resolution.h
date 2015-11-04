//----------------------------------------------------------------------------
//      _____
//     *     *
//    *____   *____
//   * *===*   *==*
//  *___*===*___**  AVNET
//       *======*
//        *====*
//----------------------------------------------------------------------------
//
// This design is the property of Avnet.  Publication of this
// design is not authorized without written consent from Avnet.
// 
//  Please direct any questions or issues to the MicroZed Community Forums:
//     http://www.microzed.org
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
//----------------------------------------------------------------------------
//
// Create Date:         Mar 05, 2010
// Design Name:         Video Resolution utility
// Module Name:         video_resolution.h
// Project Name:        FMC-IMAGEON
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        FMC-IMAGEON
//
// Tool versions:       ISE 14.5
//
// Description:         IVK Video Resolution
//                      - video timing definitions
//                      - video resolution detection
//
// Dependencies:        
//
// Revision:            Mar 05, 2010: 1.00 Initial version for S6-IVK
//                      Dec 03, 2011: 1.01 Reuse for FMC-IMAGEON
//                      Nov 01, 2012: 1.02 Add 576P resolution
//                      Mar 06, 2013: 1.03 Add WVGA resolution
//                                         Add Clock Frequency
//                      May 23, 2013: 1.04 Updated for Zed Display Kit
//                      Oct 30, 2015: 1.05 Add WXGA resolution 
//
//----------------------------------------------------------------------------

#ifndef __VIDEO_RESOLUTION_H__
#define __VIDEO_RESOLUTION_H__

#include "types.h"

// Video Pattern Generator - Video Resolution values
#define VIDEO_RESOLUTION_VGA       0
#define VIDEO_RESOLUTION_480P      1
#define VIDEO_RESOLUTION_576P      2
#define VIDEO_RESOLUTION_WVGA      3
#define VIDEO_RESOLUTION_SVGA      4
#define VIDEO_RESOLUTION_XGA       5
#define VIDEO_RESOLUTION_720P      6
#define VIDEO_RESOLUTION_SXGA      7
#define VIDEO_RESOLUTION_1080P     8
#define VIDEO_RESOLUTION_UXGA      9
#define VIDEO_RESOLUTION_WXGA	   10
#define NUM_VIDEO_RESOLUTIONS      11

struct struct_vres_timing_t
{
    char *pName;
    int32u VActiveVideo;
    int32u VFrontPorch;
    int32u VSyncWidth;
    int32u VBackPorch;
    int32u VSyncPolarity;
    int32u HActiveVideo;
    int32u HFrontPorch;
    int32u HSyncWidth;
    int32u HBackPorch;
    int32u HSyncPolarity;
    int32u ClockFrequency;
};
typedef struct struct_vres_timing_t vres_timing_t;

char *  vres_get_name(int32u resolutionId);
int32u vres_get_width(int32u resolutionId);
int32u vres_get_height(int32u resolutionId);
int32u vres_get_timing(int32u resolutionId, vres_timing_t *pTiming);

int32s vres_detect(int32u width, int32u height);

#endif // __VIDEO_RESOLUTION_H__

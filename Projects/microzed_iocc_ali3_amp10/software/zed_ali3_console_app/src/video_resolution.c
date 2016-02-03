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
// Please direct any questions or issues to the MicroZed Community Forums:
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
// Module Name:         video_resolution.c
// Project Name:        FMC-IMAGEON
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        FMC-IMAGEON, ZedBoard
//
// Tool versions:       ISE 14.4
//
// Description:         Video timing definitions
//
// Dependencies:        
//
// Revision:            Mar 05, 2010: 1.00 Initial version for S6-IVK
//                      Dec 03, 2011: 1.01 Reuse for FMC-IMAGEON
//                      Nov 01, 2012: 1.02 Add 576P resolution
//                      Mar 06, 2013: 1.03 Add WVGA resolution
//                                         Add Clock Frequency
//                      May 23, 2013: 1.04 Updated for Zed Display Kit
//                      Oct 28, 2013: 1.05 Add WXGA resolution 
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "types.h"
#include "video_resolution.h"

vres_timing_t vres_resolutions[NUM_VIDEO_RESOLUTIONS] =
{
    // name     vav,  vfp,  vsw,  vbp,  vsp,  hav,  hfp,  hsw,  hbp,  hsp
    { "VGA",    480,   10,    2,   33,    0,  640,   16,   96,   48,    0,  25175000 }, // VIDEO_RESOLUTION_VGA
    { "480P",   480,    9,    6,   30,    0,  720,   16,   62,   60,    0,  27000000 }, // VIDEO_RESOLUTION_480P
    { "576P",   576,    5,    5,   39,    0,  720,   12,   64,   68,    0,  27000000 }, // VIDEO_RESOLUTION_576P
    { "WVGA",   480,    8,    2,   35,    0,  800,   40,  128,   88,    0,  33000000 }, // VIDEO_RESOLUTION_WVGA
    { "SVGA",   600,    1,    4,   23,    1,  800,   40,  128,   88,    1,  45000000 }, // VIDEO_RESOLUTION_SVGA
    { "XGA",    768,    3,    6,   29,    0, 1024,   24,  136,  160,    0,  65000000 }, // VIDEO_RESOLUTION_XGA
    { "720P",   720,    5,    5,   20,    1, 1280,  110,   40,  220,    1,  74250000 }, // VIDEO_RESOLUTION_720P
    { "SXGA",  1024,    1,    3,   26,    0, 1280,   48,  184,  200,    0, 110000000 }, // VIDEO_RESOLUTION_SXGA
    { "1080P", 1080,    4,    5,   36,    1, 1920,   88,   44,  148,    1, 148500000 }, // VIDEO_RESOLUTION_1080P
    { "UXGA",  1200,    1,    3,   46,    0, 1600,   64,  192,  304,    0, 162000000 }, // VIDEO_RESOLUTION_UXGA
    { "WXGA",   800,    7,    4,   12,    0, 1280,   65,   55,   40,    0,  71100000 }  // VIDEO_RESOLUTION_WXGA
};

char *vres_get_name(int32u resolutionId)
{
    if ( resolutionId < NUM_VIDEO_RESOLUTIONS )
    {
        return vres_resolutions[resolutionId].pName;
    }
    else
    {
        return "{UNKNOWN}";
    }
}

int32u vres_get_width(int32u resolutionId)
{
    return vres_resolutions[resolutionId].HActiveVideo; // horizontal active
}

int32u vres_get_height(int32u resolutionId)
{
    return vres_resolutions[resolutionId].VActiveVideo; // vertical active
}

int32u vres_get_timing(int32u ResolutionId, vres_timing_t *pTiming)
{
    pTiming->pName         = vres_resolutions[ResolutionId].pName;
    pTiming->HActiveVideo  = vres_resolutions[ResolutionId].HActiveVideo;
    pTiming->HFrontPorch   = vres_resolutions[ResolutionId].HFrontPorch;
    pTiming->HSyncWidth    = vres_resolutions[ResolutionId].HSyncWidth;
    pTiming->HBackPorch    = vres_resolutions[ResolutionId].HBackPorch;
    pTiming->HSyncPolarity = vres_resolutions[ResolutionId].HSyncPolarity;
    pTiming->VActiveVideo  = vres_resolutions[ResolutionId].VActiveVideo;
    pTiming->VFrontPorch   = vres_resolutions[ResolutionId].VFrontPorch;
    pTiming->VSyncWidth    = vres_resolutions[ResolutionId].VSyncWidth;
    pTiming->VBackPorch    = vres_resolutions[ResolutionId].VBackPorch;
    pTiming->VSyncPolarity = vres_resolutions[ResolutionId].VSyncPolarity;
    pTiming->ClockFrequency= vres_resolutions[ResolutionId].ClockFrequency;

    return 0;
}

int32s vres_detect(int32u width, int32u height)
{
    int32s index;
    int32s resolution = -1;

    for (index = 0; index < NUM_VIDEO_RESOLUTIONS; index++)
    {
        if (width == vres_get_width(index) && height == vres_get_height(index))
        {
            resolution = index;
            break;
        }
    }

    return resolution;
}

// ----------------------------------------------------------------------------
//  
//        ** **        **          **  ****      **  **********  ********** ® 
//       **   **        **        **   ** **     **  **              ** 
//      **     **        **      **    **  **    **  **              ** 
//     **       **        **    **     **   **   **  *********       ** 
//    **         **        **  **      **    **  **  **              ** 
//   **           **        ****       **     ** **  **              ** 
//  **  .........  **        **        **      ****  **********      ** 
//     ........... 
//                                     Reach Further™ 
//  
// ----------------------------------------------------------------------------
// 
// This design is the property of Avnet.  Publication of this 
// design is not authorized without written consent from Avnet. 
// 
// Please direct any questions to the PicoZed community support forum: 
//    http://www.zedboard.org/forum 
// 
// Disclaimer: 
//    Avnet, Inc. makes no warranty for the use of this code or design. 
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
//    any errors, which may appear in this code, nor does it make a commitment 
//    to update the information contained herein. Avnet, Inc specifically 
//    disclaims any implied warranties of fitness for a particular purpose. 
//                     Copyright(c) 2017 Avnet, Inc. 
//                             All rights reserved. 
// 
// ----------------------------------------------------------------------------
//
// Create Date:         Nov 18, 2011
// Design Name:         Demo
// Module Name:         demo.h
// Project Name:        Demo
//
// Tool versions:       Vivado 2016.4
//
// Description:         PYTHON1300-C Getting Started Demo application
//
// Dependencies:        
//
// Revision:            Jun 01, 2017: 1.03 Add CFA command to set bayer
//
//----------------------------------------------------------------

#ifndef _DEMO_H_
#define _DEMO_H_

#include "xparameters.h"
#include "sleep.h"

#include "fmc_iic.h"
#include "fmc_hdmi_cam.h"

#include "xaxivdma.h"
#include "xaxivdma_ext.h"
#include "xosd.h"
#include "onsemi_python_sw.h"
#include "xcfa.h"

typedef struct {
	XAxiVdma axivdma0;
	XAxiVdma axivdma1;
	XOSD osd;
	XCfa cfa;
    fmc_iic_t fmc_hdmi_cam_iic;
    fmc_hdmi_cam_t fmc_hdmi_cam;
    onsemi_python_t python_receiver;
    onsemi_python_status_t python_status_t1;
    onsemi_python_status_t python_status_t2;

	XAxiVdma *paxivdma0;
	XAxiVdma *paxivdma1;
	XOSD *posd;
	XCfa *pcfa;
    fmc_iic_t *pfmc_hdmi_cam_iic;
    fmc_hdmi_cam_t *pfmc_hdmi_cam;
	onsemi_python_t *ppython_receiver;

    Xuint32 hdmii_locked;
    Xuint32 hdmii_width;
    Xuint32 hdmii_height;
    fmc_hdmi_cam_video_timing_t hdmii_timing;

    Xuint32 hdmio_width;
    Xuint32 hdmio_height;
    fmc_hdmi_cam_video_timing_t hdmio_timing;

	// general commands
    int bVerbose;

    // fmc-hami-cam commands
    Xuint32 adv7611_llc_polarity;
    Xuint32 adv7611_llc_delay;

    // cam commands
    Xuint32 cam_aec;
    Xuint32 cam_again;
    Xuint32 cam_dgain;
    Xuint32 cam_exposure;

	// video ip commands
	Xuint32 cam_bayer;

    // start commands
	u8 cam_alpha;
	u8 hdmi_alpha;

} demo_t;

extern Xuint8 fmc_hdmi_cam_hdmii_edid_content[256];

int demo_init( demo_t *pdemo );
int demo_start_hdmi_in( demo_t *pdemo );
int demo_start_cam_in( demo_t *pdemo );
int demo_init_frame_buffer( demo_t *pdemo );
int demo_stop_frame_buffer( demo_t *pdemo );
int demo_start_frame_buffer( demo_t *pdemo );


#endif // _DEMO_H_

#ifndef _DEMO_H_
#define _DEMO_H_

#include "xparameters.h"
#include "sleep.h"

#include "fmc_iic.h"
#include "fmc_ipmi.h"
#include "fmc_ipmi_fru.h"
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
	fmc_iic_t fmc_ipmi_iic;
    fmc_iic_t fmc_hdmi_cam_iic;
    fmc_hdmi_cam_t fmc_hdmi_cam;
    onsemi_python_t python_receiver;
    onsemi_python_status_t python_status_t1;
    onsemi_python_status_t python_status_t2;

	XAxiVdma *paxivdma0;
	XAxiVdma *paxivdma1;
	XOSD *posd;
	XCfa *pcfa;
	fmc_iic_t *pfmc_ipmi_iic;
    fmc_iic_t *pfmc_hdmi_cam_iic;
    fmc_hdmi_cam_t *pfmc_hdmi_cam;
	onsemi_python_t *ppython_receiver;

	// IPMI information
	int ipmi_info_valid;
	struct fru_header     fmc_hdmi_cam_common_info;
	struct fru_area_board fmc_hdmi_cam_board_info;

    Xuint32 hdmii_locked;
    Xuint32 hdmii_width;
    Xuint32 hdmii_height;
    fmc_hdmi_cam_video_timing_t hdmii_timing;

    Xuint32 hdmio_width;
    Xuint32 hdmio_height;
    fmc_hdmi_cam_video_timing_t hdmio_timing;

	u8 cam_alpha;
	u8 hdmi_alpha;

    int bVerbose;
} demo_t;

extern Xuint8 fmc_hdmi_cam_hdmii_edid_content[256];

int demo_init( demo_t *pdemo );
int demo_start_hdmi_in( demo_t *pdemo );
int demo_start_cam_in( demo_t *pdemo );
int demo_init_frame_buffer( demo_t *pdemo );
int demo_stop_frame_buffer( demo_t *pdemo );
int demo_start_frame_buffer( demo_t *pdemo );


#endif // _DEMO_H_

#ifndef _DEMO_H_
#define _DEMO_H_

#include "xparameters.h"
#include "sleep.h"

#include "fmc_iic.h"

#include "xaxivdma.h"
#include "xaxivdma_ext.h"
#include "xosd.h"
#include "onsemi_python_sw.h"
#include "xcfa.h"
#include "xv_tpg.h"

#include "cat9554.h"
#include "tca9548.h"

typedef struct {
	XAxiVdma axivdma0;
	XAxiVdma axivdma1;
	XOSD osd;
	XCfa cfa;
	XV_tpg tpg;
    fmc_iic_t fmc_hdmi_cam_iic;
    onsemi_python_t python_receiver;
    onsemi_python_status_t python_status_t1;
    onsemi_python_status_t python_status_t2;

	XAxiVdma *paxivdma0;
	XAxiVdma *paxivdma1;
	XOSD *posd;
	XCfa *pcfa;
	XV_tpg *ptpg;
	XV_tpg_Config *ptpg_config;
    fmc_iic_t *pfmc_hdmi_cam_iic;
	onsemi_python_t *ppython_receiver;

	u8 cam_alpha;
	u8 tpg_alpha;

	// PYTHON settings
	int uManualTap;
	int uSamplePoint;

    int bVerbose;
} demo_t;

extern Xuint8 fmc_hdmi_cam_hdmii_edid_content[256];

int demo_init( demo_t *pdemo );
int demo_start_tpg_in( demo_t *pdemo );
int demo_start_cam_in( demo_t *pdemo );
int demo_init_frame_buffer( demo_t *pdemo );
int demo_stop_frame_buffer( demo_t *pdemo );
int demo_start_frame_buffer( demo_t *pdemo );


#endif // _DEMO_H_

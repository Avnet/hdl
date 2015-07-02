/*
 * main.c
 *
 *  Created on: Jun 23, 2015
 *      Author: 910560
 */

#include <stdlib.h>

#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"
#include "demo.h"

#include "xgpiops.h"
#include "xiicps.h"
#include "xcfa.h"
#include "xccm.h"
#include "xrgb2ycrcb.h"
#include "xcresample.h"
#include "xaxivdma.h"
#include "xosd.h"
#include "xvtc.h"

#include "ccm_ext.h"
#include "xrgb2ycrcb_ext.h"
#include "xcresample_ext.h"
#include "xaxivdma_ext.h"

#include "pca9534.h"
#include "tca9548.h"
#include "adv7511.h"
#include "tcm5117pl.h"

#include "avnet_console_serial.h"

void avnet_console_command_help() {
	  printf("\n\r");
	  printf("---------------------------------------------\n\r");
	  printf("--     Toshiba TCM3232PB on Avnet EMBV     --\n\r");
	  printf("---------------------------------------------\n\r");
	  printf("General Commands:\n\r");
	  printf("  help        Print the Top-Level menu Help Screen \n\r");
	  printf("  iic         IIC control to Toshiba sensor \n\r");
	  printf("  cfg         Change the Toshiba sensor configuration\n\r");
	  printf("              0: VGAP60\r\n");
	  printf("              1: 720P60\r\n");
	  printf("              2: 1080P15\r\n");
	  printf("              3: 1080P30\r\n");
	  printf("              4: 1080P60\r\n");
	  printf("  ccm         Color correction matrix related \n\r");
	  printf("\n\r");
	  printf("---------------------------------------------\n\r");
}

void avnet_config_vgap60_video(demo_t *pInstance) {
	int status;

	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);
	XCfa_Reset(pInstance->pcfa);
	XCcm_Reset(pInstance->pccm);
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XCresample_Reset(pInstance->pcresample);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	XVtc_Reset(pInstance->pvtc);
	XOSD_Reset(pInstance->posd);

	/* CLKWIZ */
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0200, 0x00002203);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0208, 0x0000002D);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000007);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000002);

	status = 0;
	while (!status) {
		status = Xil_In32(XPAR_CLK_WIZ_1_BASEADDR + 0x0004);
	}

	/* ISERDES Reset Assert */
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);

	/* TCM Initialization */
	tca9548_i2c_mux_select(pInstance->piicps, EMBV_IIC_MUX_CAM);
//	tcm5117pl_get_chip_id(pInstance->piicps);
	tcm5117pl_init(pInstance->piicps, TCM5117PL_VGAP60);

	/* CFA */
	XCfa_Reset(pInstance->pcfa);
	XCfa_Enable(pInstance->pcfa);

	XCfa_SetBayerPhase(pInstance->pcfa, 0x00000001);
	XCfa_SetActiveSize(pInstance->pcfa, 656, 496);
	XCfa_RegUpdateEnable(pInstance->pcfa);

	/* CCM */
	XCcm_Reset(pInstance->pccm);
	XCcm_Enable(pInstance->pccm);

	XCcm_SetCoefMatrix(pInstance->pccm, &CCM_IDENTITY);
	XCcm_SetRgbOffset(pInstance->pccm, 0, 0, 0);
	XCcm_SetActiveSize(pInstance->pccm, 656, 496);
	XCcm_RegUpdateEnable(pInstance->pccm);

	/* RGB2YCRCB */
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XRgb2YCrCb_Enable(pInstance->prgb2ycrcb);

	XRgb2YCrCb_Configuration(pInstance->prgb2ycrcb, XRGB_STANDARD_ITU_601_SD, XRGB_TV_16_TO_240, XRGB_DATA_WIDTH_10);
	XRgb2YCrCb_SetActiveSize(pInstance->prgb2ycrcb, 656, 496);
	XRgb2YCrCb_RegUpdateEnable(pInstance->prgb2ycrcb);

	/* CRESAMPLE */
	XCresample_Reset(pInstance->pcresample);
	XCresample_Enable(pInstance->pcresample);

	XCresample_Configuration(pInstance->pcresample);
	XCresample_SetActiveSize(pInstance->pcresample, 656, 496);
	XCresample_RegUpdateEnable(pInstance->pcresample);

	/* AXIVDMA */
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	ReadSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 656, 496, 2048,
			2048);
	WriteSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 656, 496, 2048,
			2048);
	StartTransfer(pInstance->paxivdma);

	/* VTC */
	XVtc_Timing Timing;

	XVtc_Reset(pInstance->pvtc);
	XVtc_RegUpdateEnable(pInstance->pvtc);
	XVtc_Enable(pInstance->pvtc);
	XVtc_ConvVideoMode2Timing(pInstance->pvtc, XVTC_VMODE_VGA, &Timing);
	Timing.HSyncPolarity = 1;
	Timing.VSyncPolarity = 1;
	XVtc_SetGeneratorTiming(pInstance->pvtc, &Timing);

	/* OSD */
	XOSD_Reset(pInstance->posd);
	XOSD_RegUpdateEnable(pInstance->posd);
	XOSD_Enable(pInstance->posd);

	XOSD_SetScreenSize(pInstance->posd, 656, 496);
	XOSD_SetBackgroundColor(pInstance->posd, 0x80, 0x80, 0x80);

	// Layer 0 - Test Pattern Generator
	XOSD_SetLayerPriority(pInstance->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pInstance->posd, 0, 1, 0xFF);
	XOSD_SetLayerDimension(pInstance->posd, 0, 0, 0, 656, 496);
	XOSD_EnableLayer(pInstance->posd, 0);

	// ISERDES Reset De-Assert
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);
}

void avnet_config_720p60_video(demo_t *pInstance) {
	int status;

	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);
	XCfa_Reset(pInstance->pcfa);
	XCcm_Reset(pInstance->pccm);
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XCresample_Reset(pInstance->pcresample);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	XVtc_Reset(pInstance->pvtc);
	XOSD_Reset(pInstance->posd);

	/* CLKWIZ */
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0200, 0x047D2504);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0208, 0x0005F40C);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000007);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000002);

	status = 0;
	while (!status) {
		status = Xil_In32(XPAR_CLK_WIZ_1_BASEADDR + 0x0004);
	}

	/* ISERDES Reset Assert */
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);

	/* TCM Initialization */
	tca9548_i2c_mux_select(pInstance->piicps, EMBV_IIC_MUX_CAM);
//	tcm5117pl_get_chip_id(pInstance->piicps);
	tcm5117pl_init(pInstance->piicps, TCM5117PL_720P60);

	/* CFA */
	XCfa_Reset(pInstance->pcfa);
	XCfa_Enable(pInstance->pcfa);

	XCfa_SetBayerPhase(pInstance->pcfa, 0x00000001);
	XCfa_SetActiveSize(pInstance->pcfa, 1280, 720);
	XCfa_RegUpdateEnable(pInstance->pcfa);

	/* CCM */
	XCcm_Reset(pInstance->pccm);
	XCcm_Enable(pInstance->pccm);

	XCcm_SetCoefMatrix(pInstance->pccm, &CCM_IDENTITY);
	XCcm_SetRgbOffset(pInstance->pccm, 0, 0, 0);
	XCcm_SetActiveSize(pInstance->pccm, 1280, 720);
	XCcm_RegUpdateEnable(pInstance->pccm);

	/* RGB2YCRCB */
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XRgb2YCrCb_Enable(pInstance->prgb2ycrcb);

	XRgb2YCrCb_Configuration(pInstance->prgb2ycrcb, XRGB_STANDARD_ITU_601_SD, XRGB_TV_16_TO_240, XRGB_DATA_WIDTH_10);
	XRgb2YCrCb_SetActiveSize(pInstance->prgb2ycrcb, 1280, 720);
	XRgb2YCrCb_RegUpdateEnable(pInstance->prgb2ycrcb);

	/* CRESAMPLE */
	XCresample_Reset(pInstance->pcresample);
	XCresample_Enable(pInstance->pcresample);

	XCresample_Configuration(pInstance->pcresample);
	XCresample_SetActiveSize(pInstance->pcresample, 1280, 720);
	XCresample_RegUpdateEnable(pInstance->pcresample);

	/* AXIVDMA */
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	ReadSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1280, 720, 2048,
			2048);
	WriteSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1280, 720, 2048,
			2048);
	StartTransfer(pInstance->paxivdma);

	/* VTC */
	XVtc_Reset(pInstance->pvtc);
	XVtc_RegUpdateEnable(pInstance->pvtc);
	XVtc_Enable(pInstance->pvtc);
	XVtc_SetGeneratorVideoMode(pInstance->pvtc, XVTC_VMODE_720P);

	/* OSD */
	XOSD_Reset(pInstance->posd);
	XOSD_RegUpdateEnable(pInstance->posd);
	XOSD_Enable(pInstance->posd);

	XOSD_SetScreenSize(pInstance->posd, 1280, 720);
	XOSD_SetBackgroundColor(pInstance->posd, 0x80, 0x80, 0x80);

	// Layer 0 - Test Pattern Generator
	XOSD_SetLayerPriority(pInstance->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pInstance->posd, 0, 1, 0xFF);
	XOSD_SetLayerDimension(pInstance->posd, 0, 0, 0, 1280, 720);
	XOSD_EnableLayer(pInstance->posd, 0);

	// ISERDES Reset De-Assert
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);
}

void avnet_config_1080p15_video(demo_t *pInstance) {
	int status;

	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);
	XCfa_Reset(pInstance->pcfa);
	XCcm_Reset(pInstance->pccm);
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XCresample_Reset(pInstance->pcresample);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	XVtc_Reset(pInstance->pvtc);
	XOSD_Reset(pInstance->posd);

	/* CLKWIZ */
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0200, 0x047D2504);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0208, 0x0004FA06);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000007);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000002);

	status = 0;
	while (!status) {
		status = Xil_In32(XPAR_CLK_WIZ_1_BASEADDR + 0x0004);
	}

	/* ISERDES Reset Assert */
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);

	/* TCM Initialization */
	tca9548_i2c_mux_select(pInstance->piicps, EMBV_IIC_MUX_CAM);
//	tcm5117pl_get_chip_id(pInstance->piicps);
	tcm5117pl_init(pInstance->piicps, TCM5117PL_VGAP60);

	/* CFA */
	XCfa_Reset(pInstance->pcfa);
	XCfa_Enable(pInstance->pcfa);

	XCfa_SetBayerPhase(pInstance->pcfa, 0x00000001);
	XCfa_SetActiveSize(pInstance->pcfa, 1920, 1080);
	XCfa_RegUpdateEnable(pInstance->pcfa);

	/* CCM */
	XCcm_Reset(pInstance->pccm);
	XCcm_Enable(pInstance->pccm);

	XCcm_SetCoefMatrix(pInstance->pccm, &CCM_IDENTITY);
	XCcm_SetRgbOffset(pInstance->pccm, 0, 0, 0);
	XCcm_SetActiveSize(pInstance->pccm, 1920, 1080);
	XCcm_RegUpdateEnable(pInstance->pccm);

	/* RGB2YCRCB */
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XRgb2YCrCb_Enable(pInstance->prgb2ycrcb);

	XRgb2YCrCb_Configuration(pInstance->prgb2ycrcb, XRGB_STANDARD_ITU_601_SD, XRGB_TV_16_TO_240, XRGB_DATA_WIDTH_10);
	XRgb2YCrCb_SetActiveSize(pInstance->prgb2ycrcb, 1920, 1080);
	XRgb2YCrCb_RegUpdateEnable(pInstance->prgb2ycrcb);

	/* CRESAMPLE */
	XCresample_Reset(pInstance->pcresample);
	XCresample_Enable(pInstance->pcresample);

	XCresample_Configuration(pInstance->pcresample);
	XCresample_SetActiveSize(pInstance->pcresample, 1920, 1080);
	XCresample_RegUpdateEnable(pInstance->pcresample);

	/* AXIVDMA */
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	ReadSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
			2048);
	WriteSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
			2048);
	StartTransfer(pInstance->paxivdma);

	/* VTC */
	XVtc_Reset(pInstance->pvtc);
	XVtc_RegUpdateEnable(pInstance->pvtc);
	XVtc_Enable(pInstance->pvtc);
	XVtc_SetGeneratorVideoMode(pInstance->pvtc, XVTC_VMODE_1080P);

	/* OSD */
	XOSD_Reset(pInstance->posd);
	XOSD_RegUpdateEnable(pInstance->posd);
	XOSD_Enable(pInstance->posd);

	XOSD_SetScreenSize(pInstance->posd, 1920, 1080);
	XOSD_SetBackgroundColor(pInstance->posd, 0x80, 0x80, 0x80);

	// Layer 0 - Test Pattern Generator
	XOSD_SetLayerPriority(pInstance->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pInstance->posd, 0, 1, 0xFF);
	XOSD_SetLayerDimension(pInstance->posd, 0, 0, 0, 1920, 1080);
	XOSD_EnableLayer(pInstance->posd, 0);

	// ISERDES Reset De-Assert
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);
}

void avnet_config_1080p30_video(demo_t *pInstance) {
	int status;

	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);
	XCfa_Reset(pInstance->pcfa);
	XCcm_Reset(pInstance->pccm);
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XCresample_Reset(pInstance->pcresample);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	XVtc_Reset(pInstance->pvtc);
	XOSD_Reset(pInstance->posd);

	/* CLKWIZ */
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0200, 0x047D2504);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0208, 0x0004FA06);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000007);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000002);

	status = 0;
	while (!status) {
		status = Xil_In32(XPAR_CLK_WIZ_1_BASEADDR + 0x0004);
	}

	/* ISERDES Reset Assert */
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);

	/* TCM Initialization */
	tca9548_i2c_mux_select(pInstance->piicps, EMBV_IIC_MUX_CAM);
//	tcm5117pl_get_chip_id(pInstance->piicps);
	tcm5117pl_init(pInstance->piicps, TCM5117PL_VGAP60);

	/* CFA */
	XCfa_Reset(pInstance->pcfa);
	XCfa_Enable(pInstance->pcfa);

	XCfa_SetBayerPhase(pInstance->pcfa, 0x00000001);
	XCfa_SetActiveSize(pInstance->pcfa, 1920, 1080);
	XCfa_RegUpdateEnable(pInstance->pcfa);

	/* CCM */
	XCcm_Reset(pInstance->pccm);
	XCcm_Enable(pInstance->pccm);

	XCcm_SetCoefMatrix(pInstance->pccm, &CCM_IDENTITY);
	XCcm_SetRgbOffset(pInstance->pccm, 0, 0, 0);
	XCcm_SetActiveSize(pInstance->pccm, 1920, 1080);
	XCcm_RegUpdateEnable(pInstance->pccm);

	/* RGB2YCRCB */
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XRgb2YCrCb_Enable(pInstance->prgb2ycrcb);

	XRgb2YCrCb_Configuration(pInstance->prgb2ycrcb, XRGB_STANDARD_ITU_601_SD, XRGB_TV_16_TO_240, XRGB_DATA_WIDTH_10);
	XRgb2YCrCb_SetActiveSize(pInstance->prgb2ycrcb, 1920, 1080);
	XRgb2YCrCb_RegUpdateEnable(pInstance->prgb2ycrcb);

	/* CRESAMPLE */
	XCresample_Reset(pInstance->pcresample);
	XCresample_Enable(pInstance->pcresample);

	XCresample_Configuration(pInstance->pcresample);
	XCresample_SetActiveSize(pInstance->pcresample, 1920, 1080);
	XCresample_RegUpdateEnable(pInstance->pcresample);

	/* AXIVDMA */
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	ReadSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
			2048);
	WriteSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
			2048);
	StartTransfer(pInstance->paxivdma);

	/* VTC */
	XVtc_Reset(pInstance->pvtc);
	XVtc_RegUpdateEnable(pInstance->pvtc);
	XVtc_Enable(pInstance->pvtc);
	XVtc_SetGeneratorVideoMode(pInstance->pvtc, XVTC_VMODE_1080P);

	/* OSD */
	XOSD_Reset(pInstance->posd);
	XOSD_RegUpdateEnable(pInstance->posd);
	XOSD_Enable(pInstance->posd);

	XOSD_SetScreenSize(pInstance->posd, 1920, 1080);
	XOSD_SetBackgroundColor(pInstance->posd, 0x80, 0x80, 0x80);

	// Layer 0 - Test Pattern Generator
	XOSD_SetLayerPriority(pInstance->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pInstance->posd, 0, 1, 0xFF);
	XOSD_SetLayerDimension(pInstance->posd, 0, 0, 0, 1920, 1080);
	XOSD_EnableLayer(pInstance->posd, 0);

	// ISERDES Reset De-Assert
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);
}

void avnet_config_1080p60_video(demo_t *pInstance) {
	int status;

	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);
	XCfa_Reset(pInstance->pcfa);
	XCcm_Reset(pInstance->pccm);
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XCresample_Reset(pInstance->pcresample);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	XVtc_Reset(pInstance->pvtc);
	XOSD_Reset(pInstance->posd);

	/* CLKWIZ */
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0200, 0x047D2504);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x0208, 0x0004FA06);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000007);
	Xil_Out32(XPAR_CLK_WIZ_1_BASEADDR + 0x025C, 0x00000002);

	status = 0;
	while (!status) {
		status = Xil_In32(XPAR_CLK_WIZ_1_BASEADDR + 0x0004);
	}

	/* ISERDES Reset Assert */
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);

	/* TCM Initialization */
	tca9548_i2c_mux_select(pInstance->piicps, EMBV_IIC_MUX_CAM);
//	tcm5117pl_get_chip_id(pInstance->piicps);
	tcm5117pl_init(pInstance->piicps, TCM5117PL_VGAP60);

	/* CFA */
	XCfa_Reset(pInstance->pcfa);
	XCfa_Enable(pInstance->pcfa);

	XCfa_SetBayerPhase(pInstance->pcfa, 0x00000001);
	XCfa_SetActiveSize(pInstance->pcfa, 1920, 1080);
	XCfa_RegUpdateEnable(pInstance->pcfa);

	/* CCM */
	XCcm_Reset(pInstance->pccm);
	XCcm_Enable(pInstance->pccm);

	XCcm_SetCoefMatrix(pInstance->pccm, &CCM_IDENTITY);
	XCcm_SetRgbOffset(pInstance->pccm, 0, 0, 0);
	XCcm_SetActiveSize(pInstance->pccm, 1920, 1080);
	XCcm_RegUpdateEnable(pInstance->pccm);

	/* RGB2YCRCB */
	XRgb2YCrCb_Reset(pInstance->prgb2ycrcb);
	XRgb2YCrCb_Enable(pInstance->prgb2ycrcb);

	XRgb2YCrCb_Configuration(pInstance->prgb2ycrcb, XRGB_STANDARD_ITU_601_SD, XRGB_TV_16_TO_240, XRGB_DATA_WIDTH_10);
	XRgb2YCrCb_SetActiveSize(pInstance->prgb2ycrcb, 1920, 1080);
	XRgb2YCrCb_RegUpdateEnable(pInstance->prgb2ycrcb);

	/* CRESAMPLE */
	XCresample_Reset(pInstance->pcresample);
	XCresample_Enable(pInstance->pcresample);

	XCresample_Configuration(pInstance->pcresample);
	XCresample_SetActiveSize(pInstance->pcresample, 1920, 1080);
	XCresample_RegUpdateEnable(pInstance->pcresample);

	/* AXIVDMA */
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pInstance->paxivdma, XAXIVDMA_READ);
	ReadSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
			2048);
	WriteSetup(pInstance->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
			2048);
	StartTransfer(pInstance->paxivdma);

	/* VTC */
	XVtc_Reset(pInstance->pvtc);
	XVtc_RegUpdateEnable(pInstance->pvtc);
	XVtc_Enable(pInstance->pvtc);
	XVtc_SetGeneratorVideoMode(pInstance->pvtc, XVTC_VMODE_1080P);

	/* OSD */
	XOSD_Reset(pInstance->posd);
	XOSD_RegUpdateEnable(pInstance->posd);
	XOSD_Enable(pInstance->posd);

	XOSD_SetScreenSize(pInstance->posd, 1920, 1080);
	XOSD_SetBackgroundColor(pInstance->posd, 0x80, 0x80, 0x80);

	// Layer 0 - Test Pattern Generator
	XOSD_SetLayerPriority(pInstance->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pInstance->posd, 0, 1, 0xFF);
	XOSD_SetLayerDimension(pInstance->posd, 0, 0, 0, 1920, 1080);
	XOSD_EnableLayer(pInstance->posd, 0);

	// ISERDES Reset De-Assert
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);
}

void avnet_console_command_iic(demo_t *pInstance, int cargc, char ** cargv) {
	Xuint32 tmp;
	Xuint8 device;
	Xuint16 address, address2;
	Xuint8 data;

	int bDispSyntax = 0;
	tca9548_i2c_mux_select(pInstance->piicps, EMBV_IIC_MUX_CAM);

	if ( cargc > 1 && !strcmp(cargv[1],"help") ) {
		bDispSyntax = 1;
	}
	else if ( cargc < 2 ) {
		bDispSyntax = 1;
	}
	else {
		if (strcmp(cargv[1], "read") == 0) {
			if (cargc < 4) {
				bDispSyntax = 1;
			}
			else {
				scanhex(cargv[2], &tmp);	device = (Xuint8) tmp;
				scanhex(cargv[3], &tmp);	address = (Xuint16) tmp;

//				printf("  device = 0x%02X\n\r", device);
//				printf("  address = 0x%02X\n\r", address);

				XIicPs_A16_Read(pInstance->piicps,  (device >> 1), address, &data, 1);

				printf("  0x%02X[0x%02X] => 0x%02X\n\r", device, address, data);
			}
		}
		else if (strcmp(cargv[1], "write") == 0) {
			if (cargc < 5) {
				bDispSyntax = 1;
			} else {
				scanhex(cargv[2], &tmp);	device = (Xuint8) tmp;
				scanhex(cargv[3], &tmp);	address = (Xuint16) tmp;
				scanhex(cargv[4], &tmp);	data = (Xuint8) tmp;

//				printf("  device = 0x%02X\n\r", device);
//				printf("  address = 0x%02X\n\r", address);
//				printf("  data = 0x%02X\n\r", data);

				XIicPs_A16_Write(pInstance->piicps, (device >> 1), address, &data, 1);

				printf("  0x%02X[0x%02X] <= 0x%02X\n\r", device, address, data);
			}
		}
		else if (strcmp(cargv[1], "dump") == 0) {
			if (cargc < 5) {
				bDispSyntax = 1;
			} else {
				scanhex(cargv[2], &tmp);	device = (Xuint8) tmp;
				scanhex(cargv[3], &tmp);	address = (Xuint16) tmp;
				scanhex(cargv[4], &tmp);	address2 = (Xuint16) tmp;

//				printf("  device = 0x%02X\n\r", device);
//				printf("  address(start) = 0x%02X\n\r", address);
//				printf("  address( end ) = 0x%02X\n\r", address2);

				for (; address <= address2; address += 1) {
					XIicPs_A16_Read(pInstance->piicps, (device >> 1), address, &data, 1);
					printf("  0x%02X[0x%02X] => 0x%02X\n\r", device, address, data);
				}
			}
		}
		else {
			bDispSyntax = 1;
		}
	}

	if ( bDispSyntax == 1 ) {
		printf("  Syntax :\r\n" );
		printf("    %s                                         => ...\r\n", cargv[0] );
		printf("    %s read  {device} {address}                => For {device}, Read from {address}\n\r", cargv[0] );
		printf("    %s write {device} {address} {data}         => For {device}, Write {data} to {address}\n\r", cargv[0] );
		printf("    %s dump  {device} {address1} {address2}    => For {device}, Read from {address1} to {address2}\n\r", cargv[0] );
	}

	return;
}

void avnet_console_command_cfg(demo_t *pInstance, int cargc, char ** cargv) {
	int bDispSyntax = 0;

	if ( cargc > 1 && !strcmp(cargv[1],"help") ) {
		bDispSyntax = 1;
	}
	else if ( cargc != 2 ) {
		bDispSyntax = 1;
	}
	else {
		if (strcmp(cargv[1], "0") == 0) {	/* VGAP60 */
			avnet_config_vgap60_video(pInstance);
		}
		else if (strcmp(cargv[1], "1") == 0) {	/* 720P60 */
			avnet_config_720p60_video(pInstance);
		}
		else if (strcmp(cargv[1], "2") == 0) {	/* 1080P15 */
			avnet_config_1080p15_video(pInstance);
		}
		else if (strcmp(cargv[1], "3") == 0) {	/* 1080P30 */
			avnet_config_1080p30_video(pInstance);
		}
		else if (strcmp(cargv[1], "4") == 0) {	/* 1080P60 */
			avnet_config_1080p60_video(pInstance);
		}
		else {
			bDispSyntax = 1;
		}
	}

	if ( bDispSyntax == 1 ) {
		printf("  Syntax :\r\n" );
		printf("    %s                                         => ...\r\n", cargv[0] );
		printf("    %s 0                                       => Switch video to VGAP60\n\r", cargv[0] );
		printf("    %s 1                                       => Switch video to 720P60\n\r", cargv[0] );
		printf("    %s 2                                       => Switch video to 1080P15\n\r", cargv[0] );
		printf("    %s 3                                       => Switch video to 1080P30\n\r", cargv[0] );
		printf("    %s 4                                       => Switch video to 1080P60\n\r", cargv[0] );
	}

}

void avnet_console_command_ccm(demo_t *pInstance, int cargc, char ** cargv) {
	int bDispSyntax = 0;

	if (cargc > 1 && !strcmp(cargv[1], "help")) {
		bDispSyntax = 1;
	} else if (cargc == 1) {
		XCcm_Coefs ccmCustom;
		s32 ROffset, GOffset, BOffset;

		XCcm_GetCoefMatrix(pInstance->pccm, &ccmCustom);

		printf("  %s coefficients = ...\r\n", cargv[0] );
		printf("    k11 = %2d.%03d\n\r", Integer(ccmCustom.K11), Fraction(ccmCustom.K11, 1000) );
		printf("    k12 = %2d.%03d\n\r", Integer(ccmCustom.K12), Fraction(ccmCustom.K12, 1000) );
		printf("    k13 = %2d.%03d\n\r", Integer(ccmCustom.K13), Fraction(ccmCustom.K13, 1000) );
		printf("    k21 = %2d.%03d\n\r", Integer(ccmCustom.K21), Fraction(ccmCustom.K21, 1000) );
		printf("    k22 = %2d.%03d\n\r", Integer(ccmCustom.K22), Fraction(ccmCustom.K22, 1000) );
		printf("    k23 = %2d.%03d\n\r", Integer(ccmCustom.K23), Fraction(ccmCustom.K23, 1000) );
		printf("    k31 = %2d.%03d\n\r", Integer(ccmCustom.K31), Fraction(ccmCustom.K31, 1000) );
		printf("    k32 = %2d.%03d\n\r", Integer(ccmCustom.K32), Fraction(ccmCustom.K32, 1000) );
		printf("    k33 = %2d.%03d\n\r", Integer(ccmCustom.K33), Fraction(ccmCustom.K33, 1000) );

		XCcm_GetRgbOffset(pInstance->pccm,  &ROffset, &GOffset, &BOffset);

		printf("    R offset = %d\n\r", (int)ROffset );
		printf("    G offset = %d\n\r", (int)GOffset );
		printf("    B offset = %d\n\r", (int)BOffset );
	} else if (!strcmp(cargv[1], "custom") && (cargc == 14)) {
		XCcm_Coefs ccmCustom;
		s32 ROffset, GOffset, BOffset;

		char *pArg;
		Xint32 negative;

		float fvalues[9];
		Xint32 ivalues[3];
		int i;

		for (i = 0; i < 12; i++) {
			pArg = cargv[2 + i];
			negative = 0;
			if (pArg[0] == '-') {
				pArg++;
				negative = 1;
			}
			if (pArg[0] == '+') {
				pArg++;
				negative = 0;
			}

			if (i < 9) {
				scanfloat(pArg, &fvalues[i]);
			if (negative) {
				fvalues[i] = -fvalues[i];
			}

			fvalues[i] = (fvalues[i] >= 8.0) ? 7.9999 : fvalues[i];
			fvalues[i] = (fvalues[i] <= -8.0) ? -7.9999 : fvalues[i];
			} else {
				scanhex(pArg, &ivalues[i - 9]);
				if (negative) {
					ivalues[i - 9] = -ivalues[i - 9];
				}

				ivalues[i - 9] = (ivalues[i - 9] >= 256) ? 255 : ivalues[i - 9];
				ivalues[i - 9] = (ivalues[i - 9] <= -256) ? -255 : ivalues[i - 9];
			}
		}

		ccmCustom.K11 = fvalues[0];
		ccmCustom.K12 = fvalues[1];
		ccmCustom.K13 = fvalues[2];
		ccmCustom.K21 = fvalues[3];
		ccmCustom.K22 = fvalues[4];
		ccmCustom.K23 = fvalues[5];
		ccmCustom.K31 = fvalues[6];
		ccmCustom.K32 = fvalues[7];
		ccmCustom.K33 = fvalues[8];

		ROffset = ivalues[0];
		GOffset = ivalues[1];
		BOffset = ivalues[2];

		XCcm_SetCoefMatrix(pInstance->pccm, &ccmCustom);
		XCcm_SetRgbOffset(pInstance->pccm, ROffset, GOffset, BOffset);

	} else if (!strcmp(cargv[1], "bypass")) {
		XCcm_SetCoefMatrix(pInstance->pccm, &CCM_IDENTITY);
		printf("  CCM = Bypass\r\n");
	} else if (!strcmp(cargv[1], "day")) {
		XCcm_SetCoefMatrix(pInstance->pccm, &CCM_RGB_DAY);
		printf("  CCM = Daylight\r\n");
	} else if (!strcmp(cargv[1], "cwf")) {
		XCcm_SetCoefMatrix(pInstance->pccm, &CCM_RGB_CWF);
		printf("  CCM = CoolWhiteFluorescent\r\n");
	} else if (!strcmp(cargv[1], "u30")) {
		XCcm_SetCoefMatrix(pInstance->pccm, &CCM_RGB_U30);
		printf("  CCM = 3000K\r\n");
	} else if (!strcmp(cargv[1], "inc")) {
		XCcm_SetCoefMatrix(pInstance->pccm, &CCM_RGB_INC);
		printf("  CCM = Incandescent\r\n");
	} else {
		bDispSyntax = 1;
	}

	if (bDispSyntax) {
		printf("  Syntax :\r\n" );
		printf("    %s                                         => ...\r\n", cargv[0] );
		printf("    %s custom {...}                            => Set custom CCM coefficient\r\n", cargv[0] );
		printf("    %s bypass                                  => Set CCM to Bypass\r\n", cargv[0] );
		printf("    %s day                                     => Set CCM to Daylight\r\n", cargv[0] );
		printf("    %s cwf                                     => Set CCM to CoolWhiteFluorescent\r\n", cargv[0] );
		printf("    %s u30                                     => Set CCM to 3000K\r\n", cargv[0] );
		printf("    %s inc                                     => Set CCM to Incandescent\r\n", cargv[0] );
	}

	return;
}

void avnet_console_command_process(void *pInstance, int cargc, char ** cargv) {
	if (!strcmp(cargv[0], "help")) {
		avnet_console_command_help();
	}
	else if ( !strcmp(cargv[0], "iic") )
	{
	  avnet_console_command_iic((demo_t *)pInstance, cargc, cargv);
	}
	else if ( !strcmp(cargv[0], "cfg") )
	{
	  avnet_console_command_cfg((demo_t *)pInstance, cargc, cargv);
	}
	else if ( !strcmp(cargv[0], "ccm") )
	{
	 avnet_console_command_ccm((demo_t *)pInstance, cargc, cargv);
	}
	else
	{
	 printf("  Unknown command : %s\n\r", cargv[0] );
	}

}

int main () {
	int status;

	XGpioPs_Config *pgpiops_config;
	XIicPs_Config *piicps_config;
	XCfa_Config *pcfa_config;
	XCcm_Config *pccm_config;
	XRgb2YCrCb_Config *prgb2ycrcb_config;
	XCresample_Config *pcresample_config;
	XAxiVdma_Config *paxivdma_config;
	XVtc_Config *pvtc_config;
	XOSD_Config *posd_config;

	demo_t *pdemo = malloc(sizeof(demo_t));
	pdemo->pgpiops = malloc(sizeof(XGpioPs));
	pdemo->piicps = malloc(sizeof(XIicPs));
	pdemo->pcfa = malloc(sizeof(XCfa));
	pdemo->pccm = malloc(sizeof(XCcm));
	pdemo->prgb2ycrcb = malloc(sizeof(XRgb2YCrCb));
	pdemo->pcresample = malloc(sizeof(XCresample));
	pdemo->paxivdma = malloc(sizeof(XAxiVdma));
	pdemo->pvtc = malloc(sizeof(XVtc));
	pdemo->posd = malloc(sizeof(XOsd));

	pgpiops_config = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
	XGpioPs_CfgInitialize(pdemo->pgpiops, pgpiops_config, pgpiops_config->BaseAddr);

	piicps_config = XIicPs_LookupConfig(XPAR_XIICPS_0_DEVICE_ID);
	XIicPs_CfgInitialize(pdemo->piicps, piicps_config, piicps_config->BaseAddress);

	pcfa_config = XCfa_LookupConfig(XPAR_CFA_0_DEVICE_ID);
	XCfa_CfgInitialize(pdemo->pcfa, pcfa_config, pcfa_config->BaseAddress);

	pccm_config = XCcm_LookupConfig(XPAR_CCM_0_DEVICE_ID);
	XCcm_CfgInitialize(pdemo->pccm, pccm_config, pccm_config->BaseAddress);

	prgb2ycrcb_config = XRgb2YCrCb_LookupConfig(XPAR_RGB2YCRCB_0_DEVICE_ID);
	XRgb2YCrCb_CfgInitialize(pdemo->prgb2ycrcb, prgb2ycrcb_config, prgb2ycrcb_config->BaseAddress);

	pcresample_config = XCresample_LookupConfig(XPAR_RGB2YCRCB_0_DEVICE_ID);
	XCresample_CfgInitialize(pdemo->pcresample, pcresample_config, pcresample_config->BaseAddress);

	paxivdma_config = XAxiVdma_LookupConfig(XPAR_AXIVDMA_0_DEVICE_ID);
	XAxiVdma_CfgInitialize(pdemo->paxivdma, paxivdma_config, paxivdma_config->BaseAddress);

	pvtc_config = XVtc_LookupConfig(XPAR_VTC_0_DEVICE_ID);
	XVtc_CfgInitialize(pdemo->pvtc, pvtc_config, pvtc_config->BaseAddress);

	posd_config = XOsd_LookupConfig(XPAR_OSD_0_DEVICE_ID);
	XOsd_CfgInitialize(pdemo->posd, posd_config, posd_config->BaseAddress);

	XIicPs_Reset(pdemo->piicps);
	XIicPs_SetSClk(pdemo->piicps, 100000);

	XGpioPs_SetDirection(pdemo->pgpiops, 2, 0xFFFFFFFF);
	XGpioPs_SetOutputEnable(pdemo->pgpiops, 2, 0xFFFFFFFF);

	XGpioPs_WritePin(pdemo->pgpiops, 54, 0);
	usleep(4000);
	XGpioPs_WritePin(pdemo->pgpiops, 54, 1);

	/* I2C MUX Reset */
	tca9548_i2c_mux_select(pdemo->piicps, EMBV_IIC_MUX_I2CIO);
	status = 0x08;
	pca9534_set_pins_direction(pdemo->piicps, status);
	pca9534_set_pin_value(pdemo->piicps, 7, 1);		/* Disable I2C MUX Reset */

	/* HDMI Ouput Initialization */
	tca9548_i2c_mux_select(pdemo->piicps, EMBV_IIC_MUX_I2CIO);
	pca9534_set_pin_value(pdemo->piicps, 4, 0);		/* Disable HDMI Output Power Down */

	tca9548_i2c_mux_select(pdemo->piicps, EMBV_IIC_MUX_HDMIO);
	adv7511_configure(pdemo->piicps);

	avnet_config_1080p60_video(pdemo);

	printf("System Ready\r\n");

	print_avnet_console_serial_app_header();
	start_avnet_console_serial_application((void *)pdemo, &avnet_console_command_process);

	while (1) {
		if (transfer_avnet_console_serial_data()) {
			break;
		}
	}

	return XST_SUCCESS;
}

/*
 * main.c
 *
 *  Created on: Aug 1, 2014
 *      Author: 910560
 */

#include "xparameters.h"
#include "xiicps.h"
#include "xiicps_ext.h"
#include "pca9534.h"
#include "tca9548.h"
#include "tcm5117pl.h"
#include "adv7511.h"
#include "xil_io.h"
#include "xaxivdma.h"
#include "xaxivdma_ext.h"
#include "xosd.h"
#include "xcfa.h"
#include "xccm.h"
#include "ccm_ext.h"
#include "demo.h"

#include "xdebug.h"

demo_t demo;
demo_t *pdemo;

int main() {
	int status;

	XIicPs_Config *piicps_config;
	XCfa_Config *pcfa_config;
	XCcm_Config *pccm_config;
	XAxiVdma_Config *paxivdma_config;
	XOSD_Config *posd_config;

	pdemo = &demo;
	pdemo->piicps0 = &(pdemo->iicps0);
	pdemo->pcfa = &(pdemo->cfa);
	pdemo->pccm = &(pdemo->ccm);
	pdemo->paxivdma = &(pdemo->axivdma);
	pdemo->posd = &(pdemo->osd);

	piicps_config = XIicPs_LookupConfig(XPAR_XIICPS_0_DEVICE_ID);
	XIicPs_CfgInitialize(pdemo->piicps0, piicps_config,
			piicps_config->BaseAddress);
	XIicPs_Reset(pdemo->piicps0);
	XIicPs_SetSClk(pdemo->piicps0, 100000);

	paxivdma_config = XAxiVdma_LookupConfig(XPAR_AXIVDMA_0_DEVICE_ID);
	XAxiVdma_CfgInitialize(pdemo->paxivdma, paxivdma_config,
			paxivdma_config->BaseAddress);

	pcfa_config = XCfa_LookupConfig(XPAR_CFA_0_DEVICE_ID);
	XCfa_CfgInitialize(pdemo->pcfa, pcfa_config, pcfa_config->BaseAddress);

	pccm_config = XCcm_LookupConfig(XPAR_CCM_0_DEVICE_ID);
	XCcm_CfgInitialize(pdemo->pccm, pccm_config, pccm_config->BaseAddress);

	posd_config = XOSD_LookupConfig(XPAR_OSD_0_DEVICE_ID);
	XOSD_CfgInitialize(pdemo->posd, posd_config, posd_config->BaseAddress);

	// I2C MUX Reset
	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_I2CIO);
	status = 0x08;
	pca9534_set_pins_direction(pdemo->piicps0, status);
	pca9534_set_pin_value(pdemo->piicps0, 7, 1);		// Disable I2C MUX Reset

	// HDMI Ouput Initialization
	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_I2CIO);
	pca9534_set_pin_value(pdemo->piicps0, 4, 0);// Disable HDMI Output Power Down

	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_HDMIO);
	adv7511_configure(pdemo->piicps0);

	// ISERDES Reset Assert
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);

	// TCM Initialization
	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_CAM);
	tcm5117pl_get_chip_id(pdemo->piicps0);
	tcm5117pl_init(pdemo->piicps0, TCM5117PL_1080P60);

	// CFA
	XCfa_Reset(pdemo->pcfa);
	XCfa_SetBayerPhase(pdemo->pcfa, 0x00000001);
	XCfa_RegUpdateEnable(pdemo->pcfa);
	XCfa_Enable(pdemo->pcfa);

	// CCM
	XCcm_Reset(pdemo->pccm);
	XCcm_RegUpdateEnable(pdemo->pccm);
	XCcm_Enable(pdemo->pccm);
	XCcm_SetCoefMatrix(pdemo->pccm, &CCM_IDENTITY);
	XCcm_SetRgbOffset(pdemo->pccm, 0, 0, 0);

	xil_printf("VDMA Initialization\r\n");
	XAxiVdma_Reset(pdemo->paxivdma, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pdemo->paxivdma, XAXIVDMA_READ);
	ReadSetup(pdemo->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
			2048);
	WriteSetup(pdemo->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
			2048);
	StartTransfer(pdemo->paxivdma);
//	StartReadTransfer(pdemo->paxivdma);

	xil_printf("OSD Initialization\r\n");
	XOSD_Reset(pdemo->posd);
	XOSD_RegUpdateEnable(pdemo->posd);
	XOSD_Enable(pdemo->posd);

	XOSD_SetScreenSize(pdemo->posd, 1920, 1080);
	XOSD_SetBackgroundColor(pdemo->posd, 0x80, 0x80, 0x80);

	// Layer 0 - Test Pattern Generator
	XOSD_SetLayerPriority(pdemo->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pdemo->posd, 0, 1, 0xFF);
	XOSD_SetLayerDimension(pdemo->posd, 0, 0, 0, 1920, 1080);

	XOSD_EnableLayer(pdemo->posd, 0);

	// ISERDES Reset De-Assert
	Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);


	printf("System Ready\r\n");


	print_avnet_console_serial_app_header();
	start_avnet_console_serial_application();

	while (1)
	{
		if (transfer_avnet_console_serial_data()) {
			break;
		}
	}

	return 0;

}
//
//#define IIC_TCM5117PL_SADR   0x3C
//
//	char inchar;
//
//	while (1) {
//		inchar = inbyte();
//
//		if (inchar == 't') {
//			static testmode = 0;
//			testmode++;
//			testmode &= 0x3;
//			status = testmode;
//
//			tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_CAM);
//			XIicPs_A16_Write(pdemo->piicps0, IIC_TCM5117PL_SADR, 0x0601,
//					(u8 *) &status, 1);
//			status = 0;
//			XIicPs_A16_Read(pdemo->piicps0, IIC_TCM5117PL_SADR, 0x0601, (u8 *) &status,
//					1);
//			printf("[0x%04x]: 0x%04X\r\n", 0x301D, status);
//		}
//
//		if (inchar == 'r') {
//			Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);
//			usleep(100);
//			Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);
//		}
//
//		if (inchar == 'c') {
//			static cfamode = 0;
//			cfamode++;
//			cfamode &= 0x3;
//			status = cfamode;
//
//			CFA_Reset(XPAR_CFA_0_BASEADDR);
//			CFA_WriteReg(XPAR_CFA_0_BASEADDR, 0x0100, status);
//			CFA_RegUpdateEnable(XPAR_CFA_0_BASEADDR);
//			CFA_Enable(XPAR_CFA_0_BASEADDR);
//		}
//
//		if (inchar == '0') {
//			Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);
//
//			XAxiVdma_Reset(pdemo->paxivdma, XAXIVDMA_WRITE);
//			XAxiVdma_Reset(pdemo->paxivdma, XAXIVDMA_READ);
//			ReadSetup(pdemo->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
//					2048);
//			WriteSetup(pdemo->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
//					2048);
//			StartTransfer(pdemo->paxivdma);
//
//			tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_CAM);
//			tcm5117pl_init(pdemo->piicps0, TCM5117PL_1080P15);
//
//			Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);
//		}
//
//		if (inchar == '1') {
//			Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0001);
//
//			XAxiVdma_Reset(pdemo->paxivdma, XAXIVDMA_WRITE);
//			XAxiVdma_Reset(pdemo->paxivdma, XAXIVDMA_READ);
//			ReadSetup(pdemo->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
//					2048);
//			WriteSetup(pdemo->paxivdma, 0x30000000, 2, 0, 1, 1, 0, 0, 1920, 1080, 2048,
//					2048);
//			StartTransfer(pdemo->paxivdma);
//
//			tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_CAM);
//			tcm5117pl_init(pdemo->piicps0, TCM5117PL_1080P60);
//
//			Xil_Out32(XPAR_TCM_RECEIVER_0_S00_AXI_BASEADDR + 0x0000, 0x0000);
//		}
//
//	}
//
//	return 0;
//}

/*
 * main.c
 *
 *  Created on: Aug 1, 2014
 *      Author: 910560
 */

#include "xparameters.h"
#include "xiicps.h"
#include "xiicps_ext.h"
#include "xtpg.h"
#include "pca9534.h"
#include "tca9548.h"
#include "adv7511.h"
#include "xaxivdma.h"
#include "xaxivdma_ext.h"
#include "xosd.h"
#include "onsemi_python_sw.h"
	#define onsemi_python_t	onsemi_vita_t
#include "xcfa.h"
#include "cat9554.h"

#define EMBV_IIC_MUX_I2CIO      TCA9548_I2C0_SEL
#define EMBV_IIC_MUX_HDMII      TCA9548_I2C1_SEL
#define EMBV_IIC_MUX_HDMIO      TCA9548_I2C2_SEL
#define EMBV_IIC_MUX_HDMIO_DDC  TCA9548_I2C3_SEL
#define EMBV_IIC_MUX_AUD        TCA9548_I2C4_SEL
#define EMBV_IIC_MUX_CAM        TCA9548_I2C5_SEL

typedef struct {
	XIicPs iicps0;
	XAxiVdma axivdma0;
	XAxiVdma axivdma1;
	XOSD osd;
	XTpg tpg;
	XCfa cfa;
	onsemi_python_t python_receiver;

	XIicPs *piicps0;
	XAxiVdma *paxivdma0;
	XAxiVdma *paxivdma1;
	XOSD *posd;
	XTpg *ptpg;
	XCfa *pcfa;
	onsemi_python_t *pPython_receiver;

} demo_t;

demo_t demo;
demo_t *pdemo;

int main()
{
	int status;
	u8 camera_alpha = 0xFF;
	u8 tpg_alpha = 0x00;
	char c;

	pdemo = &demo;
	pdemo->piicps0 = &(pdemo->iicps0);
	pdemo->paxivdma0 = &(pdemo->axivdma0);
	pdemo->paxivdma1 = &(pdemo->axivdma1);
	pdemo->posd = &(pdemo->osd);
	pdemo->ptpg = &(pdemo->tpg);
	pdemo->pcfa = &(pdemo->cfa);
	pdemo->pPython_receiver = &(pdemo->python_receiver);

	XIicPs_Config *piicps_config;
	XAxiVdma_Config *paxivdma_config;
	XOSD_Config *posd_config;
	XTpg_Config *ptpg_config;
	XCfa_Config *pcfa_config;

	xil_printf("\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("--            Embedded Vision Carrier Card          --\n\r");
	xil_printf("--               PYTHON-1300-C Design               --\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("\n\r");

	piicps_config = XIicPs_LookupConfig(XPAR_XIICPS_0_DEVICE_ID);
	XIicPs_CfgInitialize(pdemo->piicps0, piicps_config,
			piicps_config->BaseAddress);
	XIicPs_Reset(pdemo->piicps0);
	XIicPs_SetSClk(pdemo->piicps0, 100000);

	paxivdma_config = XAxiVdma_LookupConfig(XPAR_AXIVDMA_0_DEVICE_ID);
	XAxiVdma_CfgInitialize(pdemo->paxivdma0, paxivdma_config,
			paxivdma_config->BaseAddress);

	paxivdma_config = XAxiVdma_LookupConfig(XPAR_AXIVDMA_1_DEVICE_ID);
	XAxiVdma_CfgInitialize(pdemo->paxivdma1, paxivdma_config,
			paxivdma_config->BaseAddress);

	posd_config = XOSD_LookupConfig(XPAR_OSD_0_DEVICE_ID);
	XOSD_CfgInitialize(pdemo->posd, posd_config, posd_config->BaseAddress);

	ptpg_config = XTpg_LookupConfig(XPAR_V_TPG_0_DEVICE_ID);
	XTpg_CfgInitialize(pdemo->ptpg, ptpg_config, ptpg_config->BaseAddress);

	pcfa_config = XCfa_LookupConfig(XPAR_V_CFA_0_DEVICE_ID);
	XCfa_CfgInitialize(pdemo->pcfa, pcfa_config, pcfa_config->BaseAddress);

	onsemi_python_init(pdemo->pPython_receiver, "PYTHON-1300-C",
			XPAR_ONSEMI_PYTHON_SPI_0_S00_AXI_BASEADDR,
			XPAR_ONSEMI_PYTHON_CAM_0_S00_AXI_BASEADDR);
	onsemi_python_spi_config(pdemo->pPython_receiver,
			4);
	pdemo->pPython_receiver->uManualTap = 25; // IDELAY setting (0-31)

while (1)
{

	xil_printf("HDMI Initialization\r\n");

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

    xil_printf("PYTHON Initialization\r\n");

	// Camera Power Sequence
	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_CAM);
	cat9554_initialize(pdemo->piicps0);
	usleep(10);

	// Make sure all disable first
	cat9554_vddpix_off(pdemo->piicps0);
	usleep(10);
	cat9554_vdd33_off(pdemo->piicps0);
	usleep(10);
	cat9554_vdd18_off(pdemo->piicps0);
	usleep(1000);

	// Turn them on one by one
	cat9554_vdd18_en(pdemo->piicps0);
	usleep(10);
	cat9554_vdd33_en(pdemo->piicps0);
	usleep(10);
	cat9554_vddpix_en(pdemo->piicps0);
	usleep(10);

	onsemi_python_sensor_initialize(
			pdemo->pPython_receiver, SENSOR_INIT_ENABLE, 0);
	onsemi_python_sensor_initialize(
			pdemo->pPython_receiver, SENSOR_INIT_STREAMON, 0);
	onsemi_python_sensor_cds(pdemo->pPython_receiver, 0);
	onsemi_python_cam_reg_write(pdemo->pPython_receiver,
			ONSEMI_PYTHON_CAM_SYNCGEN_HTIMING1_REG, 0x00300500);

	xil_printf("CFA Initialization\r\n");
	XCfa_Reset(pdemo->pcfa);
	//XCfa_WriteReg(pdemo->pcfa, CFA_BAYER_PHASE, 0x00);
	XCfa_SetBayerPhase(pdemo->pcfa, XCFA_RGRG_COMBINATION);
	XCfa_RegUpdateEnable(pdemo->pcfa);
	XCfa_Enable(pdemo->pcfa);

	xil_printf("TPG Initialization\r\n");
	XTpg_Reset(pdemo->ptpg);
	XTpg_WriteReg(pdemo->ptpg, TPG_PATTERN_CONTROL, 0x100A);
	XTpg_WriteReg(pdemo->ptpg, TPG_MOTION_SPEED, 0x1);
	XTpg_WriteReg(pdemo->ptpg, TPG_CONTROL, 0x2);
	//XTpg_SetPattern(pdemo->ptpg, 0x100A);
	//XTpg_SetMotionSpeed(pdemo->ptpg, 0x1);
	XTpg_Enable(pdemo->ptpg);

	xil_printf("VDMA 0 Initialization\r\n");
	XAxiVdma_Reset(pdemo->paxivdma0, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pdemo->paxivdma0, XAXIVDMA_READ);
	WriteSetup(pdemo->paxivdma0, 0x10000000, 0, 1, 1, 0, 0, 1280, 1024, 2048,
			2048);
	ReadSetup(pdemo->paxivdma0, 0x10000000, 0, 1, 1, 0, 0, 1280, 1024, 2048,
			2048);
	StartTransfer(pdemo->paxivdma0);

	xil_printf("VDMA 1 Initialization\r\n");
	XAxiVdma_Reset(pdemo->paxivdma1, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pdemo->paxivdma1, XAXIVDMA_READ);
	WriteSetup(pdemo->paxivdma1, 0x18000000, 0, 1, 1, 0, 0, 1280, 1024, 2048,
			2048);
	ReadSetup(pdemo->paxivdma1, 0x18000000, 0, 1, 1, 0, 0, 1280, 1024, 2048,
			2048);
	StartTransfer(pdemo->paxivdma1);

	xil_printf("OSD Initialization (camera=0x%02X, tpg=0x%02X)\r\n", camera_alpha, tpg_alpha);
	XOSD_Reset(pdemo->posd);
	XOSD_RegUpdateEnable(pdemo->posd);
	XOSD_Enable(pdemo->posd);

	XOSD_SetScreenSize(pdemo->posd, 1280, 1024);
	XOSD_SetBackgroundColor(pdemo->posd, 0x80, 0x80, 0x80);

	// Layer 0 - Test Pattern Generator
	XOSD_SetLayerPriority(pdemo->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pdemo->posd, 0, 1, tpg_alpha);
	XOSD_SetLayerDimension(pdemo->posd, 0, 0, 0, 1280, 1024);

	// Layer 1 - PYTHON-1300 camera
	XOSD_SetLayerPriority(pdemo->posd, 1, XOSD_LAYER_PRIORITY_1);
	XOSD_SetLayerAlpha(pdemo->posd, 1, 1, camera_alpha);
	XOSD_SetLayerDimension(pdemo->posd, 1, 0, 0, 1280, 1024);

	XOSD_EnableLayer(pdemo->posd, 0);
	XOSD_EnableLayer(pdemo->posd, 1);

	xil_printf("System Ready!\r\n");

    xil_printf("\r\n\tPress 0-9 to change alpha blending of camera/tpg layers\r\n");
	xil_printf("\r\n\tPress ENTER to restart\r\n\r\n" );
	c = getchar();

	if ( c >= '0' && c <= '9' )
	{
		camera_alpha = (c - '0') * 28;
		tpg_alpha    = ('9' - c) * 28;
	}

	if ( c == '+' )
	{
		if ( pdemo->pPython_receiver->uManualTap < 31 )
			pdemo->pPython_receiver->uManualTap++;
		xil_printf( "\tuManualTap = %d\n\r", pdemo->pPython_receiver->uManualTap );
	}
	if ( c == '-' )
	{
		if ( pdemo->pPython_receiver->uManualTap > 0 )
			pdemo->pPython_receiver->uManualTap--;
		xil_printf( "\tuManualTap = %d\n\r", pdemo->pPython_receiver->uManualTap );
	}

}

	return 0;
}

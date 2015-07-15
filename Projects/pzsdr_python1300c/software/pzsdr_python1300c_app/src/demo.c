
#include "demo.h"

int demo_init( demo_t *pdemo )
{
	int status;

	pdemo->paxivdma0 = &(pdemo->axivdma0);
	pdemo->paxivdma1 = &(pdemo->axivdma1);
	pdemo->posd = &(pdemo->osd);
	pdemo->pcfa = &(pdemo->cfa);
	pdemo->ptpg = &(pdemo->tpg);
	pdemo->pfmc_hdmi_cam_iic = &(pdemo->fmc_hdmi_cam_iic);
	pdemo->ppython_receiver = &(pdemo->python_receiver);

	pdemo->cam_alpha = 0xFF;
	pdemo->tpg_alpha = 0x00;

	pdemo->bVerbose = 0;

	XAxiVdma_Config *paxivdma_config;
	XOSD_Config *posd_config;
	XCfa_Config *pcfa_config;
	XTpg_Config *ptpg_config;

	paxivdma_config = XAxiVdma_LookupConfig(XPAR_AXIVDMA_0_DEVICE_ID);
	XAxiVdma_CfgInitialize(pdemo->paxivdma0, paxivdma_config,
			paxivdma_config->BaseAddress);

	paxivdma_config = XAxiVdma_LookupConfig(XPAR_AXIVDMA_1_DEVICE_ID);
	XAxiVdma_CfgInitialize(pdemo->paxivdma1, paxivdma_config,
			paxivdma_config->BaseAddress);

	posd_config = XOSD_LookupConfig(XPAR_OSD_0_DEVICE_ID);
	XOSD_CfgInitialize(pdemo->posd, posd_config, posd_config->BaseAddress);

	pcfa_config = XCfa_LookupConfig(XPAR_V_CFA_0_DEVICE_ID);
	XCfa_CfgInitialize(pdemo->pcfa, pcfa_config, pcfa_config->BaseAddress);

	ptpg_config = XTpg_LookupConfig(XPAR_V_TPG_0_DEVICE_ID);
	XTpg_CfgInitialize(pdemo->ptpg, ptpg_config, ptpg_config->BaseAddress);

   status = fmc_iic_xps_init(pdemo->pfmc_hdmi_cam_iic,"PZSDR FMCCC I2C Controller", XPAR_PZSDR_FMCCC_IIC_0_BASEADDR );
   if ( !status )
   {
	  xil_printf( "ERROR : Failed to open FMC-IIC driver\n\r" );
	  exit(0);
   }


   // Configure I2C Mux for I2C_ADV7511
   tca9548_i2c_mux_select(pdemo->pfmc_hdmi_cam_iic, TCA9548_I2C2_SEL); // I2C_ADV7511

   // HDMI initialization
   xil_printf("HDMI Initialization\r\n");
   adv7511_configure(pdemo->pfmc_hdmi_cam_iic);

   // Default PYTHON settings
   pdemo->uManualTap = 25;
   pdemo->uSamplePoint = 3;

    return 1;
}

int demo_start_tpg_in( demo_t *pdemo )
{
	xil_printf("TPG Initialization\r\n");
	XTpg_Reset(pdemo->ptpg);
	XTpg_WriteReg(pdemo->ptpg, TPG_PATTERN_CONTROL, 0x100A);
	XTpg_WriteReg(pdemo->ptpg, TPG_MOTION_SPEED, 0x1);
	XTpg_WriteReg(pdemo->ptpg, TPG_CONTROL, 0x2);
	//XTpg_SetPattern(pdemo->ptpg, 0x100A);
	//XTpg_SetMotionSpeed(pdemo->ptpg, 0x1);
	XTpg_Enable(pdemo->ptpg);

	return 1;
}

int demo_start_cam_in( demo_t *pdemo )
{
	int status;

    // PYTHON Receiver Initialization
    xil_printf( "PYTHON Receiver Initialization ...\n\r" );
	onsemi_python_init(pdemo->ppython_receiver, "PYTHON-1300-C",
			XPAR_ONSEMI_PYTHON_SPI_0_S00_AXI_BASEADDR,
			XPAR_ONSEMI_PYTHON_CAM_0_S00_AXI_BASEADDR);
	pdemo->ppython_receiver->uManualTap = pdemo->uManualTap; // IDELAY setting (0-31)
    xil_printf( "FMC-IMAGEON VITA SPI Config for 10MHz ...\n\r" );
    // axi4lite_0_clk = 75MHz
    onsemi_python_spi_config( pdemo->ppython_receiver, (75000000/10000000) );

    // PYTHON Initialization
    xil_printf( "PYTHON Initialization ...\n\r" );

    // Configure I2C Mux for I2C_CAMERA
    tca9548_i2c_mux_select(pdemo->pfmc_hdmi_cam_iic, TCA9548_I2C4_SEL); // I2C_CAMERA

	// Camera Power Sequence
	cat9554_initialize(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);

	cat9554_vdd18_en(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);
	cat9554_vdd33_en(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);
	cat9554_vddpix_en(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);

	onsemi_python_sensor_initialize(
			pdemo->ppython_receiver, SENSOR_INIT_ENABLE, pdemo->bVerbose);
	onsemi_python_cam_reg_write(pdemo->ppython_receiver,
			ONSEMI_PYTHON_CAM_SYNCGEN_HTIMING1_REG, 0x00300500);
	onsemi_python_sensor_cds(pdemo->ppython_receiver, pdemo->bVerbose);

	xil_printf("CFA Initialization\r\n");
	XCfa_Reset(pdemo->pcfa);
	XCfa_RegUpdateEnable(pdemo->pcfa);
	XCfa_Enable(pdemo->pcfa);

	//XCfa_WriteReg(pdemo->pcfa, CFA_BAYER_PHASE, 0x00);
	XCfa_SetBayerPhase(pdemo->pcfa, XCFA_RGRG_COMBINATION);
	XCfa_SetActiveSize(pdemo->pcfa, 1280, 1024);

	return 1;
}

int demo_init_frame_buffer( demo_t *pdemo )
{

	   // Clear frame stores
	   if ( pdemo->bVerbose )
	   {
		   xil_printf( "Video Frame Buffer Initialization ...\n\r" );
	   }
	   Xuint32 frame, row, col;
	   Xuint16 pixel;
	   volatile Xuint16 *pStorageMem;

	   // Fill HDMI frame buffer with Gray ramps
	   pStorageMem = (Xuint16 *)0x10000000;
	   volatile Xuint16 *pStorageMem2 = (Xuint16 *)0x18000000;
	   for ( frame = 0; frame < 3; frame++ )
	   {
		  //for ( row = 0; row < pdemo->hdmio_height; row++ )
		  for ( row = 0; row < 2048; row++ )
		  {
			 //for ( col = 0; col < pdemo->hdmio_width; col++ )
			  for ( col = 0; col < 2048; col++ )
			 {
				pixel = 0x8000 | (col & 0x00FF); // Grey ramp
				*pStorageMem++ = pixel;
			 }
		  }
	   }

	   // Fill Camera frame buffer with green screen
	   pStorageMem = (Xuint16 *)0x18000000;
	   for ( frame = 0; frame < 3; frame++ )
	   {
		  //for ( row = 0; row < pdemo->hdmio_height; row++ )
		  for ( row = 0; row < 2048; row++ )
		  {
			 //for ( col = 0; col < pdemo->hdmio_width; col++ )
			  for ( col = 0; col < 2048; col++ )
			 {
				pixel = 0x0000; // Green
				*pStorageMem++ = pixel;
			 }
		  }
	   }

	   // Wait for DMA to synchronize
	   Xil_DCacheFlush();


	return 1;
}

int demo_stop_frame_buffer( demo_t *pdemo )
{
	StopTransfer(pdemo->paxivdma0);
	StopTransfer(pdemo->paxivdma1);

	return 1;
}

int demo_start_frame_buffer( demo_t *pdemo )
{

	xil_printf("VDMA 0 Initialization\r\n");
	XAxiVdma_Reset(pdemo->paxivdma0, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pdemo->paxivdma0, XAXIVDMA_READ);
	WriteSetup(pdemo->paxivdma0, 0x10000000, 0, 1, 1, 0, 0, 1280, 1024, 2048, 2048);
	ReadSetup(pdemo->paxivdma0, 0x10000000, 0, 1, 1, 0, 0, 1280, 1024, 2048, 2048);
	StartTransfer(pdemo->paxivdma0);

	xil_printf("VDMA 1 Initialization\r\n");
	XAxiVdma_Reset(pdemo->paxivdma1, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pdemo->paxivdma1, XAXIVDMA_READ);
	WriteSetup(pdemo->paxivdma1, 0x18000000, 0, 1, 1, 0, 0, 1280, 1024, 2048, 2048);
	ReadSetup(pdemo->paxivdma1, 0x18000000, 0, 1, 1, 0, 0, 1280, 1024, 2048, 2048);
	StartTransfer(pdemo->paxivdma1);

	xil_printf("OSD Initialization (hdmi=0x%02X, cam=0x%02X)\r\n", pdemo->tpg_alpha, pdemo->cam_alpha);
	XOSD_Reset(pdemo->posd);
	XOSD_RegUpdateEnable(pdemo->posd);
	XOSD_Enable(pdemo->posd);

	XOSD_SetScreenSize(pdemo->posd,1280, 1024);
	XOSD_SetBackgroundColor(pdemo->posd, 0x80, 0x80, 0x80);

	// Layer 0 - TEST input
	XOSD_SetLayerPriority(pdemo->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pdemo->posd, 0, 1, pdemo->tpg_alpha);
	XOSD_SetLayerDimension(pdemo->posd, 0, 0, 0, 1280, 1024);

	// Layer 1 - PYTHON-1300 camera
	XOSD_SetLayerPriority(pdemo->posd, 1, XOSD_LAYER_PRIORITY_1);
	XOSD_SetLayerAlpha(pdemo->posd, 1, 1, pdemo->cam_alpha);
	XOSD_SetLayerDimension(pdemo->posd, 1, 0, 0, 1280, 1024);

	XOSD_EnableLayer(pdemo->posd, 0);
	XOSD_EnableLayer(pdemo->posd, 1);

	return 1;
}

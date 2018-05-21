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
// Module Name:         demo.c
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

#include "demo.h"

int demo_init( demo_t *pdemo )
{
	int status;

	pdemo->paxivdma0 = &(pdemo->axivdma0);
	pdemo->paxivdma1 = &(pdemo->axivdma1);
	pdemo->posd = &(pdemo->osd);
	pdemo->pcfa = &(pdemo->cfa);
	pdemo->pfmc_hdmi_cam_iic = &(pdemo->fmc_hdmi_cam_iic);
	pdemo->pfmc_hdmi_cam = &(pdemo->fmc_hdmi_cam);
	pdemo->ppython_receiver = &(pdemo->python_receiver);

	// general command settings
	pdemo->bVerbose = 0;

    // fmc-hami-cam commands
    pdemo->adv7611_llc_polarity = 1;
    pdemo->adv7611_llc_delay = 0;

	// cam command settings
	pdemo->cam_aec = 0; // off
	pdemo->cam_again = 0; // 1.0
	pdemo->cam_dgain = 128; // 1.0
	pdemo->cam_exposure = 90; // 90% of frame period

	// start command settings
	pdemo->cam_alpha = 0xFF;
	pdemo->hdmi_alpha = 0x00;

	// video ip command settings
	pdemo->cam_bayer = XCFA_RGRG_COMBINATION;

	XAxiVdma_Config *paxivdma_config;
	XOSD_Config *posd_config;
	XCfa_Config *pcfa_config;

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

   xil_printf( "FMC-HDMI-CAM Initialization ...\n\r" );

   status = fmc_iic_xps_init(pdemo->pfmc_hdmi_cam_iic,"FMC-HDMI-CAM I2C Controller", XPAR_FMC_HDMI_CAM_IIC_0_BASEADDR );
   if ( !status )
   {
	  xil_printf( "ERROR : Failed to open FMC-IIC driver\n\r" );
	  exit(0);
   }

   fmc_hdmi_cam_init(pdemo->pfmc_hdmi_cam, "FMC-HDMI-CAM", pdemo->pfmc_hdmi_cam_iic);
   pdemo->pfmc_hdmi_cam->bVerbose = pdemo->bVerbose;

   // Configure Video Clock Synthesizer
   xil_printf( "Video Clock Synthesizer Configuration ...\n\r" );
   fmc_hdmi_cam_vclk_init( pdemo->pfmc_hdmi_cam );
   fmc_hdmi_cam_vclk_config( pdemo->pfmc_hdmi_cam, FMC_HDMI_CAM_VCLK_FREQ_148_500_000);
   sleep(1);

    // Set HDMI output to 1080P60
    pdemo->hdmio_width  = 1920;
    pdemo->hdmio_height = 1080;

    //pDemo->hdmio_timing.IsHDMI        = 1; // HDMI Mode
    pdemo->hdmio_timing.IsHDMI        = 0; // DVI Mode
    pdemo->hdmio_timing.IsEncrypted   = 0;
    pdemo->hdmio_timing.IsInterlaced  = 0;
    pdemo->hdmio_timing.ColorDepth    = 8;

    pdemo->hdmio_timing.HActiveVideo  = 1920;
    pdemo->hdmio_timing.HFrontPorch   =   88;
    pdemo->hdmio_timing.HSyncWidth    =   44;
    pdemo->hdmio_timing.HSyncPolarity =    1;
    pdemo->hdmio_timing.HBackPorch    =  148;
    pdemo->hdmio_timing.VBackPorch    =   36;

    pdemo->hdmio_timing.VActiveVideo  = 1080;
    pdemo->hdmio_timing.VFrontPorch   =    4;
    pdemo->hdmio_timing.VSyncWidth    =    5;
    pdemo->hdmio_timing.VSyncPolarity =    1;

    xil_printf( "HDMI Output Initialization ...\n\r" );
    status = fmc_hdmi_cam_hdmio_init( pdemo->pfmc_hdmi_cam,
  	                             1,                      // hdmioEnable = 1
  	                             &(pdemo->hdmio_timing), // pTiming
  	                             0                       // waitHPD = 0
  	                             );
    if ( !status )
    {
       xil_printf( "ERROR : Failed to init HDMI Output Interface\n\r" );
       return 0;
    }

    // Default HDMI input resolution
 	pdemo->hdmii_width = pdemo->hdmio_width;
 	pdemo->hdmii_height = pdemo->hdmio_height;


    return 1;
}

int demo_start_hdmi_in( demo_t *pdemo )
{
	int status;
    Xuint32 timeout = 100;

	xil_printf("HDMI Input Initialization\r\n");
    status = fmc_hdmi_cam_hdmii_init2( pdemo->pfmc_hdmi_cam,
                                 1, // hdmiiEnable = 1
                                 1, // editInit = 1
                                 fmc_hdmi_cam_hdmii_edid_content,
                                 pdemo->adv7611_llc_polarity, //0, //llc_polarity,
								 pdemo->adv7611_llc_delay //0  //llc_delay
                                 );
    if ( !status )
    {
      xil_printf( "ERROR : Failed to init HDMI Input Interface\n\r" );
      exit(0);
    }

   xil_printf( "Waiting for ADV7611 to locked on incoming video ...\n\r" );
   pdemo->hdmii_locked = 0;
   timeout = 100;
   while ( !(pdemo->hdmii_locked) && timeout-- )
   {
      usleep(100000); // wait 100msec ...
      pdemo->hdmii_locked = fmc_hdmi_cam_hdmii_get_lock( pdemo->pfmc_hdmi_cam );
   }
   if ( !(pdemo->hdmii_locked) )
   {
      xil_printf( "\tERROR : ADV7611 has NOT locked on incoming video, aborting !\n\r" );
   }
   else
   {
       xil_printf( "\tADV7611 Video Input LOCKED\n\r" );
       usleep(100000); // wait 100msec for timing to stabilize

       // Get Video Input information
       fmc_hdmi_cam_hdmii_get_timing( pdemo->pfmc_hdmi_cam, &(pdemo->hdmii_timing) );
       pdemo->hdmii_width  = pdemo->hdmii_timing.HActiveVideo;
       pdemo->hdmii_height = pdemo->hdmii_timing.VActiveVideo;
       xil_printf( "\tInput resolution = %d X %d\n\r", pdemo->hdmii_width, pdemo->hdmii_height );
    }

	return 0;
}

int demo_start_cam_in( demo_t *pdemo )
{
	int status;

    // PYTHON Receiver Initialization
    xil_printf( "PYTHON Receiver Initialization ...\n\r" );
	onsemi_python_init(pdemo->ppython_receiver, "PYTHON-1300-C",
			XPAR_ONSEMI_PYTHON_SPI_0_S00_AXI_BASEADDR,
			XPAR_ONSEMI_PYTHON_CAM_0_S00_AXI_BASEADDR);
	pdemo->ppython_receiver->uManualTap = 25; // IDELAY setting (0-31)
    //xil_printf( "PYTHON SPI Config for 10MHz ...\n\r" );
    // axi4lite_0_clk = 75MHz
    onsemi_python_spi_config( pdemo->ppython_receiver, (75000000/10000000) );

    // PYTHON Sensor Initialization
    xil_printf( "PYTHON Sensor Initialization ...\n\r" );

	// Camera Power Sequence
	fmc_hdmi_cam_iic_mux( pdemo->pfmc_hdmi_cam, FMC_HDMI_CAM_I2C_SELECT_CAM );
	cat9554_initialize(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);

	// Make sure all disable first
	cat9554_vddpix_off(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);
	cat9554_vdd33_off(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);
	cat9554_vdd18_off(pdemo->pfmc_hdmi_cam_iic);
	usleep(1000);

	// Turn them on one by one
	cat9554_vdd18_en(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);
	cat9554_vdd33_en(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);
	cat9554_vddpix_en(pdemo->pfmc_hdmi_cam_iic);
	usleep(10);

	onsemi_python_sensor_initialize(
			pdemo->ppython_receiver, SENSOR_INIT_ENABLE, pdemo->bVerbose);
	onsemi_python_sensor_initialize(
			pdemo->ppython_receiver, SENSOR_INIT_STREAMON, pdemo->bVerbose);
	onsemi_python_sensor_cds(pdemo->ppython_receiver, pdemo->bVerbose);
	onsemi_python_cam_reg_write(pdemo->ppython_receiver,
			ONSEMI_PYTHON_CAM_SYNCGEN_HTIMING1_REG, 0x00300500);

	xil_printf("CFA Initialization\r\n");
	XCfa_Reset(pdemo->pcfa);
	XCfa_RegUpdateEnable(pdemo->pcfa);
	XCfa_Enable(pdemo->pcfa);

	XCfa_SetBayerPhase(pdemo->pcfa, pdemo->cam_bayer);
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
	WriteSetup(pdemo->paxivdma0, 0x10000000, 0, 1, 1, 0, 0, pdemo->hdmii_width, pdemo->hdmii_height, 2048, 2048);
	ReadSetup(pdemo->paxivdma0, 0x10000000, 0, 1, 1, 0, 0, pdemo->hdmio_width, pdemo->hdmio_height, 2048, 2048);
	StartTransfer(pdemo->paxivdma0);

	xil_printf("VDMA 1 Initialization\r\n");
	XAxiVdma_Reset(pdemo->paxivdma1, XAXIVDMA_WRITE);
	XAxiVdma_Reset(pdemo->paxivdma1, XAXIVDMA_READ);
	WriteSetup(pdemo->paxivdma1, 0x18000000, 0, 1, 1, 0, 0, 1280, 1024, 2048, 2048);
	ReadSetup(pdemo->paxivdma1, 0x18000000, 0, 1, 1, 0, 0, 1280, 1024, 2048, 2048);
	StartTransfer(pdemo->paxivdma1);

	xil_printf("OSD Initialization (hdmi=0x%02X, cam=0x%02X)\r\n", pdemo->hdmi_alpha, pdemo->cam_alpha);
	XOSD_Reset(pdemo->posd);
	XOSD_RegUpdateEnable(pdemo->posd);
	XOSD_Enable(pdemo->posd);

	XOSD_SetScreenSize(pdemo->posd, pdemo->hdmio_width, pdemo->hdmio_height);
	XOSD_SetBackgroundColor(pdemo->posd, 0x80, 0x80, 0x80);

	// Layer 0 - HDMI input
	XOSD_SetLayerPriority(pdemo->posd, 0, XOSD_LAYER_PRIORITY_0);
	XOSD_SetLayerAlpha(pdemo->posd, 0, 1, pdemo->hdmi_alpha);
	XOSD_SetLayerDimension(pdemo->posd, 0, 0, 0, pdemo->hdmio_width, pdemo->hdmio_height);

	// Layer 1 - PYTHON-1300 camera
	XOSD_SetLayerPriority(pdemo->posd, 1, XOSD_LAYER_PRIORITY_1);
	XOSD_SetLayerAlpha(pdemo->posd, 1, 1, pdemo->cam_alpha);
	XOSD_SetLayerDimension(pdemo->posd, 1, 0, 0, 1280, 1024);

	XOSD_EnableLayer(pdemo->posd, 0);
	XOSD_EnableLayer(pdemo->posd, 1);

	return 1;
}

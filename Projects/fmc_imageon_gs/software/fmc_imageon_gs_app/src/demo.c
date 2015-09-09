
#include "demo.h"

int demo_init( demo_t *pdemo )
{
	int status;

	pdemo->paxivdma0 = &(pdemo->axivdma0);
	pdemo->paxivdma1 = &(pdemo->axivdma1);
	pdemo->posd = &(pdemo->osd);
	pdemo->pcfa = &(pdemo->cfa);
	pdemo->pfmc_imageon_iic = &(pdemo->fmc_imageon_iic);
	pdemo->pfmc_imageon = &(pdemo->fmc_imageon);
	pdemo->pvita_receiver = &(pdemo->vita_receiver);

	pdemo->cam_alpha = 0xFF;
	pdemo->hdmi_alpha = 0x00;

	pdemo->bVerbose = 0;

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

   xil_printf( "FMC-IMAGEON Initialization ...\n\r" );

   status = fmc_iic_xps_init(pdemo->pfmc_imageon_iic,"FMC-IMAGEON I2C Controller", XPAR_FMC_IMAGEON_IIC_0_BASEADDR );
   if ( !status )
   {
	  xil_printf( "ERROR : Failed to open FMC-IIC driver\n\r" );
	  exit(0);
   }

   fmc_imageon_init(pdemo->pfmc_imageon, "FMC-IMAGEON", pdemo->pfmc_imageon_iic);
   pdemo->pfmc_imageon->bVerbose = pdemo->bVerbose;

   // Configure Video Clock Synthesizer
   xil_printf( "Video Clock Synthesizer Configuration ...\n\r" );
   fmc_imageon_vclk_init( pdemo->pfmc_imageon );
   fmc_imageon_vclk_config( pdemo->pfmc_imageon, FMC_IMAGEON_VCLK_FREQ_148_500_000);
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
    status = fmc_imageon_hdmio_init( pdemo->pfmc_imageon,
  	                             1,                      // hdmioEnable = 1
  	                             &(pdemo->hdmio_timing), // pTiming
  	                             0                       // waitHPD = 0
  	                             );
    if ( !status )
    {
       xil_printf( "ERROR : Failed to init HDMI Output Interface\n\r" );
       return 0;
    }

    return 1;
}

int demo_start_hdmi_in( demo_t *pdemo )
{
	int status;
    Xuint32 timeout = 100;

	xil_printf("HDMI Input Initialization\r\n");
    status = fmc_imageon_hdmii_init2( pdemo->pfmc_imageon,
                                 1, // hdmiiEnable = 1
                                 1, // editInit = 1
                                 fmc_imageon_hdmii_edid_content,
                                 0, //llc_polarity,
                                 0  //llc_delay
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
      pdemo->hdmii_locked = fmc_imageon_hdmii_get_lock( pdemo->pfmc_imageon );
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
       fmc_imageon_hdmii_get_timing( pdemo->pfmc_imageon, &(pdemo->hdmii_timing) );
       pdemo->hdmii_width  = pdemo->hdmii_timing.HActiveVideo;
       pdemo->hdmii_height = pdemo->hdmii_timing.VActiveVideo;
       xil_printf( "\tInput resolution = %d X %d\n\r", pdemo->hdmii_width, pdemo->hdmii_height );
    }

	return 0;
}

int demo_start_cam_in( demo_t *pdemo )
{
	int status;

    // FMC-IMAGEON VITA Receiver Initialization
    xil_printf( "FMC-IMAGEON VITA Receiver Initialization ...\n\r" );
	onsemi_vita_init(pdemo->pvita_receiver, "VITA-2000-C",
			XPAR_ONSEMI_VITA_SPI_0_S00_AXI_BASEADDR,
			XPAR_ONSEMI_VITA_CAM_0_S00_AXI_BASEADDR);
	pdemo->pvita_receiver->uManualTap = 25; // IDELAY setting (0-31)
    xil_printf( "FMC-IMAGEON VITA SPI Config for 10MHz ...\n\r" );
    // axi4lite_0_clk = 75MHz
    onsemi_vita_spi_config( pdemo->pvita_receiver, (75000000/10000000) );

    // VITA-2000 Initialization
    xil_printf( "FMC-IMAGEON VITA Initialization ...\n\r" );
    status = onsemi_vita_sensor_initialize( pdemo->pvita_receiver, SENSOR_INIT_ENABLE, pdemo->bVerbose );
    if ( status == 0 )
    {
        xil_printf( "VITA sensor failed to initialize ...\n\r" );
        return 0;
    }
    else
    {
       sleep(1);

       xil_printf( "FMC-IMAGEON VITA Configuration for 1080P60 timing ...\n\r" );
       status = onsemi_vita_sensor_1080P60( pdemo->pvita_receiver, pdemo->bVerbose );
       if ( status == 0 )
       {
          xil_printf( "VITA sensor failed to configure for 1080P60 timing ...\n\r" );
       }

       sleep(1);
       onsemi_vita_get_status( pdemo->pvita_receiver, &(pdemo->vita_status_t1), 0 );
       sleep(1);
       onsemi_vita_get_status( pdemo->pvita_receiver, &(pdemo->vita_status_t2), 0 );
       //
       xil_printf( "VITA Status = \n\r" );
       xil_printf("\tImage Width  = %d\n\r", pdemo->vita_status_t1.cntImagePixels * 4 );
       xil_printf("\tImage Height = %d\n\r", pdemo->vita_status_t1.cntImageLines  );
       xil_printf("\tFrame Rate   = %d frames/sec\n\r", pdemo->vita_status_t2.cntFrames - pdemo->vita_status_t1.cntFrames );
       xil_printf("\tCRC Status   = %X\n\r", pdemo->vita_status_t2.crcStatus );

       if ( pdemo->bVerbose )
       {
    	   onsemi_vita_get_status( pdemo->pvita_receiver, &(pdemo->vita_status_t2), 1 );
       }
    }

	xil_printf("CFA Initialization\r\n");
	XCfa_Reset(pdemo->pcfa);
	//XCfa_WriteReg(pdemo->pcfa, CFA_BAYER_PHASE, 0x00);
	XCfa_SetBayerPhase(pdemo->pcfa, XCFA_RGRG_COMBINATION);
	XCfa_RegUpdateEnable(pdemo->pcfa);
	XCfa_Enable(pdemo->pcfa);

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
	WriteSetup(pdemo->paxivdma1, 0x18000000, 0, 1, 1, 0, 0, pdemo->hdmio_width, pdemo->hdmio_height, 2048, 2048);
	ReadSetup(pdemo->paxivdma1, 0x18000000, 0, 1, 1, 0, 0, pdemo->hdmio_width, pdemo->hdmio_height, 2048, 2048);
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
	XOSD_SetLayerDimension(pdemo->posd, 1, 0, 0, pdemo->hdmio_width, pdemo->hdmio_height);

	XOSD_EnableLayer(pdemo->posd, 0);
	XOSD_EnableLayer(pdemo->posd, 1);

	return 1;
}

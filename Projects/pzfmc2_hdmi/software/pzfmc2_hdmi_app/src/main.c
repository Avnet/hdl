/*
 * main.c
 *
 *  Created on: Aug 1, 2014
 *      Author: 910560
 */

#include "demo.h"
#include "avnet_console.h"

demo_t demo;
demo_t *pdemo;

int main()
{
	xil_printf("\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("--             FMC-HDMI-CAM + PYTHON-1300-C         --\n\r");
	xil_printf("--               Getting Started Design             --\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("\n\r");

	pdemo = &demo;
	demo_init( pdemo );

	// Init reference design
	demo_init_frame_buffer(pdemo);
	demo_start_hdmi_out(pdemo);

	// Try CAM first
	pdemo->cam_alpha = 0xFF;
	pdemo->hdmi_alpha = 0x00;
	if ( !demo_start_cam_in(pdemo) )
	{
		// Then try HDMI
		pdemo->cam_alpha = 0x00;
		pdemo->hdmi_alpha = 0xFF;
		demo_start_hdmi_in(pdemo);
	}
	demo_start_frame_buffer(pdemo);

	// Start serial console
	print_avnet_console_serial_app_header();
	start_avnet_console_serial_application();
	while (1)
	{
		if (transfer_avnet_console_serial_data()) {
			break;
		}
	}

	return 0;

//    xil_printf("\r\n\tPress 0-9 to change alpha blending of hdmi/camera layers\r\n");
//	xil_printf("\r\n\tPress ENTER to restart\r\n\r\n" );
//	c = getchar();

//	if ( c >= '0' && c <= '9' )
//	{
//		camera_alpha = (c - '0') * 28;
//		hdmi_alpha    = ('9' - c) * 28;
//	}

//	if ( c == '+' )
//	{
//		if ( pdemo->pvita_receiver->uManualTap < 31 )
//			pdemo->pvita_receiver->uManualTap++;
//		xil_printf( "\tuManualTap = %d\n\r", pdemo->pvita_receiver->uManualTap );
//	}
//	if ( c == '-' )
//	{
//		if ( pdemo->pvita_receiver->uManualTap > 0 )
//			pdemo->pvita_receiver->uManualTap--;
//		xil_printf( "\tuManualTap = %d\n\r", pdemo->pvita_receiver->uManualTap );
//	}
//}

	return 0;
}

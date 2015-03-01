/*
 * main.c
 *
 *  Created on: Jun 26, 2014
 *      Author: 910560
 */

#include "xparameters.h"
#include "xiicps.h"
#include "xiicps_ext.h"
#include "adv7511.h"
#include "tca9548.h"
#include "pca9534.h"
#include "adv7611.h"
#include "xvtc.h"

#define EMBV_IIC_MUX_I2CIO      TCA9548_I2C0_SEL
#define EMBV_IIC_MUX_HDMII      TCA9548_I2C1_SEL
#define EMBV_IIC_MUX_HDMIO      TCA9548_I2C2_SEL
#define EMBV_IIC_MUX_HDMIO_DDC  TCA9548_I2C3_SEL
#define EMBV_IIC_MUX_AUD        TCA9548_I2C4_SEL
#define EMBV_IIC_MUX_CAM        TCA9548_I2C5_SEL

typedef struct {
	XIicPs iicps0;
	XVtc vtc;

	XIicPs *piicps0;
	XVtc *pvtc;
} demo_t;

demo_t demo;
demo_t *pdemo;

int main() {
	int status = 0;

	u32 iterations = 0;
	u8 llc_polarity = 0;
	u8 llc_delay = 0;
	char c;

	xil_printf("\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("--            Embedded Vision Carrier Card          --\n\r");
	xil_printf("                   HDMI Pass-Through                --\n\r");
	xil_printf("------------------------------------------------------\n\r");
	xil_printf("\n\r");

	pdemo = &demo;
	pdemo->piicps0 = &(pdemo->iicps0);
	pdemo->pvtc = &(pdemo->vtc);

	XIicPs_Config *piicps_config;
	XVtc_Config *pvtc_config;

	piicps_config = XIicPs_LookupConfig(XPAR_XIICPS_0_DEVICE_ID);
	XIicPs_CfgInitialize(pdemo->piicps0, piicps_config,
			piicps_config->BaseAddress);
	XIicPs_Reset(pdemo->piicps0);
	XIicPs_SetSClk(pdemo->piicps0, 100000);

while (1)
{
	if ( iterations > 0 )
	{
	   xil_printf( "\n\rPress ENTER to re-start ...\n\r" );
	   c = getchar();
	   if ( c == '!' )
	   {
		   llc_polarity = !llc_polarity;
		   continue;
	   }
	   if ( c == '+' )
	   {
		   llc_delay = (llc_delay + 1) % 32;
		   continue;
	   }
	   if ( c == '-' )
	   {
		   llc_delay = (llc_delay - 1) % 32;
		   continue;
	   }
	}
	iterations++;

	// I2C MUX Reset
	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_I2CIO);
	status = 0x08;
	pca9534_set_pins_direction(pdemo->piicps0, status);
	pca9534_set_pin_value(pdemo->piicps0, 7, 1);			// Disable I2C MUX Reset

	// HDMI Input Initialization
	pca9534_set_pin_value(pdemo->piicps0, 0, 1);			// De-assert ADV7611 reset
	usleep(10000);
	pca9534_set_pin_value(pdemo->piicps0, 0, 0);			// Assert ADV7611 reset
	usleep(10000);
	pca9534_set_pin_value(pdemo->piicps0, 0, 1);			// De-assert ADV7611 reset
	sleep(1);

	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_HDMII);
	adv7611_configure(pdemo->piicps0, adv7611_set_slave_table);

	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_I2CIO);
	pca9534_set_pin_value(pdemo->piicps0, 2, 0);			// Disable HDMI Input HPD
	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_HDMII);
	adv7611_configure(pdemo->piicps0, adv7611_set_edid_0_table);
	adv7611_load_edid(pdemo->piicps0);
	adv7611_configure(pdemo->piicps0, adv7611_set_edid_1_table);
	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_I2CIO);
	pca9534_set_pin_value(pdemo->piicps0, 2, 1);			// Enable HDMI Input HPD

    xil_printf( "HDMI Input Initialization ...\n\r" );
    xil_printf( "\tLLC polarity = %d\n\r", llc_polarity );
    xil_printf( "\tLLC delay = %d\n\r", llc_delay );

	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_HDMII);
	//adv7611_configure(pdemo->piicps0, adv7611_hdmi_config_table);
	adv7611_configure2(pdemo->piicps0, adv7611_hdmi_config_table, llc_polarity, llc_delay );

	adv7611_configure(pdemo->piicps0, adv7611_spdif_config_table);

	// Check HDMI Input Lock
	do {
		XIicPs_Read(pdemo->piicps0, (IIC_ADV7611_HDMI_ADDR>>1), 0x07, &status, 1);
	} while ((status & 0xA0) != 0xA0);

	xil_printf("HDMI Input locked!!\r\n");
	sleep(1);

	// Video Timing Controller

	pvtc_config = XVtc_LookupConfig(XPAR_VTC_0_DEVICE_ID);
	XVtc_CfgInitialize(pdemo->pvtc, pvtc_config,
			pvtc_config->BaseAddress);


	XVtc_Reset(pdemo->pvtc);
	XVtc_WriteReg(pdemo->pvtc->Config.BaseAddress, XVTC_CTL, \
			XVtc_ReadReg(pdemo->pvtc->Config.BaseAddress, XVTC_CTL) | \
			XVTC_CTL_SW_MASK);

	// HDMI Ouput Initialization
	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_I2CIO);
	pca9534_set_pin_value(pdemo->piicps0, 4, 0);			// Disable HDMI Output Power Down

	tca9548_i2c_mux_select(pdemo->piicps0, EMBV_IIC_MUX_HDMIO);
	adv7511_configure(pdemo->piicps0);

	xil_printf("System Ready!\r\n");

} // while(1)

	return 0;

}

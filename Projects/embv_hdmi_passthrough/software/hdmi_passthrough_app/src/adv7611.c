/*
 * adv7611.c
 *
 *  Created on: Jun 26, 2014
 *      Author: 910560
 */

#include "adv7611.h"
#include "xiicps_ext.h"


void adv7611_configure(XIicPs *pInstance, u8 config_table[][3]) {
	int i = 0;

	while (1) {
		if ((config_table[i][0] == 0xDE) && (config_table[i][1] == 0xAD)){
			break;
		}

		XIicPs_Write(pInstance, config_table[i][0], config_table[i][1],
				(u8*) &config_table[i][2], 1);
		i++;
	}
}

void adv7611_configure2(XIicPs *pInstance, u8 config_table[][3], u8 llc_polarity, u8 llc_delay) {
	int i = 0;

   //xil_printf( "LLC polarity = %d\n\r", llc_polarity );
   //xil_printf( "   iic_hdmi_in_config[10] => { 0x%02X, 0x%02X, 0x%02X }\n\r", iic_hdmi_in_config[10][0], iic_hdmi_in_config[10][1], iic_hdmi_in_config[10][2] );
	config_table[10][2] &= 0xFE;
	config_table[10][2] |= (llc_polarity & 0x01);
   //xil_printf( "   iic_hdmi_in_config[10] <= { 0x%02X, 0x%02X, 0x%02X }\n\r", iic_hdmi_in_config[10][0], iic_hdmi_in_config[10][1], iic_hdmi_in_config[10][2] );

   //xil_printf( "LLC delay = %d\n\r", llc_delay );
   //xil_printf( "   iic_hdmi_in_config[11] => { 0x%02X, 0x%02X, 0x%02X }\n\r", iic_hdmi_in_config[11][0], iic_hdmi_in_config[11][1], iic_hdmi_in_config[11][2] );
	config_table[11][2] &= 0x80;
	config_table[11][2] |= (llc_delay & 0x1F);

	while (1) {
		if ((config_table[i][0] == 0xDE) && (config_table[i][1] == 0xAD)){
			break;
		}

		XIicPs_Write(pInstance, config_table[i][0], config_table[i][1],
				(u8*) &config_table[i][2], 1);
		i++;
	}
}

void adv7611_load_edid(XIicPs *pInstance) {
	int i = 0;

	for (i = 0; i < 256; i++) {
		XIicPs_Write(pInstance, (IIC_ADV7611_EDID_ADDR>>1), i,
				(u8*) &adv7611_edid_content[i], 1);
	}

}

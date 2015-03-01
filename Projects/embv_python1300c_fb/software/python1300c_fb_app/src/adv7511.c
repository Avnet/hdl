/*
 * adv7511.c
 *
 *  Created on: Jun 10, 2014
 *      Author: 910560
 */

#include <unistd.h>
#include "adv7511.h"

#define IIC_ADV7511_SADR   0x39

void adv7511_configure(XIicPs *pInstance) {
	int i = 0;

	while (1) {
		if ((iic_hdmi_config[i][0] == 0xDE) && (iic_hdmi_config[i][1] == 0xAD)){
			break;
		}

		XIicPs_Write(pInstance, IIC_ADV7511_SADR, iic_hdmi_config[i][0],
				(u8*) &iic_hdmi_config[i][1], 1);

		i++;
	}
}


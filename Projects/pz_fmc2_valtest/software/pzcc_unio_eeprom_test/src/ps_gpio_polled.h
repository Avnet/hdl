//----------------------------------------------------------------------------
//      _____
//     *     *
//    *____   *____
//   * *===*   *==*
//  *___*===*___**  AVNET
//       *======*
//        *====*
//----------------------------------------------------------------------------
//
// This design is the property of Avnet.  Publication of this
// design is not authorized without written consent from Avnet.
//
// Please direct any questions to:  technical.support@avnet.com
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2013 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Jun 26, 2013
// Design Name:         PS GPIO Polled Interface
// Module Name:         ps_gpio_polled.h
// Project Name:        Avnet Touch Panel
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        ZedBoard, MicroZed, Zed Display Kit
//
// Tool versions:       ISE 14.5
//
// Description:         Definitions for interface to ZedBoard PS GPIO
//                      hardware.
//
// Dependencies:
//
// Revision:            Jun 26, 2013: 1.00 Created for Zed Display Kit
//                      Jul  1, 2013: 1.01 Revised for MicroZed target
//
//----------------------------------------------------------------------------

#ifndef __PS_GPIO_POLLED_H__
#define __PS_GPIO_POLLED_H__

#include "types.h"
#include "unio_eeprom.h"
#include "xgpiops.h"
#include "xparameters.h"	/* SDK generated parameters */

/************************** Constant Definitions *****************************/
#define PS_GPIO_EMIO_START             54
#define PS_GPIO_USER_LED_START         ((PS_GPIO_EMIO_START) + 1)
#define PS_GPIO_USER_BUTTON_START      ((PS_GPIO_EMIO_START) + 5)
#define PS_GPIO_USER_UNIO_START        ((PS_GPIO_EMIO_START) + 0)


/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

int ps_gpio_get_button(unio_eeprom_t *pTest, int button_number);
int ps_gpio_get_mio_state(unio_eeprom_t *pTest, int mio_number);
int ps_gpio_get_unio(unio_eeprom_t *pTest);
int ps_gpio_polled_init(unio_eeprom_t *pTest, int16u gpio_device_id);
int ps_gpio_set_led(unio_eeprom_t *pTest, int led_number, int led_state);
int ps_gpio_set_unio(unio_eeprom_t *pTest, int unio_state);

#endif // __PS_GPIO_POLLED_H__

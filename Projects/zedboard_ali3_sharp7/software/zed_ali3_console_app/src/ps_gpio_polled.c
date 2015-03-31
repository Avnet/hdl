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
// Module Name:         ps_gpio_polled.c
// Project Name:        Avnet Touch Panel
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        ZedBoard, Zed Display Kit
//
// Tool versions:       ISE 14.5
//
// Description:         Implementation interface to ZedBoard PS GPIO
//                      hardware.  Adapted from Xilinx example code found in
//                      xgpiops_polled_example.c
//
// Dependencies:
//
// Revision:            Jun 26, 2013: 1.00 Created for Zed Display Kit
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "zed_ali3_controller_demo.h"
#include "types.h"
#include "ps_gpio_polled.h"

/************************** Variable Definitions *****************************/

/*****************************************************************************
*
* This function gets a GPIO button device state configured as INPUT.
*
* @param	None.
*
* @return	1 if depressed, else 0.
*
* @note		None.
*
****************************************************************************/
int ps_gpio_get_button(zed_ali3_controller_demo_t *pDemo, int button_number)
{
    int button_state;

    /*
     * Set the direction for the specified pin to be input.
     */
    XGpioPs_SetDirectionPin(&(pDemo->gpio_driver), (PS_GPIO_USER_BUTTON_START + button_number), 0);

    /*
     * Read the state of the data so that it can be  verified.
     */
    button_state = XGpioPs_ReadPin(&(pDemo->gpio_driver), (PS_GPIO_USER_BUTTON_START + button_number));

    return button_state;
}

/*****************************************************************************
*
* This function gets a GPIO MIO state configured as INPUT.
*
* @param	None.
*
* @return	1 if depressed, else 0.
*
* @note		None.
*
****************************************************************************/
int ps_gpio_get_mio_state(zed_ali3_controller_demo_t *pDemo, int mio_number)
{
    int mio_state;

    /*
     * Set the direction for the specified pin to be input.
     */
    XGpioPs_SetDirectionPin(&(pDemo->gpio_driver), mio_number, 0);

    /*
     * Read the state of the data so that it can be  verified.
     */
    mio_state = XGpioPs_ReadPin(&(pDemo->gpio_driver), mio_number);

    return mio_state;
}

/*****************************************************************************
*
* This function gets a GPIO switch device state configured as INPUT.
*
* @param	None.
*
* @return	1 if set to ON postion, else 0.
*
* @note		None.
*
****************************************************************************/
int ps_gpio_get_switch(zed_ali3_controller_demo_t *pDemo, int switch_number)
{
    int switch_state;

    /*
     * Set the direction for the specified pin to be input.
     */
    XGpioPs_SetDirectionPin(&(pDemo->gpio_driver), (PS_GPIO_USER_SWITCH_START + switch_number), 0);

    /*
     * Read the state of the data so that it can be  verified.
     */
    switch_state = XGpioPs_ReadPin(&(pDemo->gpio_driver), (PS_GPIO_USER_SWITCH_START + switch_number));

    return switch_state;
}

/*****************************************************************************
*
* The purpose of this function is to initialize the underlying PS GPIO driver
* allowing usage of further APIs for reading/writing to the individual pins.
*
* Please see xgpiops.h file for description of the pin numbering.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int ps_gpio_polled_init(zed_ali3_controller_demo_t *pDemo)
{
    int status;
    XGpioPs_Config * gpio_config;

    /*
     * Initialize the PS GPIO driver so that it's ready to use.
     */
    gpio_config = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
    if (gpio_config == NULL)
    {
        return XST_FAILURE;
    }

    status = XGpioPs_CfgInitialize(&(pDemo->gpio_driver), gpio_config, gpio_config->BaseAddr);

    return status;
}

/*****************************************************************************
*
* This function sets GPIO LED device state configured as OUTPUT.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
****************************************************************************/
int ps_gpio_set_led(zed_ali3_controller_demo_t *pDemo, int led_number, int led_state)
{
    /*
     * Set the direction for the GPIO pin to be output and
     * Enable the Output enable for the LED Pin.
     */
    XGpioPs_SetDirectionPin(&(pDemo->gpio_driver), (PS_GPIO_USER_LED_START + led_number), 1);
    XGpioPs_SetOutputEnablePin(&(pDemo->gpio_driver), (PS_GPIO_USER_LED_START + led_number), 1);

    /*
     * Set the GPIO output to the specified state.
     */
    XGpioPs_WritePin(&(pDemo->gpio_driver), (PS_GPIO_USER_LED_START + led_number), led_state);

    return 0;
}

/*
 * Copyright (c) 2016 Avnet, Inc.  All rights reserved.
 *
 * Avnet, Inc.
 * Avnet IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, Avnet IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * Avnet EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

#ifndef __PMODUTILITES_H_
#define __PMODUTILITES_H_
#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xstatus.h"
#include "xspi_l.h"
#include "sleep.h"
#include "xiic_l.h"
#include "xgpio.h"

/************************** Constant Definitions *****************************/
/*
 * The following constant maps to the name of the hardware instances that
 * were created in the Vivado system design.
 */

#define PWM_BASE_ADDRESS				XPAR_PWM_W_INT_0_BASEADDR

#define MAX44000_IIC_ADDRESS            0x4A   // The actual address is 8'b1001 010x (0x94)
#define MAX44000_MAIN_CONFIG_REG        0x01   // Main configuration register
#define MAX44000_RECV_CONFIG_REG        0x02   // Receive configuration register
#define MAX44000_LED_DRIVE_CURRENT_REG  0x03   // LED Drive Current register
#define MAX44000_LUX_HIGH_BYTE_REG      0x04   // Lux High-Byte register (overflow bit + bits 13:8 of lux reading)
#define MAX44000_LUX_LOW_BYTE_REG       0x05   // Lux Low-Byte register (bits 7:0 of lux reading)

#define MAX44000_STATE_BEGIN 0           //!< LUX measurement state: Beginning state.
#define MAX44000_STATE_SET_ALSPGA 1      //!< LUX measurement state: Set ADC resolution and amplifier gain.
#define MAX44000_STATE_READ_04 2         //!< LUX measurement state: Read LUX high and overflow.
#define MAX44000_STATE_READ_05 3         //!< LUX measurement state: Read LUX low byte
#define MAX44000_STATE_INCREASE_ALSPGA 4 //!< LUX measurement state: Increase PGA setting (lower gain)
#define MAX44000_STATE_PROCESS_LUX 5     //!< LUX measurement state: Scale the LUX value per PGA setting
#define MAX44000_STATE_FAILED_RW 6       //!< LUX measurement state: Abort, I2C failure
#define MAX44000_STATE_DELAY 7           //!< LUX measurement state: Delay one state
#define MAX44000_STATE_EXIT_FAILED 8     //!< LUX measurement state: Failure, exit
#define MAX44000_STATE_EXIT_SUCCESS 9    //!< LUX measurement state: Process completed, exit

/* following constant is used to determine which channel of the GPIO is
 * used if there are 2 channels supported in the GPIO.
 */
#define LED_GPIO_CHANNEL 2
#define PB_GPIO_CHANNEL 1
#define DEVICE_ID 	XPAR_GPIO_1_DEVICE_ID

#define SPI_BASEADDR			XPAR_AXI_QUAD_SPI_0_BASEADDR  // Base address for AXI SPI controller

#define SPI_CHANNEL_SEL_0		0xFFFFFFFE					// Select spi channel 0
#define SPI_CHANNEL_SEL_1		0xFFFFFFFD					// Select spi channel 1
#define SPI_CHANNEL_SEL_NONE	0xFFFFFFFF					// Deselect all SPI channels

// Initialization settings for the AXI SPI controller's Control Register when addressing the MAX31855
// 0x186 = b1_1000_0110
//			1	Inhibited to hold off transactions starting
//			1	Manually select the slave
//			0	Do not reset the receive FIFO at this time
//			0	Do not reset the transmit FIFO at this time
//			0	Clock phase of 0
//			0	Clock polarity of low
//			1	Enable master mode
//			1	Enable the SPI Controller
//			0	Do not put in loopback mode

#define MAX31855_CLOCK_PHASE_CPHA		0
#define MAX31855_CLOCK_POLARITY_CPOL	0

#define MAX31855_CR_INIT_MODE		XSP_CR_TRANS_INHIBIT_MASK | XSP_CR_MANUAL_SS_MASK   | \
									XSP_CR_MASTER_MODE_MASK   | XSP_CR_ENABLE_MASK
#define MAX31855_CR_UNINHIBIT_MODE	                            XSP_CR_MANUAL_SS_MASK   | \
									XSP_CR_MASTER_MODE_MASK   | XSP_CR_ENABLE_MASK
#define AXI_SPI_RESET_VALUE			0x0A  //!< Reset value for the AXI SPI Controller
/***************************************************************************/

/************************** Variable Definitions **************************/
/*
 * The following are declared globally so they are zeroed and so they are
 * easily accessible from a debugger
 */
XGpio GpioOutput; /* The driver instance for GPIO Device configured as O/P */
XGpio GpioInput;  /* The driver instance for GPIO Device configured as I/P */
/***************************************************************************/

/*********************** Function Prototypes *******************************/
int MAX44000_write(u32 ZynqIicAddress, u8 register_offset, u8 write_value);
int MAX44000_read(u32 ZynqIicAddress, u8 register_offset, u8 *read_value);
int max_MAX44000_readLux(u32 unPeripheralAddressI2C, unsigned int *unLuxReading);

int XSpi_MAX31855_INIT(u32 BaseAddress);
int XSpi_LowLevelExecute(u32 BaseAddress, u32 SPI_Channel, u32 *TxBuffer, u32 *RxBuffer, u32 TxByteCount);

void print_banner();
/***************************************************************************/

#endif

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
// Please direct any questions or issues to the MicroZed Community Forums:
//     http://www.microzed.org
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2015 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Jun 04, 2015
// Design Name:         ZedBoard ALI3 Controller Demonstration
// Module Name:         drv2605.h
// Project Name:        ZedBoard ALI3 Display Kit
//
// Tool versions:       Vivado 2014.4
//
// Description:         Definitions for TI DRV2605 haptic driver
//
// Dependencies:        
//
// Revision:            Jun 04, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#ifndef DRV2605_H_
#define DRV2605_H_

#define DRV2605_SLAVE_ADDR		0x5A

// DRV2605 Registers
#define DRV2605_STATUS_REG 		0x00
#define DRV2605_MODE_REG		0x01
#define DRV2605_WAVEFORM_1		0x04
#define DRV2605_WAVEFORM_2		0x05
#define DRV2605_WAVEFORM_3		0x06
#define DRV2605_WAVEFORM_4		0x07
#define DRV2605_WAVEFORM_5		0x08
#define DRV2605_WAVEFORM_6		0x09
#define DRV2605_WAVEFORM_7		0x0A
#define DRV2605_WAVEFORM_8		0x0B
#define DRV2605_GO_REG			0x0C
#define DRV2605_RATED_VOLT_REG	0x16
#define DRV2605_OD_CLAMP_REG	0x17
#define DRV2605_FBK_CNTRL_REG	0x1A
#define DRV2605_CNTL_1_REG		0x1B
#define DRV2605_CNTL_2_REG		0x1C
#define DRV2605_CNTL_4_REG		0x1E

// Register settings to initiate auto calibration - verify for specific actuator to be used
#define DRV2605_AUTOCAL_FBK_CNTL_VAL	0xA8
#define DRV2605_AUTOCAL_CNTL_1_VAL		0x8F
#define DRV2605_AUTOCAL_CNTL_2_VAL		0xF5
#define DRV2605_AUTOCAL_CNTL_4_VAL		0x30

// This value calculated using equation in DRV2605 datasheet and parameters from actuator datasheet
// Must be recalculated for any actuator other than Samsung DMJBRN0934BW
#define DRV2605_AUTOCAL_RATED_VOLT_VAL	0x50

// This value calculated using equation in DRV2605 datasheet and parameters from actuator datasheet
// Must be recalculated for any actuator other than Samsung DMJBRN0934BW
#define DRV2605_AUTOCAL_OD_CLAMP_VAL	0x66
#endif /* DRV2605_H_ */

typedef enum haptic_effects{
	STRONG_CLICK_100 = 1,
	STRONG_CLICK_60,
	STRONG_CLICK_30,
	SHARP_CLICK_100,
	SHARP_CLICK_60,
	SHARP_CLICK_30,
	SHORT_DOUBLE_CLICK_STRONG_1_100 = 27,
	TRANSITION_HUM_1_100 = 64,
	TRANSITION_RAMP_DOWN_LONG_SMOOTH_1_100_TO_0 = 70,
	TRANSITION_RAMP_UP_LONG_SMOOTH_2_0_TO_100 = 83,
	TRANSITION_RAMP_DOWN_SHORT_SHARP_1_50_TO_0 = 104
} HAPTIC_EFFECT;

extern int32u haptic_driver_init(zed_ali3_controller_demo_t *pDemo);
extern int32u haptic_trigger_effect(zed_ali3_controller_demo_t *pDemo, HAPTIC_EFFECT effect);

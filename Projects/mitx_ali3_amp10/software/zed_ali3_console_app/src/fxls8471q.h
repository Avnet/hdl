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
// Create Date:         May 08, 2015
// Design Name:         ZedBoard ALI3 Controller Demonstration
// Module Name:         fxls8471.h
// Project Name:        ZedBoard ALI3 Display Kit
//
// Tool versions:       Vivado 2014.4
//
// Description:         Definitions for Freescale FXLS8471 accelerometer
//
// Dependencies:        
//
// Revision:            May 08, 2015: 1.00 Initial version
//
//----------------------------------------------------------------------------

#ifndef FXLS8471Q_H_
#define FXLS8471Q_H_

// FXLS8471Q I2C address
#define FXLS8471Q_SLAVE_ADDR 0x1E // with pins SA0=0, SA1=0

// FXLS8471Q internal register addresses
#define FXLS8471Q_STATUS 0x00
#define FXLS8471Q_WHOAMI 0x0D
#define FXLS8471Q_XYZ_DATA_CFG 0x0E
#define FXLS8471Q_CTRL_REG1 0x2A
#define FXLS8471Q_WHOAMI_VAL 0x6A

// number of bytes to be read from FXLS8471Q
#define FXLS8471Q_READ_LEN 7// status plus 3 accelerometer channels

// higher number means less sensitivity - won't trigger unless it sees a change of at least ACCEL_SENSITIVITY
#define ACCEL_SENSITIVITY 3
#define ACCEL_LOW_THRESHOLD 1
#define ACCEL_MED_THRESHOLD 10
#define ACCEL_HI_THRESHOLD 20

typedef struct
{
int16_t x;
int16_t y;
int16_t z;
} SRAWDATA;

extern int32u accelerometer_init(zed_ali3_controller_demo_t *pDemo);
extern int32u accelerometer_poll(zed_ali3_controller_demo_t *pDemo);
#endif /* FXLS8471Q_H_ */

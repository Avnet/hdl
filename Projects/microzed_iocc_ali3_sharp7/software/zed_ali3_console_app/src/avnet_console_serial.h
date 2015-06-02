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
//                     Copyright(c) 2011 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Nov 18, 2011
// Design Name:         Serial Entry for Avnet Console
// Module Name:         avnet_console_serial.h
// Project Name:        Serial Entry for Avnet Console
//
// Tool versions:       ISE 13.3
//
// Description:         Serial entry point for Avnet console
//
// Dependencies:        
//
// Revision:            Nov 18, 2010: 1.01 Initial version
//                      May 23, 2013: 1.02 Updated for Zed Display Kit
//
//----------------------------------------------------------------------------

#ifndef __AVNET_CONSOLE_SERIAL_H__
#define __AVNET_CONSOLE_SERIAL_H__

int avnet_console_serial_flush(void);
int transfer_avnet_console_serial_data(void);
void print_avnet_console_serial_app_header(void);
int start_avnet_console_serial_application(void);

#endif // __AVNET_CONSOLE_SERIAL_H__

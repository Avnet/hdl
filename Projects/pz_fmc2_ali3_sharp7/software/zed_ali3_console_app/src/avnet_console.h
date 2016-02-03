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
// Design Name:         Avnet Console
// Module Name:         avnet_console.h
// Project Name:        Avnet Console
//
// Tool versions:       ISE 13.3
//
// Description:         Text-based console for application XXX
//
// Dependencies:        
//
// Revision:            Nov 18, 2010: 1.01 Initial version
//                      May 23, 2013: 1.02 Updated for Zed Display Kit
//
//----------------------------------------------------------------------------

#ifndef __AVNET_CONSOLE_H__
#define __AVNET_CONSOLE_H__

#include <stdio.h>

#include "xil_types.h"

#define MAX_LINE_LENGTH             256
#define MAX_ARGC                    16

#define AVNET_CONSOLE_PROMPT          "AVNET"

#define AVNET_CONSOLE_MAJOR         0
#define AVNET_CONSOLE_MINOR         1

// This structure allows the text-based console to be accessed from any interface
//   for example: serial port, ethernet connection, etc...
struct struct_avnet_console_t
{
    // For input:
    // - new character received from user
    int32_t inchar;
    char inline_buffer[MAX_LINE_LENGTH];
    int inline_count;
   
    // For output:
    // - context handle
    // - function pointer to formatted print routine
    void * io_handle;
    void (*io_hprintf)( void *h, const char *fmt, ... );

    // General status:
    int verbose;
    int echo;
    int run_once;
    int quit;
};
typedef struct struct_avnet_console_t avnet_console_t;

void avnet_console_init(avnet_console_t *pConsole);
void avnet_console_process(avnet_console_t *pConsole);

#endif // __AVNET_CONSOLE_H__

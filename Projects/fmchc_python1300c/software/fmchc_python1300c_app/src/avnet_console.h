// ----------------------------------------------------------------------------
//  
//        ** **        **          **  ****      **  **********  ********** ® 
//       **   **        **        **   ** **     **  **              ** 
//      **     **        **      **    **  **    **  **              ** 
//     **       **        **    **     **   **   **  *********       ** 
//    **         **        **  **      **    **  **  **              ** 
//   **           **        ****       **     ** **  **              ** 
//  **  .........  **        **        **      ****  **********      ** 
//     ........... 
//                                     Reach Further™ 
//  
// ----------------------------------------------------------------------------
// 
// This design is the property of Avnet.  Publication of this 
// design is not authorized without written consent from Avnet. 
// 
// Please direct any questions to the PicoZed community support forum: 
//    http://www.zedboard.org/forum 
// 
// Disclaimer: 
//    Avnet, Inc. makes no warranty for the use of this code or design. 
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
//    any errors, which may appear in this code, nor does it make a commitment 
//    to update the information contained herein. Avnet, Inc specifically 
//    disclaims any implied warranties of fitness for a particular purpose. 
//                     Copyright(c) 2017 Avnet, Inc. 
//                             All rights reserved. 
// 
// ----------------------------------------------------------------------------
//
// Create Date:         Nov 18, 2011
// Design Name:         Avnet Console
// Module Name:         avnet_console.h
// Project Name:        Avnet Console
//
// Tool versions:       Vivado 2016.4
//
// Description:         Text-based console for application XXX
//
// Dependencies:        
//
// Revision:            Nov 18, 2010: 1.01 Initial version
//                      Sep 17, 2012: 1.02 Remove video multiplexers
//                                         Fix gamma equalization
//                      Jun 01, 2017: 1.03 Add CFA command to set bayer
//
//----------------------------------------------------------------

#ifndef __AVNET_CONSOLE_H__
#define __AVNET_CONSOLE_H__

#include <stdio.h>
#include "demo.h"
#include "xbasic_types.h"

#define MAX_LINE_LENGTH             256
#define MAX_ARGC                    16

#define AVNET_CONSOLE_PROMPT          "FMCHC_PYTHON1300C"

#define AVNET_CONSOLE_MAJOR         0
#define AVNET_CONSOLE_MINOR         1

// This structure allows the text-based console to be accessed from any interface
//   for example: serial port, ethernet connection, etc...
struct struct_avnet_console_t
{
   // For input:
   // - new character received from user
   Xint32 inchar;
   char inline_buffer[MAX_LINE_LENGTH];
   int inline_count;
   
   // For output:
   // - context handle
   // - function pointer to formatted print routine
	void * io_handle;
	void (*io_hprintf)( void *h, const char *fmt, ... );
	void (*pipe_hprintf)( void *h, const char *fmt, ... );

	// General status:
	int pipe;
	int verbose;
	int echo;
	int quit;
};
typedef struct struct_avnet_console_t avnet_console_t;

void avnet_console_init( avnet_console_t *pConsole );
void avnet_console_process( avnet_console_t *pConsole );
int web_hprintf( void *web_handle, const char * fmt, ...);
int web_pipeprintf( void *web_handle, const char * fmt, ...);

void avnet_console_verbose_command( avnet_console_t *pConsole, int cargc, char ** cargv );
void avnet_console_delay_command( avnet_console_t *pConsole, int cargc, char ** cargv );
void avnet_console_mem_command( avnet_console_t *pConsole, int cargc, char ** cargv, Xuint32 baseAddress );
void avnet_console_iic_command( avnet_console_t *pConsole, int cargc, char ** cargv, fmc_iic_t *pIIC );

void avnet_console_adv7611_command( avnet_console_t *pConsole, int cargc, char ** cargv );
void avnet_console_adv7511_command( avnet_console_t *pConsole, int cargc, char ** cargv );
void avnet_console_cdce913_command( avnet_console_t *pConsole, int cargc, char ** cargv );

void avnet_console_cam_command( avnet_console_t *pConsole, int cargc, char ** cargv );
void avnet_console_cam_spi_command( avnet_console_t *pConsole, int cargc, char ** cargv );
//void avnet_console_cam_trigger_command( avnet_console_t *pConsole, int cargc, char ** cargv );
void avnet_console_cam_aec_command( avnet_console_t *pConsole, int cargc, char ** cargv );
void avnet_console_cam_again_command(avnet_console_t *pConsole, int cargc, char ** cargv );
void avnet_console_cam_dgain_command(avnet_console_t *pConsole, int cargc, char ** cargv );
//void avnet_console_cam_exposure_command(avnet_console_t *pConsole, int cargc, char ** cargv );

void avnet_console_ipipe_cfa_command( avnet_console_t *pConsole, int cargc, char ** cargv );

void avnet_console_start_command( avnet_console_t *pConsole, int cargc, char ** cargv );

#endif // __AVNET_CONSOLE_H__

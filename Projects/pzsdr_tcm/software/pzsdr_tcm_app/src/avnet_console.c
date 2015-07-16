//----------------------------------------------------------------
//      _____
//     /     \
//    /____   \____
//   / \===\   \==/
//  /___\===\___\/  AVNET
//       \======/
//        \====/    
//---------------------------------------------------------------
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
//----------------------------------------------------------------
//
// Create Date:         Nov 18, 2011
// Design Name:         Avnet Console
// Module Name:         avnet_console.c
// Project Name:        Avnet Console
//
// Tool versions:       ISE 14.2
//
// Description:         Text-based console for
//                      FMC-IMAGEON Getting Started Design
//
// Dependencies:        
//
// Revision:            Nov 18, 2010: 1.01 Initial version
//                      Sep 17, 2012: 1.02 Remove video multiplexers
//                                         Fix gamma equalization
//
//----------------------------------------------------------------


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

// Located in: microblaze_0/include/
#include "xbasic_types.h"
#include "xparameters.h"
#include "xstatus.h"
#include "fmc_iic.h"

//#include "sleep.h"

#if defined(LINUX_CODE)
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <regex.h>
#endif

#include "avnet_console.h"
#include "avnet_console_scanput.h"
#include "avnet_console_tokenize.h"

#include "tca9548.h"
#include "tcm5117pl.h"
#include "xccm.h"
#include "ccm_ext.h"

extern demo_t *pdemo;

#define RANGE_VALIDATE(value, min, max)	(value > max) ? max : (value < min) ? min : value

int avnet_console_get_line_poll( avnet_console_t *pConsole );

//void avnet_console_verbose_command( avnet_console_t *pConsole, int cargc, char ** cargv );

int avnet_console_input_validate( avnet_console_t *pConsole, char * argv, int min, int max, int *value);
void avnet_console_help( avnet_console_t *pConsole );

void avnet_console_init( avnet_console_t *pConsole )
{
   pConsole->inchar = ' ';
   pConsole->inline_count = 0;
   pConsole->verbose = 0;
   pConsole->echo = 1;
   pConsole->quit = 0;

   return;
}  

void avnet_console_process( avnet_console_t *pConsole )
{
  int  cargc;
  char * cargv[MAX_ARGC];
  int len;

  if ( pConsole->echo )
  {
    pConsole->io_hprintf( pConsole->io_handle, "%c", pConsole->inchar );
  }
   
#if 1
  // Check if complete line has been received ...
  if ( avnet_console_get_line_poll(pConsole) == -1 )
  {
     return;
  }

  // Pre-process command line
  len = strlen(pConsole->inline_buffer);
  if (pConsole->inline_buffer[len-1] == '\n')
  {
     pConsole->inline_buffer[len-1] = 0;
  }
  tokenize(pConsole->inline_buffer, &cargc, cargv, MAX_ARGC);

  // Process command line
  if (cargc == 0) {
     pConsole->io_hprintf( pConsole->io_handle, "\n\r%s>", AVNET_CONSOLE_PROMPT );
     return;
  }
  else if ( pConsole->verbose )
  {
     pConsole->io_hprintf( pConsole->io_handle, "\t");
     for ( len = 0; len < cargc; len++ )
     {
         pConsole->io_hprintf( pConsole->io_handle, "%s ", cargv[len]);
     }
     pConsole->io_hprintf( pConsole->io_handle, "\n\r");
  }

  if ( cargv[0][0] == '#' )
  {
     // comment, ignore line ...
  }
  //
  // General Commands
  //
  else if ( !strcmp(cargv[0],"help") )
  {
     avnet_console_help(pConsole);
  }
  else if ( !strcmp(cargv[0],"quit") )
  {
     pConsole->quit = 1;
  }
//  else if ( !strcmp(cargv[0],"verbose") )
//  {
//     avnet_console_verbose_command( pConsole, cargc, cargv );
//  }
  else if ( !strcmp(cargv[0],"iic") )
  {
	  avnet_console_iic_command( pConsole, cargc, cargv, pdemo->ppzsdr_fmccc_iic );
  }
  else if ( !strcmp(cargv[0],"fps") )
  {
	  avnet_console_fps_command( pConsole, cargc, cargv, pdemo->ppzsdr_fmccc_iic );
  }
  else if ( !strcmp(cargv[0],"ccm") )
  {
     avnet_console_ccm_command( pConsole, cargc, cargv );
  }
  else
  {
     pConsole->io_hprintf( pConsole->io_handle, "\tUnknown command : %s\n\r", cargv[0] );
  }
  pConsole->io_hprintf( pConsole->io_handle, "\n\r%s>", AVNET_CONSOLE_PROMPT );

#else
  // Get input character from xxx_session
  inchar = pConsole->inchar;
   
  //pConsole->io_hprintf( pConsole->io_handle, "%c (0x%02X)\n\r",inchar,inchar);

  switch ( inchar )
  {
     case '?':
     {
        avnet_console_help(p);
       break;
     }
     default:
     {
       break;
     }
  }

  pConsole->io_hprintf( pConsole->io_handle, "\n\r>");
#endif

  return;
}

void avnet_console_help( avnet_console_t *pConsole )
{
  pConsole->io_hprintf( pConsole->io_handle, "\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "--     Toshiba TCM3232PB on Avnet EMBV     --\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "General Commands:\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\thelp        Print the Top-Level menu Help Screen \n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tiic         IIC control to Toshiba sensor \n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tfps         Change the FPS of the Toshiba sensor \n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tccm         Color correction matrix related \n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------\n\r");

  return;
}

int avnet_console_input_validate( avnet_console_t *pConsole, char * argv, int min, int max, int *value)
{
	unsigned int uvalue = 0;
	int negative = 0;

	if (argv[0] == '-') {
		argv++;
		negative = 1;
	} else if (argv[0] == '+') {
		argv++;
		negative = 0;
	}

    if (!scanhex( argv, &uvalue )) {
    	pConsole->io_hprintf( pConsole->io_handle, "Non numeric input detected!\r\n");
    	return 0;
    }

    *value = (negative == 1) ? -uvalue : uvalue;
    *value = RANGE_VALIDATE(*value, min, max);

    return 1;
}

int avnet_console_get_line_poll( avnet_console_t *pConsole )
{
    int buffer_index;
    char character_copy = 0;
    u8 DataBuffer[MAX_LINE_LENGTH];
    unsigned int received_char_count = 0;
    //static unsigned int total_received_char_count = 0;

    // New characters come in one at a time ...
    DataBuffer[0] = (u8)pConsole->inchar;
    received_char_count = 1;

   for (buffer_index = 0; buffer_index < received_char_count; buffer_index++)
   {
      // Make sure that the line length has not been reached.
      if (pConsole->inline_count == (MAX_LINE_LENGTH-3))
      {
         // Force a line feed character, this is the end of the
         // line that is being polled for.
         pConsole->io_hprintf( pConsole->io_handle, "\r\n" );
         // Null terminate the string so that it is still a
         // valid string.
         pConsole->inline_buffer[pConsole->inline_count] = 0;
         // Reset the total character count in preparation for the
         // next line yet to be received.
         pConsole->inline_count = 0;
         // Return the total count of characters in the current line.
         return MAX_LINE_LENGTH;
      }
      // Get the next character that was received from the Uart Lite
      // device.
      character_copy = (char) DataBuffer[buffer_index];

      // Determine what action to take with the next received
      // character.
#if defined(LINUX_CODE)	  
      if (character_copy == '\r')
#else
      if (character_copy == '\n')
#endif	  
      {
         // Ignore it.
         ;
      }
#if defined(LINUX_CODE)	  
      else if (character_copy == '\n')
#else
      else if (character_copy == '\r')
#endif	  
      {
         // A line feed character has been encountered, this is the
         // end of the line that is being polled for.
         pConsole->io_hprintf( pConsole->io_handle, "\r\n" );
         // Null terminate the string so that it is still a
         // valid string.
         pConsole->inline_buffer[pConsole->inline_count] = 0;
         // Determine the number of characters that are in the line.
         received_char_count = pConsole->inline_count;
         // Reset the total character count in preparation for the
         // next line yet to be received.
         pConsole->inline_count = 0;
         // Return the total count of characters in the current line.
         return received_char_count;
      }
      // Check for backspace or delete key.
      else if ((character_copy == '\b') || (character_copy == 0x7F))
      {
         if (pConsole->inline_count > 0)
         {
            //outbyte('\b'); // Write backspace
            //outbyte(' ');  // Write space
            //outbyte('\b'); // Write backspace
            //pConsole->io_hprintf( pConsole->io_handle, "\b \b" );
            pConsole->io_hprintf( pConsole->io_handle, " \b" );
            pConsole->inline_count--;
            pConsole->inline_buffer[pConsole->inline_count] = 0;
         }
      }
      // Check for escape key or control-U.
      else if ((character_copy == 0x1b) || (character_copy == 0x15))
      {
         while (pConsole->inline_count > 0)
         {
            //outbyte('\b'); // Write backspace
            //outbyte(' ');  // Write space
            //outbyte('\b'); // Write backspace
            //pConsole->io_hprintf( pConsole->io_handle, "\b \b" );
            pConsole->io_hprintf( pConsole->io_handle, " \b" );
            pConsole->inline_count--;
            pConsole->inline_buffer[pConsole->inline_count] = 0;
         }
      }
      else
      {
         // Echo character back to the user.
         //pConsole->io_hprintf( pConsole->io_handle, "%c", character_copy );
         pConsole->inline_buffer[pConsole->inline_count] = character_copy;
         pConsole->inline_count++;
      }
   }

    return -1;
}

//void avnet_console_verbose_command( avnet_console_t *pConsole, int cargc, char ** cargv )
//{
//   int bDispSyntax = 0;
//
//   if ( cargc > 1 && !strcmp(cargv[1],"help") )
//   {
//      bDispSyntax = 1;
//   }
//   else if ( !strcmp(cargv[1],"ipipe") && cargc > 2 )
//   {
//	  if ( !strcmp(cargv[2],"on") || !strcmp(cargv[2],"1") )
//	  {
//		 fmc_imageon_demo.vipp.bVerbose = 1;
//	  }
//	  else
//	  {
//		 fmc_imageon_demo.vipp.bVerbose = 0;
//	  }
//   }
//   else if ( cargc > 1 )
//   {
//      if ( !strcmp(cargv[1],"on") || !strcmp(cargv[1],"1") )
//      {
//         pConsole->verbose = 1;
//         fmc_imageon_demo.bVerbose = 1;
//      }
//      else
//      {
//         pConsole->verbose = 0;
//         fmc_imageon_demo.bVerbose = 0;
//      }
//   }
//
//   pConsole->io_hprintf( pConsole->io_handle, "\tverbose = %s\n\r", pConsole->verbose ? "on" : "off" );
//
//   if ( bDispSyntax )
//   {
//      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
//      pConsole->io_hprintf( pConsole->io_handle, "\t\tverbose on|1  => Enable verbose mode\r\n" );
//      pConsole->io_hprintf( pConsole->io_handle, "\t\tverbose off   => Disable verbose mode\r\n" );
//      pConsole->io_hprintf( pConsole->io_handle, "\t\tverbose ipipe on|1  => Enable verbose mode for ipipe\r\n" );
//      pConsole->io_hprintf( pConsole->io_handle, "\t\tverbose ipipe off   => Disable verbose mode for ipipe\r\n" );
//   }
//
//   return;
//}
//
void avnet_console_iic_command( avnet_console_t *pConsole, int cargc, char ** cargv, fmc_iic_t *pIIC )
{
   Xuint32 tmp;
   Xuint8 device;
   Xuint16 address, address2;
   Xuint8 data, data2;
   Xuint8 mask;
   int num_bytes;

   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( cargc < 2 )
   {
      bDispSyntax = 1;
   }
   else
   {
//     if ( strcmp( cargv[1], "scan") == 0 )
//     {
//         Xuint8 dev;
//         address = 0x00;
//         pConsole->io_hprintf( pConsole->io_handle, "\tScanning for I2C devices ...\n\r" );
//         for ( dev = 1; dev < 128; dev++ )
//         {
//          device = (dev<<1);
//         num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data, 1 );
//         if ( num_bytes > 0 )
//         {
//            pConsole->io_hprintf( pConsole->io_handle, "\t\t0x%02X\n\r", device );
//         }
//       }
//     }
//     else if ( strcmp( cargv[1], "read") == 0 )
		if (strcmp(cargv[1], "read") == 0) {
			if (cargc < 4) {
				bDispSyntax = 1;
			}
       else {
				scanhex(cargv[2], &tmp);	device = (Xuint8) tmp;
				scanhex(cargv[3], &tmp);	address = (Xuint16) tmp;
				if (pConsole->verbose) {
					pConsole->io_hprintf(pConsole->io_handle,
							"\tdevice = 0x%02X\n\r", device);
					pConsole->io_hprintf(pConsole->io_handle,
							"\taddress = 0x%02X\n\r", address);
				}

				//XIicPs_A16_Read(pIIC,  (device >> 1), address, &data, 1);
				pIIC->fpIicERead( pIIC, (device>>1), address, &data, 1 );

				pConsole->io_hprintf(pConsole->io_handle,
						"\t0x%02X[0x%02X] => 0x%02X\n\r", device, address,
						data);
			}
		}
     else if (strcmp(cargv[1], "write") == 0) {
			if (cargc < 5) {
				bDispSyntax = 1;
			} else {
				scanhex(cargv[2], &tmp);	device = (Xuint8) tmp;
				scanhex(cargv[3], &tmp);	address = (Xuint16) tmp;
				scanhex(cargv[4], &tmp);	data = (Xuint8) tmp;
				if (pConsole->verbose) {
					pConsole->io_hprintf(pConsole->io_handle,
							"\tdevice = 0x%02X\n\r", device);
					pConsole->io_hprintf(pConsole->io_handle,
							"\taddress = 0x%02X\n\r", address);
					pConsole->io_hprintf(pConsole->io_handle,
							"\tdata = 0x%02X\n\r", data);
				}

				//XIicPs_A16_Write(pIIC, (device >> 1), address, &data, 1);
				pIIC->fpIicEWrite( pIIC, (device>>1), address, &data, 1 );

				pConsole->io_hprintf(pConsole->io_handle,
						"\t0x%02X[0x%02X] <= 0x%02X\n\r", device, address,
						data);
			}
		}
//     else if ( strcmp( cargv[1], "poll") == 0 )
//     {
//        if ( cargc < 6 )
//        {
//          bDispSyntax = 1;
//        }
//        else
//        {
//             scanhex(cargv[2],&tmp); device = (Xuint8)tmp;
//             scanhex(cargv[3],&tmp); address = (Xuint8)tmp;
//             scanhex(cargv[4],&tmp); data = (Xuint8)tmp;
//          scanhex(cargv[5],&tmp); mask = (Xuint8)tmp;
//          if ( pConsole->verbose )
//          {
//                pConsole->io_hprintf( pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
//            pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
//            pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%02X\n\r", data);
//            pConsole->io_hprintf( pConsole->io_handle, "\tmask = 0x%02X\n\r", mask);
//          }
//          do
//          {
//                num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data2, 1 );
//            pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X (polling for 0x%02X & 0x%02X)\n\r", device, address, data2, data, mask );
//          }
//          while ( data != (data2 & mask) );
//        }
//     }
//     else if ( strcmp( cargv[1], "rmw") == 0 )
//     {
//        if ( cargc < 6 )
//        {
//          bDispSyntax = 1;
//        }
//        else
//        {
//             scanhex(cargv[2],&tmp); device = (Xuint8)tmp;
//             scanhex(cargv[3],&tmp); address = (Xuint8)tmp;
//             scanhex(cargv[4],&tmp); data = (Xuint8)tmp;
//             scanhex(cargv[5],&tmp); mask = (Xuint8)tmp;
//             if ( pConsole->verbose )
//             {
//                pConsole->io_hprintf( pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
//                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
//                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%02X\n\r", data);
//                pConsole->io_hprintf( pConsole->io_handle, "\tmask = 0x%02X\n\r", mask);
//             }
//          // Read
//             num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data2, 1 );
//          pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X\n\r", device, address, data2 );
//          // Modify
//          data2 &= ~mask;
//          data2 |=  data;
//          // Write
//             num_bytes = pIIC->fpIicWrite( pIIC, (device>>1), address, &data2, 1 );
//          pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] <= 0x%02X\n\r", device, address, data2 );
//        }
//     }
		else if (strcmp(cargv[1], "dump") == 0) {
			if (cargc < 5) {
				bDispSyntax = 1;
			} else {
				scanhex(cargv[2], &tmp);	device = (Xuint8) tmp;
				scanhex(cargv[3], &tmp);	address = (Xuint16) tmp;
				scanhex(cargv[4], &tmp);	address2 = (Xuint16) tmp;
				if (pConsole->verbose) {
					pConsole->io_hprintf(pConsole->io_handle,
							"\tdevice = 0x%02X\n\r", device);
					pConsole->io_hprintf(pConsole->io_handle,
							"\taddress(start) = 0x%02X\n\r", address);
					pConsole->io_hprintf(pConsole->io_handle,
							"\taddress( end ) = 0x%02X\n\r", address2);
				}
				for (; address <= address2; address += 1) {
					//XIicPs_A16_Read(pIIC, (device >> 1), address, &data, 1);
					pIIC->fpIicERead( pIIC, (device>>1), address, &data, 1 );
					pConsole->io_hprintf(pConsole->io_handle,
							"\t0x%02X[0x%02X] => 0x%02X\n\r", device, address,
							data);
				}
			}
		}
//      else if ( strcmp( cargv[1], "gpio") == 0 )
//      {
//         Xuint32 gpio;
//         if ( cargc < 3 )
//         {
//            num_bytes = pIIC->fpGpoRead( pIIC, &gpio );
//            pConsole->io_hprintf( pConsole->io_handle, "\tGPIO => 0x%02X\n\r", gpio );
//         }
//         else
//         {
//             scanhex(cargv[2],&gpio);
//             if ( pConsole->verbose )
//             {
//                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%02X\n\r", gpio);
//             }
//             num_bytes = pIIC->fpGpoWrite( pIIC, gpio );
//             pConsole->io_hprintf( pConsole->io_handle, "\tGPIO <= 0x%02X\n\r", gpio );
//         }
//     }
     else
     {
        bDispSyntax = 1;
     }
   }

   if ( bDispSyntax == 1 )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
//      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s scan                                    => Scan for I2C devices\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s read  {device} {address}                => For {device}, Read from {address}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s write {device} {address} {data}         => For {device}, Write {data} to {address}\n\r", cargv[0] );
//      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s rmw   {device} {address} {data} {mask}  => For {device}, Read from {address}, apply {mask}, then write {data}\n\r", cargv[0] );
//      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s poll  {device} {address} {data} {mask}  => For {device}, Read from {address}, apply {mask}, until matches {data}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s dump  {device} {address1} {address2}    => For {device}, Read from {address1} to {address2}\n\r", cargv[0] );
//      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s gpio  {data}\n\r", cargv[0] );
   }

   return;
}

void avnet_console_fps_command( avnet_console_t *pConsole, int cargc, char ** cargv, fmc_iic_t *pIIC )
{
   Xuint32 tmp;
   int fps;


   Xuint8 device;
   Xuint16 address, address2;
   Xuint8 data, data2;
   Xuint8 mask;
   int num_bytes;

   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( cargc < 2 )
   {
      bDispSyntax = 1;
   }
   else {
		scanhex(cargv[1], &tmp); fps = tmp;

		switch (fps) {
		case 15:
			tca9548_i2c_mux_select(pIIC, EMBV_IIC_MUX_CAM);
			tcm5117pl_init(pIIC, TCM5117PL_1080P15);
			break;
		case 30:
			tca9548_i2c_mux_select(pIIC, EMBV_IIC_MUX_CAM);
			tcm5117pl_init(pIIC, TCM5117PL_1080P30);
			break;
		case 60:
			tca9548_i2c_mux_select(pIIC, EMBV_IIC_MUX_CAM);
			tcm5117pl_init(pIIC, TCM5117PL_1080P60);
			break;
		default:
			pConsole->io_hprintf(pConsole->io_handle,
					"Unsupported framerate\r\n");
			break;
		}
	}

   if ( bDispSyntax == 1 )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s [15|30|60]                              => Change framerate to [15|30|60]\n\r", cargv[0] );
   }

   return;
}

void avnet_console_ccm_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;

   if (cargc > 1 && !strcmp(cargv[1], "help")) {
		bDispSyntax = 1;
	} else if (cargc == 1) {
		XCcm_Coefs ccmCustom;
		s32 ROffset, GOffset, BOffset;

		XCcm_GetCoefMatrix(pdemo->pccm, &ccmCustom);

		pConsole->io_hprintf( pConsole->io_handle, "\t%s coefficients = ...\r\n", cargv[0] );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk11 = %2d.%03d\n\r", Integer(ccmCustom.K11), Fraction(ccmCustom.K11, 1000) );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk12 = %2d.%03d\n\r", Integer(ccmCustom.K12), Fraction(ccmCustom.K12, 1000) );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk13 = %2d.%03d\n\r", Integer(ccmCustom.K13), Fraction(ccmCustom.K13, 1000) );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk21 = %2d.%03d\n\r", Integer(ccmCustom.K21), Fraction(ccmCustom.K21, 1000) );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk22 = %2d.%03d\n\r", Integer(ccmCustom.K22), Fraction(ccmCustom.K22, 1000) );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk23 = %2d.%03d\n\r", Integer(ccmCustom.K23), Fraction(ccmCustom.K23, 1000) );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk31 = %2d.%03d\n\r", Integer(ccmCustom.K31), Fraction(ccmCustom.K31, 1000) );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk32 = %2d.%03d\n\r", Integer(ccmCustom.K32), Fraction(ccmCustom.K32, 1000) );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tk33 = %2d.%03d\n\r", Integer(ccmCustom.K33), Fraction(ccmCustom.K33, 1000) );

		XCcm_GetRgbOffset(pdemo->pccm,  &ROffset, &GOffset, &BOffset);

		pConsole->io_hprintf( pConsole->io_handle, "\t\tR offset = %d\n\r", ROffset );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tG offset = %d\n\r", GOffset );
		pConsole->io_hprintf( pConsole->io_handle, "\t\tB offset = %d\n\r", BOffset );
	} else if (!strcmp(cargv[1], "custom") && (cargc == 14)) {
		XCcm_Coefs ccmCustom;
		s32 ROffset, GOffset, BOffset;

		char *pArg;
		Xint32 negative;

		float fvalues[9];
		Xint32 ivalues[3];
		int i;

		for (i = 0; i < 12; i++) {
			pArg = cargv[2 + i];
			negative = 0;
			if (pArg[0] == '-') {
				pArg++;
				negative = 1;
			}
			if (pArg[0] == '+') {
				pArg++;
				negative = 0;
			}

			if (i < 9) {
				scanfloat(pArg, &fvalues[i]);
				if (negative) {
					fvalues[i] = -fvalues[i];
				}

				fvalues[i] = (fvalues[i] >= 8.0) ? 7.9999 : fvalues[i];
				fvalues[i] = (fvalues[i] <= -8.0) ? -7.9999 : fvalues[i];
			} else {
				scanhex(pArg, &ivalues[i - 9]);
				if (negative) {
					ivalues[i - 9] = -ivalues[i - 9];
				}

				ivalues[i - 9] = (ivalues[i - 9] >= 256) ? 255 : ivalues[i - 9];
				ivalues[i - 9] = (ivalues[i - 9] <= -256) ? -255 : ivalues[i - 9];
			}
		}

		ccmCustom.K11 = fvalues[0];
		ccmCustom.K12 = fvalues[1];
		ccmCustom.K13 = fvalues[2];
		ccmCustom.K21 = fvalues[3];
		ccmCustom.K22 = fvalues[4];
		ccmCustom.K23 = fvalues[5];
		ccmCustom.K31 = fvalues[6];
		ccmCustom.K32 = fvalues[7];
		ccmCustom.K33 = fvalues[8];

		ROffset = ivalues[0];
		GOffset = ivalues[1];
		BOffset = ivalues[2];

		XCcm_SetCoefMatrix(pdemo->pccm, &ccmCustom);
		XCcm_SetRgbOffset(pdemo->pccm, ROffset, GOffset, BOffset);

	} else if (!strcmp(cargv[1], "bypass")) {
		XCcm_SetCoefMatrix(pdemo->pccm, &CCM_IDENTITY);
		pConsole->io_hprintf(pConsole->io_handle, "\tCCM = Bypass\r\n");
	} else if (!strcmp(cargv[1], "day")) {
		XCcm_SetCoefMatrix(pdemo->pccm, &CCM_RGB_DAY);
		pConsole->io_hprintf(pConsole->io_handle, "\tCCM = Daylight\r\n");
	} else if (!strcmp(cargv[1], "cwf")) {
		XCcm_SetCoefMatrix(pdemo->pccm, &CCM_RGB_CWF);
		pConsole->io_hprintf(pConsole->io_handle, "\tCCM = CoolWhiteFluorescent\r\n");
	} else if (!strcmp(cargv[1], "u30")) {
		XCcm_SetCoefMatrix(pdemo->pccm, &CCM_RGB_U30);
		pConsole->io_hprintf(pConsole->io_handle, "\tCCM = 3000K\r\n");
	} else if (!strcmp(cargv[1], "inc")) {
		XCcm_SetCoefMatrix(pdemo->pccm, &CCM_RGB_INC);
		pConsole->io_hprintf(pConsole->io_handle, "\tCCM = Incandescent\r\n");
	} else {
		bDispSyntax = 1;
	}

	if (bDispSyntax) {
		pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
		pConsole->io_hprintf( pConsole->io_handle, "\t\t%s              => ...\r\n", cargv[0] );
		pConsole->io_hprintf( pConsole->io_handle, "\t\t%s custom {...} => Set custom CCM coefficient\r\n", cargv[0] );
		pConsole->io_hprintf( pConsole->io_handle, "\t\t%s bypass       => Set CCM to Bypass\r\n", cargv[0] );
		pConsole->io_hprintf( pConsole->io_handle, "\t\t%s day          => Set CCM to Daylight\r\n", cargv[0] );
		pConsole->io_hprintf( pConsole->io_handle, "\t\t%s cwf          => Set CCM to CoolWhiteFluorescent\r\n", cargv[0] );
		pConsole->io_hprintf( pConsole->io_handle, "\t\t%s u30          => Set CCM to 3000K\r\n", cargv[0] );
		pConsole->io_hprintf( pConsole->io_handle, "\t\t%s inc          => Set CCM to Incandescent\r\n", cargv[0] );
	}

	return;
}

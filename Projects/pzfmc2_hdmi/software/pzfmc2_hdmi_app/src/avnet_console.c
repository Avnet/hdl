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
//                      FMC-HDMI-CAM Getting Started Design
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
  else if ( !strcmp(cargv[0],"verbose") )
  {
     avnet_console_verbose_command( pConsole, cargc, cargv );
  }
  //
  // Getting Started Commands
  //
  else if ( !strcmp(cargv[0],"start") )
  {
     avnet_console_start_command( pConsole, cargc, cargv );
  }
  //
  // Debug Commands
  //
  else if ( !strcmp(cargv[0],"hdmio") )
  {
     avnet_console_hdmio_command( pConsole, cargc, cargv );
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
  pConsole->io_hprintf( pConsole->io_handle, "------------------------------------------------------\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "--             FMC-HDMI-CAM + PYTHON-1300-C         --\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "--               Getting Started Design             --\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "------------------------------------------------------\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "General Commands:\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\thelp        Print the Top-Level menu Help Screen \n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tverbose on  Enable verbose\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tverbose off Disable verbose\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "Getting Started Commands\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tstart       start and select video source (hdmi|cam)\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "Debugging Commands\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\thdmio delay Set ADV7511 programmable clk delay (0=-1.2ns, ... 3=0ns, ... 7=+1.2ns)\r\n" );
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

void avnet_console_verbose_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( cargc > 1 )
   {
      if ( !strcmp(cargv[1],"on") || !strcmp(cargv[1],"1") )
      {
         pConsole->verbose = 1;
         pdemo->bVerbose = 1;
      }
      else
      {
         pConsole->verbose = 0;
         pdemo->bVerbose = 0;
      }
   }

   pConsole->io_hprintf( pConsole->io_handle, "\tverbose = %s\n\r", pConsole->verbose ? "on" : "off" );

   if ( bDispSyntax )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tverbose on|1  => Enable verbose mode\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tverbose off   => Disable verbose mode\r\n" );
   }

   return;
}

void avnet_console_start_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( cargc > 1 )
   {
      if ( !strcmp(cargv[1],"hdmi") )
      {
         demo_stop_frame_buffer(pdemo);
         demo_init_frame_buffer(pdemo);
         demo_start_hdmi_out(pdemo);

         pdemo->cam_alpha = 0x00;
         pdemo->hdmi_alpha = 0xFF;
         demo_start_hdmi_in(pdemo);

         demo_start_frame_buffer(pdemo);
      }
      else if ( !strcmp(cargv[1],"cam") )
      {
         demo_stop_frame_buffer(pdemo);
         demo_init_frame_buffer(pdemo);
         demo_start_hdmi_out(pdemo);

         pdemo->cam_alpha = 0xFF;
         pdemo->hdmi_alpha = 0x00;
         demo_start_cam_in(pdemo);

         demo_start_frame_buffer(pdemo);
      }
   }

   if ( bDispSyntax )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tstart cam   => Start CAM  video source\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tstart hdmi  => Start HDMI video source\r\n" );
   }

   return;
}

void avnet_console_hdmio_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;
	Xuint32 tmp;
	Xuint8 clk_delay;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( cargc > 1 )
   {
	  if ( !strcmp(cargv[1],"delay") )
	  {
         scanhex(cargv[2], &tmp);	clk_delay = (Xuint8) tmp;
         pzfmc2_hdmio_set_clk_delay( clk_delay );
	  }
   }

   if ( bDispSyntax )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\thdmio delay => Set ADV7511 programmable clk delay (0=-1.2ns, ... 3=0ns, ... 7=+1.2ns)\r\n" );
   }

   return;
}


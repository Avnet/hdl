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
// Module Name:         avnet_console.c
// Project Name:        Avnet Console
//
// Tool versions:       Vivado 2016.4
//
// Description:         Text-based console for
//                      FMC-HDMI-CAM Getting Started Design
//
// Dependencies:        
//
// Revision:            Nov 18, 2010: 1.01 Initial version
//                      Sep 17, 2012: 1.02 Remove video multiplexers
//                                         Fix gamma equalization
//                      Jun 01, 2017: 1.03 Add CFA command to set bayer
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
  else if ( !strcmp(cargv[0],"delay") )
  {
     avnet_console_delay_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"mem") )
  {
     avnet_console_mem_command( pConsole, cargc, cargv, 0x00000000 );
  }
  else if ( !strcmp(cargv[0],"iic") )
  {
     avnet_console_iic_command( pConsole, cargc, cargv, &(pdemo->fmc_hdmi_cam_iic) );
  }
  //
  // FMC-HDMI-CAM commands
  //
  else if ( !strcmp(cargv[0],"adv7611") )
  {
    avnet_console_adv7611_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"adv7511") )
  {
    avnet_console_adv7511_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"cdce913") )
  {
    avnet_console_cdce913_command( pConsole, cargc, cargv );
  }

  //
  // CAM (PYTHON-1300-C) Commands
  //
  else if ( !strcmp(cargv[0],"cam") )
  {
     avnet_console_cam_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"camspi") )
  {
     avnet_console_cam_spi_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"camreg") )
  {
     avnet_console_mem_command( pConsole, cargc, cargv, XPAR_ONSEMI_PYTHON_CAM_0_S00_AXI_BASEADDR );
  }
  //else if ( !strcmp(cargv[0],"trig") )
  //{
  //   avnet_console_cam_trigger_command( pConsole, cargc, cargv );
  //}
  else if ( !strcmp(cargv[0],"aec") )
  {
    avnet_console_cam_aec_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"again") )
  {
	avnet_console_cam_again_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"dgain") )
  {
	avnet_console_cam_dgain_command( pConsole, cargc, cargv );
  }
  //else if ( !strcmp(cargv[0],"exposure") )
  //{
  //  avnet_console_cam_exposure_command( pConsole, cargc, cargv );
  //}
  // Video IP Commands
  else if ( !strcmp(cargv[0],"cfa") )
  {
     avnet_console_ipipe_cfa_command( pConsole, cargc, cargv );
  }
  // Getting Started Commands
  else if ( !strcmp(cargv[0],"start") )
  {
     avnet_console_start_command( pConsole, cargc, cargv );
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
  pConsole->io_hprintf( pConsole->io_handle, "\thelp       Print the Top-Level menu Help Screen \n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tverbose    Toggle verbosity on/off\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tdelay      Wait for specified delay\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tmem        Memory accesses\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tiic        IIC accesses on FMC-HDMI-CAM I2C chain\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "FMC-HDMI-CAM Commands\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tadv7611    HDMI input (ADV7611) configuration\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tadv7511    HDMI output (ADV7511) configuration\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tcdce913    Clock syntheizer (CDCE913) configuration\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "Camera (PYTHON-1300-C) Commands\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tcam        PYTHON-1300 commands (status, ...)\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tcamspi     SPI accesses to PYTHON-1300 sensor\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tcamreg     Memory accesses to PYTHON-1300 receiver\n\r");
  //pConsole->io_hprintf( pConsole->io_handle, "\ttrig       Trigger configuration (off/stress/internal/external/manual)\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\taec        Auto Exposure Control (on|off)\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tagain      Analog gain (0-10)\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tdgain      Digital gain (0-4095) where 128 corresponds to 1.00\n\r");
  //pConsole->io_hprintf( pConsole->io_handle, "\texposure   Exposure time (1-99) in percentage of frame period (16.66 msec)\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "Video IP Commands\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tcfa        Color Filter Array Interpolation configuration\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "Getting Started Commands\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tstart      Start and select video source (hdmi|cam)\n\r");
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

void avnet_console_delay_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   Xuint32 delay;

   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( cargc < 2 )
   {
     pConsole->io_hprintf( pConsole->io_handle, "\twaiting 1 sec\n\r" );
     sleep(1);
   }
   else
   {
      scanhex( cargv[1], &delay );
      if ( cargc < 3 )
      {
        pConsole->io_hprintf( pConsole->io_handle, "\twaiting %d sec\n\r", delay );
        sleep(delay);
      }
      else if ( strcmp( cargv[2], "sec") == 0 )
      {
         pConsole->io_hprintf( pConsole->io_handle, "\twaiting %d sec\n\r", delay );
         sleep(delay);
      }
      else if ( strcmp( cargv[2], "msec") == 0 )
      {
         pConsole->io_hprintf( pConsole->io_handle, "\twaiting %d msec\n\r", delay );
         usleep(1000*delay);
      }
      else if ( strcmp( cargv[2], "usec") == 0 )
      {
         pConsole->io_hprintf( pConsole->io_handle, "\twaiting %d usec\n\r", delay );
         usleep(delay);
      }
   }

   if ( bDispSyntax )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tdelay {#}         => Delay by specified number of seconds\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tdelay {#} sec     => Delay by specified number of seconds\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tdelay {#} msec    => Delay by specified number of milli-seconds\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tdelay {#} usec    => Delay by specified number of micro-seconds\r\n" );
   }


}

void avnet_console_mem_command( avnet_console_t *pConsole, int cargc, char ** cargv, Xuint32 base_address )
{
   Xuint32 *pMemory;

   Xuint32 address, address2;
   Xuint32 data, data2;
   Xuint32 mask;

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
      if ( strcmp( cargv[1], "read") == 0 )
      {
         if ( cargc < 3 )
         {
            bDispSyntax = 1;
         }
         else
         {
            scanhex(cargv[2],&address);
            if ( pConsole->verbose )
            {
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%08X\n\r", address);
            }
            pMemory = (Xuint32 *)(base_address + address);
            data = *pMemory;
            pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X => 0x%08X\n\r", pMemory, data );
         }
      }
      else if ( strcmp( cargv[1], "write") == 0 )
      {
          if ( cargc < 4 )
          {
             bDispSyntax = 1;
          }
          else
          {
             scanhex(cargv[2],&address);
             scanhex(cargv[3],&data);
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%08X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%08X\n\r", data);
             }
             pMemory = (Xuint32 *)(base_address + address);
             *pMemory = data;
             pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", pMemory, data );
          }
      }
      else if ( strcmp( cargv[1], "poll") == 0 )
      {
          if ( cargc < 5 )
          {
             bDispSyntax = 1;
          }
          else
          {
             scanhex(cargv[2],&address);
             scanhex(cargv[3],&data);
             scanhex(cargv[4],&mask);
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%08X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%08X\n\r", data);
                pConsole->io_hprintf( pConsole->io_handle, "\tmask = 0x%08X\n\r", mask);
             }
             pMemory = (Xuint32 *)(base_address + address);
             do
             {
                data2 = *pMemory;
                pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X => 0x%08X (polling for 0x%08X & 0x%08X)\n\r", pMemory, data2, data, mask );
             }
             while ( data != (data2 & mask) );
          }
      }
      else if ( strcmp( cargv[1], "rmw") == 0 )
      {
          if ( cargc < 5 )
          {
             bDispSyntax = 1;
          }
          else
          {
             scanhex(cargv[2],&address);
             scanhex(cargv[3],&data);
             scanhex(cargv[4],&mask);
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%08X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%08X\n\r", data);
                pConsole->io_hprintf( pConsole->io_handle, "\tmask = 0x%08X\n\r", mask);
             }
             pMemory = (Xuint32 *)(base_address + address);
             // Read
             data2 = *pMemory;
             pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X => 0x%08X\n\r", pMemory, data2 );
             // Modify
             data2 &= ~mask;
             data2 |=  data;
             // Write
             *pMemory = data2;
             pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", pMemory, data2 );
          }
      }
      else if ( strcmp( cargv[1], "dump") == 0 )
      {
          if ( cargc < 4 )
          {
             bDispSyntax = 1;
          }
          else
          {
             scanhex(cargv[2],&address);
             scanhex(cargv[3],&address2);
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\tstart address = 0x%08X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tend   address = 0x%08X\n\r", address2);
             }
             for ( ; address <= address2; address += 4 )
             {
                pMemory = (Xuint32 *)(base_address + address);
                data = *pMemory;
                pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X => 0x%08X\n\r", pMemory, data );
             }
          }
      }
   }

   if ( bDispSyntax == 1 )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s read  {address}                 => Read from {address}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s write {address} {data}          => Write {data} to {address}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s rmw   {address} {data} {mask}   => Read from {address}, apply {mask}, then write {data}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s poll  {address} {data} {mask}   => Read from {address}, apply {mask}, until matches {data}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s dump  {address1} {address2}     => Read from {address1} to {address2}\n\r", cargv[0] );
   }

   return;
}

void avnet_console_iic_command( avnet_console_t *pConsole, int cargc, char ** cargv, fmc_iic_t *pIIC )
{
   Xuint32 tmp;
   Xuint8 device;
   Xuint8 address, address2;
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
     if ( strcmp( cargv[1], "scan") == 0 )
     {
         Xuint8 dev;
         address = 0x00;
         pConsole->io_hprintf( pConsole->io_handle, "\tScanning for I2C devices ...\n\r" );
         for ( dev = 1; dev < 128; dev++ )
         {
          device = (dev<<1);
         num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data, 1 );
         if ( num_bytes > 0 )
         {
            pConsole->io_hprintf( pConsole->io_handle, "\t\t0x%02X\n\r", device );
         }
       }
     }
     else if ( strcmp( cargv[1], "read") == 0 )
     {
       if ( cargc < 4 )
       {
         bDispSyntax = 1;
       }
       else
       {
            scanhex(cargv[2],&tmp); device = (Xuint8)tmp;
         scanhex(cargv[3],&tmp); address = (Xuint8)tmp;
         if ( pConsole->verbose )
         {
               pConsole->io_hprintf( pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
               pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
         }
         num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data, 1 );
         pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X\n\r", device, address, data );
       }
     }
     else if ( strcmp( cargv[1], "write") == 0 )
     {
        if ( cargc < 5 )
        {
          bDispSyntax = 1;
        }
        else
        {
             scanhex(cargv[2],&tmp); device = (Xuint8)tmp;
             scanhex(cargv[3],&tmp); address = (Xuint8)tmp;
             scanhex(cargv[4],&tmp); data = (Xuint8)tmp;
          if ( pConsole->verbose )
          {
                pConsole->io_hprintf( pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
            pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
            pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%02X\n\r", data);
          }
             num_bytes = pIIC->fpIicWrite( pIIC, (device>>1), address, &data, 1 );
          pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] <= 0x%02X\n\r", device, address, data );
        }
     }
     else if ( strcmp( cargv[1], "poll") == 0 )
     {
        if ( cargc < 6 )
        {
          bDispSyntax = 1;
        }
        else
        {
             scanhex(cargv[2],&tmp); device = (Xuint8)tmp;
             scanhex(cargv[3],&tmp); address = (Xuint8)tmp;
             scanhex(cargv[4],&tmp); data = (Xuint8)tmp;
          scanhex(cargv[5],&tmp); mask = (Xuint8)tmp;
          if ( pConsole->verbose )
          {
                pConsole->io_hprintf( pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
            pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
            pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%02X\n\r", data);
            pConsole->io_hprintf( pConsole->io_handle, "\tmask = 0x%02X\n\r", mask);
          }
          do
          {
                num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data2, 1 );
            pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X (polling for 0x%02X & 0x%02X)\n\r", device, address, data2, data, mask );
          }
          while ( data != (data2 & mask) );
        }
     }
     else if ( strcmp( cargv[1], "rmw") == 0 )
     {
        if ( cargc < 6 )
        {
          bDispSyntax = 1;
        }
        else
        {
             scanhex(cargv[2],&tmp); device = (Xuint8)tmp;
             scanhex(cargv[3],&tmp); address = (Xuint8)tmp;
             scanhex(cargv[4],&tmp); data = (Xuint8)tmp;
             scanhex(cargv[5],&tmp); mask = (Xuint8)tmp;
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%02X\n\r", data);
                pConsole->io_hprintf( pConsole->io_handle, "\tmask = 0x%02X\n\r", mask);
             }
          // Read
             num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data2, 1 );
          pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X\n\r", device, address, data2 );
          // Modify
          data2 &= ~mask;
          data2 |=  data;
          // Write
             num_bytes = pIIC->fpIicWrite( pIIC, (device>>1), address, &data2, 1 );
          pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] <= 0x%02X\n\r", device, address, data2 );
        }
     }
     else if ( strcmp( cargv[1], "dump") == 0 )
     {
        if ( cargc < 5 )
        {
          bDispSyntax = 1;
        }
        else
        {
             scanhex(cargv[2],&tmp); device = (Xuint8)tmp;
             scanhex(cargv[3],&tmp); address = (Xuint8)tmp;
             scanhex(cargv[4],&tmp); address2 = (Xuint8)tmp;
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
                pConsole->io_hprintf( pConsole->io_handle, "\taddress(start) = 0x%02X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\taddress( end ) = 0x%02X\n\r", address2);
             }
          for ( ; address <= address2; address += 1 )
          {
                num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data, 1 );
            pConsole->io_hprintf( pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X\n\r", device, address, data );
          }
        }
     }
      else if ( strcmp( cargv[1], "gpio") == 0 )
      {
         Xuint32 gpio;
         if ( cargc < 3 )
         {
            num_bytes = pIIC->fpGpoRead( pIIC, &gpio );
            pConsole->io_hprintf( pConsole->io_handle, "\tGPIO => 0x%02X\n\r", gpio );
         }
         else
         {
             scanhex(cargv[2],&gpio);
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%02X\n\r", gpio);
             }
             num_bytes = pIIC->fpGpoWrite( pIIC, gpio );
             pConsole->io_hprintf( pConsole->io_handle, "\tGPIO <= 0x%02X\n\r", gpio );
         }
     }
     else
     {
        bDispSyntax = 1;
     }
   }

   if ( bDispSyntax == 1 )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s scan                                    => Scan for I2C devices\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s read  {device} {address}                => For {device}, Read from {address}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s write {device} {address} {data}         => For {device}, Write {data} to {address}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s rmw   {device} {address} {data} {mask}  => For {device}, Read from {address}, apply {mask}, then write {data}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s poll  {device} {address} {data} {mask}  => For {device}, Read from {address}, apply {mask}, until matches {data}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s dump  {device} {address1} {address2}    => For {device}, Read from {address1} to {address2}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s gpio  {data}\n\r", cargv[0] );
   }

   return;
}

void avnet_console_adv7611_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;
   Xuint32 llc_polarity;
   Xuint32 llc_delay;
   int i;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( cargc > 1 )
   {
	  if ( !strcmp(cargv[1],"llcp") )
	  {
		 scanhex( cargv[2], &llc_polarity );
		 if ( llc_polarity > 1 ) llc_polarity = 0;
         pdemo->adv7611_llc_polarity = llc_polarity;
	  }
	  else if ( !strcmp(cargv[1],"llcd") )
	  {
		 scanhex( cargv[2], &llc_delay );
		 if ( llc_delay > 31 ) llc_delay = 31;
         pdemo->adv7611_llc_delay = llc_delay;
	  }
	  else
	  {
		 bDispSyntax = 1;
	  }
   }

   pConsole->io_hprintf( pConsole->io_handle, "ADV7611 LLC Polarity = %d\n\r", pdemo->adv7611_llc_polarity );
   pConsole->io_hprintf( pConsole->io_handle, "ADV7611 LLC Delay = %d\n\r", pdemo->adv7611_llc_delay );
   pConsole->io_hprintf( pConsole->io_handle, "=> use \"start hdmi\" command for changes to take effect\n\r" );


   if ( bDispSyntax )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tadv7611 llcp # => Set the FMC's ADV7611 programmable LLC polarity (0-1)\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tadv7611 llcd # => Set the FMC's ADV7611 programmable LLC delay (0-31)\r\n" );
   }

   return;
}

#define ADV7511_CSC_CONFIG_LEN  (24)

// ADV7511 Default Values
Xuint8 adv7511_csc_config_00[ADV7511_CSC_CONFIG_LEN][3] =
{
		IIC_ADV7511_BASE_ADDR>>1, 0x18, 0xC6,
		IIC_ADV7511_BASE_ADDR>>1, 0x19, 0x62,
		IIC_ADV7511_BASE_ADDR>>1, 0x1A, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x1B, 0xA8,
		IIC_ADV7511_BASE_ADDR>>1, 0x1C, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1D, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1E, 0x1C,
		IIC_ADV7511_BASE_ADDR>>1, 0x1F, 0x84,
		IIC_ADV7511_BASE_ADDR>>1, 0x20, 0x1C,
		IIC_ADV7511_BASE_ADDR>>1, 0x21, 0xBF,
		IIC_ADV7511_BASE_ADDR>>1, 0x22, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x23, 0xA8,
		IIC_ADV7511_BASE_ADDR>>1, 0x24, 0x1E,
		IIC_ADV7511_BASE_ADDR>>1, 0x25, 0x70,
		IIC_ADV7511_BASE_ADDR>>1, 0x26, 0x02,
		IIC_ADV7511_BASE_ADDR>>1, 0x27, 0x1E,
		IIC_ADV7511_BASE_ADDR>>1, 0x28, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x29, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x2A, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x2B, 0xA8,
		IIC_ADV7511_BASE_ADDR>>1, 0x2C, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x2D, 0x12,
		IIC_ADV7511_BASE_ADDR>>1, 0x2E, 0x1B,
		IIC_ADV7511_BASE_ADDR>>1, 0x2F, 0xAC
};

// HDTV YCbCr (16to235) to RGB (16to235)
Xuint8 adv7511_csc_config_01[ADV7511_CSC_CONFIG_LEN][3] =
{
		IIC_ADV7511_BASE_ADDR>>1, 0x18, 0xAC,
		IIC_ADV7511_BASE_ADDR>>1, 0x19, 0x53,
		IIC_ADV7511_BASE_ADDR>>1, 0x1A, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x1B, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1C, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1D, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1E, 0x19,
		IIC_ADV7511_BASE_ADDR>>1, 0x1F, 0xD6,
		IIC_ADV7511_BASE_ADDR>>1, 0x20, 0x1C,
		IIC_ADV7511_BASE_ADDR>>1, 0x21, 0x56,
		IIC_ADV7511_BASE_ADDR>>1, 0x22, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x23, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x24, 0x1E,
		IIC_ADV7511_BASE_ADDR>>1, 0x25, 0x88,
		IIC_ADV7511_BASE_ADDR>>1, 0x26, 0x02,
		IIC_ADV7511_BASE_ADDR>>1, 0x27, 0x91,
		IIC_ADV7511_BASE_ADDR>>1, 0x28, 0x1F,
		IIC_ADV7511_BASE_ADDR>>1, 0x29, 0xFF,
		IIC_ADV7511_BASE_ADDR>>1, 0x2A, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x2B, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x2C, 0x0E,
		IIC_ADV7511_BASE_ADDR>>1, 0x2D, 0x85,
		IIC_ADV7511_BASE_ADDR>>1, 0x2E, 0x18,
		IIC_ADV7511_BASE_ADDR>>1, 0x2F, 0xBE
};

// HDTV YCbCr (16to235) to RGB (0to255)
Xuint8 adv7511_csc_config_02[ADV7511_CSC_CONFIG_LEN][3] =
{
		IIC_ADV7511_BASE_ADDR>>1, 0x18, 0xE7,
		IIC_ADV7511_BASE_ADDR>>1, 0x19, 0x34,
		IIC_ADV7511_BASE_ADDR>>1, 0x1A, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x1B, 0xAD,
		IIC_ADV7511_BASE_ADDR>>1, 0x1C, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1D, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1E, 0x1C,
		IIC_ADV7511_BASE_ADDR>>1, 0x1F, 0x1B,
		IIC_ADV7511_BASE_ADDR>>1, 0x20, 0x1D,
		IIC_ADV7511_BASE_ADDR>>1, 0x21, 0xDC,
		IIC_ADV7511_BASE_ADDR>>1, 0x22, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x23, 0xAD,
		IIC_ADV7511_BASE_ADDR>>1, 0x24, 0x1F,
		IIC_ADV7511_BASE_ADDR>>1, 0x25, 0x24,
		IIC_ADV7511_BASE_ADDR>>1, 0x26, 0x01,
		IIC_ADV7511_BASE_ADDR>>1, 0x27, 0x35,
		IIC_ADV7511_BASE_ADDR>>1, 0x28, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x29, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x2A, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x2B, 0xAD,
		IIC_ADV7511_BASE_ADDR>>1, 0x2C, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x2D, 0x7C,
		IIC_ADV7511_BASE_ADDR>>1, 0x2E, 0x1B,
		IIC_ADV7511_BASE_ADDR>>1, 0x2F, 0x77
};

// SDTV YCbCr (16to235) to RGB (16to235)
Xuint8 adv7511_csc_config_03[ADV7511_CSC_CONFIG_LEN][3] =
{
		IIC_ADV7511_BASE_ADDR>>1, 0x18, 0xAA,
		IIC_ADV7511_BASE_ADDR>>1, 0x19, 0xF8,
		IIC_ADV7511_BASE_ADDR>>1, 0x1A, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x1B, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1C, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1D, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1E, 0x1A,
		IIC_ADV7511_BASE_ADDR>>1, 0x1F, 0x84,
		IIC_ADV7511_BASE_ADDR>>1, 0x20, 0x1A,
		IIC_ADV7511_BASE_ADDR>>1, 0x21, 0x6A,
		IIC_ADV7511_BASE_ADDR>>1, 0x22, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x23, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x24, 0x1D,
		IIC_ADV7511_BASE_ADDR>>1, 0x25, 0x50,
		IIC_ADV7511_BASE_ADDR>>1, 0x26, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x27, 0x23,
		IIC_ADV7511_BASE_ADDR>>1, 0x28, 0x1F,
		IIC_ADV7511_BASE_ADDR>>1, 0x29, 0xFC,
		IIC_ADV7511_BASE_ADDR>>1, 0x2A, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x2B, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x2C, 0x0D,
		IIC_ADV7511_BASE_ADDR>>1, 0x2D, 0xDE,
		IIC_ADV7511_BASE_ADDR>>1, 0x2E, 0x19,
		IIC_ADV7511_BASE_ADDR>>1, 0x2F, 0x13
};

// SDTV YCbCr (16to235) to RGB (0to255)
Xuint8 adv7511_csc_config_04[ADV7511_CSC_CONFIG_LEN][3] =
{
		IIC_ADV7511_BASE_ADDR>>1, 0x18, 0xE6,
		IIC_ADV7511_BASE_ADDR>>1, 0x19, 0x69,
		IIC_ADV7511_BASE_ADDR>>1, 0x1A, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x1B, 0xAC,
		IIC_ADV7511_BASE_ADDR>>1, 0x1C, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1D, 0x00,
		IIC_ADV7511_BASE_ADDR>>1, 0x1E, 0x1C,
		IIC_ADV7511_BASE_ADDR>>1, 0x1F, 0x81,
		IIC_ADV7511_BASE_ADDR>>1, 0x20, 0x1C,
		IIC_ADV7511_BASE_ADDR>>1, 0x21, 0xBC,
		IIC_ADV7511_BASE_ADDR>>1, 0x22, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x23, 0xAD,
		IIC_ADV7511_BASE_ADDR>>1, 0x24, 0x1E,
		IIC_ADV7511_BASE_ADDR>>1, 0x25, 0x6E,
		IIC_ADV7511_BASE_ADDR>>1, 0x26, 0x02,
		IIC_ADV7511_BASE_ADDR>>1, 0x27, 0x20,
		IIC_ADV7511_BASE_ADDR>>1, 0x28, 0x1F,
		IIC_ADV7511_BASE_ADDR>>1, 0x29, 0xFE,
		IIC_ADV7511_BASE_ADDR>>1, 0x2A, 0x04,
		IIC_ADV7511_BASE_ADDR>>1, 0x2B, 0xAD,
		IIC_ADV7511_BASE_ADDR>>1, 0x2C, 0x08,
		IIC_ADV7511_BASE_ADDR>>1, 0x2D, 0x1A,
		IIC_ADV7511_BASE_ADDR>>1, 0x2E, 0x1B,
		IIC_ADV7511_BASE_ADDR>>1, 0x2F, 0xA9,
};

Xuint8 adv7511_clk_delay[1][3] =
{
		IIC_ADV7511_BASE_ADDR>>1, 0xBA, 0xA0 // 101 = 0.8ns
};


void avnet_console_adv7511_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;
   Xuint32 csc_idx;
   Xuint32 clk_delay;
   int i;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( cargc > 1 )
   {
	  if ( !strcmp(cargv[1],"csc") )
	  {
		 scanhex( cargv[2], &csc_idx );
		 if ( csc_idx > 4 ) csc_idx = 0;
		 switch ( csc_idx )
		 {
		 case 0:
			 pConsole->io_hprintf( pConsole->io_handle, "ADV7511 CSC = {default values}\n\r" );
             for ( i = 0; i < ADV7511_CSC_CONFIG_LEN; i++ )
             {
            	 pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, adv7511_csc_config_00[i][0], adv7511_csc_config_00[i][1], &(adv7511_csc_config_00[i][2]), 1);
             }
			 break;
		 case 1:
			 pConsole->io_hprintf( pConsole->io_handle, "ADV7511 CSC = HDTV YCbCr (16to235) to RGB (16to235)\n\r" );
             for ( i = 0; i < ADV7511_CSC_CONFIG_LEN; i++ )
             {
            	 pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, adv7511_csc_config_01[i][0], adv7511_csc_config_01[i][1], &(adv7511_csc_config_01[i][2]), 1);
             }
			 break;
		 case 2:
			 pConsole->io_hprintf( pConsole->io_handle, "ADV7511 CSC = HDTV YCbCr (16to235) to RGB (0to255)\n\r" );
             for ( i = 0; i < ADV7511_CSC_CONFIG_LEN; i++ )
             {
            	 pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, adv7511_csc_config_02[i][0], adv7511_csc_config_02[i][1], &(adv7511_csc_config_02[i][2]), 1);
             }
			 break;
		 case 3:
			 pConsole->io_hprintf( pConsole->io_handle, "ADV7511 CSC = SDTV YCbCr (16to235) to RGB (16to235)\n\r" );
             for ( i = 0; i < ADV7511_CSC_CONFIG_LEN; i++ )
             {
            	 pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, adv7511_csc_config_03[i][0], adv7511_csc_config_03[i][1], &(adv7511_csc_config_03[i][2]), 1);
             }
			 break;
		 case 4:
			 pConsole->io_hprintf( pConsole->io_handle, "ADV7511 CSC = SDTV YCbCr (16to235) to RGB (0to255)\n\r" );
             for ( i = 0; i < ADV7511_CSC_CONFIG_LEN; i++ )
             {
            	 pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, adv7511_csc_config_04[i][0], adv7511_csc_config_04[i][1], &(adv7511_csc_config_04[i][2]), 1);
             }
			 break;
		 }
	  }
	  if ( !strcmp(cargv[1],"clk") )
	  {
		 scanhex( cargv[2], &clk_delay );
		 if ( clk_delay > 7 ) clk_delay = 0;
		 adv7511_clk_delay[0][2] = clk_delay << 5;
		 pConsole->io_hprintf( pConsole->io_handle, "ADV7511 Clock Delay = %d\n\r", clk_delay );
       	 pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, adv7511_clk_delay[0][0], adv7511_clk_delay[0][1], &(adv7511_clk_delay[0][2]), 1);
	  }
	  else
	  {
		 bDispSyntax = 1;
	  }
   }

   if ( bDispSyntax )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tadv7511 csc #  => Select FMC's ADV7511 Color Space Conversion coefficients\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t0 = {default values}\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t1 = HDTV YCbCr (16to235) to RGB (16to235)\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t2 = HDTV YCbCr (16to235) to RGB (0to255)\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t3 = SDTV YCbCr (16to235) to RGB (16to235)\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t4 = SDTV YCbCr (16to235) to RGB (0to255)\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tadv7511 clk #  => Set the FMC's ADV7511 programmable clock delay\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t0 = -1.2ns\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t1 = -0.8ns\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t2 = -0.4ns\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t3 = no delays\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t4 = +0.4\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t5 = +0.8ns\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t6 = +1.2ns\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t\t7 = +1.6ns\r\n" );
   }

   return;
}

// CDCE913
#define MAX_IIC_CDCE913_SSC 3
static Xuint8 iic_cdce913_ssc_off[MAX_IIC_CDCE913_SSC][2]=
{
   0x10, 0x00, // SSC = 000 (off)
   0x11, 0x00, //
   0x12, 0x00  //
};
static Xuint8 iic_cdce913_ssc_0_25[MAX_IIC_CDCE913_SSC][2]=
{
   0x10, 0x24, // SSC = 001 (0.25%)
   0x11, 0x92, //
   0x12, 0x49  //
};
static Xuint8 iic_cdce913_ssc_0_50[MAX_IIC_CDCE913_SSC][2]=
{
   0x10, 0x49, // SSC = 010 (0.50%)
   0x11, 0x24, //
   0x12, 0x92  //
};
static Xuint8 iic_cdce913_ssc_0_75[MAX_IIC_CDCE913_SSC][2]=
{
   0x10, 0x6D, // SSC = 011 (0.75%)
   0x11, 0xB6, //
   0x12, 0xDB  //
};
static Xuint8 iic_cdce913_ssc_1_00[MAX_IIC_CDCE913_SSC][2]=
{
   0x10, 0x92, // SSC = 100 (1.00%)
   0x11, 0x49, //
   0x12, 0x24  //
};
static Xuint8 iic_cdce913_ssc_1_25[MAX_IIC_CDCE913_SSC][2]=
{
   0x10, 0xB6, // SSC = 101 (1.25%)
   0x11, 0xDB, //
   0x12, 0x6D  //
};
static Xuint8 iic_cdce913_ssc_1_50[MAX_IIC_CDCE913_SSC][2]=
{
   0x10, 0xDB, // SSC = 110 (1.50%)
   0x11, 0x6D, //
   0x12, 0xB6  //
};
static Xuint8 iic_cdce913_ssc_2_00[MAX_IIC_CDCE913_SSC][2]=
{
   0x10, 0xFF, // SSC = 111 (2.00%)
   0x11, 0xFF, //
   0x12, 0xFF  //
};

void avnet_console_cdce913_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;
   Xuint8 num_bytes;
   int i;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( cargc > 1 )
   {
	  if ( !strcmp(cargv[1],"ssc") && cargc > 2 )
	  {
		  fmc_hdmi_cam_iic_mux( pdemo->pfmc_hdmi_cam, FMC_HDMI_CAM_I2C_SELECT_VID_CLK );
         //
         if ( !strcmp(cargv[2],"off") || !strcmp(cargv[2],"0") )
         {
            for ( i = 0; i < MAX_IIC_CDCE913_SSC; i++ )
            {
               num_bytes = pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, FMC_HDMI_CAM_VID_CLK_ADDR,
            		(0x80 | iic_cdce913_ssc_off[i][0]), &(iic_cdce913_ssc_off[i][1]), 1);
            }
         }
         else if ( !strcmp(cargv[2],"0.25") )
         {
            for ( i = 0; i < MAX_IIC_CDCE913_SSC; i++ )
            {
                num_bytes = pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, FMC_HDMI_CAM_VID_CLK_ADDR,
            		(0x80 | iic_cdce913_ssc_0_25[i][0]), &(iic_cdce913_ssc_0_25[i][1]), 1);
            }
         }
         else if ( !strcmp(cargv[2],"0.50") )
         {
            for ( i = 0; i < MAX_IIC_CDCE913_SSC; i++ )
            {
                num_bytes = pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, FMC_HDMI_CAM_VID_CLK_ADDR,
            		(0x80 | iic_cdce913_ssc_0_50[i][0]), &(iic_cdce913_ssc_0_50[i][1]), 1);
            }
         }
         else if ( !strcmp(cargv[2],"on") || !strcmp(cargv[2],"0.75") )
         {
            for ( i = 0; i < MAX_IIC_CDCE913_SSC; i++ )
            {
                num_bytes = pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, FMC_HDMI_CAM_VID_CLK_ADDR,
            		(0x80 | iic_cdce913_ssc_0_75[i][0]), &(iic_cdce913_ssc_0_75[i][1]), 1);
            }
         }
         else if ( !strcmp(cargv[2],"1.00") )
         {
            for ( i = 0; i < MAX_IIC_CDCE913_SSC; i++ )
            {
                num_bytes = pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, FMC_HDMI_CAM_VID_CLK_ADDR,
            		(0x80 | iic_cdce913_ssc_1_00[i][0]), &(iic_cdce913_ssc_1_00[i][1]), 1);
            }
         }
         else if ( !strcmp(cargv[2],"1.25") )
         {
            for ( i = 0; i < MAX_IIC_CDCE913_SSC; i++ )
            {
                num_bytes = pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, FMC_HDMI_CAM_VID_CLK_ADDR,
            		(0x80 | iic_cdce913_ssc_1_25[i][0]), &(iic_cdce913_ssc_1_25[i][1]), 1);
            }
         }
         else if ( !strcmp(cargv[2],"1.50") )
         {
            for ( i = 0; i < MAX_IIC_CDCE913_SSC; i++ )
            {
                num_bytes = pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, FMC_HDMI_CAM_VID_CLK_ADDR,
            		(0x80 | iic_cdce913_ssc_1_50[i][0]), &(iic_cdce913_ssc_1_50[i][1]), 1);
            }
         }
         else if ( !strcmp(cargv[2],"2.00") )
         {
            for ( i = 0; i < MAX_IIC_CDCE913_SSC; i++ )
            {
                num_bytes = pdemo->pfmc_hdmi_cam_iic->fpIicWrite( pdemo->pfmc_hdmi_cam_iic, FMC_HDMI_CAM_VID_CLK_ADDR,
            		(0x80 | iic_cdce913_ssc_2_00[i][0]), &(iic_cdce913_ssc_2_00[i][1]), 1);
            }
         }
         else
         {
    		 bDispSyntax = 1;
         }
	  }
	  else
	  {
		 bDispSyntax = 1;
	  }
   }

   if ( bDispSyntax )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tcdce913 ssc off|0.25|0.50|0.75|1.00|1.25|1.50|2.00\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\t                     => Spread Spectrum Clocking\r\n" );
   }

   return;
}

void avnet_console_cam_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( (cargc == 2) && !strcmp(cargv[1],"stat") )
   {
	   onsemi_python_get_status( pdemo->ppython_receiver, &(pdemo->python_status_t1), 1 );
   }
   else
   {
      bDispSyntax = 1;
   }

   if ( bDispSyntax )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tcam stat    => Get status of PYTHON receiver\r\n" );
   }

   return;
}

void avnet_console_cam_spi_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   Xuint32 tmp;
   Xuint16 address, address2;
   Xuint16 data, data2;
   Xuint16 mask;

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
      if ( strcmp( cargv[1], "read") == 0 )
      {
         if ( cargc < 3 )
         {
            bDispSyntax = 1;
         }
         else
         {
            scanhex(cargv[2],&tmp); address = (Xuint16)tmp;
            if ( pConsole->verbose )
            {
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%04X\n\r", address);
            }
            onsemi_python_spi_read( pdemo->ppython_receiver, address, &data );
            pConsole->io_hprintf( pConsole->io_handle, "\t0x%04X => 0x%04X\n\r", address, data );
         }
      }
      else if ( strcmp( cargv[1], "write") == 0 )
      {
          if ( cargc < 4 )
          {
             bDispSyntax = 1;
          }
          else
          {
             scanhex(cargv[2],&tmp); address = (Xuint16)tmp;
             scanhex(cargv[3],&tmp); data = (Xuint16)tmp;
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%04X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%04X\n\r", data);
             }
             onsemi_python_spi_write( pdemo->ppython_receiver, address, data );
             pConsole->io_hprintf( pConsole->io_handle, "\t0x%04X <= 0x%04X\n\r", address, data );
          }
      }
      else if ( strcmp( cargv[1], "poll") == 0 )
      {
          if ( cargc < 5 )
          {
             bDispSyntax = 1;
          }
          else
          {
             scanhex(cargv[2],&tmp); address = (Xuint16)tmp;
             scanhex(cargv[3],&tmp); data = (Xuint16)tmp;
             scanhex(cargv[4],&tmp); mask = (Xuint16)tmp;
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%04X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%04X\n\r", data);
                pConsole->io_hprintf( pConsole->io_handle, "\tmask = 0x%04X\n\r", mask);
             }
             do
             {
            	onsemi_python_spi_read( pdemo->ppython_receiver, address, &data );
                pConsole->io_hprintf( pConsole->io_handle, "\t0x%04X => 0x%04X (polling for 0x%04X & 0x%04X)\n\r", address, data2, data, mask );
             }
             while ( data2 != (data & mask) );
          }
      }
      else if ( strcmp( cargv[1], "rmw") == 0 )
      {
          if ( cargc < 5 )
          {
             bDispSyntax = 1;
          }
          else
          {
             scanhex(cargv[2],&tmp); address = (Xuint16)tmp;
             scanhex(cargv[3],&tmp); data = (Xuint16)tmp;
             scanhex(cargv[4],&tmp); mask = (Xuint16)tmp;
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\taddress = 0x%04X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tdata = 0x%04X\n\r", data);
                pConsole->io_hprintf( pConsole->io_handle, "\tmask = 0x%04X\n\r", mask);
             }
             // Read
             onsemi_python_spi_read( pdemo->ppython_receiver, address, &data2 );
             pConsole->io_hprintf( pConsole->io_handle, "\t0x%04X => 0x%04X\n\r", address, data2 );
             // Modify
             data2 &= ~mask;
             data2 |=  data;
             // Write
             onsemi_python_spi_write( pdemo->ppython_receiver, address, data2 );
             pConsole->io_hprintf( pConsole->io_handle, "\t0x%04X <= 0x%04X\n\r", address, data2 );
          }
      }
      else if ( strcmp( cargv[1], "dump") == 0 )
      {
          if ( cargc < 4 )
          {
             bDispSyntax = 1;
          }
          else
          {
             scanhex(cargv[2],&tmp); address = (Xuint16)tmp;
             scanhex(cargv[3],&tmp); address2 = (Xuint16)tmp;
             if ( pConsole->verbose )
             {
                pConsole->io_hprintf( pConsole->io_handle, "\tstart address = 0x%04X\n\r", address);
                pConsole->io_hprintf( pConsole->io_handle, "\tend   address = 0x%04X\n\r", address2);
             }
             for ( ; address <= address2; address += 1 )
             {
            	onsemi_python_spi_read( pdemo->ppython_receiver, address, &data );
                pConsole->io_hprintf( pConsole->io_handle, "\t0x%04X => 0x%04X\n\r", address, data );
             }
          }
      }
   }

   if ( bDispSyntax == 1 )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax:\n\r" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s read  {address}               => Read from {address}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s write {address} {data}        => Write {data} to {address}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s rmw   {address} {data} {mask} => Read from {address}, apply {mask}, then write {data}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s poll  {address} {data} {mask} => Read from {address}, apply {mask}, until matches {data}\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s dump  {address1} {address2}   => Read from {address1} to {address2}\n\r", cargv[0] );
   }

   return;
}

#if 0
void avnet_console_cam_trigger_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   Xuint32 vitaTrigGenControl;
   Xuint32 vitaTrigGenDefaultFreq;
   Xuint32 vitaTrigGenTrig0High;
   Xuint32 vitaTrigGenTrig0Low;
   Xuint32 vitaTrigGenTrig1High;
   Xuint32 vitaTrigGenTrig1Low;
   Xuint32 vitaTrigGenTrig2High;
   Xuint32 vitaTrigGenTrig2Low;

   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( cargc > 1 )
   {
      if ( !strcmp(cargv[1],"manual") )
      {
         pConsole->io_hprintf( pConsole->io_handle, "\tTrigger = manual (pulse) ...\r\n" );
         vitaTrigGenControl  = onsemi_python_spi_reg_read( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X => 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         vitaTrigGenControl |=  0x00000020; // manual trigger mode
         vitaTrigGenControl |=  0x00000100; // enable manual trigger
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         vitaTrigGenControl &= ~0x00000100; // disable manual trigger
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
      }
      else if ( !strcmp(cargv[1],"stress") )
      {
         pConsole->io_hprintf( pConsole->io_handle, "\tTrigger = stress (trigger[2:0] generating 1 cycle pulses at 8 cycles) ...\r\n" );
         vitaTrigGenDefaultFreq = 8-2;
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG, vitaTrigGenDefaultFreq );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG, vitaTrigGenDefaultFreq );
         vitaTrigGenTrig0High   = 0; // 1 cycle pulse
         vitaTrigGenTrig0Low    = 0;
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG  , vitaTrigGenTrig0High   );
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG   , vitaTrigGenTrig0Low    );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG, vitaTrigGenTrig0High );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG , vitaTrigGenTrig0Low  );
         vitaTrigGenTrig1High   = 0; // 1 cycle pulse
         vitaTrigGenTrig1Low    = 0;
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_TRIG1_HIGH_REG  , vitaTrigGenTrig1High   );
         onsemi_python_spi_reg_write(pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_TRIG1_LOW_REG   , vitaTrigGenTrig1Low    );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG1_HIGH_REG, vitaTrigGenTrig1High );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG1_LOW_REG , vitaTrigGenTrig1Low  );
         vitaTrigGenTrig2High   = 0; // 1 cycle pulse
         vitaTrigGenTrig2Low    = 0;
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_TRIG2_HIGH_REG  , vitaTrigGenTrig2High   );
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_TRIG2_LOW_REG   , vitaTrigGenTrig2Low    );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG2_HIGH_REG, vitaTrigGenTrig2High );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG2_LOW_REG , vitaTrigGenTrig2Low  );

         vitaTrigGenControl     = 0x01000017; // internal trigger, enable trigger[2:0], update triggen_cnt registers
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         vitaTrigGenControl     = 0x00000017; // internal trigger, enable trigger[2:0]
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
      }
      else if ( !strcmp(cargv[1],"internal") )
      {
         Xuint32 trigFramesPerSec = 60;
         Xuint32 trigDutyCycle    = pdemo->cam_exposure;
         vitaTrigGenDefaultFreq = (((1920+88+44+148)*(1080+4+5+36))>>2) - 2;
         //vitaTrigGenDefaultFreq = (((1920+88+44+132)*(1080+4+5+36))>>2) - 2;

         if ( cargc > 2 )
         {
            scanhex(cargv[2],&trigFramesPerSec);
            vitaTrigGenDefaultFreq = ((148500000/trigFramesPerSec)>>2) - 2;
         }
         if ( cargc > 3 )
         {
            scanhex(cargv[3],&trigDutyCycle);
         }
         pdemo->cam_exposure = trigDutyCycle;
         pConsole->io_hprintf( pConsole->io_handle, "\tTrigger = internal (%d fps, duty cycle = %d \%, period = %d cycles)...\r\n", trigFramesPerSec, trigDutyCycle, vitaTrigGenDefaultFreq+2 );

         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG, vitaTrigGenDefaultFreq );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_DEFAULT_FREQ_REG, vitaTrigGenDefaultFreq );
         //vitaTrigGenTrig0High   = vitaTrigGenDefaultFreq>>1; // half frame width
         //vitaTrigGenTrig0High   = (vitaTrigGenDefaultFreq * trigDutyCycle)/100; // positive polarity
         vitaTrigGenTrig0High   = (vitaTrigGenDefaultFreq * (100-trigDutyCycle))/100; // negative polarity
         vitaTrigGenTrig0Low    = 1;
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG  , vitaTrigGenTrig0High   );
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG   , vitaTrigGenTrig0Low    );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG0_HIGH_REG, vitaTrigGenTrig0High );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_TRIG0_LOW_REG , vitaTrigGenTrig0Low  );

         vitaTrigGenControl     = 0x31000011; // invert trigger[2:0], internal trigger, enable trigger[0], update triggen_cnt registers
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         vitaTrigGenControl     = 0x30000011; // invert trigger[2:0], internal trigger, enable trigger[0]
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
      }
      else if ( !strcmp(cargv[1],"external") )
      {
          pConsole->io_hprintf( pConsole->io_handle, "\tTrigger = external ...\r\n" );

          vitaTrigGenControl     = 0x00000047; // external trigger, enable trigger[2:0]
          onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
          if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
      }
      else
      {
         pConsole->io_hprintf( pConsole->io_handle, "\tTrigger = off ...\r\n" );

         vitaTrigGenControl     = 0x00000000;
         onsemi_python_spi_reg_write( pdemo->ppython_receiver, ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
         if ( pConsole->verbose ) pConsole->io_hprintf( pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", ONSEMI_VITA_CAM_TRIGGEN_CONTROL_REG, vitaTrigGenControl );
      }
   }

   if ( bDispSyntax )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\ttrig off          => Disable all triggers\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\ttrig stress       => Enable all triggers (all triggers generate 1 cycle pulse at each 8 cycles\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\ttrig internal [#] => Enable trigger0 in specified [#] Hz\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\ttrig external     => Enable trigger0 in external mode\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\ttrig manual       => Simulate external trigger\r\n" );
   }

   return;
}
#endif

#define VITA_AUTOEXP_ON_QTY  2
Xuint16 local_vita_autoexp_on_seq[VITA_AUTOEXP_ON_QTY][3] = {
   // Auto-Exposure ON
   {160, 0x0001, 0x0001}, // [  4] Auto Exposure enable
   {161, 0x03FF, 0x00B8}  // [9:0] Desired Intensity Level
   };

#define VITA_AUTOEXP_OFF_QTY  1
Xuint16 local_vita_autoexp_off_seq[VITA_AUTOEXP_OFF_QTY][3] = {
   // Auto-Exposure OFF
   {160, 0x0001, 0x0000}, // [  4] Auto Exposure disable
   {161, 0x03FF, 0x00B8}  // [9:0] Desired Intensity Level
   };

void avnet_console_cam_aec_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   Xuint16 **seqData;
   int seqLen;
   int bDispSyntax = 0;
   Xuint32 desiredLevel;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( cargc > 1 )
   {
      if ( !strcmp(cargv[1],"on") || !strcmp(cargv[1],"1") )
      {
    	  if ( cargc > 2 )
    	  {
            scanhex(cargv[2], &desiredLevel);
            local_vita_autoexp_on_seq[1][2] = desiredLevel;
    	  }
          seqData = local_vita_autoexp_on_seq;
          seqLen = VITA_AUTOEXP_ON_QTY;
    	  pdemo->cam_aec = 1;
      }
      else
      {
          seqData = local_vita_autoexp_off_seq;
          seqLen = VITA_AUTOEXP_OFF_QTY;
    	  pdemo->cam_aec = 0;
      }
      if ( pdemo->bVerbose)
      {
         onsemi_python_spi_display_sequence( pdemo->ppython_receiver, seqData, seqLen );
      }
      onsemi_python_spi_write_sequence( pdemo->ppython_receiver, seqData, seqLen );
      if ( ! pdemo->cam_aec )
      {
         onsemi_python_set_analog_gain(pdemo->ppython_receiver, pdemo->cam_again, pdemo->bVerbose);
         onsemi_python_set_digital_gain(pdemo->ppython_receiver, pdemo->cam_dgain, pdemo->bVerbose);
         onsemi_python_set_exposure_time( pdemo->ppython_receiver, pdemo->cam_exposure, pdemo->bVerbose);
         pdemo->ppython_receiver->uAnalogGain = pdemo->cam_again;
         pdemo->ppython_receiver->uDigitalGain = pdemo->cam_dgain;
         pdemo->ppython_receiver->uExposureTime = pdemo->cam_exposure;
      }
   }

   if ( bDispSyntax == 1 )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax:\n\r" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s on    => Enable AEC\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s off   => Disable AEC\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s trig  => Global Reset\n\r", cargv[0] );
      pConsole->io_hprintf( pConsole->io_handle, "\t\t%s       => Display status of AEC\n\r", cargv[0] );
      return;
   }

   pConsole->io_hprintf( pConsole->io_handle, "\tPYTHON AEC = %s\n\r", pdemo->cam_aec ? "on" : "off" );

   return;
}

void avnet_console_cam_again_command(avnet_console_t *pConsole, int cargc, char ** cargv) {
	int bDispSyntax = 0;

	if (cargc > 1 && !strcmp(cargv[1], "help")) {
		bDispSyntax = 1;
	} else if (cargc == 1) {
		pConsole->io_hprintf(pConsole->io_handle, "\tagain = %d\r\n", pdemo->cam_again );
	} else if (cargc == 2) {
		scanhex(cargv[1], &(pdemo->cam_again));
		onsemi_python_set_analog_gain(pdemo->ppython_receiver, pdemo->cam_again, pdemo->bVerbose);
	} else {
		bDispSyntax = 1;
	}

	if (bDispSyntax) {
		pConsole->io_hprintf(pConsole->io_handle, "\tSyntax :\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\tagain    => Display analog gain\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\tagain #  => Set analog gain(# = 0-10)\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             0 = 1.00\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             1 = 1.14\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             2 = 1.33\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             3 = 1.60\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             4 = 2.00\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             5 = 2.29\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             6 = 2.67\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             7 = 3.20\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             8 = 4.00\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             9 = 5.33\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t            10 = 8.00\r\n");
	}

	return;
}

void avnet_console_cam_dgain_command(avnet_console_t *pConsole, int cargc, char ** cargv) {
	int bDispSyntax = 0;

	if (cargc > 1 && !strcmp(cargv[1], "help")) {
		bDispSyntax = 1;
	} else if (cargc == 1) {
		pConsole->io_hprintf(pConsole->io_handle, "\tdgain = %d\r\n", pdemo->cam_dgain );
	} else if (cargc == 2) {
		scanhex(cargv[1], &(pdemo->cam_dgain));
		onsemi_python_set_digital_gain(pdemo->ppython_receiver, pdemo->cam_dgain, pdemo->bVerbose);
	} else {
		bDispSyntax = 1;
	}

	if (bDispSyntax) {
		pConsole->io_hprintf(pConsole->io_handle, "\tSyntax :\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\tdgain    => Display digital gain\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\tdgain #  => Set digital gain(# = 0-4095)\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t               0 = 0.00\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t               ...\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t             128 = 1.00\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t               ...\r\n");
	}

	return;
}

#if 0
void avnet_console_cam_exposure_command(avnet_console_t *pConsole, int cargc, char ** cargv) {
	int bDispSyntax = 0;

	if (cargc > 1 && !strcmp(cargv[1], "help")) {
		bDispSyntax = 1;
	} else if (cargc == 1) {
		pConsole->io_hprintf(pConsole->io_handle, "\texposure = %d\r\n", pdemo->cam_exposure );
	} else if (cargc == 2) {
		scanhex(cargv[1], &(pdemo->cam_exposure));
        onsemi_python_set_exposure_time( pdemo->ppython_receiver, pdemo->cam_exposure, pdemo->bVerbose);
	} else {
		bDispSyntax = 1;
	}

	if (bDispSyntax) {
		pConsole->io_hprintf(pConsole->io_handle, "\tSyntax :\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\texposure    => Display exposure\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\texposure #  => Set Exposure in percentage of frame time (16.6msec)\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t                1% => 0.16 msec\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t                      ...\r\n");
		pConsole->io_hprintf(pConsole->io_handle, "\t\t               99% => 16.5 msec\r\n");
	}

	return;
}
#endif

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

         pdemo->cam_alpha = 0x00;
         pdemo->hdmi_alpha = 0xFF;
         demo_start_hdmi_in(pdemo);

         demo_start_frame_buffer(pdemo);
      }
      else if ( !strcmp(cargv[1],"cam") )
      {
         demo_stop_frame_buffer(pdemo);
         demo_init_frame_buffer(pdemo);

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

void avnet_console_ipipe_cfa_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;
   unsigned int cfa_bayer = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( !strcmp(cargv[1],"bayer") && (cargc > 2) )
   {
	  scanhex( cargv[2], &cfa_bayer );
      if ( cfa_bayer > 3 ) cfa_bayer = 3;
   }

   pConsole->io_hprintf( pConsole->io_handle, "\tcfa = %d\n\r", cfa_bayer );
   pdemo->cam_bayer = cfa_bayer;
   pConsole->io_hprintf( pConsole->io_handle, "=> use \"start cam\" command for changes to take effect\n\r" );


   if ( bDispSyntax )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tcfa bayer #   => Set CFA bayer pattern (0-3)\r\n" );
   }

   return;
}

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
  else if ( !strcmp(cargv[0],"start") )
  {
     avnet_console_start_command( pConsole, cargc, cargv );
  }
  //
  // Factory Test Suite Commands
  //
  else if ( !strcmp(cargv[0],"serial") )
  {
     avnet_console_serial_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"ipmi") )
  {
     avnet_console_test_ipmi_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"iic") )
  {
     avnet_console_test_iic_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"hdmi") )
  {
     avnet_console_test_hdmi_command( pConsole, cargc, cargv );
  }
  else if ( !strcmp(cargv[0],"camera") )
  {
     avnet_console_test_camera_command( pConsole, cargc, cargv );
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
  pConsole->io_hprintf( pConsole->io_handle, "--                    FMC-HDMI-CAM                  --\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "--                    Factory Test                  --\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "------------------------------------------------------\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "General Commands:\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\thelp        Print the Top-Level menu Help Screen \n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tverbose on  Enable verbose\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tverbose off Disable verbose\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "Getting Started Commands\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tstart       start and select video source (hdmi|cam)\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "Factory Test Commands\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tserial       Get/Set serial number\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tipmi test    Test FMC IPMI EEPROM\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tiic test     Test Peripheral I2C chain\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\thdmi test    Test HDMI Interfaces\n\r");
  pConsole->io_hprintf( pConsole->io_handle, "\tcamera test  Test Camera Interface (with PYTHON-1300-C camera)\n\r");
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

void avnet_console_serial_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
      bDispSyntax = 1;
   }
   else if ( cargc == 2 )
   {
      strcpy( pdemo->fmc_hdmi_cam_board_info.serial, cargv[1] );
   }
   pConsole->io_hprintf( pConsole->io_handle, "\tFMC-HDMI-CAM Serial Number = %s\n\r", pdemo->fmc_hdmi_cam_board_info.serial );

   if ( bDispSyntax )
   {
      pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tserial        => Display serial number\r\n" );
      pConsole->io_hprintf( pConsole->io_handle, "\t\tserial {xxx}  => Set serial number\r\n" );
   }

   return;
}

void avnet_console_test_ipmi_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;
   struct fru_header     write_common_info;
   struct fru_area_board write_board_info;
   struct fru_header     read_common_info;
   struct fru_area_board read_board_info;
   int ret;
   int bTest = 0;
   int bRead = 0;
   int bPass = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( cargc == 2 && !strcmp(cargv[1],"read") )
   {
      bRead = 1;
   }
   else if ( cargc == 2 && !strcmp(cargv[1],"test") )
   {
      bTest = 1;
   }
   else
   {
      bDispSyntax = 1;
   }

   if ( bTest )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------------\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---- TEST 1 : IPMI EEPROM I2C Chain            ----\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------------\n\r" );

	  // Create common_info
	  write_common_info.version         = 0x01;
	  write_common_info.offset.internal = 0x00;
	  write_common_info.offset.chassis  = 0x00;
	  write_common_info.offset.board    = 0x01; // offset = 8 bytes
	  write_common_info.offset.product  = 0x00;
	  write_common_info.offset.multi    = 0x00;
	  write_common_info.pad             = 0x00;
	  write_common_info.checksum        = 0x00; // will be calculated by driver

	  ret = fmc_ipmi_set_common_info( pdemo->pfmc_ipmi_iic, 0xA0, &write_common_info );
	  if ( ret == FRU_SUCCESS )
	  {
         write_board_info.area_ver      = 0x01;
         write_board_info.lang          = 0x19; // english
         write_board_info.mfg_date_time = 0x00030201; // TBD
         write_board_info.mfg     = "Avnet";
         write_board_info.prod    = "FMC-HDMI-CAM";
         write_board_info.serial  = "                                ";
         strcpy( write_board_info.serial, pdemo->fmc_hdmi_cam_board_info.serial );
         write_board_info.part    = "AES-FMCHDMICAM-G";
         write_board_info.fru     = "";

		 ret = fmc_ipmi_set_board_info( pdemo->pfmc_ipmi_iic, 0xA0, &write_board_info );
		 if ( ret == FRU_SUCCESS )
		 {
            if ( pConsole->verbose )
            {
               pConsole->io_hprintf( pConsole->io_handle, "\tSuccessfully programmed IPMI EEPROM\n\r" );
            }
		 }
		 else
		 {
			pConsole->io_hprintf( pConsole->io_handle, "\tERROR : Failed to decode IPMI board information!\n\r" );
		 }
	  }
	  else
	  {
		 pConsole->io_hprintf( pConsole->io_handle, "\tERROR : Failed to decode IPMI common information!\n\r" );
	  }
   }
   if ( bTest || bRead )
   {
      ret = fmc_ipmi_get_common_info( pdemo->pfmc_ipmi_iic, 0xA0, &read_common_info );
      if ( ret == FRU_SUCCESS )
      {
         ret = fmc_ipmi_get_board_info(pdemo->pfmc_ipmi_iic, 0xA0, &read_board_info );
         if ( ret == FRU_SUCCESS )
         {
            bPass = 1;
            if ( pConsole->verbose )
            {
               pConsole->io_hprintf( pConsole->io_handle, "\tSuccessfully read IPMI EEPROM\n\r" );
               pConsole->io_hprintf( pConsole->io_handle, "\tCommon Info Area:\n\r" );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tcommon_info.version         = 0x%02X\n\r", read_common_info.version             );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tcommon_info.offset.internal = 0x%02X\n\r", read_common_info.offset.internal * 8 );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tcommon_info.offset.chassis  = 0x%02X\n\r", read_common_info.offset.chassis  * 8 );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tcommon_info.offset.board    = 0x%02X\n\r", read_common_info.offset.board    * 8 );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tcommon_info.offset.product  = 0x%02X\n\r", read_common_info.offset.product  * 8 );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tcommon_info.offset.multi    = 0x%02X\n\r", read_common_info.offset.multi    * 8 );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tcommon_info.pad             = 0x%02X\n\r", read_common_info.pad                 );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tcommon_info.checksum        = 0x%02X\n\r", read_common_info.checksum            );
               pConsole->io_hprintf( pConsole->io_handle, "\tBoard Info Area:\n\r" );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.area_ver         = 0x%02X\n\r", read_board_info.area_ver      );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.mfg_date_time    = 0x%08X\n\r", read_board_info.mfg_date_time );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.lang             = 0x%02X\n\r", read_board_info.lang          );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.mfg              = %s\n\r"    , read_board_info.mfg           );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.prod             = %s\n\r"    , read_board_info.prod          );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.serial           = %s\n\r"    , read_board_info.serial        );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.part             = %s\n\r"    , read_board_info.part          );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.fru              = %s\n\r"    , read_board_info.fru           );
               pConsole->io_hprintf( pConsole->io_handle, "\t\tboard_info.area_len         = 0x%04X\n\r", read_board_info.area_len      );
            }
         }
         else
         {
            pConsole->io_hprintf( pConsole->io_handle, "\tERROR : Failed to decode IPMI board information!\n\r" );
         }
      }
      else
      {
         pConsole->io_hprintf( pConsole->io_handle, "\tERROR : Failed to decode IPMI common information!\n\r" );
      }
   }
   if ( bTest )
   {
      if ( bPass )
      {
    	  pConsole->io_hprintf( pConsole->io_handle, "IPMI EEPROM Write/Read Test .................. PASS!\n\r" );
      }
      else
      {
    	  pConsole->io_hprintf( pConsole->io_handle, "IPMI EEPROM Write/Read Test .................. FAIL!\n\r" );
      }
   }

   if ( bDispSyntax )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tipmi test     => Test FMC-IPMI EEPROM\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tipmi read     => Display FMC-IPMI EEPROM contents\r\n" );
   }

   return;
}

void avnet_console_test_iic_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( cargc == 2 && !strcmp(cargv[1],"test") )
   {
	  Xuint8 iic_address;
	  Xuint8 iic_data;

	  pConsole->io_hprintf( pConsole->io_handle, "\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------------\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---- TEST 2 : Peripheral I2C Chain             ----\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------------\n\r" );

	  // ADV7511 - HDMI Output
	  fmc_hdmi_cam_iic_mux( pdemo->pfmc_hdmi_cam, FMC_HDMI_CAM_I2C_SELECT_HDMI_OUT );
	  //
	  iic_address = FMC_HDMI_CAM_HDMI_OUT_ADDR;
	  pConsole->io_hprintf( pConsole->io_handle, "Detecting ADV7511 device at address 0x%02X ..... ", iic_address<<1 );
	  if ( pdemo->pfmc_hdmi_cam_iic->fpIicRead( pdemo->pfmc_hdmi_cam_iic, iic_address, 0, &iic_data, 1 ) > 0 )
		  pConsole->io_hprintf( pConsole->io_handle, "PASS!\n\r" );
	  else
		  pConsole->io_hprintf( pConsole->io_handle, "FAIL! *****\n\r" );


	  // ADV7611 - HDMI Input
	  fmc_hdmi_cam_iic_mux( pdemo->pfmc_hdmi_cam, FMC_HDMI_CAM_I2C_SELECT_HDMI_IN );
	  //
	  iic_address = FMC_HDMI_CAM_HDMI_IN_ADDR;
	  pConsole->io_hprintf( pConsole->io_handle, "Detecting ADV7611 device at address 0x%02X ..... ", iic_address<<1 );
	  if ( pdemo->pfmc_hdmi_cam_iic->fpIicRead( pdemo->pfmc_hdmi_cam_iic, iic_address, 0, &iic_data, 1 ) > 0 )
		  pConsole->io_hprintf( pConsole->io_handle, "PASS!\n\r" );
	  else
		  pConsole->io_hprintf( pConsole->io_handle, "FAIL! *****\n\r" );

	  // CDCE913 - Video Clock Synthesizer
	  fmc_hdmi_cam_iic_mux( pdemo->pfmc_hdmi_cam, FMC_HDMI_CAM_I2C_SELECT_VID_CLK );
	  //
	  iic_address = FMC_HDMI_CAM_VID_CLK_ADDR;
	  pConsole->io_hprintf( pConsole->io_handle, "Detecting CDCE913 device at address 0x%02X ..... ", iic_address<<1 );
	  if ( pdemo->pfmc_hdmi_cam_iic->fpIicRead( pdemo->pfmc_hdmi_cam_iic, iic_address, 0, &iic_data, 1 ) > 0 )
		  pConsole->io_hprintf( pConsole->io_handle, "PASS!\n\r" );
	  else
		  pConsole->io_hprintf( pConsole->io_handle, "FAIL! *****\n\r" );

	  // PCA9534 - I2C I/O Expander
	  fmc_hdmi_cam_iic_mux( pdemo->pfmc_hdmi_cam, FMC_HDMI_CAM_I2C_SELECT_VID_CLK );
	  //
	  iic_address = FMC_HDMI_CAM_IO_EXP_ADDR;
	  pConsole->io_hprintf( pConsole->io_handle, "Detecting PCA9534 device at address 0x%02X ..... ", iic_address<<1 );
	  if ( pdemo->pfmc_hdmi_cam_iic->fpIicRead( pdemo->pfmc_hdmi_cam_iic, iic_address, 0, &iic_data, 1 ) > 0 )
		  pConsole->io_hprintf( pConsole->io_handle, "PASS!\n\r" );
	  else
		  pConsole->io_hprintf( pConsole->io_handle, "FAIL! *****\n\r" );
   }
   if ( bDispSyntax )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tiic test     => Test Peripheral IIC peripherals\r\n" );
   }

   return;
}

void avnet_console_test_hdmi_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;
   int bPass = 0;
   char c;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( cargc == 2 && !strcmp(cargv[1],"test") )
   {
    pConsole->io_hprintf( pConsole->io_handle, "\n\r" );
    pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------------\n\r" );
    pConsole->io_hprintf( pConsole->io_handle, "---- TEST 3 : HDMI Pass-Through Test           ----\n\r" );
    pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------------\n\r" );

    demo_stop_frame_buffer(pdemo);
    demo_init_frame_buffer(pdemo);

    pdemo->cam_alpha = 0x00;
    pdemo->hdmi_alpha = 0xFF;
    demo_start_hdmi_in(pdemo);

    demo_start_frame_buffer(pdemo);

    bPass = 0;
    if ( (pdemo->hdmii_height == 720) && (pdemo->hdmii_width == 1280) )
    {
    	bPass = 1;
    }
    pConsole->io_hprintf( pConsole->io_handle, "HDMI Input Detection  ........................ " );
    if ( bPass )
	  {
		  pConsole->io_hprintf( pConsole->io_handle, "PASS!\n\r" );
	  }
	  else
	  {
		  pConsole->io_hprintf( pConsole->io_handle, "FAIL!\n\r" );
	  }

    pConsole->io_hprintf( pConsole->io_handle, "Enter result of visual test\n\r" );
    pConsole->io_hprintf( pConsole->io_handle, "\t(Y=pass, N=fail) : " );
    c = ' ';
    while ( 1 )
    {
    	c = inbyte();
    	if ( c == 'y' || c == 'Y' ) { bPass = 1; break; }
    	if ( c == 'n' || c == 'N' ) { bPass = 0; break; }
    }
    pConsole->io_hprintf( pConsole->io_handle, "%c\n\r", c );

    pConsole->io_hprintf( pConsole->io_handle, "HDMI Visual Test ............................. " );
    if ( bPass )
	  {
		  pConsole->io_hprintf( pConsole->io_handle, "PASS!\n\r" );
	  }
	  else
	  {
		  pConsole->io_hprintf( pConsole->io_handle, "FAIL!\n\r" );
	  }

   }



   if ( bDispSyntax )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\thdmi test     => Test HDMI Interfaces (requires loopback cable)\r\n" );
   }

   return;
}

void avnet_console_test_camera_command( avnet_console_t *pConsole, int cargc, char ** cargv )
{
   int bDispSyntax = 0;
   Xuint32 frameWidth;
   Xuint32 frameHeight;
   Xuint32 frameRate;
   int bPass = 0;
   char c;

   Xuint32 uManualTap;

   if ( cargc > 1 && !strcmp(cargv[1],"help") )
   {
	  bDispSyntax = 1;
   }
   else if ( cargc == 2 && !strcmp(cargv[1],"test") )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------------\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---- TEST 4 : Camera (PYTHON-1300-C) Test      ----\n\r" );
	  pConsole->io_hprintf( pConsole->io_handle, "---------------------------------------------------\n\r" );


     //for ( uManualTap = 0; uManualTap < 32; uManualTap++ )
     uManualTap = pdemo->ppython_receiver->uManualTap; // optimal tap setting for FMC-HDMI-CAM
     {
      demo_stop_frame_buffer(pdemo);
      demo_init_frame_buffer(pdemo);

      pConsole->io_hprintf( pConsole->io_handle, "Detecting PYTHON-1300-C Camera ...\n\r" );

      pdemo->cam_alpha = 0xFF;
      pdemo->hdmi_alpha = 0x00;
      demo_start_cam_in(pdemo);

      demo_start_frame_buffer(pdemo);

	  sleep(1);
	  onsemi_python_get_status( pdemo->ppython_receiver, &(pdemo->python_status_t1), 0 );
	  sleep(1);
	  onsemi_python_get_status( pdemo->ppython_receiver, &(pdemo->python_status_t2), 0 );
	  //
	  frameWidth  = pdemo->python_status_t1.cntImagePixels * 4;
	  frameHeight = pdemo->python_status_t1.cntImageLines;
	  frameRate   = pdemo->python_status_t2.cntFrames - pdemo->python_status_t1.cntFrames;
	  if ( pConsole->verbose )
      {
         pConsole->io_hprintf( pConsole->io_handle, "PYTHON Status\n\r" );
         pConsole->io_hprintf( pConsole->io_handle, "\tBlack Lines  = %d\n\r", pdemo->python_status_t2.cntBlackLines );
         pConsole->io_hprintf( pConsole->io_handle, "\tImage Lines  = %d\n\r", pdemo->python_status_t2.cntImageLines );
         pConsole->io_hprintf( pConsole->io_handle, "\tBlack Pixels = %d\n\r", pdemo->python_status_t2.cntBlackPixels*4 );
         pConsole->io_hprintf( pConsole->io_handle, "\tImage Pixels = %d\n\r", pdemo->python_status_t2.cntImagePixels*4 );
         pConsole->io_hprintf( pConsole->io_handle, "\tFrames       = %d\n\r", pdemo->python_status_t2.cntFrames );
         pConsole->io_hprintf( pConsole->io_handle, "\tWindows      = %d\n\r", pdemo->python_status_t2.cntWindows );
         pConsole->io_hprintf( pConsole->io_handle, "\tStart Lines  = %d\n\r", pdemo->python_status_t2.cntStartLines );
         pConsole->io_hprintf( pConsole->io_handle, "\tEnd Lines    = %d\n\r", pdemo->python_status_t2.cntEndLines );
         pConsole->io_hprintf( pConsole->io_handle, "\t(End-Start)  = %d\n\r", pdemo->python_status_t2.cntEndLines - pdemo->python_status_t2.cntStartLines );

         pConsole->io_hprintf( pConsole->io_handle, "\tClocks       = %d\n\r", pdemo->python_status_t2.cntClocks );

         pConsole->io_hprintf( pConsole->io_handle, "\tCRC Status   = 0x%08X\n\r", pdemo->python_status_t2.crcStatus );

         pConsole->io_hprintf( pConsole->io_handle, "\tImage Width  = %d\n\r", frameWidth );
	     pConsole->io_hprintf( pConsole->io_handle, "\tImage Height = %d\n\r", frameHeight  );
	     pConsole->io_hprintf( pConsole->io_handle, "\tFrame Rate   = %d frames/sec\n\r", frameRate );

         pConsole->io_hprintf( pConsole->io_handle, "VITA Status = \n\r" );
         pConsole->io_hprintf( pConsole->io_handle, "\tCRC Status   = 0x%02X\n\r", pdemo->python_status_t2.crcStatus );
	  }
	  else
	  {
		 pConsole->io_hprintf( pConsole->io_handle, "\tImage Width  = %d\n\r", frameWidth );
		 pConsole->io_hprintf( pConsole->io_handle, "\tImage Height = %d\n\r", frameHeight  );
		 pConsole->io_hprintf( pConsole->io_handle, "\tFrame Rate   = %d frames/sec\n\r", frameRate );
	  }

	  if ( (frameWidth != 1280) || (frameHeight != 1023) ) // based on working hardware
	  {
         pConsole->io_hprintf( pConsole->io_handle, "\tERROR : Invalid frame dimensions (%d x %d)\n\r", frameWidth, frameHeight );
	  }
	  //else if ( (frameRate < 50) || (frameRate > 70)  ) // 60 frame/sec
	  else if ( (frameRate < 35) || (frameRate > 40)  ) // 37-38 frame/sec
      {
         pConsole->io_hprintf( pConsole->io_handle, "\tERROR : Invalid frame rate (%d frames/sec)\n\r", frameRate );
      }
	  else if ( (pdemo->python_status_t2.cntStartLines != pdemo->python_status_t2.cntEndLines) )
	  {
         pConsole->io_hprintf( pConsole->io_handle, "\tERROR : Mismatching number for StartLine (%d) & EndLine (%d)\n\r", pdemo->python_status_t2.cntStartLines, pdemo->python_status_t2.cntEndLines );
	  }
	  else if ( (pdemo->python_status_t2.crcStatus != 0x00) )
	  {
         pConsole->io_hprintf( pConsole->io_handle, "\tERROR : CRC checksum errors (0x%02X)\n\r", pdemo->python_status_t2.crcStatus );
	  }
	  else
	  {
         bPass = 1;
	  }

      if ( bPass )
      {
    	   pConsole->io_hprintf( pConsole->io_handle, "PYTHON-1300-C Camera detection ............... PASS!\n\r" );
      }
      else
      {
    	   pConsole->io_hprintf( pConsole->io_handle, "PYTHON-1300-C Camera detection ............... FAIL!\n\r" );
      }
     } // for ( uManualTap = 0; uManualTap < 32; uManualTap++ )

     pConsole->io_hprintf( pConsole->io_handle, "Enter result of visual test\n\r" );
     pConsole->io_hprintf( pConsole->io_handle, "\t(Y=pass, N=fail) : " );
     c = ' ';
     while ( 1 )
     {
     	c = inbyte();
     	if ( c == 'y' || c == 'Y' ) { bPass = 1; break; }
     	if ( c == 'n' || c == 'N' ) { bPass = 0; break; }
     }
     pConsole->io_hprintf( pConsole->io_handle, "%c\n\r", c );

     pConsole->io_hprintf( pConsole->io_handle, "PYTHON-1300-C Camera Visual Test ............. " );
     if ( bPass )
 	  {
 		  pConsole->io_hprintf( pConsole->io_handle, "PASS!\n\r" );
 	  }
 	  else
 	  {
 		  pConsole->io_hprintf( pConsole->io_handle, "FAIL!\n\r" );
 	  }

   }

   if ( bDispSyntax )
   {
	  pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
	  pConsole->io_hprintf( pConsole->io_handle, "\t\tcamera test     => Test Camera Interface (requires VITA-2000 camera module)\r\n" );
   }

   return;
}

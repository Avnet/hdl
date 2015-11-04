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
//    http://www.microzed.org
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
// Module Name:         avnet_console.c
// Project Name:        Avnet Console
//
// Tool versions:       ISE 14.5
//
// Description:         Text-based console for
//                      Zed Display Kit Demonstration
//
// Dependencies:        
//
// Revision:            Nov 18, 2010: 1.01 Initial version
//                      May 23, 2013: 1.02 Updated for Zed Display Kit
//						Mar 27, 2015: 1.03 Updated to remove
//                                         dependency upon
//                                         xbasic_types.h
//						Jun  5, 2015: 1.04 Updated for Zynq Mini-ITX
//
//----------------------------------------------------------------------------


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

// Located in: microblaze_0/include/
#include "xil_types.h"
#include "xparameters.h"
#include "xstatus.h"

#include "sleep.h"

#if defined(LINUX_CODE)
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#endif

#include "zed_ali3_controller_demo.h"
#include "avnet_console.h"
#include "avnet_console_scanput.h"
#include "avnet_console_serial.h"
#include "avnet_console_tokenize.h"

extern zed_ali3_controller_demo_t demo;

int avnet_console_get_line_poll(avnet_console_t *pConsole);

void avnet_console_banner_command(avnet_console_t *pConsole);
void avnet_console_calibrate_command(avnet_console_t *pConsole);
void avnet_console_colorbars_command(avnet_console_t *pConsole);
void avnet_console_control_command(avnet_console_t *pConsole, int cargc, char ** cargv);
void avnet_console_delay_command(avnet_console_t *pConsole, int cargc, char ** cargv);
void avnet_console_help(avnet_console_t *pConsole);
void avnet_console_iic_command(avnet_console_t *pConsole, int cargc, char ** cargv, zed_iic_t *pIIC);
void avnet_console_vdma_command(avnet_console_t *pConsole, int cargc, char ** cargv, XAxiVdma *pAxiVdma);
void avnet_console_led_command(avnet_console_t *pConsole, int cargc, char ** cargv);
void avnet_console_logo_command(avnet_console_t *pConsole);
void avnet_console_mem_command(avnet_console_t *pConsole, int cargc, char ** cargv, uint32_t baseAddress);
void avnet_console_pcap_command(avnet_console_t *pConsole, int cargc, char ** cargv);
void avnet_console_verbose_command(avnet_console_t *pConsole, int cargc, char ** cargv);

void avnet_console_init(avnet_console_t *pConsole)
{
    int index;

    pConsole->inchar = ' ';
    pConsole->inline_count = 0;
    pConsole->verbose = 0;
    pConsole->echo = 1;
    pConsole->run_once = 0;
    pConsole->quit = 0;

    // Clear out the command input buffer.
    for (index = 0; index < MAX_LINE_LENGTH; index++)
    {
        pConsole->inline_buffer[index] = 0;
    }

    // Initialize the application instance to the one specified by the caller.
    demo.bVerbose = pConsole->verbose;

    // Flush the UART receive buffer.
    avnet_console_serial_flush();

    return;
}

void avnet_console_process(avnet_console_t *pConsole)
{
    int  cargc;
    char * cargv[MAX_ARGC];
    int len;

    if (pConsole->echo)
    {
        pConsole->io_hprintf(pConsole->io_handle, "%c", pConsole->inchar);
    }
   
#if 1
    // Check if complete line has been received ...
    if (avnet_console_get_line_poll(pConsole) == -1)
    {
        return;
    }

    if (pConsole->run_once == 0)
    {
        // Print the banner the first time the console process is run through.
        avnet_console_banner_command(pConsole);

        // Print the first prompt.
        pConsole->io_hprintf(pConsole->io_handle, "\n\r%s>", AVNET_CONSOLE_PROMPT);

        pConsole->inline_buffer[0] = 0;
        pConsole->inline_count = 0;
        pConsole->run_once = 1;
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
    if (cargc == 0)
    {
        pConsole->io_hprintf(pConsole->io_handle, "\n\r%s>", AVNET_CONSOLE_PROMPT);
        return;
    }
    else if (pConsole->verbose)
    {
        pConsole->io_hprintf(pConsole->io_handle, "\t");

        for (len = 0; len < cargc; len++)
        {
            pConsole->io_hprintf(pConsole->io_handle, "%s ", cargv[len]);
        }

        pConsole->io_hprintf(pConsole->io_handle, "\n\r");
    }

    if (cargv[0][0] == '#')
    {
        // comment, ignore line ...
    }

    //
    // General Commands
    //
    else if (!strcmp(cargv[0],"banner"))
    {
        avnet_console_banner_command(pConsole);
    }
    else if (!strcmp(cargv[0],"calibrate"))
	{
		avnet_console_calibrate_command(pConsole);
	}
    else if (!strcmp(cargv[0],"colorbars"))
    {
        avnet_console_colorbars_command(pConsole);
    }
    else if (!strcmp(cargv[0],"control"))
	{
		avnet_console_control_command(pConsole, cargc, cargv);
	}
    else if (!strcmp(cargv[0],"delay"))
    {
        avnet_console_delay_command(pConsole, cargc, cargv);
    }
    else if (!strcmp(cargv[0],"help"))
	{
		avnet_console_help(pConsole);
	}
    else if (!strcmp(cargv[0],"iic"))
    {
        avnet_console_iic_command(pConsole, cargc, cargv, &(demo.touch_iic));
    }
	else if (!strcmp(cargv[0],"vdma"))
	{
		avnet_console_vdma_command(pConsole, cargc, cargv, &(demo.vdma_ali3) );
	}
    else if (!strcmp(cargv[0],"led"))
    {
        avnet_console_led_command(pConsole, cargc, cargv);
    }
    else if (!strcmp(cargv[0],"logo"))
	{
		avnet_console_logo_command(pConsole);
	}
    else if (!strcmp(cargv[0],"mem"))
    {
        avnet_console_mem_command(pConsole, cargc, cargv, 0x00000000);
    }
    else if (!strcmp(cargv[0],"quit"))
	{
		pConsole->quit = 1;
	}
	else if (!strcmp(cargv[0],"verbose"))
	{
		avnet_console_verbose_command(pConsole, cargc, cargv);
	}
    else
    {
        pConsole->io_hprintf(pConsole->io_handle, "\tUnknown command : %s\n\r", cargv[0]);
    }
    pConsole->io_hprintf(pConsole->io_handle, "\n\r%s>", AVNET_CONSOLE_PROMPT);

#else
    // Get input character from xxx_session
    inchar = pConsole->inchar;
   
    //pConsole->io_hprintf( pConsole->io_handle, "%c (0x%02X)\n\r",inchar,inchar);

    switch (inchar)
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

void avnet_console_banner_command(avnet_console_t *pConsole)
{
    pConsole->io_hprintf(pConsole->io_handle, "\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "------------------------------------------------------------------------------\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "|      @     @                      @@@@@@@@    @@@@@@@@  @@@    @@@         |\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "|      @@   @@                      @@@@@@@@    @@@@@@@@   @@@  @@@          |\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "|      @ @ @ @  @         @            @@          @@       @@@@@@           |\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "|      @  @  @                         @@          @@         @@@            |\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "|      @     @  @  @ @@   @  @@@@@     @@          @@        @@@             |\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "|      @     @  @  @@  @  @  @@@@@     @@          @@       @@@@@@           |\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "|      @     @  @  @   @  @         @@@@@@@@    @@@@@@@@   @@@  @@@          |\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "|      @     @  @  @   @  @         @@@@@@@@    @@@@@@@@  @@@    @@@         |\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "------------------------------------------------------------------------------\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "--                  Zynq Mini-ITX Display Kit Demonstration                 --\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "------------------------------------------------------------------------------\n\r");

    return;
}

void avnet_console_colorbars_command(avnet_console_t *pConsole)
{
   static int32u cbars_offset = 0;

   zed_ali3_controller_demo_cbars(&demo, cbars_offset++);

   return;
}

void avnet_console_control_command(avnet_console_t *pConsole, int cargc, char ** cargv)
{
    int bDispSyntax = 0;

    if (cargc > 1 && !strcmp(cargv[1],"help"))
    {
        bDispSyntax = 1;
    }
    else if (cargc < 2)
    {
        bDispSyntax = 1;
    }
    else
    {
        if (strcmp(cargv[1], "start") == 0)
        {
            if (cargc < 2)
            {
                bDispSyntax = 1;
            }
            else
            {
                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\tcommand = start\n\r");
                }

                zed_ali3_controller_demo_control(&demo);
            }
        }
    }

    if (bDispSyntax == 1)
    {
        pConsole->io_hprintf(pConsole->io_handle, "\tSyntax :\r\n");
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s start                           => Start control panel demo\n\r");
    }

    return;
}

void avnet_console_logo_command(avnet_console_t *pConsole)
{
	zed_ali3_controller_demo_logo(&demo);

    return;
}

void avnet_console_help(avnet_console_t *pConsole)
{
    pConsole->io_hprintf(pConsole->io_handle, "\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "------------------------------------------------------------------------------\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "--                         Text-based Console for                           --\n\r" );
    pConsole->io_hprintf(pConsole->io_handle, "--                 Zynq Mini-ITX Display Kit Demonstration                  --\n\r" );
    pConsole->io_hprintf(pConsole->io_handle, "------------------------------------------------------------------------------\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "General Commands:\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tcolorbars  Display colorbars pattern to display \n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tcontrol    Display control panel \n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tcalibrate  Calibrate touch \n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tdelay      Wait for specified delay\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\thelp       Print the Top-Level menu Help Screen \n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tiic        IIC accesses on Zynq Mini-ITX Display Kit\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tvdma       Display VDMA status\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tlogo       Display logo to display \n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tmem        Memory accesses\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tquit       Exit console (if applicable)\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\tverbose    Toggle verbosity on/off\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "\n\r");
    pConsole->io_hprintf(pConsole->io_handle, "------------------------------------------------------------------------------\n\r");

    return;
}

int avnet_console_get_line_poll(avnet_console_t *pConsole)
{
    int buffer_index;
    char character_copy = 0;
    u8 DataBuffer[MAX_LINE_LENGTH];
    unsigned int received_char_count = 0;

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

        // Get the next character that was received from the UART
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
                pConsole->io_hprintf( pConsole->io_handle, " \b" );
                pConsole->inline_count--;
                pConsole->inline_buffer[pConsole->inline_count] = 0;
            }
            else
            {
                // User backspaced into prompt, fix the prompt and reposition
                // the cursor.
                pConsole->io_hprintf( pConsole->io_handle, ">" );
            }
        }
        // Check for escape key or control-U.
        else if ((character_copy == 0x1b) || (character_copy == 0x15))
        {
            while (pConsole->inline_count > 0)
            {
                pConsole->io_hprintf( pConsole->io_handle, " \b" );
                pConsole->inline_count--;
                pConsole->inline_buffer[pConsole->inline_count] = 0;
            }
        }
        else
        {
            // Echo character back to the user.
            pConsole->inline_buffer[pConsole->inline_count] = character_copy;
            pConsole->inline_count++;
        }
    }

    return -1;
}

void avnet_console_calibrate_command(avnet_console_t *pConsole)
{
    zed_ali3_controller_demo_touch_calibrate(&demo);

    return;
}

void avnet_console_delay_command(avnet_console_t *pConsole, int cargc, char ** cargv)
{
    uint32_t delay;

    int bDispSyntax = 0;

    if (cargc > 1 && !strcmp(cargv[1],"help"))
    {
        bDispSyntax = 1;
    }
    else if (cargc < 2)
    {
        pConsole->io_hprintf(pConsole->io_handle, "\twaiting 1 sec\n\r");
        sleep(1);
    }
    else
    {
        scanhex(cargv[1], (unsigned*) &delay);
        if (cargc < 3)
        {
            pConsole->io_hprintf(pConsole->io_handle, "\twaiting %d sec\n\r", delay);
            sleep(delay);
        }
        else if (strcmp( cargv[2], "sec") == 0)
        {
            pConsole->io_hprintf( pConsole->io_handle, "\twaiting %d sec\n\r", delay );
            sleep(delay);
        }
        else if (strcmp( cargv[2], "msec") == 0)
        {
            pConsole->io_hprintf( pConsole->io_handle, "\twaiting %d msec\n\r", delay );
            usleep(1000*delay);
        }
        else if (strcmp( cargv[2], "usec") == 0)
        {
            pConsole->io_hprintf( pConsole->io_handle, "\twaiting %d usec\n\r", delay );
            usleep(delay);
        }
    }

    if (bDispSyntax)
    {
        pConsole->io_hprintf(pConsole->io_handle, "\tSyntax :\r\n");
        pConsole->io_hprintf(pConsole->io_handle, "\t\tdelay {#}         => Delay by specified number of seconds\r\n");
        pConsole->io_hprintf(pConsole->io_handle, "\t\tdelay {#} sec     => Delay by specified number of seconds\r\n");
        pConsole->io_hprintf(pConsole->io_handle, "\t\tdelay {#} msec    => Delay by specified number of milli-seconds\r\n");
        pConsole->io_hprintf(pConsole->io_handle, "\t\tdelay {#} usec    => Delay by specified number of micro-seconds\r\n");
    }
}

void avnet_console_iic_command(avnet_console_t *pConsole, int cargc, char ** cargv, zed_iic_t *pIIC)
{
    uint32_t tmp;
    uint8_t device;
    uint8_t address, address2;
    uint8_t data, data2;
    uint8_t mask;
    int num_bytes;

    int bDispSyntax = 0;

    if (cargc > 1 && !strcmp(cargv[1],"help"))
    {
        bDispSyntax = 1;
    }
    else if (cargc < 2)
    {
        bDispSyntax = 1;
    }
    else
    {
        if (strcmp( cargv[1], "scan") == 0)
        {
            uint8_t dev;
            address = 0x00;
            pConsole->io_hprintf(pConsole->io_handle, "\tScanning for I2C devices ...\n\r");
            for (dev = 1; dev < 128; dev++)
            {
                device = (dev<<1);
                num_bytes = pIIC->fpIicRead( pIIC, (device>>1), address, &data, 1);

                if (num_bytes > 0)
                {
                    pConsole->io_hprintf( pConsole->io_handle, "\t\t0x%02X\n\r", device);
                }
            }
        }
        else if (strcmp(cargv[1], "read") == 0)
        {
            if (cargc < 4)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned *) &tmp);
                device = (uint8_t)tmp;
                scanhex(cargv[3], (unsigned *) &tmp);
                address = (uint8_t)tmp;

                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
                }

                num_bytes = pIIC->fpIicRead(pIIC, (device>>1), address, &data, 1);
                pConsole->io_hprintf(pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X\n\r", device, address, data);
            }
        }
        else if (strcmp( cargv[1], "write") == 0)
        {
            if (cargc < 5)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned *) &tmp);
                device = (uint8_t)tmp;
                scanhex(cargv[3], (unsigned *) &tmp);
                address = (uint8_t)tmp;
                scanhex(cargv[4], (unsigned *) &tmp);
                data = (uint8_t)tmp;

                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
                    pConsole->io_hprintf(pConsole->io_handle, "\tdata = 0x%02X\n\r", data);
                }

                num_bytes = pIIC->fpIicWrite(pIIC, (device>>1), address, &data, 1);
                pConsole->io_hprintf(pConsole->io_handle, "\t0x%02X[0x%02X] <= 0x%02X\n\r", device, address, data);
            }
        }
        else if (strcmp(cargv[1], "poll") == 0)
        {
            if (cargc < 6)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned *) &tmp);
                device = (uint8_t)tmp;
                scanhex(cargv[3], (unsigned *) &tmp);
                address = (uint8_t)tmp;
                scanhex(cargv[4], (unsigned *) &tmp);
                data = (uint8_t)tmp;
                scanhex(cargv[5], (unsigned *) &tmp);
                mask = (uint8_t)tmp;

                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
                    pConsole->io_hprintf(pConsole->io_handle, "\tdata = 0x%02X\n\r", data);
                    pConsole->io_hprintf(pConsole->io_handle, "\tmask = 0x%02X\n\r", mask);
                }

                do
                {
                    num_bytes = pIIC->fpIicRead(pIIC, (device>>1), address, &data2, 1);
                    pConsole->io_hprintf(pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X (polling for 0x%02X & 0x%02X)\n\r", device, address, data2, data, mask);
                }
                while (data != (data2 & mask));
            }
        }
        else if (strcmp(cargv[1], "rmw") == 0)
        {
            if (cargc < 6)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned *) &tmp);
                device = (uint8_t)tmp;
                scanhex(cargv[3], (unsigned *) &tmp);
                address = (uint8_t)tmp;
                scanhex(cargv[4], (unsigned *) &tmp);
                data = (uint8_t)tmp;
                scanhex(cargv[5], (unsigned *) &tmp);
                mask = (uint8_t)tmp;

                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress = 0x%02X\n\r", address);
                    pConsole->io_hprintf(pConsole->io_handle, "\tdata = 0x%02X\n\r", data);
                    pConsole->io_hprintf(pConsole->io_handle, "\tmask = 0x%02X\n\r", mask);
                }

                // Read
                num_bytes = pIIC->fpIicRead(pIIC, (device>>1), address, &data2, 1);
                pConsole->io_hprintf(pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X\n\r", device, address, data2);
                // Modify
                data2 &= ~mask;
                data2 |=  data;
                // Write
                num_bytes = pIIC->fpIicWrite(pIIC, (device>>1), address, &data2, 1);
                pConsole->io_hprintf(pConsole->io_handle, "\t0x%02X[0x%02X] <= 0x%02X\n\r", device, address, data2);
            }
        }
        else if (strcmp(cargv[1], "dump") == 0)
        {
            if (cargc < 5)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned *) &tmp);
                device = (uint8_t)tmp;
                scanhex(cargv[3], (unsigned *) &tmp);
                address = (uint8_t)tmp;
                scanhex(cargv[4], (unsigned *) &tmp);
                address2 = (uint8_t)tmp;

                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\tdevice = 0x%02X\n\r", device);
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress(start) = 0x%02X\n\r", address);
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress( end ) = 0x%02X\n\r", address2);
                }

                for (; address <= address2; address += 1)
                {
                    num_bytes = pIIC->fpIicRead(pIIC, (device>>1), address, &data, 1);
                    pConsole->io_hprintf(pConsole->io_handle, "\t0x%02X[0x%02X] => 0x%02X\n\r", device, address, data);

                    if (address == 0xFF) break;
                }
            }
        }
        else
        {
            bDispSyntax = 1;
        }
    }

    if (bDispSyntax == 1)
    {
        pConsole->io_hprintf(pConsole->io_handle, "\tSyntax :\r\n");
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s scan                                    => Scan for I2C devices\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s read  {device} {address}                => For {device}, Read from {address}\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s write {device} {address} {data}         => For {device}, Write {data} to {address}\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s rmw   {device} {address} {data} {mask}  => For {device}, Read from {address}, apply {mask}, then write {data}\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s poll  {device} {address} {data} {mask}  => For {device}, Read from {address}, apply {mask}, until matches {data}\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s dump  {device} {address1} {address2}    => For {device}, Read from {address1} to {address2}\n\r", cargv[0]);
    }

    return;
}

void avnet_console_vdma_command(avnet_console_t *pConsole, int cargc, char ** cargv, XAxiVdma *pAxiVdma)
{
    int bDispSyntax = 0;

    if (cargc > 1 && !strcmp(cargv[1],"help"))
    {
        bDispSyntax = 1;
    }
    else if (cargc < 2)
    {
        bDispSyntax = 1;
    }
    else
    {
        if (strcmp( cargv[1], "status") == 0)
        {
        	vfb_check_errors( pAxiVdma, 1 );
        	vfb_dump_registers( pAxiVdma );
        }
        else
        {
            bDispSyntax = 1;
        }
    }

    if (bDispSyntax == 1)
    {
        pConsole->io_hprintf(pConsole->io_handle, "\tSyntax :\r\n");
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s status   => Display VDMA Status\n\r", cargv[0]);
    }

    return;
}

void avnet_console_led_command(avnet_console_t *pConsole, int cargc, char ** cargv)
{
    int bDispSyntax = 0;
    int target_led_number = 0; // Zero-based index to match the board silkscreen.
    int target_led_state = 0;  // 0 = off, 1 = on

    if ((cargc > 1) && (!strcmp(cargv[1], "help")))
    {
        bDispSyntax = 1;
    }
    else if (cargc > 2)
    {
    	// Handle the led number argument of the command.
        if (!strcmp(cargv[1], "0"))
        {
            target_led_number = 0;
        }
        else if (!strcmp(cargv[1], "1"))
        {
            target_led_number = 1;
        }
        else if (!strcmp(cargv[1], "2"))
        {
            target_led_number = 2;
        }
        else if (!strcmp(cargv[1], "3"))
        {
            target_led_number = 3;
        }
        else if (!strcmp(cargv[1], "4"))
        {
            target_led_number = 4;
        }
        else if (!strcmp(cargv[1], "5"))
        {
            target_led_number = 5;
        }
        else if (!strcmp(cargv[1], "6"))
        {
            target_led_number = 6;
        }
        else if (!strcmp(cargv[1], "7"))
        {
            target_led_number = 7;
        }
        else
        {
        	bDispSyntax = 1;
        }

        // Handle the on/off argument of the command.
        if (!strcmp(cargv[2], "on"))
        {
    	    // User specified that the LED is to be turned on.
    	    target_led_state = 1;
        }
        else if (!strcmp(cargv[2], "off"))
        {
            // User specified that the LED is to be turned off.
            target_led_state = 0;
        }
        else
        {
        	bDispSyntax = 1;
        }
    }

    /*
     * Check to see if there were any issues with the command syntax during parsing.
     */
    if (bDispSyntax)
    {
        pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n");
        pConsole->io_hprintf( pConsole->io_handle, "\t\tled <led #0-7> on|off  => Turn specified User LED on/off\r\n");
        pConsole->io_hprintf( pConsole->io_handle, "\tExample:\r\n");
        pConsole->io_hprintf( pConsole->io_handle, "\t\tled 1 on   => Turns LED 1 on\r\n");
    }
    else
    {
        /*
         * Now that the arguments for the command have been parsed, perform
         * the requested action.
         */
        zed_ali3_controller_demo_led(&demo, target_led_number, target_led_state);
    }

    return;
}

void avnet_console_mem_command(avnet_console_t *pConsole, int cargc, char ** cargv, uint32_t base_address)
{
    uint32_t *pMemory;

    uint32_t address, address2;
    uint32_t data, data2;
    uint32_t mask;

    int bDispSyntax = 0;

    if (cargc > 1 && !strcmp(cargv[1],"help"))
    {
        bDispSyntax = 1;
    }
    else if (cargc < 2)
    {
        bDispSyntax = 1;
    }
    else
    {
        if (strcmp(cargv[1], "read") == 0)
        {
            if (cargc < 3)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned*) &address);
                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress = 0x%08X\n\r", address);
                }
                pMemory = (uint32_t *)(base_address + address);
                data = *pMemory;
                pConsole->io_hprintf(pConsole->io_handle, "\t0x%08X => 0x%08X\n\r", pMemory, data);
            }
        }
        else if (strcmp(cargv[1], "write") == 0)
        {
            if (cargc < 4)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned*) &address);
                scanhex(cargv[3], (unsigned*) &data);
                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress = 0x%08X\n\r", address);
                    pConsole->io_hprintf(pConsole->io_handle, "\tdata = 0x%08X\n\r", data);
                }
                pMemory = (uint32_t *)(base_address + address);
                *pMemory = data;
                pConsole->io_hprintf(pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", pMemory, data);
            }
        }
        else if (strcmp(cargv[1], "poll") == 0)
        {
            if (cargc < 5)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned*) &address);
                scanhex(cargv[3], (unsigned*) &data);
                scanhex(cargv[4], (unsigned*) &mask);
                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress = 0x%08X\n\r", address);
                    pConsole->io_hprintf(pConsole->io_handle, "\tdata = 0x%08X\n\r", data);
                    pConsole->io_hprintf(pConsole->io_handle, "\tmask = 0x%08X\n\r", mask);
                }
                pMemory = (uint32_t *)(base_address + address);
                do
                {
                    data2 = *pMemory;
                    pConsole->io_hprintf(pConsole->io_handle, "\t0x%08X => 0x%08X (polling for 0x%08X & 0x%08X)\n\r", pMemory, data2, data, mask);
                }
                while ( data != (data2 & mask) );
            }
        }
        else if (strcmp(cargv[1], "rmw") == 0)
        {
            if (cargc < 5)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned*) &address);
                scanhex(cargv[3], (unsigned*) &data);
                scanhex(cargv[4], (unsigned*) &mask);
                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\taddress = 0x%08X\n\r", address);
                    pConsole->io_hprintf(pConsole->io_handle, "\tdata = 0x%08X\n\r", data);
                    pConsole->io_hprintf(pConsole->io_handle, "\tmask = 0x%08X\n\r", mask);
                }
                pMemory = (uint32_t *)(base_address + address);
                // Read
                data2 = *pMemory;
                pConsole->io_hprintf(pConsole->io_handle, "\t0x%08X => 0x%08X\n\r", pMemory, data2);
                // Modify
                data2 &= ~mask;
                data2 |=  data;
                // Write
                *pMemory = data2;
                pConsole->io_hprintf(pConsole->io_handle, "\t0x%08X <= 0x%08X\n\r", pMemory, data2);
            }
        }
        else if (strcmp(cargv[1], "dump") == 0)
        {
            if (cargc < 4)
            {
                bDispSyntax = 1;
            }
            else
            {
                scanhex(cargv[2], (unsigned*) &address);
                scanhex(cargv[3], (unsigned*) &address2);

                if (pConsole->verbose)
                {
                    pConsole->io_hprintf(pConsole->io_handle, "\tstart address = 0x%08X\n\r", address);
                    pConsole->io_hprintf(pConsole->io_handle, "\tend   address = 0x%08X\n\r", address2);
                }
                for ( ; address <= address2; address += 4)
                {
                    pMemory = (uint32_t *)(base_address + address);
                    data = *pMemory;
                    pConsole->io_hprintf(pConsole->io_handle, "\t0x%08X => 0x%08X\n\r", pMemory, data);
                }
            }
        }
    }

    if (bDispSyntax == 1)
    {
        pConsole->io_hprintf(pConsole->io_handle, "\tSyntax :\r\n");
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s read  {address}                 => Read from {address}\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s write {address} {data}          => Write {data} to {address}\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s rmw   {address} {data} {mask}   => Read from {address}, apply {mask}, then write {data}\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s poll  {address} {data} {mask}   => Read from {address}, apply {mask}, until matches {data}\n\r", cargv[0]);
        pConsole->io_hprintf(pConsole->io_handle, "\t\t%s dump  {address1} {address2}     => Read from {address1} to {address2}\n\r", cargv[0]);
    }

    return;
}

void avnet_console_verbose_command(avnet_console_t *pConsole, int cargc, char ** cargv)
{
    int bDispSyntax = 0;

    if (cargc > 1 && !strcmp(cargv[1],"help"))
    {
        bDispSyntax = 1;
    }
    else if ( cargc > 1 )
    {
        if (!strcmp(cargv[1],"on") || !strcmp(cargv[1],"1"))
        {
            pConsole->verbose = 1;
            demo.bVerbose = 1;
        }
        else
        {
            pConsole->verbose = 0;
            demo.bVerbose = 0;
        }
    }

    pConsole->io_hprintf(pConsole->io_handle, "\tverbose = %s\n\r", pConsole->verbose ? "on" : "off");

    if (bDispSyntax)
    {
        pConsole->io_hprintf( pConsole->io_handle, "\tSyntax :\r\n" );
        pConsole->io_hprintf( pConsole->io_handle, "\t\tverbose on|1  => Enable verbose mode\r\n" );
        pConsole->io_hprintf( pConsole->io_handle, "\t\tverbose off   => Disable verbose mode\r\n" );
    }

    return;
}

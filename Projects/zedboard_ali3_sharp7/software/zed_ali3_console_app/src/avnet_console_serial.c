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
// Module Name:         avnet_console_serial.c
// Project Name:        Serial Entry for Avnet Console
//
// Tool versions:       ISE 13.3
//
// Description:         Serial entry point for Text-based console
//
// Dependencies:
//
// Revision:            Nov 18, 2010: 1.01 Initial version
//                      May 23, 2013: 1.02 Updated for Zed Display Kit
//
//----------------------------------------------------------------------------


#include <stdio.h>
#include <string.h>
#include <stdarg.h> // for variable argument lists
#include "os.h"

// Located in: microblaze_0/include/
//#include "xbasic_types.h"
//#include "xutil.h"
#include "xparameters.h"
#include "xstatus.h"

#ifdef XPAR_XUARTPS_NUM_INSTANCES
#include "xuartps.h"
#else
#include "xuartlite_l.h"
#endif

#include "avnet_console.h"

// Serial session
avnet_console_t serial_console;

void *serial_handle = NULL;
#if 1
// this implemenation uses 50Kbytes more code because of vsnprintf(),
// use alternate implementation instead ...
int serial_hprintf( void *serial_handle, const char * fmt, ...)
{
	static char buf[1024];
	va_list marker;
	int n;
	int i;

	va_start( marker, fmt);
	n = vsnprintf( buf, sizeof buf, fmt, marker);
	va_end( marker);

	for ( i = 0; i < n; i++ )
	{
	   OS_PUTCHAR( buf[i] );
	}

	return n;
}
#else
/*---------------------------------------------------*/
/* Modified from :                                   */
/* Public Domain version of printf                   */
/* Rud Merriam, Compsult, Inc. Houston, Tx.          */
/* For Embedded Systems Programming, 1991            */
/*                                                   */
/*---------------------------------------------------*/

#include <ctype.h>
#include <string.h>
#include <stdarg.h>



/*----------------------------------------------------*/
/* Use the following parameter passing structure to   */
/* make xil_printf re-entrant.                        */
/*----------------------------------------------------*/
typedef struct params_s {
    int len;
    int num1;
    int num2;
    char pad_character;
    int do_padding;
    int left_flag;
} params_t;

/*---------------------------------------------------*/
/* The purpose of this routine is to output data the */
/* same as the standard printf function without the  */
/* overhead most run-time libraries involve. Usually */
/* the printf brings in many kilobytes of code and   */
/* that is unacceptable in most embedded systems.    */
/*---------------------------------------------------*/

typedef char* charptr;
typedef int (*func_ptr)(int c);

/*---------------------------------------------------*/
/*                                                   */
/* This routine puts pad characters into the output  */
/* buffer.                                           */
/*                                                   */
static void padding( const int l_flag, params_t *par)
{
    int i;

    if (par->do_padding && l_flag && (par->len < par->num1))
        for (i=par->len; i<par->num1; i++)
            OS_PUTCHAR( par->pad_character);
}

/*---------------------------------------------------*/
/*                                                   */
/* This routine moves a string to the output buffer  */
/* as directed by the padding and positioning flags. */
/*                                                   */
static void outs( charptr lp, params_t *par)
{
    /* pad on left if needed                         */
    par->len = strlen( lp);
    padding( !(par->left_flag), par);

    /* Move string to the buffer                     */
    while (*lp && (par->num2)--)
        OS_PUTCHAR( *lp++);

    /* Pad on right if needed                        */
    /* CR 439175 - elided next stmt. Seemed bogus.   */
    /* par->len = strlen( lp);                       */
    padding( par->left_flag, par);
}

/*---------------------------------------------------*/
/*                                                   */
/* This routine moves a number to the output buffer  */
/* as directed by the padding and positioning flags. */
/*                                                   */

static void outnum( const long n, const long base, params_t *par)
{
    charptr cp;
    int negative;
    char outbuf[32];
    const char digits[] = "0123456789ABCDEF";
    unsigned long num;

    /* Check if number is negative                   */
    if (base == 10 && n < 0L) {
        negative = 1;
        num = -(n);
    }
    else{
        num = (n);
        negative = 0;
    }

    /* Build number (backwards) in outbuf            */
    cp = outbuf;
    do {
        *cp++ = digits[(int)(num % base)];
    } while ((num /= base) > 0);
    if (negative)
        *cp++ = '-';
    *cp-- = 0;

    /* Move the converted number to the buffer and   */
    /* add in the padding where needed.              */
    par->len = strlen(outbuf);
    padding( !(par->left_flag), par);
    while (cp >= outbuf)
        OS_PUTCHAR( *cp--);
    padding( par->left_flag, par);
}

/*---------------------------------------------------*/
/*                                                   */
/* This routine gets a number from the format        */
/* string.                                           */
/*                                                   */
static int getnum( charptr* linep)
{
    int n;
    charptr cp;

    n = 0;
    cp = *linep;
    while (isdigit(((int)*cp)))
        n = n*10 + ((*cp++) - '0');
    *linep = cp;
    return(n);
}

/*---------------------------------------------------*/
/*                                                   */
/* This routine operates just like a printf/sprintf  */
/* routine. It outputs a set of data under the       */
/* control of a formatting string. Not all of the    */
/* standard C format control are supported. The ones */
/* provided are primarily those needed for embedded  */
/* systems work. Primarily the floaing point         */
/* routines are omitted. Other formats could be      */
/* added easily by following the examples shown for  */
/* the supported formats.                            */
/*                                                   */

/* void esp_printf( const func_ptr f_ptr,
   const charptr ctrl1, ...) */
void serial_hprintf( void *serial_handle, const char * fmt, ...)
{
    int long_flag;
    int dot_flag;

    params_t par;

    char ch;
    va_list argp;
    char *ctrl = (char *)fmt;

    va_start( argp, fmt);

    for ( ; *ctrl; ctrl++) {

        /* move format string chars to buffer until a  */
        /* format control is found.                    */
        if (*ctrl != '%') {
            OS_PUTCHAR(*ctrl);
            continue;
        }

        /* initialize all the flags for this format.   */
        dot_flag   = long_flag = par.left_flag = par.do_padding = 0;
        par.pad_character = ' ';
        par.num2=32767;

 try_next:
        ch = *(++ctrl);

        if (isdigit((int)ch)) {
            if (dot_flag)
                par.num2 = getnum(&ctrl);
            else {
                if (ch == '0')
                    par.pad_character = '0';

                par.num1 = getnum(&ctrl);
                par.do_padding = 1;
            }
            ctrl--;
            goto try_next;
        }

        switch (tolower((int)ch)) {
            case '%':
                OS_PUTCHAR( '%');
                continue;

            case '-':
                par.left_flag = 1;
                break;

            case '.':
                dot_flag = 1;
                break;

            case 'l':
                long_flag = 1;
                break;

            case 'd':
                if (long_flag || ch == 'D') {
                    outnum( va_arg(argp, long), 10L, &par);
                    continue;
                }
                else {
                    outnum( va_arg(argp, int), 10L, &par);
                    continue;
                }
            case 'x':
                outnum((long)va_arg(argp, int), 16L, &par);
                continue;

            case 's':
                outs( va_arg( argp, char *), &par);
                continue;

            case 'c':
                OS_PUTCHAR( va_arg( argp, int));
                continue;

            case '\\':
                switch (*ctrl) {
                    case 'a':
                        OS_PUTCHAR( 0x07);
                        break;
                    case 'h':
                        OS_PUTCHAR( 0x08);
                        break;
                    case 'r':
                        OS_PUTCHAR( 0x0D);
                        break;
                    case 'n':
                        OS_PUTCHAR( 0x0D);
                        OS_PUTCHAR( 0x0A);
                        break;
                    default:
                        OS_PUTCHAR( *ctrl);
                        break;
                }
                ctrl++;
                break;

            default:
                continue;
        }
        goto try_next;
    }
    va_end( argp);
}
#endif

static unsigned avnet_console_serial_server_running = 0;

int avnet_console_serial_flush(void)
{
    int count = 0;

#if defined(LINUX_CODE)
    int input;

    while ((input = getchar()) != EOF)
    {
       count = count + 1;
#else
#ifdef XPAR_XUARTPS_NUM_INSTANCES
   while (XUartPs_IsReceiveData(STDIN_BASEADDRESS))
#else
   while (!XUartLite_IsReceiveEmpty(STDIN_BASEADDRESS))
#endif
   {
      OS_GETCHAR();
      count = count + 1;
#endif
   }

   return count;
}

int
transfer_avnet_console_serial_data(void)
{
   char inchar;

#if defined(LINUX_CODE)
   int input;

   if (( input = getchar() ) != EOF )
   {
      inchar = (char)input;
#else
 #ifdef XPAR_XUARTPS_NUM_INSTANCES
   if (XUartPs_IsReceiveData(STDIN_BASEADDRESS))
 #else
   if (!XUartLite_IsReceiveEmpty(STDIN_BASEADDRESS))
 #endif
   {
      inchar = OS_GETCHAR();
#endif
      serial_console.inchar = inchar;

      avnet_console_process(&serial_console);

      if (serial_console.quit == 1)
      {
    	  return 1;
      }
   }

    return 0;
}

void
print_avnet_console_serial_app_header(void)
{
#if 0
    OS_PRINTF("%20s %6s %s\r\n", "serial avnet console",
                        "COM?",
                        "115200 baud, 8 bits, no parity");
#endif
}


int
start_avnet_console_serial_application(void)
{
    // Initialize serial console
    avnet_console_init( &serial_console );
    serial_console.io_handle = serial_handle;
    serial_console.io_hprintf = (void*) serial_hprintf;
    serial_console.echo = 1; // characters are not echoed by terminal, need echo on

    avnet_console_serial_server_running = 1;

    strcpy( serial_console.inline_buffer, "help" );
    serial_console.inline_count = strlen( serial_console.inline_buffer );
#if defined(LINUX_CODE)
    serial_console.inchar = '\n';
#else
    serial_console.inchar = '\r';
#endif	
    avnet_console_process(&serial_console);

    return 0;
}

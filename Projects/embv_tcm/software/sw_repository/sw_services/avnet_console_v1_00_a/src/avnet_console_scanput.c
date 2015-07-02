//----------------------------------------------------------------------------
//--    _____
//--   /     \
//--  /____   \____
//-- / \===\   \==/
//--/___\===\___\/  AVNET
//--     \======/   DESIGN
//--      \====/    SERVICES
//----------------------------------------------------------------------------
//--
//-- Title:
//-- Program:
//-- Filename:  scanput.c
//--
//-- Author(s):
//-- Date:
//--
//-- Purpose:
//--    This file implements the interface for printing and scanning 
//--    special numerical types.
//--
//-- Disclaimer:
//--    Avnet, Inc. makes no warranty for the use of this code or design.
//--    This code is provided  "As Is". Avnet, Inc assumes no responsibility 
//--    for any errors, which may appear in this code, nor does it make a 
//--    commitment to update the information contained herein. Avnet, Inc 
//--    specifically disclaims any implied warranties of fitness for a 
//--    particular purpose.
//--                     Copyright (c) 2008 Avnet, Inc.
//--                         All rights reserved.
//--
//----------------------------------------------------------------------------
//-- Revision List
//-- Version            Date            Changes
//-- 1.0
//--
//----------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// System Includes.
#include <stdio.h>
#include "os.h"

// ---------------------------------------------------------------------------
// Local includes. 
#include "avnet_console_scanput.h"

// ---------------------------------------------------------------------------
// Global variable definitions.
static char hex_digits[] = "0123456789abcdef";

// ---------------------------------------------------------------------------
void putdecwf(unsigned n, unsigned width, char fill)
{
    unsigned r;
    char buf[12];
    char * p;
    unsigned i;
    
    if (n == 0) {
        for (i = 1; i < width; i++)
            OS_PUTCHAR(fill);
        OS_PUTCHAR('0');
    }
    else {
        p = buf;
        while (n != 0) {
            r = n % 10;
            n = n / 10;
            *p = r + '0';
            p++;
            *p = 0;
        }
        p--;
        for (i = p-buf+1; i < width; i++)
        	OS_PUTCHAR(fill);
        for (; p >= buf; p--)
        	OS_PUTCHAR(*p);
    }
}

// ---------------------------------------------------------------------------
void putdecw(unsigned n, unsigned width)
{
    putdecwf(n, width, ' ');
}

// ---------------------------------------------------------------------------
void putdec(unsigned n)
{
    putdecw(n, 0);
}

// ---------------------------------------------------------------------------
void puthexbyte(unsigned char hex_byte)
{
    unsigned char lower_nibble = hex_byte & 0xf;
    unsigned char upper_nibble = hex_byte >> 4;
        
    OS_PUTCHAR(hex_digits[upper_nibble]);
    OS_PUTCHAR(hex_digits[lower_nibble]);
}

// ---------------------------------------------------------------------------
int scandec(char   * dec_string,
            unsigned * pval)
{
    char * p;
    unsigned digit;
    
    *pval = 0;
    if (!*dec_string)
        return 0;
    
    p = dec_string;
    
    for (; *p; p++) {
        if ((*p >= '0') && (*p <= '9'))
            digit = *p - '0';
        else
            return 0;
        *pval *= 10;
        *pval += digit;
    }
    
    return 1;
}

// ---------------------------------------------------------------------------
int scanhex(char * hex_string,
            unsigned * pval)
{
    char * p;
    unsigned nybble;
    
    *pval = 0;
    if (!*hex_string)
        return 0;
    
    p = hex_string;
    if ( (p[0] == '0') && ((p[1] == 'x') || (p[1] == 'X')) )
    {
        p += 2;
    }
    else
    {
    	// If not prefixed with 0x, assume a decimal value
    	return scandec( p, pval );
    }
    
    for (; *p; p++) {
        if ((*p >= '0') && (*p <= '9'))
            nybble = *p - '0';
        else if ((*p >= 'a') && (*p <= 'f'))
            nybble = *p - 'a' + 0xa;
        else if ((*p >= 'A') && (*p <= 'F'))
            nybble = *p - 'A' + 0xa;
        else
            return 0;
        *pval <<= 4;
        *pval |= nybble;
    }
    
    return 1;
}

// ---------------------------------------------------------------------------
int scanfloat(char   * dec_string,
            float * pval)
{
    char * p;
    int mode = 0;
    unsigned digit;

    *pval = 0;
    if (!*dec_string)
        return 0;

    p = dec_string;

    for (; *p; p++) {
        if ((*p >= '0') && (*p <= '9'))
            digit = *p - '0';
        else if (*p == '.') {
        	mode = 10;
        	continue;
        }
        else
            return 0;

        if (mode == 0) {
            *pval *= 10;
            *pval += digit;
        }
        else {
        	*pval += (float) digit / (float) mode;
        	mode *= 10;
        }
    }

    return 1;
}

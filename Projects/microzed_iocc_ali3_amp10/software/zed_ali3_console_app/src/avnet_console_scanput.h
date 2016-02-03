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
//     http://www.microzed.org
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
// Design Name:         Avnet Console Scanput
// Module Name:         avnet_console_scanput.h
// Project Name:        Avnet Console
//
// Tool versions:       ISE 13.3
//
// Description:         Text-based console for applications.
//
// Dependencies:
//
// Revision:            Nov 18, 2010: 1.01 Initial version
//                      May 23, 2013: 1.02 Updated for Zed Display Kit
//--
//----------------------------------------------------------------------------

#ifndef SCANPUT_H
#define SCANPUT_H

// Prints a decimal string representation of an integer type.
void putdec(unsigned n);

// Prints a decimal string representation of an integer type with a 
// specified minimum field width, right-aligned.
void putdecw(unsigned n, unsigned width);

// Prints a decimal string representation  of an integer type with a 
// specified minimum field width, right-aligned, with specified character 
// pading (e.g. ' ' or '0').
void putdecwf(unsigned n, unsigned width, char fill);

// Prints a hexadecimal string representation  of an unsigned byte type.
void puthexbyte(unsigned char hex_byte);

// Scans decimal string to integer type.
int scandec(char * dec_string, unsigned * pval);

// Scans hex string to integer type.
int scanhex(char * hex_string, unsigned * pval);

#endif // SCANPUT_H

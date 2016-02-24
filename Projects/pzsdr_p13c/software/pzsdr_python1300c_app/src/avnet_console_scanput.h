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
//-- Filename:  scanput.h
//--
//-- Author(s):
//-- Date:
//--
//-- Purpose:
//--    This file specifies the interface for printing and scanning 
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

// Scans decimal string to float type.
int scanfloat(char * dec_string, float * pval);



#endif // SCANPUT_H

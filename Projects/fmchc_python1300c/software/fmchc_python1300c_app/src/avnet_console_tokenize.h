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

// ================================================================
// tokenize.h
//
// Routines for splitting a command line into an argv-style array
// of tokens.  E.g. with the following input ('#' representing a
// null character):
//
//   +---------------------------------------------------------+
//   |The quick brown fox jumped over the lazy dogs.#          | <- command_line
//   +---------------------------------------------------------+
//
// the string will be modified after return to look like this:
//
//   +---------------------------------------------------------+
//   |The#quick#brown#fox#jumped#over#the#lazy#dogs.#          | <- command_line
//   +---------------------------------------------------------+
//    ^   ^     ^     ^   ^      ^    ^   ^    ^
//    |   |     |     |   |      |    |   |    |    argv[9] = NULL
//    |   |     |     |   |      |    |   |    argv[8]
//    |   |     |     |   |      |    |   argv[7]
//    |   |     |     |   |      |    argv[6]
//    |   |     |     |   |      argv[5]
//    |   |     |     |   argv[4]
//    |   |     |     argv[3]
//    |   |     argv[2]
//    |   argv[1]
//    argv[0]
//
// with argc set to 9.
//
// The input *WILL* be overwritten.  You may wish to copy the original
// using strcpy().
//
// Having argv[argc] pointing to null is a historical convention which some
// programmers might expect.
//
// ================================================================
// Author: JRK
// Date: 2001/08/22
//
// (c) 2001 Avnet Design Services
// All Rights Reserved.
// ================================================================

#ifndef TOKENIZE_H
#define TOKENIZE_H

#include "avnet_console_types.h"

void tokenize(
	char  * line,
	int   * pargc,
	char ** argv,
	int     max_arguments);

#endif // TOKENIZE_H

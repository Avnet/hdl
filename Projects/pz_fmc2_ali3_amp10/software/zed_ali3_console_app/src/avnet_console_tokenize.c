// ================================================================
// tokenize.c
//
// Author: JRK
// Date: 2001/08/22
//
// (c) 2001 Avnet Design Services
// All Rights Reserved.
// ================================================================

#include "avnet_console_tokenize.h"

// ----------------------------------------------------------------
// Breaks a single character string into an array of tokens.
//
// The logic is straightforward:  A token is a sequence of non-whitespace
// characters.  A token is delimited by the beginning of the input string, a
// whitespace character, or the end of the string.

void tokenize(
	char    * line,
	int     * pargc,
	char   ** argv,
	int       max_arguments)
{
	char * readp;
	int    inside_token = 0;

	*pargc = 0;

	for (readp = line; *readp; readp++) {
		if (!inside_token) {
			if ((*readp == ' ') || (*readp == '\t')) {
				// Whitespace is not copied.
			}
			else {
				// Start of token
				inside_token = 1;
				argv[*pargc] = readp;
				(*pargc)++;
			}
		}
		else { // inside token
			if ((*readp == ' ') || (*readp == '\t')) {
				// End of token
				inside_token = 0;
				*readp = 0;
			}
			else {
				// Continuation of token
			}
		}
	}

	if (inside_token) {
		// End of input line terminates a token.
		*readp = 0;
		readp++;
	}

	argv[*pargc] = 0; // Null-terminate just to be nice.
}

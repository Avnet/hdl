#ifndef TYPES_H
#define TYPES_H

#ifndef TRUE
#define TRUE (1)
#endif

#ifndef FALSE
#define FALSE (0)
#endif


// This file may be included for embedded programs as well as for
// programs running on the host PC.  For the latter case, BOOL is
// already otherwise defined.
#ifndef HOST_COMPILE
typedef unsigned char   BOOL;
#endif // HOST_COMPILE

typedef unsigned char   int8u;
typedef char            int8s;

typedef unsigned short  int16u;
typedef short           int16s;

typedef unsigned long   int32u;
typedef long            int32s;

typedef struct _int64u {
	int32u lo_addr;
	int32u hi_addr;
} int64u;

#endif // TYPES_H

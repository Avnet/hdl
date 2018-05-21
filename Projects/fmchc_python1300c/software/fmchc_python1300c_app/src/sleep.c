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

#include "xparameters.h"

#include "sleep.h"

//#define USE_DEFAULT_USLEEP

#if !defined(USE_DEFAULT_USLEEP)

// excerpt from standalone_v3_06_a\src\usleep.c

#include "xparameters.h"
#include "xpseudo_asm.h"
#include "xreg_cortexa9.h"

//#define COUNTS_PER_SECOND          (XPAR_CPU_CORTEXA9_CORE_CLOCK_FREQ_HZ / 64)
// the above runs 64x too fast, so remove the division by 64 ...
#define COUNTS_PER_SECOND          (XPAR_CPU_CORTEXA9_CORE_CLOCK_FREQ_HZ)

void usleep(unsigned int useconds)
{
	unsigned long tEnd, tCur;
	unsigned int reg;
	// debug
	unsigned long tCur1;
	unsigned int iterations = 0;
	unsigned int invalid = 0;

	/* check requested delay for out of range */

	if (useconds == 0) {
		return 0;
	}

	if (((COUNTS_PER_SECOND / 1000000) > 0) &&
	    (useconds > (0xFFFFFFFF / (COUNTS_PER_SECOND / 1000000)))) {
		return -1;
	}

	/* enable the counter */
	mtcp(XREG_CP15_PERF_MONITOR_CTRL, 1);
#ifdef __GNUC__
	reg = mfcp(XREG_CP15_COUNT_ENABLE_SET);
#else
	{ register unsigned int Reg __asm(XREG_CP15_COUNT_ENABLE_SET);
	  reg = Reg; }
#endif
	mtcp(XREG_CP15_COUNT_ENABLE_SET, reg | 0x80000000);

#ifdef __GNUC__
	tCur = mfcp(XREG_CP15_PERF_CYCLE_COUNTER);
#else
	{ register unsigned int Reg __asm(XREG_CP15_PERF_CYCLE_COUNTER);
	  tCur = Reg; }
#endif
	tEnd = tCur + (useconds * (COUNTS_PER_SECOND / 1000000));
	// debug
	tCur1 = tCur;
	if ( tEnd < tCur )
	{
		//xil_printf( "[usleep] WARNING : Wrap-around Condition (implementing bug fix)\r\n" );
		// wrap-around condition ... wait until counter wraps ...
		do {
#ifdef __GNUC__
			tCur = mfcp(XREG_CP15_PERF_CYCLE_COUNTER);
#else
			{ register unsigned int Reg __asm(XREG_CP15_PERF_CYCLE_COUNTER);
			  tCur = Reg; }
#endif
			// debug
			iterations++;
		} while (tCur > tCur1);
	}

	do {
#ifdef __GNUC__
		tCur = mfcp(XREG_CP15_PERF_CYCLE_COUNTER);
#else
		{ register unsigned int Reg __asm(XREG_CP15_PERF_CYCLE_COUNTER);
		  tCur = Reg; }
#endif
		// debug
		iterations++;
	} while (tCur < tEnd);

	if ( iterations < 40*useconds ) invalid = 1;
	//printf( "[usleep] useconds=%d, tCur1=%08X, tEnd=%08X, tCur=%08X, iterations=%d\r\n", useconds, tCur1, tEnd, tCur, iterations );
	if ( invalid )
	{
	   xil_printf( "[usleep] ERROR : function terminated too early ...\r\n" );
       return -1;
	}

	//return 0;
	return;
}

#endif // #if !defined(USE_DEFAULT_USLEEP)

void millisleep(unsigned int milliseconds)
{
	int i = 0;

	//xil_printf( "millisleep(%d) ...\n\r", milliseconds );

	for (i=0; i<milliseconds; i++)
	{
		usleep(1000);
	}
}

void sleep(unsigned int seconds)
{
	int i = 0;

	//xil_printf( "sleep(%d)...\n\r", seconds );

	for (i=0; i<seconds; i++)
	{
		//millisleep(1000);
		usleep(1000000);
	}
}


//----------------------------------------------------------------
//      _____
//     *     *
//    *____   *____
//   * *===*   *==*
//  *___*===*___**  AVNET
//       *======*
//        *====*
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
//                     Copyright(c) 2013 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------
//
// Create Date:         Jul 01, 2013
// Design Name:         ZED-IIC
// Module Name:         zed_iic.h
// Project Name:        ZED-IIC
// Target Devices:      Zynq
// Avnet Boards:        ZedBoard
//
// Tool versions:       ISE 14.6
//
// Description:         IIC Hardware Abstraction Layer
//
// Dependencies:        
//
// Revision:            Jul 01, 2013: 1.00 Initial version
//
//----------------------------------------------------------------

#ifndef __ZED_IIC_H__
#define __ZED_IIC_H__

#include <stdio.h>

#include "xbasic_types.h"

#define ZED_IIC_CONTEXT_BUFFER_SIZE 32

struct struct_zed_iic_t
{
   // software library version
   Xuint32 uVersion;

   // instantiation-specific names
   char szName[32];

   // pointer to instantiation-specific data
   void *pContext;

   // context data (must be large enough to contain fmc_iic_axi_t or other implementations)
   unsigned char ContextBuffer[ZED_IIC_CONTEXT_BUFFER_SIZE];

   // function pointers to implementation-specific code
   int (*fpIicRead )(struct struct_zed_iic_t *, Xuint8 ChipAddress,
                                                Xuint8 RegAddress, 
                                                Xuint8 *pBuffer,
                                                Xuint8 ByteCount );
   int (*fpIicWrite)(struct struct_zed_iic_t *, Xuint8 ChipAddress,
                                                Xuint8 RegAddress, 
                                                Xuint8 *pBuffer,
                                                Xuint8 ByteCount );
};
typedef struct struct_zed_iic_t zed_iic_t;

// Initialization routine for AXI_IIC implementation
int zed_iic_axi_init( zed_iic_t *pIIC, char szName[], Xuint32 CoreAddress );


#endif // __ZED_IIC_H__

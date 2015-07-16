//----------------------------------------------------------------
//      _____
//     /     \
//    /____   \____
//   / \===\   \==/
//  /___\===\___\/  AVNET
//       \======/
//        \====/    
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
//                     Copyright(c) 2010 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------
//
// Create Date:         Jan 08, 2010
// Design Name:         FMC-IIC
// Module Name:         fmc_iic.h
// Project Name:        FMC-IIC
// Target Devices:      Spartan-6, Virtex-6, Kintex-7, Zynq
// Avnet Boards:        FMC-IMAGEOV, FMC-DVI/DP, FMC-ISM
//                      FMC-IMAGEON, FMC-MOTORTI
//
// Tool versions:       ISE 13.4
//
// Description:         IIC Hardware Abstraction Layer
//
// Dependencies:        
//
// Revision:            Jan 08, 2010: 1.00 Initial version
//                      Jan 12, 2010: 1.01 Add support for >256 EEPROMs
//                      Jun 23, 2010: 1.02 Remove malloc from code
//                      ------------------------------------------
//                      Apr 12, 2011: 2.01 Update code to support iic_v2_02_a
//                      Aug 31, 2011: 2.02 Make sure all the Fifo's are cleared and Bus is Not busy
//                      Feb 20, 2012: 2.03 Rename file "fmc_iic_axi.c" to "fmc_iic_axi.c"
//                                         Use "xil_io.h" instead of "xio.h"
//
//----------------------------------------------------------------

#ifndef __FMC_IIC_H__
#define __FMC_IIC_H__

#include <stdio.h>

#include "xbasic_types.h"

#define FMC_IIC_CONTEXT_BUFFER_SIZE 32

struct struct_fmc_iic_t
{
   // software library version
   Xuint32 uVersion;

   // instantiation-specific name
   char szName[32];

   // pointer to instantiation-specific data
   void *pContext;

   // context data (must be large enough to contain fmc_iic_pb_t or fmc_iic_axi_t)
   unsigned char ContextBuffer[FMC_IIC_CONTEXT_BUFFER_SIZE];

   // function pointers to implementation-specific code
   int (*fpGpoRead )(struct struct_fmc_iic_t *, Xuint32 *pGpoData );
   int (*fpGpoWrite)(struct struct_fmc_iic_t *, Xuint32 GpoData );
   int (*fpIicRead )(struct struct_fmc_iic_t *, Xuint8 ChipAddress,
                                                Xuint8 RegAddress, 
                                                Xuint8 *pBuffer,
                                                Xuint8 ByteCount );
   int (*fpIicWrite)(struct struct_fmc_iic_t *, Xuint8 ChipAddress,
                                                Xuint8 RegAddress, 
                                                Xuint8 *pBuffer,
                                                Xuint8 ByteCount );
   int (*fpIicERead )(struct struct_fmc_iic_t *, Xuint8 ChipAddress,
                                                 Xuint16 RegAddress, 
                                                 Xuint8 *pBuffer,
                                                 Xuint8 ByteCount );
   int (*fpIicEWrite)(struct struct_fmc_iic_t *, Xuint8 ChipAddress,
                                                 Xuint16 RegAddress, 
                                                 Xuint8 *pBuffer,
                                                 Xuint8 ByteCount );
};
typedef struct struct_fmc_iic_t fmc_iic_t;

// Initialization routine for XPS_IIC implementation
int fmc_iic_axi_init( fmc_iic_t *pIIC, char szName[], Xuint32 CoreAddress ); 
// define for backward compatibility with previous _xps_ name
#define fmc_iic_xps_init fmc_iic_axi_init

// Initialization routine for SG_I2C_CONTROLLER_PLBW implementation
int fmc_iic_sg_init( fmc_iic_t *pIIC, char szName[], void *pConfig, Xuint32 delay );       


#endif // __FMC_IIC_H__

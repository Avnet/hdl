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
// Module Name:         fmc_iic_sg.c
// Project Name:        FMC-IIC
// Target Devices:      Spartan-6
// Avnet Boards:        FMC-IMAGEOV, FMC-DVI/DP, FMC-ISM
//
// Tool versions:       ISE 11.4
//
// Description:         IIC Hardware Abstraction Layer
//                      => SG_I2C_CONTROLLER_S3ADSP_PLBW implementation
//                      => SG_I2C_CONTROLLER_S6_PLBW implementation
//                      => SG_I2C_CONTROLLER_V6_PLBW implementation
//
// Dependencies:        
//
// Revision:            Jun 30, 2009: 1.00 Initial version
//                      Jan 12, 2010: 1.01 Add support for >256 EEPROMs
//                      Jan 15, 2010:      Update to device specific pcores
//                      Jun 23, 2010: 1.02 Remove malloc from code
//                      Jul 20, 2010: 1.03 Add support for IicEWrite/IicERead
//                      Sep 03, 2010:      Rename to fmc_iic_sg.c
//                                         Add new argument for programmable delay
//
//----------------------------------------------------------------

#include <stdio.h>
#include <malloc.h>
#include <string.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "fmc_iic.h"

#if defined(XPAR_SG_I2C_CONTROLLER_S3ADSP_PLBW_NUM_INSTANCES) || defined(XPAR_SG_I2C_CONTROLLER_S6_PLBW_NUM_INSTANCES) || defined(XPAR_SG_I2C_CONTROLLER_V6_PLBW_NUM_INSTANCES)

#if defined(XPAR_SG_I2C_CONTROLLER_S3ADSP_PLBW_NUM_INSTANCES)
#include "sg_i2c_controller_s3adsp_plbw.h"
#endif
#if defined(XPAR_SG_I2C_CONTROLLER_S6_PLBW_NUM_INSTANCES)
#include "sg_i2c_controller_s6_plbw.h"
#endif
#if defined(XPAR_SG_I2C_CONTROLLER_V6_PLBW_NUM_INSTANCES)
#include "sg_i2c_controller_v6_plbw.h"
#endif

////////////////////////////////////////////////////////////////////////
// Context Data
////////////////////////////////////////////////////////////////////////

struct struct_fmc_iic_sg_t
{
   xc_iface_t *iface0;
   xc_to_fifo_t *CmdRequest0;
   xc_from_fifo_t *CmdResponse0;

   xc_to_reg_t *GpioOut0;
   Xuint32 GpioOutData0;
};
typedef struct struct_fmc_iic_sg_t fmc_iic_sg_t;

#define PROCESS_I2C_REG_WRITE       0x01
#define PROCESS_I2C_REG_READ        0x02
#define PROCESS_DELAY_VALUE         0x08
#define PROCESS_I2C_SEND_START      0x10
#define PROCESS_I2C_SEND_STOP       0x11
#define PROCESS_I2C_WRITE_BYTE      0x12
#define PROCESS_I2C_WRITE_BYTE_LAST	0x13
#define PROCESS_I2C_READ_BYTE       0x14
#define PROCESS_I2C_READ_BYTE_LAST  0x15

////////////////////////////////////////////////////////////////////////
// Implementation Functions
////////////////////////////////////////////////////////////////////////

// Forward declarations
int fmc_iic_sg_GpoRead ( fmc_iic_t *pIIC, Xuint32 *pGpioData );
int fmc_iic_sg_GpoWrite( fmc_iic_t *pIIC, Xuint32 GpioData );
int fmc_iic_sg_IicWrite( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 RegAddress, 
                                          Xuint8 *pBuffer, Xuint8 ByteCount);
int fmc_iic_sg_IicRead ( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 RegAddress, 
                                          Xuint8 *pBuffer, Xuint8 ByteCount);
int fmc_iic_sg_IicEWrite( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint16 RegAddress, 
                                           Xuint8 *pBuffer, Xuint8 ByteCount);
int fmc_iic_sg_IicERead ( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint16 RegAddress, 
                                           Xuint8 *pBuffer, Xuint8 ByteCount);

/******************************************************************************
* This function initializes the IIC controller.
*
* @param    CoreAddress contains the address of the IIC core.
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_iic_sg_init( fmc_iic_t *pIIC, char szName[], void *pConfig, Xuint32 delay )
{
   //fmc_iic_sg_t *c  = (fmc_iic_sg_t *)malloc( sizeof(fmc_iic_sg_t) );
   //if ( pContext == NULL )
   //{
   //   xil_printf("Failed to allocate context data for FMC-IIC-XPS implementation\n\r" );
   //   return 0;
   //}
   fmc_iic_sg_t *pContext = (fmc_iic_sg_t *) (pIIC->ContextBuffer);
   if ( sizeof(fmc_iic_sg_t) > FMC_IIC_CONTEXT_BUFFER_SIZE )
   {
      xil_printf("FMC_IIC_CONTEXT_BUFFER_SIZE is not large enough for fmc_iic_sg_t structure (increase to %d)\n\r", sizeof(fmc_iic_sg_t) );
      return 0;
   }

   // initialize the software driver
   xc_create(&(pContext->iface0), pConfig);

   // obtain the memory locations for storing the settings of shared memories
   xc_get_shmem((pContext->iface0), "cmd_request",  (void **)&(pContext->CmdRequest0) );
   xc_get_shmem((pContext->iface0), "cmd_response", (void **)&(pContext->CmdResponse0));
   xc_get_shmem((pContext->iface0), "gpio_out8",    (void **)&(pContext->GpioOut0)    );
   
   // init GPIO[7:0] to 0
   pContext->GpioOutData0 = 0x00;
   xc_write((pContext->iface0), pContext->GpioOut0->din,  pContext->GpioOutData0 );

   /*
    * Initialize the IIC structure
	*/ 
   pIIC->uVersion = 1;
   strcpy( pIIC->szName, szName );
   pIIC->pContext = (void *)pContext;
   pIIC->fpGpoRead   = &fmc_iic_sg_GpoRead;
   pIIC->fpGpoWrite  = &fmc_iic_sg_GpoWrite;
   pIIC->fpIicRead   = &fmc_iic_sg_IicRead;
   pIIC->fpIicWrite  = &fmc_iic_sg_IicWrite;
   pIIC->fpIicERead  = &fmc_iic_sg_IicERead;
   pIIC->fpIicEWrite = &fmc_iic_sg_IicEWrite;

   {
      uint32_t status;
	  uint32_t cmd_req;
      uint32_t cmd_rsp;

      // Format Request1 : DELAY_VALUE 
      cmd_req = (PROCESS_DELAY_VALUE << 24) | (delay << 16);
      //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
      // Send Request1
      do {
        xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
      } while ( status );
      xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

      // Get Response1
      do {
        xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
      } while ( status );
      xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

      // Parse Response1
      //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
      if ( cmd_rsp == 0xDEADCAFE )
      {
        // I2C error, abort
	    return 0;
      }
   }

   return 1;
}

/******************************************************************************
* This function reads the I2C controller's 8 bit GPIO bits.
*
* @param    pGpioData .
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_iic_sg_GpoRead( fmc_iic_t *pIIC, Xuint32 *pGpioData )
{
   fmc_iic_sg_t *pContext = (fmc_iic_sg_t *)(pIIC->pContext);

   *pGpioData = pContext->GpioOutData0;

   return 1;
}

/******************************************************************************
* This function sets the I2C controller's 8 bit GPIO bits.
*
* @param    GpioData .
*
* @return   If successfull, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int fmc_iic_sg_GpoWrite( fmc_iic_t *pIIC, Xuint32 GpioData )
{
   fmc_iic_sg_t *pContext = (fmc_iic_sg_t *)(pIIC->pContext);

   pContext->GpioOutData0 = GpioData;
   xc_write((pContext->iface0), pContext->GpioOut0->din,  pContext->GpioOutData0 );

   return 1;
}


/*****************************************************************************/
/**
* This function writes a buffer of bytes to the IIC chip.
*
* @param    ChipAddress contains the address of the chip.
* @param    RegAddress contains the address of the register to write to.
* @param    pBuffer contains the address of the data to write.
* @param    ByteCount contains the number of bytes in the buffer to be written.
*           Note that this should not exceed the page size as noted by the 
*           constant PAGE_SIZE.
*
* @return   The number of bytes written, a value less than that which was
*           specified as an input indicates an error.
*
* @note     None.
*
******************************************************************************/
int fmc_iic_sg_IicWrite(fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 RegAddress, 
                                         Xuint8 *pBuffer, Xuint8 ByteCount)
{
  Xuint8 SentByteCount;
  uint32_t status;
  uint32_t cmd_req;
  uint32_t cmd_rsp;
  fmc_iic_sg_t *pContext = (fmc_iic_sg_t *)(pIIC->pContext);

  for ( SentByteCount = 0; SentByteCount < ByteCount; SentByteCount++ )
  {
    // Format request
	 cmd_req = (PROCESS_I2C_REG_WRITE << 24) | ((uint32_t)ChipAddress << 16+1) | ((uint32_t)RegAddress << 8) | (uint32_t)pBuffer[SentByteCount];
	 //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
    // Send Request
	 do {
      xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
	 } while ( status );
    xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

    // Get Response
	 do {
      xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
	 } while ( status );
    xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );
  
    // Parse response
	 //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
    if ( cmd_rsp == 0xDEADCAFE )
    {
	    // I2C error, abort
	    break;
    }
  }
 
  // Return the number of bytes written.
  return SentByteCount;
}


/******************************************************************************
* This function reads a number of bytes from an IIC chip into a
* specified buffer.
*
* @param    ChipAddress contains the address of the IIC core.
* @param    RegAddress contains the address of the register to write to.
* @param    pBuffer contains the address of the data buffer to be filled.
* @param    ByteCount contains the number of bytes in the buffer to be read.
*           This value is constrained by the page size of the device such
*           that up to 64K may be read in one call.
*
* @return   The number of bytes read. A value less than the specified input
*           value indicates an error.
*
* @note     None.
*
******************************************************************************/
int fmc_iic_sg_IicRead(fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 RegAddress, 
                                        Xuint8 *pBuffer, Xuint8 ByteCount)
{
  Xuint8 ReceivedByteCount;
  uint32_t status;
  uint32_t cmd_req;
  uint32_t cmd_rsp;
  fmc_iic_sg_t *pContext = (fmc_iic_sg_t *)(pIIC->pContext);

  
  for ( ReceivedByteCount = 0; ReceivedByteCount < ByteCount; ReceivedByteCount++ )
  {
    // Format request
	 cmd_req = (PROCESS_I2C_REG_READ << 24)  | ((uint32_t)ChipAddress << 16+1) | ((uint32_t)RegAddress << 8);
	 //xil_printf( "[%s] fmc_iic_sg_read : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
    // Send Request
	 do {
      xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
	 } while ( status );
    xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

    // Get Response
	 do {
      xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
	 } while ( status );
    xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );
  
    // Parse response
	 //xil_printf( "[%s] fmc_iic_sg_read : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
    if ( cmd_rsp == 0xDEADCAFE )
    {
	    // I2C error, abort
	    break;
    }
    pBuffer[ReceivedByteCount] = (Xuint8)(cmd_rsp & 0x000000FF);
  }
  
  // Return the number of bytes received.
  return ReceivedByteCount;
}

/*****************************************************************************/
/**
* This function writes a buffer of bytes to the IIC chip.
* This function implements extended 16 bit addressing.
*
* @param    ChipAddress contains the address of the chip.
* @param    RegAddress contains the address of the register to write to.
* @param    pBuffer contains the address of the data to write.
* @param    ByteCount contains the number of bytes in the buffer to be written.
*           Note that this should not exceed the page size as noted by the 
*           constant PAGE_SIZE.
*
* @return   The number of bytes written, a value less than that which was
*           specified as an input indicates an error.
*
* @note     None.
*
******************************************************************************/
int fmc_iic_sg_IicEWrite(fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint16 RegAddress, 
                                         Xuint8 *pBuffer, Xuint8 ByteCount)
{
  Xuint8 SentByteCount;
  uint32_t status;
  uint32_t cmd_req;
  uint32_t cmd_rsp;
  fmc_iic_sg_t *pContext = (fmc_iic_sg_t *)(pIIC->pContext);

  // Format Request1 : SEND_START 
  cmd_req = (PROCESS_I2C_SEND_START << 24);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request1
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response1
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response1
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
	return 0;
  }

  // Format Request2 : WRITE_BYTE (for Device ID)
  cmd_req = (PROCESS_I2C_WRITE_BYTE << 24) | ((uint32_t)ChipAddress << 16+1);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request2
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response2
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response2
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
	// I2C error, abort
    return 0;
  }

  // Format Request3 : WRITE_BYTE (for Reg Address[15:8])
  cmd_req = (PROCESS_I2C_WRITE_BYTE << 24) | ((uint32_t)((RegAddress>>8) & 0x00FF) << 16);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request3
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response3
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response3
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
    return 0;
  }

  // Format Request4 : WRITE_BYTE (for Reg Address[7:0])
  cmd_req = (PROCESS_I2C_WRITE_BYTE << 24) | ((uint32_t)( RegAddress     & 0x00FF) << 16);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request4
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response4
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response4
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
    return 0;
  }

  for ( SentByteCount = 0; SentByteCount < ByteCount; SentByteCount++ )
  {
    // Format Request5 : WRITE_BYTE (for Reg Data[7:0])
	cmd_req = (PROCESS_I2C_WRITE_BYTE << 24) | ((uint32_t)pBuffer[SentByteCount] << 16);
    //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
	// Send Request5
    do {
      xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
    } while ( status );
    xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

    // Get Response5
	do {
      xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
	 } while ( status );
    xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

    // Parse Response5
    //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
    if ( cmd_rsp == 0xDEADCAFE )
    {
	    // I2C error, abort
	    break;
    }
  }

  // Format Request6 : SEND_STOP
  cmd_req = (PROCESS_I2C_SEND_STOP << 24);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request6
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response6
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response6
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
    return 0;
  }
 
  // Return the number of bytes written.
  return SentByteCount;
}


/******************************************************************************
* This function reads a number of bytes from an IIC chip into a
* specified buffer.
* This function implements extended 16 bit addressing.
*
* @param    ChipAddress contains the address of the IIC core.
* @param    RegAddress contains the address of the register to write to.
* @param    pBuffer contains the address of the data buffer to be filled.
* @param    ByteCount contains the number of bytes in the buffer to be read.
*           This value is constrained by the page size of the device such
*           that up to 64K may be read in one call.
*
* @return   The number of bytes read. A value less than the specified input
*           value indicates an error.
*
* @note     None.
*
******************************************************************************/
int fmc_iic_sg_IicERead(fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint16 RegAddress, 
                                        Xuint8 *pBuffer, Xuint8 ByteCount)
{
  Xuint8 ReceivedByteCount;
  uint32_t status;
  uint32_t cmd_req;
  uint32_t cmd_rsp;
  fmc_iic_sg_t *pContext = (fmc_iic_sg_t *)(pIIC->pContext);

  // Format Request1 : SEND_START 
  cmd_req = (PROCESS_I2C_SEND_START << 24);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request1
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response1
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response1
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
	return 0;
  }

  // Format Request2 : WRITE_BYTE (for Device ID)
  cmd_req = (PROCESS_I2C_WRITE_BYTE << 24) | ((uint32_t)ChipAddress << 16+1);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request2
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response2
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response2
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
	// I2C error, abort
    return 0;
  }

  // Format Request3 : WRITE_BYTE (for Reg Address[15:8])
  cmd_req = (PROCESS_I2C_WRITE_BYTE << 24) | ((uint32_t)((RegAddress>>8) & 0x00FF) << 16);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request3
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response3
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response3
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
    return 0;
  }

  // Format Request4 : WRITE_BYTE (for Reg Address[7:0])
  cmd_req = (PROCESS_I2C_WRITE_BYTE << 24) | ((uint32_t)( RegAddress     & 0x00FF) << 16);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request4
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response4
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response4
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
    return 0;
  }

  // Format Request5 : SEND_START 
  cmd_req = (PROCESS_I2C_SEND_START << 24);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request5
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response5
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response5
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
	return 0;
  }

  // Format Request6 : WRITE_BYTE (for Device ID, Read)
  cmd_req = (PROCESS_I2C_WRITE_BYTE << 24) | ((uint32_t)ChipAddress << 16+1) | 0x00010000;
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request6
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response6
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response6
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
	// I2C error, abort
    return 0;
  }

  for ( ReceivedByteCount = 0; ReceivedByteCount < ByteCount-1; ReceivedByteCount++ )
  {
    // Format Request7 : READ_BYTE (for Reg Data[7:0])
	cmd_req = (PROCESS_I2C_READ_BYTE << 24);
    //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
	// Send Request7
    do {
      xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
    } while ( status );
    xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

    // Get Response7
	do {
      xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
	 } while ( status );
    xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

    // Parse Response7
	//xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
    if ( cmd_rsp == 0xDEADCAFE )
    {
	    // I2C error, abort
	    break;
    }
	pBuffer[ReceivedByteCount] = (Xuint8)((cmd_rsp & 0x00FF0000)>>16);
  }

  // Format Request8 : READ_BYTE_LAST (for Reg Data[7:0])
  cmd_req = (PROCESS_I2C_READ_BYTE_LAST << 24);
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_req = 0x%08X\n\r", pIIC->szName, cmd_req );
       	  
  // Send Request8
  do {
    xc_read ((pContext->iface0), pContext->CmdRequest0->full, &status );
  } while ( status );
  xc_write((pContext->iface0), pContext->CmdRequest0->din, cmd_req );

  // Get Response8
  do {
    xc_read ((pContext->iface0), pContext->CmdResponse0->empty, &status );
  } while ( status );
  xc_read((pContext->iface0), pContext->CmdResponse0->dout, &cmd_rsp );

  // Parse Response8
  //xil_printf( "[%s] fmc_iic_sg_write : cmd_rsp = 0x%08X\n\r", pIIC->szName, cmd_rsp );
  if ( cmd_rsp == 0xDEADCAFE )
  {
    // I2C error, abort
    return 0;
  }
  pBuffer[ReceivedByteCount] = (Xuint8)((cmd_rsp & 0x00FF0000)>>16);
  ReceivedByteCount++;
  
  // Return the number of bytes received.
  return ReceivedByteCount;
}

#endif // defined(XPAR_SG_I2C_CONTROLLER_S3ADSP_PLBW_NUM_INSTANCES) || defined(XPAR_SG_I2C_CONTROLLER_S6_PLBW_NUM_INSTANCES) || defined(XPAR_SG_I2C_CONTROLLER_V6_PLBW_NUM_INSTANCES)

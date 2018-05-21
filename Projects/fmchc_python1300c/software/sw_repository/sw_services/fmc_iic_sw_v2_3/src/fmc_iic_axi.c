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
// Design Name:         FMC-IIC-XPS
// Module Name:         fmc_iic_axi.c
// Project Name:        FMC-IIC-XPS
// Target Devices:      Spartan-6
// Avnet Boards:        FMC-IMAGEOV, FMC-DVI/DP, FMC-ISM
//                      FMC-IMAGEON, FMC-MOTORTI
//
// Tool versions:       ISE 13.4
//
// Description:         IIC Hardware Abstraction Layer
//                      => AXI_IIC implementation
//
// Dependencies:        
//
// Revision:            Jun 30, 2009: 1.00 Initial version
//                      Jan 12, 2010: 1.01 Add support for >256 EEPROMs
//                      Jun 23, 2010: 1.02 Remove malloc from code
//                      ------------------------------------------
//                      Apr 12, 2011: 2.01 Update code to support iic_v2_02_a
//                      Aug 31, 2011: 2.02 Make sure all the Fifo's are cleared and Bus is Not busy
//                      Feb 20, 2012: 2.03 Rename file "fmc_iic_axi.c" to "fmc_iic_axi.c"
//                                         Use "xil_io.h" instead of "xio.h"
//
//----------------------------------------------------------------

#include <stdio.h>
#include <malloc.h>
#include <string.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "fmc_iic.h"

#if defined(XPAR_XIIC_NUM_INSTANCES)

#include "xiic.h"
#include "xil_io.h"
   
/*
 * The page size determines how much data should be written at a time.
 * The write function should be called with this as a maximum byte count.
 */
#define PAGE_SIZE   2


////////////////////////////////////////////////////////////////////////
// Context Data
////////////////////////////////////////////////////////////////////////

struct struct_fmc_iic_axi_t
{
	Xuint32 CoreAddress;
};
typedef struct struct_fmc_iic_axi_t fmc_iic_axi_t;

////////////////////////////////////////////////////////////////////////
// I2C Functions
////////////////////////////////////////////////////////////////////////

// Forward declarations
int fmc_iic_axi_GpoRead ( fmc_iic_t *pIIC, Xuint32 *pGpioData );
int fmc_iic_axi_GpoWrite( fmc_iic_t *pIIC, Xuint32 GpioData );
int fmc_iic_axi_IicWrite( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 RegAddress, 
                                           Xuint8 *pBuffer, Xuint8 ByteCount);
int fmc_iic_axi_IicRead ( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 RegAddress, 
                                           Xuint8 *pBuffer, Xuint8 ByteCount);
int fmc_iic_axi_IicEWrite( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint16 RegAddress, 
                                            Xuint8 *pBuffer, Xuint8 ByteCount);
int fmc_iic_axi_IicERead ( fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint16 RegAddress, 
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
int fmc_iic_axi_init( fmc_iic_t *pIIC, char szName[], Xuint32 CoreAddress )
{
   XStatus Status;
   Xuint8 StatusReg;
   Xuint32 timeout = 10000;

   //fmc_iic_axi_t *pContext = (fmc_iic_axi_t *)malloc( sizeof(fmc_iic_axi_t) );
   //if ( pContext == NULL )
   //{
   //   xil_printf("Failed to allocate context data for FMC-IIC-AXI implementation\n\r" );
   //   return 0;
   //}
   fmc_iic_axi_t *pContext = (fmc_iic_axi_t *) (pIIC->ContextBuffer);
   if ( sizeof(fmc_iic_axi_t) > FMC_IIC_CONTEXT_BUFFER_SIZE )
   {
      xil_printf("FMC_IIC_CONTEXT_BUFFER_SIZE is not large enough for fic_iic_xps_t structure (increase to %d)\n\r", sizeof(fmc_iic_axi_t) );
      return 0;
   }

   pContext->CoreAddress = CoreAddress;

   /*
    * Initialize the IIC Core.
    */
   Status = XIic_DynInit(pContext->CoreAddress);
   if(Status != XST_SUCCESS)
   {
      xil_printf("Failed to initialize I2C chain\n\r" );
      return 0;
   }

   /*
    * Check to see if the core was initialized successfully
	*/ 
  do
  {
    StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
    //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
    StatusReg = StatusReg & (XIIC_SR_RX_FIFO_EMPTY_MASK |
                             XIIC_SR_TX_FIFO_EMPTY_MASK |
                             XIIC_SR_BUS_BUSY_MASK);
  } while ( (timeout-- > 0) &&
            (StatusReg != (XIIC_SR_RX_FIFO_EMPTY_MASK | XIIC_SR_TX_FIFO_EMPTY_MASK)) );

   /*
    * Initialize the IIC structure
	*/ 
   pIIC->uVersion = 1;
   strcpy( pIIC->szName, szName );
   pIIC->pContext = (void *)pContext;
   pIIC->fpGpoRead   = &fmc_iic_axi_GpoRead;
   pIIC->fpGpoWrite  = &fmc_iic_axi_GpoWrite;
   pIIC->fpIicRead   = &fmc_iic_axi_IicRead;
   pIIC->fpIicWrite  = &fmc_iic_axi_IicWrite;
   pIIC->fpIicERead  = &fmc_iic_axi_IicERead;
   pIIC->fpIicEWrite = &fmc_iic_axi_IicEWrite;

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
int fmc_iic_axi_GpoRead( fmc_iic_t *pIIC, Xuint32 *pGpioData )
{
   fmc_iic_axi_t *pContext = (fmc_iic_axi_t *)(pIIC->pContext);

   *pGpioData = Xil_In32((pContext->CoreAddress + 0x124));

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
int fmc_iic_axi_GpoWrite( fmc_iic_t *pIIC, Xuint32 GpioData )
{
   fmc_iic_axi_t *pContext = (fmc_iic_axi_t *)(pIIC->pContext);

   //xil_printf("[%s] Xil_Out32((pContext->CoreAddress + 0x124),data) => 0x%08X\n\r", pContext->szName, Xil_In32(pContext->CoreAddress + 0x124) );
   Xil_Out32((pContext->CoreAddress + 0x124),GpioData);
   //xil_printf("[%s] Xil_Out32((pContext->CoreAddress + 0x124),data) <= 0x%08X\n\r", pContext->szName, GpioData );

   return 1;
}


/******************************************************************************
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
int fmc_iic_axi_IicWrite(fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 RegAddress, 
                                          Xuint8 *pBuffer, Xuint8 ByteCount)
{
  Xuint8 SentByteCount;
  Xuint8 WriteBuffer[PAGE_SIZE + 1];
  Xuint8 Index;
  Xuint8 StatusReg;
  fmc_iic_axi_t *pContext = (fmc_iic_axi_t *)(pIIC->pContext);

#if 1
  // Make sure all the Fifo's are cleared and Bus is Not busy.
  do
  {
    StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
    //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
    StatusReg = StatusReg & (XIIC_SR_RX_FIFO_EMPTY_MASK |
                             XIIC_SR_TX_FIFO_EMPTY_MASK |
                             XIIC_SR_BUS_BUSY_MASK);
  } while (StatusReg != (XIIC_SR_RX_FIFO_EMPTY_MASK |
			                XIIC_SR_TX_FIFO_EMPTY_MASK));
#endif

  /*
   * A temporary write buffer must be used which contains both the address
   * and the data to be written, put the address in first 
   */
  WriteBuffer[0] = RegAddress;

  /*
   * Put the data in the write buffer following the address.
   */
  for (Index = 0; Index < ByteCount; Index++)
  {
    WriteBuffer[Index + 1] = pBuffer[Index];
  }

  /*
   * Write data at the specified address.
   */
  SentByteCount = XIic_DynSend(pContext->CoreAddress, ChipAddress, WriteBuffer,
                               ByteCount + 1, XIIC_STOP);
  if (SentByteCount < 1) { SentByteCount = 1; }
                               
  // Return the number of bytes written.
  return SentByteCount - 1;
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
int fmc_iic_axi_IicRead(fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint8 RegAddress, 
                                         Xuint8 *pBuffer, Xuint8 ByteCount)
{
  Xuint8 ReceivedByteCount = 0;
  Xuint8 SentByteCount = 0;
  Xuint8 StatusReg;
  XStatus TestStatus=XST_FAILURE;
  int cnt = 0;
  fmc_iic_axi_t *pContext = (fmc_iic_axi_t *)(pIIC->pContext);

#if 1
  // Make sure all the Fifo's are cleared and Bus is Not busy.
  do
  {
    StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
    //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
    StatusReg = StatusReg & (XIIC_SR_RX_FIFO_EMPTY_MASK |
	                          XIIC_SR_TX_FIFO_EMPTY_MASK |
                             XIIC_SR_BUS_BUSY_MASK);
  } while (StatusReg != (XIIC_SR_RX_FIFO_EMPTY_MASK |
			                XIIC_SR_TX_FIFO_EMPTY_MASK));
#endif

  // Position the Read pointer to specific location.
  do
  {
    StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
    //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
    if(!(StatusReg & XIIC_SR_BUS_BUSY_MASK))
    {
      SentByteCount = XIic_DynSend(pContext->CoreAddress, ChipAddress, 
                                  (Xuint8 *)&RegAddress, 1,
    								        XIIC_REPEATED_START);
    }
    cnt++;
  }while(SentByteCount != 1 && (cnt < 100));
  
  // Error writing chip address so return SentByteCount
  if (SentByteCount < 1) { return SentByteCount; }

  // Receive the data.
  ReceivedByteCount = XIic_DynRecv(pContext->CoreAddress, ChipAddress, pBuffer, 
                                   ByteCount);

  // Return the number of bytes received.
  return ReceivedByteCount;
}

/******************************************************************************
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
int fmc_iic_axi_IicEWrite(fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint16 RegAddress, 
                                          Xuint8 *pBuffer, Xuint8 ByteCount)
{
  Xuint8 SentByteCount;
  Xuint8 WriteBuffer[PAGE_SIZE + 1];
  Xuint8 Index;
  Xuint8 StatusReg;
  fmc_iic_axi_t *pContext = (fmc_iic_axi_t *)(pIIC->pContext);

#if 1
  // Make sure all the Fifo's are cleared and Bus is Not busy.
  do
  {
    StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
    //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
    StatusReg = StatusReg & (XIIC_SR_RX_FIFO_EMPTY_MASK |
                             XIIC_SR_TX_FIFO_EMPTY_MASK |
                             XIIC_SR_BUS_BUSY_MASK);
  } while (StatusReg != (XIIC_SR_RX_FIFO_EMPTY_MASK |
			                XIIC_SR_TX_FIFO_EMPTY_MASK));
#endif

  /*
   * A temporary write buffer must be used which contains both the address
   * and the data to be written, put the address in first 
   */
  WriteBuffer[0] = (Xuint8)((RegAddress>>8) & 0x00FF);
  WriteBuffer[1] = (Xuint8)( RegAddress     & 0x00FF);

  /*
   * Put the data in the write buffer following the address.
   */
  for (Index = 0; Index < ByteCount; Index++)
  {
    WriteBuffer[Index + 2] = pBuffer[Index];
  }

  /*
   * Write data at the specified address.
   */
  SentByteCount = XIic_DynSend(pContext->CoreAddress, ChipAddress, WriteBuffer,
                               ByteCount + 2, XIIC_STOP);
  if (SentByteCount < 1) { SentByteCount = 1; }
                               
  // Return the number of bytes written.
  return SentByteCount - 1;
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
int fmc_iic_axi_IicERead(fmc_iic_t *pIIC, Xuint8 ChipAddress, Xuint16 RegAddress, 
                                         Xuint8 *pBuffer, Xuint8 ByteCount)
{
  Xuint8 ReceivedByteCount = 0;
  Xuint8 SentByteCount = 0;
  Xuint8 WriteBuffer[2];
  Xuint8 StatusReg;
  XStatus TestStatus=XST_FAILURE;
  int cnt = 0;
  fmc_iic_axi_t *pContext = (fmc_iic_axi_t *)(pIIC->pContext);

#if 1
  // Make sure all the Fifo's are cleared and Bus is Not busy.
  do
  {
    StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
    //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
    StatusReg = StatusReg & (XIIC_SR_RX_FIFO_EMPTY_MASK |
	                          XIIC_SR_TX_FIFO_EMPTY_MASK |
                             XIIC_SR_BUS_BUSY_MASK);
  } while (StatusReg != (XIIC_SR_RX_FIFO_EMPTY_MASK |
			                XIIC_SR_TX_FIFO_EMPTY_MASK));
#endif

  /*
   * A temporary write buffer must be used which contains both the address
   * and the data to be written, put the address in first 
   */
  WriteBuffer[0] = (Xuint8)((RegAddress>>8) & 0x00FF);
  WriteBuffer[1] = (Xuint8)( RegAddress     & 0x00FF);

  // Position the Read pointer to specific location.
  do
  {
    StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
    //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
    if(!(StatusReg & XIIC_SR_BUS_BUSY_MASK))
    {
      SentByteCount = XIic_DynSend(pContext->CoreAddress, ChipAddress, 
                                            WriteBuffer, 2,
    								        XIIC_REPEATED_START);
    }
    cnt++;
  }while(SentByteCount != 1 && (cnt < 100));
  
  // Error writing chip address so return SentByteCount
  if (SentByteCount < 1) { return SentByteCount; }

  // Receive the data.
  ReceivedByteCount = XIic_DynRecv(pContext->CoreAddress, ChipAddress, pBuffer, 
                                   ByteCount);

  // Return the number of bytes received.
  return ReceivedByteCount;
}

#endif // defined(XPAR_XIIC_NUM_INSTANCES)

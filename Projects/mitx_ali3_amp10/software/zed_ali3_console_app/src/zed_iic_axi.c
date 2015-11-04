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
// Please direct any questions or issues to the MicroZed Community Forums:
//     http://www.microzed.org
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
// Module Name:         zed_iic_axi.c
// Project Name:        ZED-IIC
// Target Devices:      Zynq
// Avnet Boards:        ZedBoard
//
// Tool versions:       ISE 14.6
//
// Description:         IIC Hardware Abstraction Layer
//                      => AXI_IIC implementation
//
// Dependencies:        
//
// Revision:            Jul 01, 2013: 1.00 Initial version
//						Mar 27, 2015: 1.01 Updated to remove
//                                         dependency upon
//                                         xbasic_types.h
//						Oct 30, 2015: 1.02 Updated to add support
//                                         to support Ampire 
//                                         touch controller
//
//----------------------------------------------------------------

#include <stdio.h>
#include <malloc.h>
#include <string.h>

// Located in: microblaze_0/include/
#include "xparameters.h"
#include "xstatus.h"

#include "zed_iic.h"

#if defined(XPAR_XIIC_NUM_INSTANCES)

#include "xiic.h"
#include "xil_io.h"
   
/*
 * The page size determines how much data should be written at a time.
 * The write function should be called with this as a maximum byte count.
 */
#define PAGE_SIZE   67


////////////////////////////////////////////////////////////////////////
// Context Data
////////////////////////////////////////////////////////////////////////

struct struct_zed_iic_axi_t
{
	uint32_t CoreAddress;
};
typedef struct struct_zed_iic_axi_t zed_iic_axi_t;

////////////////////////////////////////////////////////////////////////
// I2C Functions
////////////////////////////////////////////////////////////////////////

// Forward declarations
int zed_iic_axi_GpoRead ( zed_iic_t *pIIC, uint32_t *pGpioData );
int zed_iic_axi_GpoWrite( zed_iic_t *pIIC, uint32_t GpioData );
int zed_iic_axi_IicWrite( zed_iic_t *pIIC, uint8_t ChipAddress, uint8_t RegAddress,
                                           uint8_t *pBuffer, uint8_t ByteCount);
int zed_iic_axi_IicRead ( zed_iic_t *pIIC, uint8_t ChipAddress, uint8_t RegAddress,
                                           uint8_t *pBuffer, uint8_t ByteCount);
int zed_iic_axi_IicDRead (zed_iic_t *pIIC, uint8_t ChipAddress, uint8_t RegAddress,
                                           uint8_t *pBuffer, uint8_t ByteCount);
int zed_iic_axi_IicEWrite( zed_iic_t *pIIC, uint8_t ChipAddress, uint16_t RegAddress,
                                            uint8_t *pBuffer, uint8_t ByteCount);
int zed_iic_axi_IicERead ( zed_iic_t *pIIC, uint8_t ChipAddress, uint16_t RegAddress,
                                            uint8_t *pBuffer, uint8_t ByteCount);

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
int zed_iic_axi_init( zed_iic_t *pIIC, char szName[], uint32_t CoreAddress )
{
   XStatus Status;
   uint8_t StatusReg;
   uint32_t timeout = 10000;

   //zed_iic_axi_t *pContext = (zed_iic_axi_t *)malloc( sizeof(zed_iic_axi_t) );
   //if ( pContext == NULL )
   //{
   //   xil_printf("Failed to allocate context data for FMC-IIC-AXI implementation\n\r" );
   //   return 0;
   //}
   zed_iic_axi_t *pContext = (zed_iic_axi_t *) (pIIC->ContextBuffer);
   if ( sizeof(zed_iic_axi_t) > ZED_IIC_CONTEXT_BUFFER_SIZE )
   {
      xil_printf("ZED_IIC_CONTEXT_BUFFER_SIZE is not large enough for fic_iic_xps_t structure (increase to %d)\n\r", sizeof(zed_iic_axi_t) );
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
   pIIC->fpIicRead   = &zed_iic_axi_IicRead;
   pIIC->fpIicWrite  = &zed_iic_axi_IicWrite;

   return 1;
}


/******************************************************************************
* This function reassigns the read operation of the IIC device to the direct
* read function such that a register address is NOT part of a read transfer
* to the slave device.
*
* @param    pIIC is the target zed_iic_t instance.
*
* @return   If successful, returns 1.  Otherwise, returns 0.
*
* @note     None.
*
******************************************************************************/
int zed_iic_axi_set_read_direct(zed_iic_t *pIIC)
{
    pIIC->fpIicRead   = &zed_iic_axi_IicDRead;

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
int zed_iic_axi_IicWrite(zed_iic_t *pIIC, uint8_t ChipAddress, uint8_t RegAddress,
                                          uint8_t *pBuffer, uint8_t ByteCount)
{
  uint8_t SentByteCount;
  uint8_t WriteBuffer[PAGE_SIZE + 1];
  uint8_t Index;
  uint8_t StatusReg;
  zed_iic_axi_t *pContext = (zed_iic_axi_t *)(pIIC->pContext);

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
  SentByteCount = XIic_Send(pContext->CoreAddress, ChipAddress, WriteBuffer,
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
int zed_iic_axi_IicRead(zed_iic_t *pIIC, uint8_t ChipAddress, uint8_t RegAddress,
                                         uint8_t *pBuffer, uint8_t ByteCount)
{
  uint8_t ReceivedByteCount = 0;
  uint8_t SentByteCount = 0;
  uint8_t ControlReg;
  uint8_t StatusReg;
  int cnt = 0;
  zed_iic_axi_t *pContext = (zed_iic_axi_t *)(pIIC->pContext);

#if 1
  // Make sure all the Fifo's are cleared and Bus is Not busy.
  do
  {
    StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
    //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
    StatusReg = StatusReg & (XIIC_SR_RX_FIFO_EMPTY_MASK |
	                          XIIC_SR_TX_FIFO_EMPTY_MASK |
                             XIIC_SR_BUS_BUSY_MASK);
    if ((StatusReg & XIIC_SR_RX_FIFO_EMPTY_MASK) != XIIC_SR_RX_FIFO_EMPTY_MASK)
    {
      /*
       * The RX buffer is not empty and it is assumed there is a stale
       * message in there.  Attempt to clear out the RX buffer, otherwise
       * this loop spins forever.
       */
      XIic_ReadReg(pContext->CoreAddress, XIIC_DRR_REG_OFFSET);
    }

	/*
	 * Check to see if the bus is busy.  Since we are master, if the bus is
	 * still busy that means that arbitration has been lost.
	 *
	 * According to Product Guide PG090, October 16, 2012:
	 *
	 * Control Register (0x100), Bit 2 MSMS:
	 *
	 * "Master/Slave Mode Select. When this bit is changed from 0 to 1,
	 * the AXI IIC bus interface generates a START condition in master
	 * mode. When this bit is cleared, a STOP condition is generated and
	 * the AXI IIC bus interface switches to slave mode. When this bit is
	 * cleared by the hardware, because arbitration for the bus has been
	 * lost, a STOP condition is not generated. (See also Interrupt(0):
	 * Arbitration Lost in Chapter 3.)"
	 *
	 * According to this, it should be okay to clear the master/slave mode
	 * select to clear a false start condition with a stop and regain
	 * arbitration over the bus.
	 */
    if ((StatusReg & XIIC_SR_BUS_BUSY_MASK) == XIIC_SR_BUS_BUSY_MASK)
    {
    	ControlReg = Xil_In8(pContext->CoreAddress + XIIC_CR_REG_OFFSET);
    	ControlReg = ControlReg & 0xFB;  // Clear the MSMS bit.
    	Xil_Out8(pContext->CoreAddress + XIIC_CR_REG_OFFSET, ControlReg);
    }
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
      SentByteCount = XIic_Send(pContext->CoreAddress, ChipAddress,
                                  (uint8_t *)&RegAddress, 1,
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
* This function directly reads a number of bytes from an IIC chip into a
* specified buffer without transmitting a register address byte.
*
* @param    ChipAddress contains the address of the IIC core.
* @param    RegAddress is ignored and not transmitted to the slave.
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
int zed_iic_axi_IicDRead(zed_iic_t *pIIC, uint8_t ChipAddress, uint8_t RegAddress,
                         uint8_t *pBuffer, uint8_t ByteCount)
{
    uint8_t ReceivedByteCount = 0;
    uint8_t SentByteCount = 0;
    uint8_t ControlReg;
    uint8_t StatusReg;
    int cnt = 0;
    zed_iic_axi_t *pContext = (zed_iic_axi_t *)(pIIC->pContext);

#if 1
    // Make sure all the Fifo's are cleared and Bus is Not busy.
    do
    {
        StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
        //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
        StatusReg = StatusReg & (XIIC_SR_RX_FIFO_EMPTY_MASK |
                                 XIIC_SR_TX_FIFO_EMPTY_MASK |
                                 XIIC_SR_BUS_BUSY_MASK);
        if ((StatusReg & XIIC_SR_RX_FIFO_EMPTY_MASK) != XIIC_SR_RX_FIFO_EMPTY_MASK)
        {
            /*
             * The RX buffer is not empty and it is assumed there is a stale
             * message in there.  Attempt to clear out the RX buffer, otherwise
             * this loop spins forever.
             */
            XIic_ReadReg(pContext->CoreAddress, XIIC_DRR_REG_OFFSET);
        }

        /*
         * Check to see if the bus is busy.  Since we are master, if the bus is
         * still busy that means that arbitration has been lost.
         *
         * According to Product Guide PG090, October 16, 2012:
         *
         * Control Register (0x100), Bit 2 MSMS:
         *
         * "Master/Slave Mode Select. When this bit is changed from 0 to 1,
         * the AXI IIC bus interface generates a START condition in master
         * mode. When this bit is cleared, a STOP condition is generated and
         * the AXI IIC bus interface switches to slave mode. When this bit is
         * cleared by the hardware, because arbitration for the bus has been
         * lost, a STOP condition is not generated. (See also Interrupt(0):
         * Arbitration Lost in Chapter 3.)"
         *
         * According to this, it should be okay to clear the master/slave mode
         * select to clear a false start condition with a stop and regain
         * arbitration over the bus.
         */
        if ((StatusReg & XIIC_SR_BUS_BUSY_MASK) == XIIC_SR_BUS_BUSY_MASK)
        {
            ControlReg = Xil_In8(pContext->CoreAddress + XIIC_CR_REG_OFFSET);
            ControlReg = ControlReg & 0xFB; // Clear the MSMS bit.
            Xil_Out8(pContext->CoreAddress + XIIC_CR_REG_OFFSET, ControlReg);
        }
    }
    while (StatusReg != (XIIC_SR_RX_FIFO_EMPTY_MASK |
                         XIIC_SR_TX_FIFO_EMPTY_MASK));
#endif

    // Position the Read pointer to specific location.
    do
    {
        StatusReg = Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET);
        //xil_printf("[%s] Xil_In8(pContext->CoreAddress + XIIC_SR_REG_OFFSET) => 0x%02X\n\r", pContext->szName, StatusReg );
        if (!(StatusReg & XIIC_SR_BUS_BUSY_MASK))
        {
            SentByteCount = XIic_DynSend(pContext->CoreAddress, ChipAddress,
                                         (uint8_t *)&RegAddress, 0,
                                         XIIC_REPEATED_START);
        }
        cnt++;
    }
    while (SentByteCount != 0 && (cnt < 100));

    // Receive the data.
    ReceivedByteCount = XIic_DynRecv(pContext->CoreAddress, ChipAddress, pBuffer,
                                     ByteCount);

    // Return the number of bytes received.
    return ReceivedByteCount;
}

#endif // defined(XPAR_XIIC_NUM_INSTANCES)

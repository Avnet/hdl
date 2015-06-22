#include "xaxivdma_ext.h"

/*****************************************************************************
******************************************************************************/
int     ReadSetup(XAxiVdma *InstancePtr, u32 BaseAddr, u32 PointNum,
          u32 EnableCircularBuf, u32 EnableSync, u32 HoriOffset, u32 VertOffset,
          u32 HoriSize, u32 VertSize, u32 HoriStride, u32 VertStride)
{
  int Index;
  int Status;
  int BlockOffset;

  XAxiVdma_DmaSetup ReadCfg;

  ReadCfg.VertSizeInput = VertSize;
  ReadCfg.HoriSizeInput = HoriSize * 2;           // Convert Pixels to Bytes

  ReadCfg.Stride = HoriStride * 2;                // Convert Pixels to Bytes
  ReadCfg.FrameDelay = 1;

  ReadCfg.EnableCircularBuf = EnableCircularBuf;
  ReadCfg.EnableSync = EnableSync;

  ReadCfg.PointNum = PointNum;
  ReadCfg.EnableFrameCounter = 0;

  ReadCfg.FixedFrameStoreAddr = 0;

  BlockOffset = (HoriStride * 2) * VertOffset;
  BlockOffset += (HoriOffset * 2);

  Status = XAxiVdma_DmaConfig(InstancePtr, XAXIVDMA_READ, &ReadCfg);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  /* Initialize buffer addresses
   *
   * These addresses are physical addresses
   */
  for(Index = 0; Index < 3; Index++) {
    ReadCfg.FrameStoreStartAddr[Index] = BaseAddr + BlockOffset;

    BaseAddr += HoriStride * 2 * VertStride;
  }

  /* Set the buffer addresses for transfer in the DMA engine
   * The buffer addresses are physical addresses
   */
  Status = XAxiVdma_DmaSetBufferAddr(InstancePtr, XAXIVDMA_READ, ReadCfg.FrameStoreStartAddr);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     WriteSetup(XAxiVdma * InstancePtr, u32 BaseAddr, u32 PointNum,
          u32 EnableCircularBuf, u32 EnableSync, u32 HoriOffset, u32 VertOffset,
          u32 HoriSize, u32 VertSize, u32 HoriStride, u32 VertStride)
{
  int Index;
  int Status;
  int BlockOffset;

  XAxiVdma_DmaSetup WriteCfg;

  WriteCfg.VertSizeInput = VertSize;
  WriteCfg.HoriSizeInput = HoriSize * 2;

  WriteCfg.Stride = HoriStride * 2;
  WriteCfg.FrameDelay = 1;

  WriteCfg.EnableCircularBuf = EnableCircularBuf;
  WriteCfg.EnableSync = EnableSync;

  WriteCfg.PointNum = PointNum;
  WriteCfg.EnableFrameCounter = 0;

  WriteCfg.FixedFrameStoreAddr = 0;

  BlockOffset = (HoriStride * 2) * VertOffset;
  BlockOffset += (HoriOffset * 2);

  Status = XAxiVdma_DmaConfig(InstancePtr, XAXIVDMA_WRITE, &WriteCfg);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  /* Initialize buffer addresses
   *
   * Use physical addresses
   */
  for(Index = 0; Index < 3; Index++) {
    WriteCfg.FrameStoreStartAddr[Index] = BaseAddr + BlockOffset;;

    BaseAddr += HoriStride * 2 * VertStride;
  }

  /* Set the buffer addresses for transfer in the DMA engine
   */
  Status = XAxiVdma_DmaSetBufferAddr(InstancePtr, XAXIVDMA_WRITE, WriteCfg.FrameStoreStartAddr);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StartWriteTransfer(XAxiVdma *InstancePtr)
{
  int Status;

  Status = XAxiVdma_DmaStart(InstancePtr, XAXIVDMA_WRITE);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StartReadTransfer(XAxiVdma *InstancePtr)
{
  int Status;

  Status = XAxiVdma_DmaStart(InstancePtr, XAXIVDMA_READ);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StartTransfer(XAxiVdma *InstancePtr)
{
  int Status;

  Status = StartWriteTransfer(InstancePtr);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  Status = StartReadTransfer(InstancePtr);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StopWriteTransfer(XAxiVdma *InstancePtr)
{
  XAxiVdma_DmaStop(InstancePtr, XAXIVDMA_WRITE);
  while (XAxiVdma_IsBusy(InstancePtr, XAXIVDMA_WRITE));

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StopReadTransfer(XAxiVdma *InstancePtr)
{
  XAxiVdma_DmaStop(InstancePtr, XAXIVDMA_READ );
  while (XAxiVdma_IsBusy(InstancePtr, XAXIVDMA_READ ));

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StopTransfer(XAxiVdma *InstancePtr)
{
  StopWriteTransfer(InstancePtr);
  StopReadTransfer(InstancePtr);
  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int vdma_dump_registers(XAxiVdma *InstancePtr)
{
   u32 uBaseAddr = InstancePtr->BaseAddr;

   // Partial Register Dump
   xil_printf( "AXI_VDMA - Partial Register Dump (uBaseAddr = 0x%08X):\n\r", uBaseAddr );
   xil_printf( "\t PARKPTR          = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_PARKPTR_OFFSET )) );
   xil_printf( "\t ----------------\n\r" );
   xil_printf( "\t S2MM_DMACR       = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_RX_OFFSET+XAXIVDMA_CR_OFFSET )) );
   xil_printf( "\t S2MM_DMASR       = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_RX_OFFSET+XAXIVDMA_SR_OFFSET )) );
   xil_printf( "\t S2MM_STRD_FRMDLY = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_S2MM_ADDR_OFFSET+XAXIVDMA_STRD_FRMDLY_OFFSET)) );
   xil_printf( "\t S2MM_START_ADDR0 = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_S2MM_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET+0)) );
   xil_printf( "\t S2MM_START_ADDR1 = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_S2MM_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET+4)) );
   xil_printf( "\t S2MM_START_ADDR2 = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_S2MM_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET+8)) );
   xil_printf( "\t S2MM_HSIZE       = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_S2MM_ADDR_OFFSET+XAXIVDMA_HSIZE_OFFSET)) );
   xil_printf( "\t S2MM_VSIZE       = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_S2MM_ADDR_OFFSET+XAXIVDMA_VSIZE_OFFSET)) );
   xil_printf( "\t ----------------\n\r" );
   xil_printf( "\t MM2S_DMACR       = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_TX_OFFSET+XAXIVDMA_CR_OFFSET )) );
   xil_printf( "\t MM2S_DMASR       = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_TX_OFFSET+XAXIVDMA_SR_OFFSET )) );
   xil_printf( "\t MM2S_STRD_FRMDLY = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_MM2S_ADDR_OFFSET+XAXIVDMA_STRD_FRMDLY_OFFSET)) );
   xil_printf( "\t MM2S_START_ADDR0 = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_MM2S_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET+0)) );
   xil_printf( "\t MM2S_START_ADDR1 = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_MM2S_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET+4)) );
   xil_printf( "\t MM2S_START_ADDR2 = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_MM2S_ADDR_OFFSET+XAXIVDMA_START_ADDR_OFFSET+8)) );
   xil_printf( "\t MM2S_HSIZE       = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_MM2S_ADDR_OFFSET+XAXIVDMA_HSIZE_OFFSET)) );
   xil_printf( "\t MM2S_VSIZE       = 0x%08X\n\r", *((volatile int *)(uBaseAddr+XAXIVDMA_MM2S_ADDR_OFFSET+XAXIVDMA_VSIZE_OFFSET)) );
   xil_printf( "\t ----------------\n\r" );
   xil_printf( "\t S2MM_HSIZE_STATUS= 0x%08X\n\r", *((volatile int *)(uBaseAddr+0xF0 )) );
   xil_printf( "\t S2MM_VSIZE_STATUS= 0x%08X\n\r", *((volatile int *)(uBaseAddr+0xF4 )) );
   xil_printf( "\t ----------------\n\r" );

   return 0;
}

/*****************************************************************************
******************************************************************************/
int vdma_check_errors(XAxiVdma *InstancePtr, u8 bClearErrors )
{
   u32 uBaseAddr = InstancePtr->BaseAddr;
   u32 inErrors;
   u32 outErrors;
   u32 Errors;

   // Get Status of Error Flags
   //inErrors = XAxiVdma_GetStatus(pAxiVdma, XAXIVDMA_WRITE) & XAXIVDMA_SR_ERR_ALL_MASK;
   //outErrors = XAxiVdma_GetStatus(pAxiVdma, XAXIVDMA_READ) & XAXIVDMA_SR_ERR_ALL_MASK;
   inErrors  = *((volatile int *)(uBaseAddr+XAXIVDMA_RX_OFFSET+XAXIVDMA_SR_OFFSET )) & 0x0000CFF0;
   outErrors = *((volatile int *)(uBaseAddr+XAXIVDMA_TX_OFFSET+XAXIVDMA_SR_OFFSET )) & 0x000046F0;
   xil_printf( "AXI_VDMA - Checking Error Flags\n\r" );

   Errors = (inErrors << 16) | (outErrors);

   if ( Errors )
   {
	   if ( inErrors & 0x00004000 )
	   {
          xil_printf( "\tS2MM_DMASR - ErrIrq\n\r" );
	   }
	   if ( inErrors & 0x00008000 )
	   {
          xil_printf( "\tS2MM_DMASR - EOLLateErr\n\r" );
	   }
	   if ( inErrors & 0x00000800 )
	   {
          xil_printf( "\tS2MM_DMASR - SOFLateErr\n\r" );
	   }
	   if ( inErrors & 0x00000400 )
	   {
          xil_printf( "\tS2MM_DMASR - SGDecErr\n\r" );
	   }
	   if ( inErrors & 0x00000200 )
	   {
          xil_printf( "\tS2MM_DMASR - SGSlvErr\n\r" );
	   }
	   if ( inErrors & 0x00000100 )
	   {
          xil_printf( "\tS2MM_DMASR - EOLEarlyErr\n\r" );
	   }
	   if ( inErrors & 0x00000080 )
	   {
          xil_printf( "\tS2MM_DMASR - SOFEarlyErr\n\r" );
	   }
	   if ( inErrors & 0x00000040 )
	   {
          xil_printf( "\tS2MM_DMASR - DMADecErr\n\r" );
	   }
	   if ( inErrors & 0x00000020 )
	   {
          xil_printf( "\tS2MM_DMASR - DMASlvErr\n\r" );
	   }
	   if ( inErrors & 0x00000010 )
	   {
          xil_printf( "\tS2MM_DMASR - DMAIntErr\n\r" );
	   }

	   if ( outErrors & 0x00004000 )
	   {
          xil_printf( "\tMM2S_DMASR - ErrIrq\n\r" );
	   }
	   if ( outErrors & 0x00000400 )
	   {
          xil_printf( "\tMM2S_DMASR - SGDecErr\n\r" );
	   }
	   if ( outErrors & 0x00000200 )
	   {
          xil_printf( "\tMM2S_DMASR - SGSlvErr\n\r" );
	   }
	   if ( outErrors & 0x00000080 )
	   {
          xil_printf( "\tMM2S_DMASR - SOFEarlyErr\n\r" );
	   }
	   if ( outErrors & 0x00000040 )
	   {
          xil_printf( "\tMM2S_DMASR - DMADecErr\n\r" );
	   }
	   if ( outErrors & 0x00000020 )
	   {
          xil_printf( "\tMM2S_DMASR - DMASlvErr\n\r" );
	   }
	   if ( outErrors & 0x00000010 )
	   {
          xil_printf( "\tMM2S_DMASR - DMAIntErr\n\r" );
	   }

	   // Clear error flags
	   xil_printf( "AXI_VDMA - Clearing Error Flags\n\r" );
	   *((volatile int *)(uBaseAddr+XAXIVDMA_RX_OFFSET+XAXIVDMA_SR_OFFSET )) = 0x0000CFF0; //XAXIVDMA_SR_ERR_ALL_MASK;
	   *((volatile int *)(uBaseAddr+XAXIVDMA_TX_OFFSET+XAXIVDMA_SR_OFFSET )) = 0x000046F0; //XAXIVDMA_SR_ERR_ALL_MASK;
   }

   return Errors;
}

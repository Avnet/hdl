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

#include "xaxivdma_ext.h"
#include "xaxivdma_hw.h"

/*****************************************************************************
******************************************************************************/
int     WaitFrameCntInterrupt(XAxiVdma *InstancePtr, u16 Direction)
{
	int status;
	XAxiVdma_Channel *Channel;

	Channel = XAxiVdma_GetChannel(InstancePtr, Direction);

	if (!Channel) {
		return XST_INVALID_PARAM;
	}


	if (Channel->IsValid) {
		do {
			status = XAxiVdma_ReadReg(Channel->ChanBase, XAXIVDMA_SR_OFFSET);
		} while ((status & 0x00001000) == 0);
	}
	else {
		return XST_DEVICE_NOT_FOUND;
	}

	return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     ReadSetup(XAxiVdma *InstancePtr, u32 BaseAddr, u32 PixelBytes, u32 PointNum,
          u32 EnableCircularBuf, u32 EnableSync, u32 HoriOffset, u32 VertOffset,
          u32 HoriSize, u32 VertSize, u32 HoriStride, u32 VertStride)
{
  int Index;
  int Status;
  int BlockOffset;

  XAxiVdma_DmaSetup ReadCfg;

  ReadCfg.VertSizeInput = VertSize;
  ReadCfg.HoriSizeInput = HoriSize * PixelBytes;           // Convert Pixels to Bytes

  ReadCfg.Stride = HoriStride * PixelBytes;                // Convert Pixels to Bytes
  ReadCfg.FrameDelay = 1;

  ReadCfg.EnableCircularBuf = EnableCircularBuf;
  ReadCfg.EnableSync = EnableSync;

  ReadCfg.PointNum = PointNum;
  ReadCfg.EnableFrameCounter = 0;

  ReadCfg.FixedFrameStoreAddr = 0;

  BlockOffset = (HoriStride * PixelBytes) * VertOffset;
  BlockOffset += (HoriOffset * PixelBytes);

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

    BaseAddr += HoriStride * PixelBytes * VertStride;
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
int     WriteSetup(XAxiVdma * InstancePtr, u32 BaseAddr, u32 PixelBytes, u32 PointNum,
          u32 EnableCircularBuf, u32 EnableSync, u32 HoriOffset, u32 VertOffset,
          u32 HoriSize, u32 VertSize, u32 HoriStride, u32 VertStride)
{
  int Index;
  int Status;
  int BlockOffset;

  XAxiVdma_DmaSetup WriteCfg;

  WriteCfg.VertSizeInput = VertSize;
  WriteCfg.HoriSizeInput = HoriSize * PixelBytes;

  WriteCfg.Stride = HoriStride * PixelBytes;
  WriteCfg.FrameDelay = 1;

  WriteCfg.EnableCircularBuf = EnableCircularBuf;
  WriteCfg.EnableSync = EnableSync;

  WriteCfg.PointNum = PointNum;
  WriteCfg.EnableFrameCounter = 0;

  WriteCfg.FixedFrameStoreAddr = 0;

  BlockOffset = (HoriStride * PixelBytes) * VertOffset;
  BlockOffset += (HoriOffset * PixelBytes);

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

    BaseAddr += HoriStride * PixelBytes * VertStride;
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
  XAxiVdma_Reset(InstancePtr, XAXIVDMA_WRITE);
  while (XAxiVdma_ResetNotDone(InstancePtr, XAXIVDMA_WRITE));

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StopReadTransfer(XAxiVdma *InstancePtr)
{
  XAxiVdma_Reset(InstancePtr, XAXIVDMA_READ );
  while (XAxiVdma_ResetNotDone(InstancePtr, XAXIVDMA_READ ));

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
int     StartWriteParking(XAxiVdma *InstancePtr)
{
  int Status;

  Status = XAxiVdma_StartParking(InstancePtr, 0, XAXIVDMA_WRITE);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StartReadParking(XAxiVdma *InstancePtr)
{
  int Status;

  Status = XAxiVdma_StartParking(InstancePtr, 0, XAXIVDMA_READ);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}

/*****************************************************************************
******************************************************************************/
int     StartParking(XAxiVdma *InstancePtr)
{
  int Status;

  Status = StartWriteParking(InstancePtr);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  Status = StartReadParking(InstancePtr);
  if (Status != XST_SUCCESS) {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}


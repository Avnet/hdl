#ifndef XAXIVDMA_EXT_H_
#define XAXIVDMA_EXT_H_

#include "xaxivdma.h"

int     ReadSetup(XAxiVdma *InstancePtr, u32 BaseAddr, u32 PointNum,
          u32 EnableCircularBuf, u32 EnableSync, u32 HoriOffset, u32 VertOffset,
          u32 HoriSize, u32 VertSize, u32 HoriStride, u32 VertStride);
int     WriteSetup(XAxiVdma * InstancePtr, u32 BaseAddr, u32 PointNum,
          u32 EnableCircularBuf, u32 EnableSync, u32 HoriOffset, u32 VertOffset,
          u32 HoriSize, u32 VertSize, u32 HoriStride, u32 VertStride);

int     StartReadTransfer(XAxiVdma *InstancePtr);
int     StartWriteTransfer(XAxiVdma *InstancePtr);
int     StartTransfer(XAxiVdma *InstancePtr);

int     StopReadTransfer(XAxiVdma *InstancePtr);
int     StopWriteTransfer(XAxiVdma *InstancePtr);
int     StopTransfer(XAxiVdma *InstancePtr);

#endif /* XAXIVDMA_EXT_H_ */

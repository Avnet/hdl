#ifndef IICPS_EXT_H_
#define IICPS_EXT_H_

#include "xstatus.h"
#include "xiicps.h"
#include <stdio.h>
#define BUF_SIZE 2
#define	SLEEP_TIME 10000

//#ifndef XIICPS_REP_START_OPTION
//#define XIICPS_REP_START_OPTION 0x08
//#endif

int XIicPs_Write(XIicPs *IicPs, u8 ChipAddress, u8 RegAddress, u8 *pBuffer, u8 ByteCount);
int XIicPs_Read(XIicPs *IicPs, u8 ChipAddress, u8 RegAddress, u8 *pBuffer, u8 ByteCount);
int XIicPs_A16_Write(XIicPs *IicPs, u8 ChipAddress, u16 RegAddress, u8 *pBuffer, u8 ByteCount);
int XIicPs_A16_Read(XIicPs *IicPs, u8 ChipAddress, u16 RegAddress, u8 *pBuffer, u8 ByteCount);

#endif /* IICPS_EXT_H_ */

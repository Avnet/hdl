#include "xiicps_ext.h"
#include <stdio.h>

int XIicPs_Write(XIicPs *IicPs, u8 ChipAddress, u8 RegAddress, u8 *pBuffer,
		u8 ByteCount) {
	u8 WriteBuffer[BUF_SIZE + 1];
	u8 Index;
	int Status;

	//xil_printf("[%04x:%04x] => %04x\r\n", ChipAddress, RegAddress, pBuffer[0]);

	/*
	 * A temporary write buffer must be used which contains both the address
	 * and the data to be written, put the address in first
	 */
	WriteBuffer[0] = RegAddress;

	/*
	 * Put the data in the write buffer following the address.
	 */
	for (Index = 0; Index < ByteCount; Index++) {
		WriteBuffer[Index + 1] = pBuffer[Index];
	}

	/*
	 * Wait until bus is idle to start another transfer.
	 */
	while (XIicPs_BusIsBusy(IicPs)) {
		/* NOP */
	}

	/*
	 * Send the buffer using the IIC and check for errors.
	 */
	Status = XIicPs_MasterSendPolled(IicPs, WriteBuffer, ByteCount + 1,
			ChipAddress);
	if (Status != XST_SUCCESS) {
		printf("XIicPs_MasterSendPolled error!\n\r");
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int XIicPs_Read(XIicPs *IicPs, u8 ChipAddress, u8 RegAddress, u8 *pBuffer,
		u8 ByteCount) {
	int Status;

	/*
	 * Read Preparation
	 */
	XIicPs_SetOptions(IicPs, XIICPS_REP_START_OPTION);
	XIicPs_Write(IicPs, ChipAddress, RegAddress, NULL, 0);

	/*
	 * Wait until bus is idle to start another transfer.
	 */

	Status = XIicPs_GetOptions(IicPs);

	while (XIicPs_BusIsBusy(IicPs) && !(Status && XIICPS_REP_START_OPTION)) {
		/* NOP */
	}

	/*
	 * Receive the data.
	 */
	Status = XIicPs_MasterRecvPolled(IicPs, pBuffer, ByteCount, ChipAddress);
	if (Status != XST_SUCCESS) {
		printf("XIicPs_MasterRecvPolled error!\n\r");
		return XST_FAILURE;
	}

	XIicPs_ClearOptions(IicPs, XIICPS_REP_START_OPTION);

	return XST_SUCCESS;
}

int XIicPs_A16_WriteImm(XIicPs *IicPs, u8 ChipAddress, u16 RegAddress, u8 RegData) {
	u8 status = RegData;

	XIicPs_A16_Write(IicPs, ChipAddress, RegAddress, &status, 1);
}

int XIicPs_A16_Write(XIicPs *IicPs, u8 ChipAddress, u16 RegAddress, u8 *pBuffer,
		u8 ByteCount) {
	u8 WriteBuffer[BUF_SIZE + 1];
	u8 Index;
	int Status;

	//xil_printf("[%04x:%04x] => %04x\r\n", ChipAddress, RegAddress, pBuffer[0]);

	/*
	 * A temporary write buffer must be used which contains both the address
	 * and the data to be written, put the address in first
	 */
	WriteBuffer[0] = (RegAddress & 0xFF00) >> 8;
	WriteBuffer[1] = (RegAddress & 0x00FF) >> 0;

	/*
	 * Put the data in the write buffer following the address.
	 */
	for (Index = 0; Index < ByteCount; Index++) {
		WriteBuffer[Index + 2] = pBuffer[Index];
	}

	/*
	 * Wait until bus is idle to start another transfer.
	 */
	while (XIicPs_BusIsBusy(IicPs)) {
		/* NOP */
	}

	/*
	 * Send the buffer using the IIC and check for errors.
	 */
	Status = XIicPs_MasterSendPolled(IicPs, WriteBuffer, ByteCount + 2,
			ChipAddress);
	if (Status != XST_SUCCESS) {
		printf("XIicPs_MasterSendPolled error!\n\r");
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}


int XIicPs_A16_Read(XIicPs *IicPs, u8 ChipAddress, u16 RegAddress, u8 *pBuffer,
		u8 ByteCount) {
	int Status;

	/*
	 * Read Preparation
	 */
	XIicPs_SetOptions(IicPs, XIICPS_REP_START_OPTION);
	XIicPs_A16_Write(IicPs, ChipAddress, RegAddress, NULL, 0);

	/*
	 * Wait until bus is idle to start another transfer.
	 */

	Status = XIicPs_GetOptions(IicPs);

	while (XIicPs_BusIsBusy(IicPs) && !(Status && 0x08)) {
		/* NOP */
	}

	/*
	 * Receive the data.
	 */
	Status = XIicPs_MasterRecvPolled(IicPs, pBuffer, ByteCount, ChipAddress);
	if (Status != XST_SUCCESS) {
		printf("XIicPs_MasterRecvPolled error!\n\r");
		return XST_FAILURE;
	}

	XIicPs_ClearOptions(IicPs, XIICPS_REP_START_OPTION);

	return XST_SUCCESS;
}


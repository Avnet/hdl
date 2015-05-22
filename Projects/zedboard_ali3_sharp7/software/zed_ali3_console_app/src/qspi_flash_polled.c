//----------------------------------------------------------------------------
//      _____
//     *     *
//    *____   *____
//   * *===*   *==*
//  *___*===*___**  AVNET
//       *======*
//        *====*
//----------------------------------------------------------------------------
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
//                     Copyright(c) 2013 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Jun 06, 2013
// Design Name:         QSPI Flash Polled Interface
// Module Name:         qspi_flash_polled.c
// Project Name:        Avnet Touch Panel
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        ZedBoard, Zed Display Kit
//
// Tool versions:       ISE 14.5
//
// Description:         Implementation for interface to ZedBoard QSPI flash
//                      storage.  Adapted from Xilinx example code found in
//                      xqspips_flash_polled_example.c
//
// Dependencies:
//
// Revision:            Jun 06, 2013: 1.00 Created for Zed Display Kit
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "zed_ali3_controller_demo.h"
#include "types.h"
#include "qspi_flash_polled.h"

/************************** Variable Definitions *****************************/

/*
 * The instances to support the device drivers are global such that they
 * are initialized to zero each time the program runs. They could be local
 * but should at least be static so they are zeroed.
 */
static XQspiPs QspiInstance;

/*
 * The following variable allows a test value to be added to the values that
 * are written to the FLASH such that unique values can be generated to
 * guarantee the writes to the FLASH were successful
 */
int Test = 5;

/*
 * The following variables are used to read and write to the QSPI Flash and
 * they are global to avoid having large buffers on the stack
 */
u8 qspi_read_buffer[MAX_TEST_DATA + DATA_OFFSET + DUMMY_SIZE];
u8 qspi_write_buffer[PAGE_SIZE + DATA_OFFSET];

/*****************************************************************************
*
* The purpose of this function is to illustrate how to use the XQspiPs
* device driver in polled mode. This function writes and reads data
* from a serial FLASH.
*
* @param	None.
*
* @return	XST_SUCCESS if successful, else XST_FAILURE.
*
* @note		None.
*
*****************************************************************************/
int qspi_flash_polled_init(void)
{
    int Status;
    u8 *BufferPtr;
    u8 UniqueValue;
    int Count;
    int Page;
    XQspiPs_Config *QspiConfig;

    /*
     * Initialize the QSPI driver so that it's ready to use
     */
    QspiConfig = XQspiPs_LookupConfig(QSPI_DEVICE_ID);
    if (NULL == QspiConfig)
    {
        xil_printf("QSPI Error:  Problem during LookupConfig(), check to see the QSPI is enabled.\n\r");
        return XST_FAILURE;
    }

    Status = XQspiPs_CfgInitialize(&QspiInstance, QspiConfig, QspiConfig->BaseAddress);
    if (Status != XST_SUCCESS)
    {
        xil_printf("QSPI Error:  Problem during CfgInitialize(), check to see the QSPI driver is built.\n\r");
        return XST_FAILURE;
    }

    /*
     * Perform a self-test to check hardware build
     */
    Status = XQspiPs_SelfTest(&QspiInstance);
    if (Status != XST_SUCCESS)
    {
        xil_printf("QSPI Error:  Problem during SelfTest(), check to see that QSPI is alive.\n\r");
        return XST_FAILURE;
    }

    /*
     * Initialize the write buffer for a pattern to write to the FLASH
     * and the read buffer to zero so it can be verified after the read,
     * the test value that is added to the unique value allows the value
     * to be changed in a debug environment to guarantee
     */
    for (UniqueValue = UNIQUE_VALUE, Count = 0; Count < PAGE_SIZE; Count++, UniqueValue++)
    {
        qspi_write_buffer[DATA_OFFSET + Count] = (u8)(UniqueValue + Test);
    }
    memset(qspi_read_buffer, 0x00, sizeof(qspi_read_buffer));

    /*
     * Set Manual Start and Manual Chip select options and drive HOLD_B
     * pin high.
     */
    XQspiPs_SetOptions(&QspiInstance, XQSPIPS_MANUAL_START_OPTION |
                       XQSPIPS_FORCE_SSELECT_OPTION |
                       XQSPIPS_HOLD_B_DRIVE_OPTION);

    /*
     * Set the pre-scaler for QSPI clock
     */
    XQspiPs_SetClkPrescaler(&QspiInstance, XQSPIPS_CLK_PRESCALE_8);

    /*
     * Assert the FLASH chip select.
     */
    XQspiPs_SetSlaveSelect(&QspiInstance);

    /* Read the QSPI flash ID. */
    qspi_flash_read_id();

    /*
     * Erase the flash.
     */
    qspi_flash_erase(&QspiInstance, TEST_ADDRESS, MAX_TEST_DATA);

    /*
     * Write the data in the write buffer to the serial FLASH a page at a
     * time, starting from TEST_ADDRESS
     */
    for (Page = 0; Page < PAGE_COUNT; Page++)
    {
        qspi_flash_write(&QspiInstance, (Page * PAGE_SIZE) + TEST_ADDRESS,
                         PAGE_SIZE, QSPI_WRITE_CMD);
    }

    /*
     * Read the contents of the FLASH from TEST_ADDRESS, using Normal Read
     * command. Change the prescaler as the READ command operates at a
     * lower frequency.
     */
    qspi_flash_read(&QspiInstance, TEST_ADDRESS, MAX_TEST_DATA, QSPI_READ_CMD);

    /*
     * Setup a pointer to the start of the data that was read into the read
     * buffer and verify the data read is the data that was written
     */
    BufferPtr = &qspi_read_buffer[DATA_OFFSET];

    for (UniqueValue = UNIQUE_VALUE, Count = 0; Count < MAX_TEST_DATA; Count++, UniqueValue++)
    {
        if (BufferPtr[Count] != (u8)(UniqueValue + Test))
        {
            xil_printf("QSPI Error:  Problem during Normal Read, check to see that QSPI supports Normal Read.\n\r");
            return XST_FAILURE;
        }
    }

    return 0;
}

int qspi_flash_load_calibration_data(zed_ali3_controller_demo_t *pDemo)
{
	int index;
	int8u packed_byte1;
	int8u packed_byte2;
	int8u packed_byte3;
	int8u packed_byte4;
	int32u packed_word;
	u8 *BufferPtr;
	XQspiPs_Config *QspiConfig;

	/*
	 * Initialize the QSPI driver so that it's ready to use
	 */
	QspiConfig = XQspiPs_LookupConfig(QSPI_DEVICE_ID);
	if (NULL == QspiConfig) {
		return XST_FAILURE;
	}

	/*
	 * Clear any existing data out of the read buffer.
	 */
	memset(qspi_read_buffer, 0x00, sizeof(qspi_read_buffer));

	/*
	 * Set Manual Start and Manual Chip select options and drive HOLD_B
	 * pin high.
	 */
	XQspiPs_SetOptions(&QspiInstance, XQSPIPS_MANUAL_START_OPTION |
			XQSPIPS_FORCE_SSELECT_OPTION |
			XQSPIPS_HOLD_B_DRIVE_OPTION);

	/*
	 * Set the prescaler for QSPI clock
	 */
	XQspiPs_SetClkPrescaler(&QspiInstance, XQSPIPS_CLK_PRESCALE_8);

	/*
	 * Assert the FLASH chip select.
	 */
	XQspiPs_SetSlaveSelect(&QspiInstance);

	/*
	 * Read the contents of the FLASH from TEST_ADDRESS, using Normal Read
	 * command. Change the prescaler as the READ command operates at a
	 * lower frequency.
	 */
	qspi_flash_read(&QspiInstance, CALIBRATION_ADDRESS, CALIBRATION_LENGTH, QSPI_READ_CMD);

	/*
	 * Setup a pointer to the start of the data that was read into the read
	 * buffer and verify the data read is the data that was written
	 */
	BufferPtr = &qspi_read_buffer[DATA_OFFSET];

	/*
	 * Start unpacking data words from the read buffer.
	 */
	index = 0;

	/*
	 * Get the magic word and see if it is valid.
	 */
	packed_byte1 = BufferPtr[index++];
	packed_byte2 = BufferPtr[index++];
	packed_byte3 = BufferPtr[index++];
	packed_byte4 = BufferPtr[index++];
	packed_word = (packed_byte1 << 24) + (packed_byte2 << 16) + (packed_byte3 << 8) + packed_byte4;

	if (packed_word != AVNET_MAGIC_WORD)
	{
		xil_printf("BAD MAGIC WORD, No Calibration Data found in Flash 0x%x\n\r", packed_word);
		return -1;
	}

	/*
	 * Get the calibration An coefficient.
	 */
	packed_byte1 = BufferPtr[index++];
	packed_byte2 = BufferPtr[index++];
	packed_byte3 = BufferPtr[index++];
	packed_byte4 = BufferPtr[index++];
	packed_word = (packed_byte1 << 24) + (packed_byte2 << 16) + (packed_byte3 << 8) + packed_byte4;
	pDemo->calibration_An = (int32s) packed_word;

	/*
	 * Get the calibration Bn coefficient.
	 */
	packed_byte1 = BufferPtr[index++];
	packed_byte2 = BufferPtr[index++];
	packed_byte3 = BufferPtr[index++];
	packed_byte4 = BufferPtr[index++];
	packed_word = (packed_byte1 << 24) + (packed_byte2 << 16) + (packed_byte3 << 8) + packed_byte4;
	pDemo->calibration_Bn = (int32s) packed_word;

	/*
	 * Get the calibration Cn coefficient.
	 */
	packed_byte1 = BufferPtr[index++];
	packed_byte2 = BufferPtr[index++];
	packed_byte3 = BufferPtr[index++];
	packed_byte4 = BufferPtr[index++];
	packed_word = (packed_byte1 << 24) + (packed_byte2 << 16) + (packed_byte3 << 8) + packed_byte4;
	pDemo->calibration_Cn = (int32s) packed_word;

	/*
	 * Get the calibration Dn coefficient.
	 */
	packed_byte1 = BufferPtr[index++];
	packed_byte2 = BufferPtr[index++];
	packed_byte3 = BufferPtr[index++];
	packed_byte4 = BufferPtr[index++];
	packed_word = (packed_byte1 << 24) + (packed_byte2 << 16) + (packed_byte3 << 8) + packed_byte4;
	pDemo->calibration_Dn = (int32s) packed_word;

	/*
	 * Get the calibration En coefficient.
	 */
	packed_byte1 = BufferPtr[index++];
	packed_byte2 = BufferPtr[index++];
	packed_byte3 = BufferPtr[index++];
	packed_byte4 = BufferPtr[index++];
	packed_word = (packed_byte1 << 24) + (packed_byte2 << 16) + (packed_byte3 << 8) + packed_byte4;
	pDemo->calibration_En = (int32s) packed_word;

	/*
	 * Get the calibration Fn coefficient.
	 */
	packed_byte1 = BufferPtr[index++];
	packed_byte2 = BufferPtr[index++];
	packed_byte3 = BufferPtr[index++];
	packed_byte4 = BufferPtr[index++];
	packed_word = (packed_byte1 << 24) + (packed_byte2 << 16) + (packed_byte3 << 8) + packed_byte4;
	pDemo->calibration_Fn = (int32s) packed_word;

	/*
	 * Get the calibration divisor.
	 */
	packed_byte1 = BufferPtr[index++];
	packed_byte2 = BufferPtr[index++];
	packed_byte3 = BufferPtr[index++];
	packed_byte4 = BufferPtr[index++];
	packed_word = (packed_byte1 << 24) + (packed_byte2 << 16) + (packed_byte3 << 8) + packed_byte4;
	pDemo->calibration_divisor = (int32s) packed_word;

	return 0;
}

int qspi_flash_store_calibration_data(zed_ali3_controller_demo_t *pDemo)
{
	int8u packed_byte1;
	int8u packed_byte2;
	int8u packed_byte3;
	int8u packed_byte4;
	int32u packed_word;
	int index;
	XQspiPs_Config *QspiConfig;

	/*
	 * Initialize the QSPI driver so that it's ready to use
	 */
	QspiConfig = XQspiPs_LookupConfig(QSPI_DEVICE_ID);
	if (NULL == QspiConfig) {
		return XST_FAILURE;
	}

	/*
	 * Initialize the write buffer with the magic word and the calibration
	 * coefficients.
	 */
	index = DATA_OFFSET;

	/*
	 * Store the magic word to create a valid calibration data set in flash
	 * memory.
	 */
	packed_word = AVNET_MAGIC_WORD;
	packed_byte1 = (int8u) (packed_word >> 24);
	qspi_write_buffer[index++] = packed_byte1;
	packed_byte2 = (int8u) (packed_word >> 16);
	qspi_write_buffer[index++] = packed_byte2;
	packed_byte3 = (int8u) (packed_word >> 8);
	qspi_write_buffer[index++] = packed_byte3;
	packed_byte4 = (int8u) packed_word;
	qspi_write_buffer[index++] = packed_byte4;

	/*
	 * Store the calibration An coefficient.
	 */
	packed_word = (int32u) pDemo->calibration_An;
	packed_byte1 = (int8u) (packed_word >> 24);
	qspi_write_buffer[index++] = packed_byte1;
	packed_byte2 = (int8u) (packed_word >> 16);
	qspi_write_buffer[index++] = packed_byte2;
	packed_byte3 = (int8u) (packed_word >> 8);
	qspi_write_buffer[index++] = packed_byte3;
	packed_byte4 = (int8u) packed_word;
	qspi_write_buffer[index++] = packed_byte4;

	/*
	 * Store the calibration Bn coefficient.
	 */
	packed_word = (int32u) pDemo->calibration_Bn;
	packed_byte1 = (int8u) (packed_word >> 24);
	qspi_write_buffer[index++] = packed_byte1;
	packed_byte2 = (int8u) (packed_word >> 16);
	qspi_write_buffer[index++] = packed_byte2;
	packed_byte3 = (int8u) (packed_word >> 8);
	qspi_write_buffer[index++] = packed_byte3;
	packed_byte4 = (int8u) packed_word;
	qspi_write_buffer[index++] = packed_byte4;

	/*
	 * Store the calibration Cn coefficient.
	 */
	packed_word = (int32u) pDemo->calibration_Cn;
	packed_byte1 = (int8u) (packed_word >> 24);
	qspi_write_buffer[index++] = packed_byte1;
	packed_byte2 = (int8u) (packed_word >> 16);
	qspi_write_buffer[index++] = packed_byte2;
	packed_byte3 = (int8u) (packed_word >> 8);
	qspi_write_buffer[index++] = packed_byte3;
	packed_byte4 = (int8u) packed_word;
	qspi_write_buffer[index++] = packed_byte4;

	/*
	 * Store the calibration Dn coefficient.
	 */
	packed_word = (int32u) pDemo->calibration_Dn;
	packed_byte1 = (int8u) (packed_word >> 24);
	qspi_write_buffer[index++] = packed_byte1;
	packed_byte2 = (int8u) (packed_word >> 16);
	qspi_write_buffer[index++] = packed_byte2;
	packed_byte3 = (int8u) (packed_word >> 8);
	qspi_write_buffer[index++] = packed_byte3;
	packed_byte4 = (int8u) packed_word;
	qspi_write_buffer[index++] = packed_byte4;

	/*
	 * Store the calibration En coefficient.
	 */
	packed_word = (int32u) pDemo->calibration_En;
	packed_byte1 = (int8u) (packed_word >> 24);
	qspi_write_buffer[index++] = packed_byte1;
	packed_byte2 = (int8u) (packed_word >> 16);
	qspi_write_buffer[index++] = packed_byte2;
	packed_byte3 = (int8u) (packed_word >> 8);
	qspi_write_buffer[index++] = packed_byte3;
	packed_byte4 = (int8u) packed_word;
	qspi_write_buffer[index++] = packed_byte4;

	/*
	 * Store the calibration Fn coefficient.
	 */
	packed_word = (int32u) pDemo->calibration_Fn;
	packed_byte1 = (int8u) (packed_word >> 24);
	qspi_write_buffer[index++] = packed_byte1;
	packed_byte2 = (int8u) (packed_word >> 16);
	qspi_write_buffer[index++] = packed_byte2;
	packed_byte3 = (int8u) (packed_word >> 8);
	qspi_write_buffer[index++] = packed_byte3;
	packed_byte4 = (int8u) packed_word;
	qspi_write_buffer[index++] = packed_byte4;

	/*
	 * Store the calibration divisor.
	 */
	packed_word = (int32u) pDemo->calibration_divisor;
	packed_byte1 = (int8u) (packed_word >> 24);
	qspi_write_buffer[index++] = packed_byte1;
	packed_byte2 = (int8u) (packed_word >> 16);
	qspi_write_buffer[index++] = packed_byte2;
	packed_byte3 = (int8u) (packed_word >> 8);
	qspi_write_buffer[index++] = packed_byte3;
	packed_byte4 = (int8u) packed_word;
	qspi_write_buffer[index++] = packed_byte4;

	/*
	 * Clear the read buffer so that the data can be read back.
	 */
	memset(qspi_read_buffer, 0x00, sizeof(qspi_read_buffer));

	/*
	 * Set Manual Start and Manual Chip select options and drive HOLD_B
	 * pin high.
	 */
	XQspiPs_SetOptions(&QspiInstance, XQSPIPS_MANUAL_START_OPTION |
			XQSPIPS_FORCE_SSELECT_OPTION |
			XQSPIPS_HOLD_B_DRIVE_OPTION);

	/*
	 * Set the prescaler for QSPI clock
	 */
	XQspiPs_SetClkPrescaler(&QspiInstance, XQSPIPS_CLK_PRESCALE_8);

	/*
	 * Assert the FLASH chip select.
	 */
	XQspiPs_SetSlaveSelect(&QspiInstance);

	/*
	 * Erase the flash.
	 */
	qspi_flash_erase(&QspiInstance, CALIBRATION_ADDRESS, PAGE_SIZE);

	/*
	 * Write the data in the write buffer to the serial FLASH starting
	 * from CALIBRATION_ADDRESS.
	 */
	qspi_flash_write(&QspiInstance, CALIBRATION_ADDRESS, PAGE_SIZE, QSPI_WRITE_CMD);

	/*
	 * Read the contents of the FLASH from TEST_ADDRESS, using Normal Read
	 * command. Change the prescaler as the READ command operates at a
	 * lower frequency.
	 */
	qspi_flash_read(&QspiInstance, CALIBRATION_ADDRESS, PAGE_SIZE, QSPI_READ_CMD);

	/*
	 * Setup a pointer to the start of the data that was read into the read
	 * buffer and verify the data read is the data that was written
	 */
	for (index = DATA_OFFSET; index < (CALIBRATION_LENGTH + DATA_OFFSET); index++)
	{
		if (qspi_read_buffer[index] != qspi_write_buffer[index])
		{
			return XST_FAILURE;
		}
	}

	return 0;
}

/******************************************************************************
*
*
* This function writes to the  serial FLASH connected to the QSPI interface.
* The FLASH contains a 256 byte write buffer which can be filled and then a
* write is automatically performed by the device.  All the data put into the
* buffer must be in the same page of the device with page boundaries being on
* 256 byte boundaries.
*
* @param	QspiPtr is a pointer to the QSPI driver component to use.
* @param	Address contains the address to write data to in the FLASH.
* @param	ByteCount contains the number of bytes to write.
* @param	Command is the command used to write data to the flash. QSPI
*		device supports only Page Program command to write data to the
*		flash.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void qspi_flash_write(XQspiPs *QspiPtr, u32 Address, u32 ByteCount, u8 Command)
{
	u8 WriteEnableCmd = { QSPI_WRITE_ENABLE_CMD };
	u8 ReadStatusCmd[] = { QSPI_READ_STATUS_CMD, 0 };  /* must send 2 bytes */
	u8 FlashStatus[2];

	/*
	 * Send the write enable command to the FLASH so that it can be
	 * written to, this needs to be sent as a seperate transfer before
	 * the write
	 */
	XQspiPs_PolledTransfer(QspiPtr, &WriteEnableCmd, NULL,
				sizeof(WriteEnableCmd));


	/*
	 * Setup the write command with the specified address and data for the
	 * FLASH
	 */
	qspi_write_buffer[COMMAND_OFFSET]   = Command;
	qspi_write_buffer[ADDRESS_1_OFFSET] = (u8)((Address & 0xFF0000) >> 16);
	qspi_write_buffer[ADDRESS_2_OFFSET] = (u8)((Address & 0xFF00) >> 8);
	qspi_write_buffer[ADDRESS_3_OFFSET] = (u8)(Address & 0xFF);

	/*
	 * Send the write command, address, and data to the FLASH to be
	 * written, no receive buffer is specified since there is nothing to
	 * receive
	 */
	XQspiPs_PolledTransfer(QspiPtr, qspi_write_buffer, NULL,
				ByteCount + OVERHEAD_SIZE);

	/*
	 * Wait for the write command to the FLASH to be completed, it takes
	 * some time for the data to be written
	 */
	while (1) {
		/*
		 * Poll the status register of the FLASH to determine when it
		 * completes, by sending a read status command and receiving the
		 * status byte
		 */
		XQspiPs_PolledTransfer(QspiPtr, ReadStatusCmd, FlashStatus,
					sizeof(ReadStatusCmd));

		/*
		 * If the status indicates the write is done, then stop waiting,
		 * if a value of 0xFF in the status byte is read from the
		 * device and this loop never exits, the device slave select is
		 * possibly incorrect such that the device status is not being
		 * read
		 */
		if ((FlashStatus[1] & 0x01) == 0) {
			break;
		}
	}
}

/******************************************************************************
*
* This function reads from the  serial FLASH connected to the
* QSPI interface.
*
* @param	QspiPtr is a pointer to the QSPI driver component to use.
* @param	Address contains the address to read data from in the FLASH.
* @param	ByteCount contains the number of bytes to read.
* @param	Command is the command used to read data from the flash. QSPI
*		device supports one of the Read, Fast Read, Dual Read and Fast
*		Read commands to read data from the flash.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void qspi_flash_read(XQspiPs *QspiPtr, u32 Address, u32 ByteCount, u8 Command)
{
	/*
	 * Setup the write command with the specified address and data for the
	 * FLASH
	 */
	qspi_write_buffer[COMMAND_OFFSET]   = Command;
	qspi_write_buffer[ADDRESS_1_OFFSET] = (u8)((Address & 0xFF0000) >> 16);
	qspi_write_buffer[ADDRESS_2_OFFSET] = (u8)((Address & 0xFF00) >> 8);
	qspi_write_buffer[ADDRESS_3_OFFSET] = (u8)(Address & 0xFF);

	if ((Command == QSPI_FAST_READ_CMD) || (Command == QSPI_DUAL_READ_CMD) ||
	    (Command == QSPI_QUAD_READ_CMD)) {
		ByteCount += DUMMY_SIZE;
	}
	/*
	 * Send the read command to the FLASH to read the specified number
	 * of bytes from the FLASH, send the read command and address and
	 * receive the specified number of bytes of data in the data buffer
	 */
	XQspiPs_PolledTransfer(QspiPtr, qspi_write_buffer, qspi_read_buffer,
				ByteCount + OVERHEAD_SIZE);
}

/******************************************************************************
*
*
* This function erases the sectors in the  serial FLASH connected to the
* QSPI interface.
*
* @param	QspiPtr is a pointer to the QSPI driver component to use.
* @param	Address contains the address of the first sector which needs to
*		be erased.
* @param	ByteCount contains the total size to be erased.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
void qspi_flash_erase(XQspiPs *QspiPtr, u32 Address, u32 ByteCount)
{
	u8 WriteEnableCmd = { QSPI_WRITE_ENABLE_CMD };
	u8 ReadStatusCmd[] = { QSPI_READ_STATUS_CMD, 0 };  /* must send 2 bytes */
	u8 FlashStatus[2];
	int Sector;

	/*
	 * If erase size is same as the total size of the flash, use bulk erase
	 * command
	 */
	if (ByteCount == (NUM_SECTORS * SECTOR_SIZE)) {
		/*
		 * Send the write enable command to the FLASH so that it can be
		 * written to, this needs to be sent as a seperate transfer
		 * before the erase
		 */
		XQspiPs_PolledTransfer(QspiPtr, &WriteEnableCmd, NULL,
				  sizeof(WriteEnableCmd));

		/*
		 * Setup the bulk erase command
		 */
		qspi_write_buffer[COMMAND_OFFSET]   = QSPI_BULK_ERASE_CMD;

		/*
		 * Send the bulk erase command; no receive buffer is specified
		 * since there is nothing to receive
		 */
		XQspiPs_PolledTransfer(QspiPtr, qspi_write_buffer, NULL,
					BULK_ERASE_SIZE);

		/*
		 * Wait for the erase command to the FLASH to be completed
		 */
		while (1) {
			/*
			 * Poll the status register of the device to determine
			 * when it completes, by sending a read status command
			 * and receiving the status byte
			 */
			XQspiPs_PolledTransfer(QspiPtr, ReadStatusCmd,
						FlashStatus,
						sizeof(ReadStatusCmd));

			/*
			 * If the status indicates the write is done, then stop
			 * waiting; if a value of 0xFF in the status byte is
			 * read from the device and this loop never exits, the
			 * device slave select is possibly incorrect such that
			 * the device status is not being read
			 */
			if ((FlashStatus[1] & 0x01) == 0) {
				break;
			}
		}

		return;
	}

	/*
	 * If the erase size is less than the total size of the flash, use
	 * sector erase command
	 */
	for (Sector = 0; Sector < ((ByteCount / SECTOR_SIZE) + 1); Sector++) {
		/*
		 * Send the write enable command to the SEEPOM so that it can be
		 * written to, this needs to be sent as a seperate transfer
		 * before the write
		 */
		XQspiPs_PolledTransfer(QspiPtr, &WriteEnableCmd, NULL,
					sizeof(WriteEnableCmd));

		/*
		 * Setup the write command with the specified address and data
		 * for the FLASH
		 */
		qspi_write_buffer[COMMAND_OFFSET]   = QSPI_SEC_ERASE_CMD;
		qspi_write_buffer[ADDRESS_1_OFFSET] = (u8)(Address >> 16);
		qspi_write_buffer[ADDRESS_2_OFFSET] = (u8)(Address >> 8);
		qspi_write_buffer[ADDRESS_3_OFFSET] = (u8)(Address & 0xFF);

		/*
		 * Send the sector erase command and address; no receive buffer
		 * is specified since there is nothing to receive
		 */
		XQspiPs_PolledTransfer(QspiPtr, qspi_write_buffer, NULL,
					SEC_ERASE_SIZE);

		/*
		 * Wait for the sector erse command to the FLASH to be completed
		 */
		while (1) {
			/*
			 * Poll the status register of the device to determine
			 * when it completes, by sending a read status command
			 * and receiving the status byte
			 */
			XQspiPs_PolledTransfer(QspiPtr, ReadStatusCmd,
						FlashStatus,
						sizeof(ReadStatusCmd));

			/*
			 * If the status indicates the write is done, then stop
			 * waiting, if a value of 0xFF in the status byte is
			 * read from the device and this loop never exits, the
			 * device slave select is possibly incorrect such that
			 * the device status is not being read
			 */
			if ((FlashStatus[1] & 0x01) == 0) {
				break;
			}
		}

		Address += SECTOR_SIZE;
	}
}

/******************************************************************************
*
* This function reads serial FLASH ID connected to the SPI interface.
*
* @param	None.
*
* @return	XST_SUCCESS if read id, otherwise XST_FAILURE.
*
* @note		None.
*
******************************************************************************/
int qspi_flash_read_id(void)
{
	int Status;

	/*
	 * Read ID in Auto mode.
	 */
	qspi_write_buffer[COMMAND_OFFSET]   = QSPI_READ_ID;
	qspi_write_buffer[ADDRESS_1_OFFSET] = 0x23;		/* 3 dummy bytes */
	qspi_write_buffer[ADDRESS_2_OFFSET] = 0x08;
	qspi_write_buffer[ADDRESS_3_OFFSET] = 0x09;

	Status = XQspiPs_PolledTransfer(&QspiInstance, qspi_write_buffer, qspi_read_buffer,
				QSPI_RD_ID_SIZE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	xil_printf("FlashID=0x%x 0x%x 0x%x\n\r", qspi_read_buffer[1], qspi_read_buffer[2],
		   qspi_read_buffer[3]);

	return 0;
}

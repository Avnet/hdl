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
//  Please direct any questions or issues to the MicroZed Community Forums:
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
//----------------------------------------------------------------------------
//
// Create Date:         Jun 06, 2013
// Design Name:         QSPI Flash Polled Interface
// Module Name:         qspi_flash_polled.h
// Project Name:        Avnet Touch Panel
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        ZedBoard, Zed Display Kit
//
// Tool versions:       ISE 14.5
//
// Description:         Definitions for interface to ZedBoard QSPI flash
//                      storage.
//
// Dependencies:
//
// Revision:            Jun 06, 2013: 1.00 Created for Zed Display Kit
//
//----------------------------------------------------------------------------

#ifndef __QSPI_FLASH_POLLED_H__
#define __QSPI_FLASH_POLLED_H__

#include "zed_ali3_controller_demo.h"
#include "types.h"
#include "xparameters.h"	/* SDK generated parameters */
#include "xqspips.h"		/* QSPI device driver */

/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define QSPI_DEVICE_ID		XPAR_XQSPIPS_0_DEVICE_ID

/*
 * The following constants define the commands which may be sent to the FLASH
 * device.
 */
#define QSPI_WRITE_STATUS_CMD          0x01
#define QSPI_WRITE_CMD                 0x02
#define QSPI_READ_CMD                  0x03
#define QSPI_WRITE_DISABLE_CMD         0x04
#define QSPI_READ_STATUS_CMD           0x05
#define QSPI_WRITE_ENABLE_CMD          0x06
#define QSPI_FAST_READ_CMD             0x0B
#define QSPI_DUAL_READ_CMD             0x3B
#define QSPI_QUAD_READ_CMD             0x6B
#define QSPI_BULK_ERASE_CMD            0xC7
#define	QSPI_SEC_ERASE_CMD             0xD8
#define QSPI_READ_ID                   0x9F

/*
 * The following constants define the offsets within a FlashBuffer data
 * type for each kind of data.  Note that the read data offset is not the
 * same as the write data because the QSPI driver is designed to allow full
 * duplex transfers such that the number of bytes received is the number
 * sent and received.
 */
#define COMMAND_OFFSET      0 /* FLASH instruction */
#define ADDRESS_1_OFFSET    1 /* MSB byte of address to read or write */
#define ADDRESS_2_OFFSET    2 /* Middle byte of address to read or write */
#define ADDRESS_3_OFFSET    3 /* LSB byte of address to read or write */
#define DATA_OFFSET         4 /* Start of Data for Read/Write */
#define DUMMY_OFFSET        4 /* Dummy byte offset for fast, dual and quad
				     reads */
#define DUMMY_SIZE          1 /* Number of dummy bytes for fast, dual and
				     quad reads */
#define QSPI_RD_ID_SIZE	    4 /* Read ID command + 3 bytes ID response */
#define BULK_ERASE_SIZE	    1 /* Bulk Erase command size */
#define SEC_ERASE_SIZE	    4 /* Sector Erase command + Sector address */

/*
 * The following constants specify the extra bytes which are sent to the
 * FLASH on the QSPI interface, that are not data, but control information
 * which includes the command and address
 */
#define OVERHEAD_SIZE        4

/*
 * The following constants specify the page size, sector size, and number of
 * pages and sectors for the FLASH.  The page size specifies a max number of
 * bytes that can be written to the FLASH with a single transfer.
 */
#define SECTOR_SIZE          0x10000
#define NUM_SECTORS          0x100
#define NUM_PAGES            0x10000
#define PAGE_SIZE            256

/*
 * Number of flash pages to be written.
 */
#define PAGE_COUNT           16

/*
 * Flash addresses to which data is to be written.
 */
#define CALIBRATION_ADDRESS  0x00060000
#define TEST_ADDRESS         0x00055000
#define AVNET_MAGIC_WORD     0x41564E54  // ASCII "AVNT" string
#define UNIQUE_VALUE         0x05
#define CALIBRATION_LENGTH   0x36
/*
 * The following constants specify the max amount of data and the size of the
 * the buffer required to hold the data and overhead to transfer the data to
 * and from the FLASH.
 */
#define MAX_TEST_DATA        PAGE_COUNT * PAGE_SIZE

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

void qspi_flash_erase(XQspiPs *QspiPtr, u32 Address, u32 ByteCount);

void qspi_flash_write(XQspiPs *QspiPtr, u32 Address, u32 ByteCount, u8 Command);

void qspi_flash_read(XQspiPs *QspiPtr, u32 Address, u32 ByteCount, u8 Command);

int qspi_flash_load_calibration_data(zed_ali3_controller_demo_t *pDemo);

int qspi_flash_read_id(void);

int qspi_flash_polled_init(void);

int qspi_flash_store_calibration_data(zed_ali3_controller_demo_t *pDemo);

#endif // __QSPI_FLASH_POLLED_H__

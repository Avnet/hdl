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
// Please direct any questions or issues to the MicroZed Community Forums:
//     http://www.microzed.org
//
// Disclaimer:
//    Avnet, Inc. makes no warranty for the use of this code or design.
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
//    any errors, which may appear in this code, nor does it make a commitment
//    to update the information contained herein. Avnet, Inc specifically
//    disclaims any implied warranties of fitness for a particular purpose.
//                     Copyright(c) 2014 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         May 10, 2014
// Design Name:         MicroZed FMC Carrier MAC ID Test
// Module Name:         unio_eeprom.h
// Project Name:        MicroZed FMC Carrier MAC ID Test
// Target Devices:      Zynq-7000
// Hardware Boards:     MicroZed, FMC Carrier
//
// Tool versions:       ISE Design Suite 14.7 / Vivado 2013.3
//
// Description:         Microchip UNI/O EEPROM access definitions.
//
// Dependencies:
//
// Revision:            May 10, 2014: 1.00 Initial version
//
//----------------------------------------------------------------------------

#ifndef __UNIO_EEPROM_H__
#define __UNIO_EEPROM_H__

#include "xparameters.h"
#include "types.h"

// PS GPIO related.
#include "xgpiops.h"

/************************** Constant Definitions *****************************/
#define UNIO_START                0x55  //  Start Header
#define UNIO_READ                 0x03  //  READ instruction
#define UNIO_CRRD                 0x06  //  READ from crt address instruction
#define UNIO_WRITE                0x6c  //  WRITE instruction
#define UNIO_WREN                 0x96  //  WRITE ENABLE instruction
#define UNIO_WRDI                 0x91  //  WRITE DISABLE instruction
#define UNIO_RDSR                 0x05  //  READ STATUS register instruction
#define UNIO_WRSR                 0x6e  //  WRITE STATUS REGISTER instruction
#define UNIO_ERAL                 0x6d  //  ERASE entire array instruction
#define UNIO_SETAL                0x67  //  SET   entire array instruction
#define UNIO_NOPROT               0x00  //  disable all write protections
#define UNIO_TIMEOUT              50    //  test beginning SAK / NOSAK
#define UNIO_THDR                 20    //  Start Header Low Pulse Time (Thdr)
#define UNIO_TSS                  40    //  Start Header Setup Time (Tss) should be (2 * UNIO_THDR)
#define UNIO_TSTBY                1000  //  Standby Pulse Time (Tstby)
//#define UNIO_QBUSEC               32     //  Quarter Bit = 32 usec ~7 KHz - This timing is not supported per the device datasheet
#define UNIO_QBUSEC               16    //  Quarter Bit = 16 usec ~ 15 KHz - Slowest recommended timing
//#define UNIO_QBUSEC               12    //  Quarter Bit = 12 usec
//#define UNIO_QBUSEC               8     //  Quarter Bit = 08 usec
//#define UNIO_QBUSEC               7 	  //  Quarter Bit = 07 usec
//#define UNIO_QBUSEC               6     //  Quarter Bit = 06 usec
//#define UNIO_QBUSEC               5     //  Quarter Bit = 05 usec
//#define UNIO_QBUSEC               4     //  Quarter Bit = 04 usec
//#define UNIO_QBUSEC               3     //  Quarter Bit = 03 usec - ~72.46 KHz Fastest recommended timing
//#define UNIO_QBUSEC               2     //  Quarter Bit = 02 usec ~102 KHz - This timing is not supported per the device datasheet


/**************************** Type Definitions *******************************/

// This structure contains the context for any UNIO EEPROM instance.
struct struct_unio_eeprom_t
{
    int32u bVerbose;

    ////////////////////////////////
    // UNI/O related members
    ////////////////////////////////
    int8u  device_address;    // Slave device address.
    int8u  data_byte;         // Data buffer to TX-RX bits.
    int16u data_address;      // Memory address used for data read or write.
    int32u error_count;       // Tracks the number of errors on UNIO line.

    ////////////////////////////////
    // GPIO related members
    ////////////////////////////////
    int button0_state;
    int button1_state;

    int led0_state;
    int led1_state;
    int led2_state;
    int led3_state;

    int16u gpio_device_id;  // The device instance for the PS GPIO device.
    XGpioPs gpio_driver;	// The driver instance for the PS GPIO device.
};
typedef struct struct_unio_eeprom_t unio_eeprom_t;

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

// Module initialization.
int unio_init(unio_eeprom_t *pDevice);

// Module debug.
void unio_timing_reference(unio_eeprom_t *pDevice);

// Command oriented operations.
void unio_command_continue(unio_eeprom_t *pDevice, int8u command_byte);
void unio_command_initial(unio_eeprom_t *pDevice, int8u command_byte);
void unio_erase_all_continue(unio_eeprom_t *pDevice);
void unio_erase_all_initial(unio_eeprom_t *pDevice);
void unio_set_all_continue(unio_eeprom_t *pDevice);
void unio_set_all_initial(unio_eeprom_t *pDevice);
int8u unio_read_status_register(unio_eeprom_t *pDevice);
void unio_write_status_register(unio_eeprom_t *pDevice, int8u status);

// Data byte oriented operations.
void unio_read_data_byte(unio_eeprom_t *pDevice);
void unio_read_next_data_byte(unio_eeprom_t *pDevice);
void unio_write_data_byte(unio_eeprom_t *pDevice);

// Data array oriented operations.
void unio_read_array(unio_eeprom_t *pDevice, int8u *destination, int8u length);
void unio_read_next_array(unio_eeprom_t *pDevice, int8u *destination, int8u length);
void unio_write_array(unio_eeprom_t *pDevice, int8u *source, int8u length);

#endif // __UNIO_EEPROM_H__

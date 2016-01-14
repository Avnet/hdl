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
// Module Name:         unio_eeprom_test.c
// Project Name:        MicroZed FMC Carrier MAC ID Test
// Target Devices:      Zynq-7000
// Hardware Boards:     MicroZed, FMC Carrier
//
// Tool versions:       ISE Design Suite 14.7 / Vivado 2013.3
//
// Description:         Microchip UNI/O EEPROM test for MicroZed FMC Carrier
//
// Dependencies:
//
// Revision:            May 10, 2014: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "platform.h"
#include "xil_cache.h"

#include "unio_eeprom.h"

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define GPIO_DEVICE_ID  	XPAR_XGPIOPS_0_DEVICE_ID

/*
 * This is the address for the target UNI/O slave device.  For
 * 11AA02E48/11AA02E64 devices the family code, which is represented by the
 * first four bits, is set to '1010' and the device code, which is represented
 *  by the last four bits is set to '0000'.
 */
#define UNIO_DEVICE_ADDRESS            0xA0

/*
 * This is the number of bytes stored in the target UNI/O slave device.  For
 * 11AA02E48/11AA02E64 devices, the capacity is 256 x 8 bits total.
 */
#define UNIO_DEVICE_CAPACITY           256

/*
 * There are six bytes in a EUI48 identifier.
 */
#define EUI48_BYTE_LENGTH              6

/*
 * The EUI48 identifier is located at address 0xFA.
 */
#define EUI48_MEMORY_ADDRESS           0xFA

// This is the top level test instance.
unio_eeprom_t unio_eeprom_test;

/*****************************************************************************
*
* Read the contents of the EEPROM memory and dump it to the terminal.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int dump_eeprom_memory(unio_eeprom_t *pDevice)
{
    int16u target_address = 0;  // Target memory address.
    int16u data_index = 0;
    int16u data_length = (UNIO_DEVICE_CAPACITY - 1);
    int8u dump_data_array[UNIO_DEVICE_CAPACITY] = {0};

    // Read the data from the EEPROM memory.
    while (data_index < data_length)
    {
        unio_eeprom_test.data_address = target_address;
        unio_read_data_byte(&unio_eeprom_test);
        dump_data_array[data_index] = pDevice->data_byte;
        data_index++;
        target_address++;
    }

    data_index = 0;

    // Begin printing the content table to the terminal.
    xil_printf("+------------------------------------------------------+\r\n");
    xil_printf("|            Dumping UNI/O EEPROM Contents             |\r\n");
    xil_printf("|------------------------------------------------------|\r\n");
    xil_printf("|  Offset:   0    1    2    3       4    5    6    7   |\r\n");
    xil_printf("|------------------------------------------------------|\r\n");

    // Display all of the data from the EEPROM memory to the terminal.
    while (data_index < data_length)
    {
        xil_printf("|    0x%02X:  %02X   %02X   %02X   %02X      %02X   %02X   %02X   %02X   |\r\n",
        	data_index,
        	dump_data_array[data_index],
            dump_data_array[data_index + 1],
            dump_data_array[data_index + 2],
            dump_data_array[data_index + 3],
            dump_data_array[data_index + 4],
            dump_data_array[data_index + 5],
            dump_data_array[data_index + 6],
            dump_data_array[data_index + 7]);

        data_index = data_index + 8;
    }

    // Finish printing the content table to the terminal.
    xil_printf("+------------------------------------------------------+\r\n");
    xil_printf("\r\n");

    return 0;
}

/*****************************************************************************
*
* Read the MAC address data from the EEPROM memory and print it to the
* terminal.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int read_mac_address(unio_eeprom_t *pDevice)
{
    int16u target_address = EUI48_MEMORY_ADDRESS;  // Target memory address.
    int16u data_index = 0;
    int16u data_length = (EUI48_BYTE_LENGTH - 1);
    int8u eui48_data_array[EUI48_BYTE_LENGTH] = {0};

    // Read the EUI48 data from the EEPROM memory.
    while (data_index < data_length)
    {
        unio_eeprom_test.data_address = target_address;
        unio_read_data_byte(&unio_eeprom_test);
        eui48_data_array[data_index] = pDevice->data_byte;
        data_index++;
        target_address++;
    }

    data_index = 0;

    // Print a string formatted version of the MAC address to the terminal.
    xil_printf("+------------------------------------------------------+\r\n");
    xil_printf("|      EUI48 (MAC Address):     %02X-%02X-%02X-%02X-%02X-%02X      |\r\n",
        eui48_data_array[data_index],
        eui48_data_array[data_index + 1],
        eui48_data_array[data_index + 2],
        eui48_data_array[data_index + 3],
        eui48_data_array[data_index + 4],
        eui48_data_array[data_index + 5]);
    xil_printf("+------------------------------------------------------+\r\n");
    xil_printf("\r\n");

    return 0;
}

/*****************************************************************************
*
* Performs a few quick READ/WRITE tests to the EEPROM to demonstrate that it
* is functioning properly.  Uncomment the call to unio_timing_reference()
* in order to calibrate the sleep timing used to create the start header
* by continuously toggling the GPIO pin with the calculated bit Period Te.
* This can be useful when porting to a different Zynq platform.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int run_unio_eeprom_test(void)
{
    int8u data_count;  // Counter for data contained within test strings.
    int8u data_length = 35;
    int16u target_address;  // Target memory address.
    int32u error_count = 0;  // Number of mismatches discovered in memory comparison test.

    int8u *source_data_array  = (int8u *) "Avnet_is_Accelerating_Your_Success!";
    int8u *test_data_array  = (int8u *) "This_is_not_the_message_we_want!!!!";

    /*
	 * Determine overall test result and print results to test operator.
	 */
	xil_printf("\n\r");

	xil_printf("---------------------------------------------------------------------------\n\r");
	xil_printf("--                                                                       --\n\r");
	xil_printf("--                   PZCC-FMC2 UNIO EEPROM Test Application              --\n\r");
	xil_printf("--                                                                       --\n\r");
	xil_printf("---------------------------------------------------------------------------\n\r");
	xil_printf("\n\r");

    // Specify configuration for hardware design.
    unio_eeprom_test.device_address = UNIO_DEVICE_ADDRESS;
    unio_eeprom_test.gpio_device_id = GPIO_DEVICE_ID;

    xil_printf("--- unio_init Start ---\r\n");
        // Initialize the UNIO control interface.
    unio_init(&unio_eeprom_test);

    // Used to calibrate timing:
    //unio_timing_reference(&unio_eeprom_test);

    xil_printf("--- dump_eeprom_memory Start ---\r\n");
        // Dump EEPROM contents to the terminal for inspection.
    dump_eeprom_memory(&unio_eeprom_test);

    xil_printf("--- read_mac_address Start ---\r\n");
        // Read the EUI48 (MAC address) data from the EEPROM.
    read_mac_address(&unio_eeprom_test);

    // Write, read, compare test for EEPROM memory in single byte mode.

    // Start by writing the data string into EEPROM memory.
    data_count = 0;
	target_address = 0x00;

	// Write all of the data from the test array.
    while (data_count < data_length)
    {
    	unio_eeprom_test.data_address = target_address;
    	unio_eeprom_test.data_byte = source_data_array[data_count];
    	unio_write_data_byte(&unio_eeprom_test);
    	data_count++;
    	target_address++;
    }

    // Next read the data string back from EEPROM memory.
    data_count = 0;
    target_address = 0x00;

    // Read the data from the EEPROM memory.
    while (data_count < data_length)
    {
        unio_eeprom_test.data_address = target_address;
        unio_read_data_byte(&unio_eeprom_test);
        test_data_array[data_count] = unio_eeprom_test.data_byte;
    	data_count++;
    	target_address++;
    }

    // Compare the contents of the two strings since the data should match.
    for (data_count = 0; data_count < data_length; data_count++)
    {
        if (test_data_array[data_count] != source_data_array[data_count])
        {
            xil_printf("\tERROR:  Found 0x%02X at 0x%04X, expected 0x%02X\r\n", test_data_array[data_count], data_count, source_data_array[data_count]);
            error_count++;
        }
    }

    xil_printf("\r\n");

    /*
     * Determine overall test result and print results to test operator.
     */
    xil_printf("UNI/O EEPROM Test: ");

    if (error_count == 0)
	{
		xil_printf("\033[32mPASSED\033[0m\r\n");
	}
	else
	{
		xil_printf("\033[5mFAILED\033[0m\r\n");
	}

    xil_printf("\r\n");
    xil_printf("--- UNI/O EEPROM Test End ---\r\n");

    return 0;
}

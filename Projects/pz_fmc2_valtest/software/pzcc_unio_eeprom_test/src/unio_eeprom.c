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
// Module Name:         unio_eeprom.c
// Project Name:        MicroZed FMC Carrier MAC ID Test
// Target Devices:      Zynq-7000
// Hardware Boards:     MicroZed, FMC Carrier
//
// Tool versions:       ISE Design Suite 14.7 / Vivado 2013.3
//
// Description:         Microchip UNI/O EEPROM access function implementation.
//
// Dependencies:
//
// Revision:            May 10, 2014: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include "ps_gpio_polled.h"
#include "sleep.h"
#include "unio_eeprom.h"


/*****************************************************************************
*
* The purpose of this function is to delay for the half the amount of time
* it takes to transfer one data bit over UNI/O.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_delay_half_bit(unio_eeprom_t *pDevice)
{
    usleep(UNIO_QBUSEC);
    usleep(UNIO_QBUSEC);
}


/*****************************************************************************
*
* The purpose of this function is to delay for quarter the amount of time
* it takes to transfer one data bit over UNI/O.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_delay_quarter_bit(unio_eeprom_t *pDevice)
{
    usleep(UNIO_QBUSEC);
}


/*****************************************************************************
*
* The purpose of this function is to delay for at least the minimum required
* Standby Pulse Time to place the UNI/O slave into standby mode.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_delay_standby(unio_eeprom_t *pDevice)
{
    usleep(UNIO_TSTBY);
}

/*****************************************************************************
*
* The purpose of this function is to delay for at least the minimum required
* Start Header Low Pulse Time prior to transmitting the start header.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_delay_thdr(unio_eeprom_t *pDevice)
{
	usleep(UNIO_THDR);
}


/*****************************************************************************
*
* The purpose of this function is to delay for at least the minimum required
* Start Header Setup Time prior to transmitting the Start Header Low Pulse.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_delay_tss(unio_eeprom_t *pDevice)
{
	usleep(UNIO_TSS);
}


/*****************************************************************************
*
* The purpose of this function is to delay for half the amount of time
* it takes to transfer one data bit over UNI/O.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_delay_whole_bit(unio_eeprom_t *pDevice)
{
    usleep(UNIO_QBUSEC);
    usleep(UNIO_QBUSEC);
    usleep(UNIO_QBUSEC);
    usleep(UNIO_QBUSEC);
}


/*****************************************************************************
*
* The purpose of this function is to record a detected error while
* communicating with the UNI/O device.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_error(unio_eeprom_t *pDevice)
{
    pDevice->error_count++;
}


/*****************************************************************************
*
* The purpose of this function is to create a Master Acknowledge (MAK)
* condition to the UNI/O slave device.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_mak(unio_eeprom_t *pDevice)
{
	// Set the line to the slave low to initiate the Master Acknowledge (MAK).
	ps_gpio_set_unio(pDevice, 0);

    // Delay for one half bit timing.
	unio_delay_half_bit(pDevice);

    // Set the line to the slave high to complete the Master Acknowledge (MAK).
    ps_gpio_set_unio(pDevice, 1);

    // Delay for one half bit timing.
    unio_delay_half_bit(pDevice);
}

/*****************************************************************************
*
* The purpose of this function is to create a Not Acknowledge (NoMAK)
* condition to the UNI/O slave device.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_nomak(unio_eeprom_t *pDevice)
{
	// Set the line to the slave high to initiate the Not Acknowledge (NoMAK).
	ps_gpio_set_unio(pDevice, 1);

    // Delay for one half bit timing.
    unio_delay_half_bit(pDevice);

    // Set the line to the slave low to complete the Not Acknowledge (NoMAK).
    ps_gpio_set_unio(pDevice, 0);

    // Delay for one half bit timing.
    unio_delay_half_bit(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to check for a Not Slave Acknowledge (NoSAK)
* condition to the UNI/O slave device.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_nosak(unio_eeprom_t *pDevice)
{
    volatile int8u wait;

    // Initialize the wait for SACK conditions.
    wait = UNIO_TIMEOUT;

    /* Set the line to the slave high to allow the slave to drive the SACK
     * condition.
     */
    ps_gpio_set_unio(pDevice, 1);

    // Read the line to put the GPIO into tristate.
    ps_gpio_get_unio(pDevice);

    // Wait to see if signal stays high.
    while (!ps_gpio_get_unio(pDevice))
    {
    	// Decrement the wait count.
        wait--;

        // Check to see if a timeout condition has occurred.
        if (wait == 0)
        {
        	unio_error(pDevice);
        }
	}

    // Delay for one whole bit timing.
    unio_delay_whole_bit(pDevice);

    // Check to see if the line is low.
    if (ps_gpio_get_unio(pDevice) == 0)
    {
    	unio_error(pDevice);
    }
    else
    {
    	ps_gpio_set_unio(pDevice, 1);
    }
}


/*****************************************************************************
*
* The purpose of this function is to check for a Slave Acknowledge (SAK)
* condition to the UNI/O slave device.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_sak(unio_eeprom_t *pDevice)
{
    volatile int8u wait;

    // Initialize the wait for SACK conditions.
    wait = UNIO_TIMEOUT;

    /* Set the line to the slave high to allow the slave to drive the SACK
     * condition.
     */
    ps_gpio_set_unio(pDevice, 1);

    // Read the line to put the GPIO into tristate.
    ps_gpio_get_unio(pDevice);

    // Wait for UNIO slave to pull signal low.
    while (ps_gpio_get_unio(pDevice) == 1)
    {
    	// Decrement the wait count.
        wait--;

        // Check to see if a timeout condition has occurred.
        if (wait == 0)
        {
        	unio_error(pDevice);
        }
	}

    // Delay for one whole bit timing.
    unio_delay_whole_bit(pDevice);

    // Check to see if the line is low.
    if (ps_gpio_get_unio(pDevice) == 0)
    {
    	unio_error(pDevice);
    }
    else
    {
    	ps_gpio_set_unio(pDevice, 1);
    }
}


/*****************************************************************************
*
* The purpose of this function is to send 8 data bits to the UNI/O slave
* device.  MSB of the data is transmitted first, LSB is transmitted last.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_send_byte(unio_eeprom_t *pDevice)
{
    int8u bit_count = 0;
    int8u data_byte_buffer;

    // Copy the data byte into a local version which can be bit rotated.
    data_byte_buffer = pDevice->data_byte;

    // Repeat the bit transmission process 8 times to complete the byte.
    while (bit_count < 8)
    {
    	// First half of the bit state transmitted must be the opposite
    	// of the bit in the buffer.
        if ((data_byte_buffer & 0x80) == 0x80)
        {
        	// Set the line to the slave low to start the high bit.
        	ps_gpio_set_unio(pDevice, 0);
        }
        else
        {
            // Set the line to the slave high to start the low bit.
            ps_gpio_set_unio(pDevice, 1);
        }

        // Delay for one half bit timing.
        unio_delay_half_bit(pDevice);

        // First half of the bit state transmitted must be the opposite
	    // of the bit in the buffer.
        if ((data_byte_buffer & 0x80) == 0x80)
	    {
	    	// Set the line to the slave high to complete the high bit.
	        ps_gpio_set_unio(pDevice, 1);
	    }
	    else
	    {
	    	// Set the line to the slave low to complete the low bit.
	        ps_gpio_set_unio(pDevice, 0);
	    }

        // Delay for one half bit timing.
        unio_delay_half_bit(pDevice);

        // Shift data byte buffer left 1 bit location to get the next
        // most significant bit.
        data_byte_buffer = data_byte_buffer << 1;

        // Increment bit counter to repeat for 8 bits.
        bit_count++;
    }
}

/*****************************************************************************
*
* The purpose of this function is to receive 8 data bits from the UNI/O slave
* device.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_receive_byte(unio_eeprom_t *pDevice)
{
    int8u bit_count = 0;
    int8u data_byte_buffer = 0;

    /* Set the line to the slave high to allow the slave to drive the SACK
     * condition.
     */
    ps_gpio_set_unio(pDevice, 1);

    // Read the line to put the GPIO into tristate.
    ps_gpio_get_unio(pDevice);

    // Repeat the bit receive process 8 times to complete the byte.
    while (bit_count < 8)
    {
        // Shift data byte buffer left 1 bit location.
        data_byte_buffer = data_byte_buffer << 1;

        // Delay for one quarter bit timing.
        unio_delay_quarter_bit(pDevice);

        // Check to see what the initial state of the GPIO is.
        if (ps_gpio_get_unio(pDevice) == 0)
        {
        	// Delay for one half bit timing.
            unio_delay_half_bit(pDevice);

            // Check to see what the next state of the GPIO is.
            if (ps_gpio_get_unio(pDevice) == 0)
            {
                // A 0 followed by a 0 is an error condition.
            	unio_error(pDevice);
            }
            else
            {
            	// A high bit was received, move it onto the buffer.
            	data_byte_buffer = data_byte_buffer | (0x01);
            }
        }
        else
        {
        	// Delay for one half bit timing.
            unio_delay_half_bit(pDevice);

            // Check to see what the next state of the GPIO is.
            if (ps_gpio_get_unio(pDevice) == 1)
            {
                // A 1 followed by a 1 is an error condition.
            	unio_error(pDevice);
            }
            else
            {
            	// A low bit was received, move it onto the buffer.
            	data_byte_buffer = data_byte_buffer | (0x00);
            }
        }

        // Delay for one quarter bit timing.
        unio_delay_quarter_bit(pDevice);

		// Increment bit counter to repeat for 8 bits.
		bit_count++;
    }

    // Copy data byte buffer back up to the EEPROM data structure.
    pDevice->data_byte = data_byte_buffer;
}


/*****************************************************************************
*
* The purpose of this function is to create the required Standby Pulse to
* reset the UNI/O slave device and place it into standby mode.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_standby(unio_eeprom_t *pDevice)
{
	// First set the line to the slave device low this will ensure the
	// required low to high transition on SCIO occurs prior to the Standby
	// Pulse.
	ps_gpio_set_unio(pDevice, 0);

	// Allow the line to stay low for at least the required Start Header
	// Low Pulse time.
    unio_delay_thdr(pDevice);

    // Set the line to the slave high which will begin the Standby Pulse.
    ps_gpio_set_unio(pDevice, 1);

    // Allow the required time for the slave to recognize the Standby Pulse
    // and enter into Slave Mode.
    unio_delay_standby(pDevice);
}

/*****************************************************************************
*
* The purpose of this function is to create the required Start Header Setup
* Time for the UNI/O slave device prior to transmitting a new command
* sequence.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_consecutive_command(unio_eeprom_t *pDevice)
{
    // Set the line to the slave high which will ready for the start header
    // setup time transmission to be followed up by the Start Header Low
	// Pulse.
    ps_gpio_set_unio(pDevice, 1);

    // Allow the required time for the Start Header Setup Time.
    unio_delay_tss(pDevice);

    // Finally set the line low to provide the required Start Header Low
    // Pulse Time prior to the transmission of a Start Header.
    ps_gpio_set_unio(pDevice, 0);

    // Allow the required time for the Start Header Low Pulse Time.
    unio_delay_thdr(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to transmit the required Start Header
* sequence which is used to synchronize the slave’s internal clock period
* with the master’s clock period.  The sequence is terminated by following
* the transmission with MAK and waiting for the expected NOSAK.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_send_start(unio_eeprom_t *pDevice)
{
    // Load the Start Header byte to the device data buffer.
    pDevice->data_byte = UNIO_START;

    // Stream out the start header.
    unio_send_byte(pDevice);

    // Transmit the Master Acknowledge.
    unio_mak(pDevice);

    // Wait for the slave Not Acknowledge on the SCIO.
    unio_nosak(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to transmit a byte of data which will later
* be followed by subsequent data.  This is done by following the byte
* transmission with MAK and waiting for the expected SAK.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_send_data_continue(unio_eeprom_t *pDevice, int8u data_byte)
{
	// Load the data byte to the device data buffer.
	pDevice->data_byte = data_byte;

    // Stream out the data byte that was loaded to the device data buffer.
	unio_send_byte(pDevice);

	// Transmit the Master Acknowledge.
    unio_mak(pDevice);

    // Wait for the Slave Acknowledge on the SCIO.
    unio_sak(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to transmit a byte of data which will not
* be followed by subsequent data.  This is done by following the byte
* transmission with NOMAK and waiting for the expected SAK.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_send_data_terminate(unio_eeprom_t *pDevice, int8u data_byte)
{
	// Load the data byte to the device data buffer.
	pDevice->data_byte = data_byte;

    // Stream out the data byte that was loaded to the device data buffer.
	unio_send_byte(pDevice);

	// Transmit the No Master Acknowledge.
    unio_nomak(pDevice);

    // Wait for the Slave Acknowledge on the SCIO.
    unio_sak(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to initialize the underlying UNI/O driver
* allowing usage of further APIs for reading/writing to a UNI/O device.
*
* Please see xgpiops.h file for description of the pin numbering used for
* bit banging the UNI/O protocol out.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int unio_init(unio_eeprom_t *pDevice)
{
	pDevice->error_count = 0;

    /*
     * Initialize the PS GPIO driver so that it's ready to use.
     */
    if (ps_gpio_polled_init(pDevice, pDevice->gpio_device_id) != 0)
    {
        xil_printf("Failed to initialize PS GPIO driver\n\r");
        return XST_FAILURE;
    }

    /* Initialize the device which must be done following POR. */
    unio_standby(pDevice);

    return XST_SUCCESS;
}


/*****************************************************************************
*
* The purpose of this function is to provide a continuous reference timing
* signal used for timing debug.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_timing_reference(unio_eeprom_t *pDevice)
{
	while (1)
	{
		// Set the line to the slave low to initiate the Master Acknowledge (MAK).
		ps_gpio_set_unio(pDevice, 0);
		ps_gpio_set_led(pDevice, 0, 0);

		// Delay for one half bit timing.
		if (usleep(UNIO_QBUSEC * 2) != 0)
		{
			xil_printf("ERROR: Bad delay!\n\r");
		}

		// Set the line to the slave high to complete the Master Acknowledge (MAK).
		ps_gpio_set_unio(pDevice, 1);
		ps_gpio_set_led(pDevice, 0, 1);

		// Delay for one half bit timing.
		if (usleep(UNIO_QBUSEC * 2) != 0)
		{
			xil_printf("ERROR: Bad delay!\n\r");
		}
	}
}


/*****************************************************************************
*
* The purpose of this function is to transmit the specified command byte to
* the UNI/O slave.  This function should be used to follow up a previous
* command (such as WREN, WRDI, ERAL, or SETAL) that was just sent to the
* slave.  Keep in mind that any ERAL or SETAL command still requires that
* WREN be transmitted first followed by a 10ms delay.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_command_continue(unio_eeprom_t *pDevice, int8u command_byte)
{
	// First, send the start header low pulse to ready the slave device to
	// synchronize to the next start header.
	unio_consecutive_command(pDevice);

	// Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Finally transmit the specified command byte and terminate the
    // the communications sequence.
    unio_send_data_terminate(pDevice, command_byte);
}


/*****************************************************************************
*
* The purpose of this function is to transmit the specified command byte to
* the UNI/O slave.  Keep in mind that any ERAL or SETAL command requires that
* WREN be transmitted first followed by a 10ms delay.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_command_initial(unio_eeprom_t *pDevice, int8u command_byte)
{
	// First, send the standby pulse to wake up the slave device after POR.
	unio_standby(pDevice);

	// First, send the start header low pulse to ready the slave device to
	// synchronize to the next start header.
	unio_consecutive_command(pDevice);

	// Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Finally transmit the specified command byte and terminate the
    // the communications sequence.
    unio_send_data_terminate(pDevice, command_byte);
}


/*****************************************************************************
*
* The purpose of this function is to transmit the Erase All command to
* the UNI/O slave.  The WREN be transmitted first, followed by ERAL, followed
* by a 10ms delay to allow the write to complete.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_erase_all_continue(unio_eeprom_t *pDevice)
{
    // Send the WREN command to enable writes to the device.
	unio_command_continue(pDevice, UNIO_WREN);

	// Send the Erase All command ERAL to set all byte storage locations
	// to 0x00.
	unio_command_continue(pDevice, UNIO_ERAL);

    // Delay the required Write Cycle Time (Twc) for ERAL before returning.
    millisleep(10);
}


/*****************************************************************************
*
* The purpose of this function is to transmit the Erase All command to
* the UNI/O slave.  The WREN be transmitted first, followed by ERAL, followed
* by a 10ms delay to allow the write to complete.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_erase_all_initial(unio_eeprom_t *pDevice)
{
    // Send the WREN command to enable writes to the device.
    unio_command_initial(pDevice, UNIO_WREN);

	// Send the Erase All command ERAL to set all byte storage locations
	// to 0x00.
	unio_command_continue(pDevice, UNIO_ERAL);

    // Delay the required Write Cycle Time (Twc) for ERAL before returning.
    millisleep(10);
}


/*****************************************************************************
*
* The purpose of this function is to transmit the Set All command to
* the UNI/O slave.  The WREN be transmitted first, followed by SETAL,
* followed by a 10ms delay to allow the write to complete.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_set_all_continue(unio_eeprom_t *pDevice)
{
     // Send the WREN command to enable writes to the device.
 	unio_command_continue(pDevice, UNIO_WREN);

 	// Send the Set All command SETAL to set all byte storage locations
 	// to 0xFF.
 	unio_command_continue(pDevice, UNIO_SETAL);

    // Delay the required Write Cycle Time (Twc) for SETAL before returning.
    millisleep(10);
}


/*****************************************************************************
*
* The purpose of this function is to transmit the Set All command to
* the UNI/O slave.  The WREN be transmitted first, followed by SETAL,
* followed by a 10ms delay to allow the write to complete.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_set_all_initial(unio_eeprom_t *pDevice)
{
    // Send the WREN command to enable writes to the device.
	unio_command_initial(pDevice, UNIO_WREN);

	// Send the Set All command SETAL to set all byte storage locations
	// to 0xFF.
	unio_command_continue(pDevice, UNIO_SETAL);

    // Delay the required Write Cycle Time (Twc) for SETAL before returning.
    millisleep(10);
}


/*****************************************************************************
*
* The purpose of this function is to transmit the Read Status Register
* command to the UNI/O slave.  The RDSR is transmitted first, followed by
* receiving the status byte from the slave.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
int8u unio_read_status_register(unio_eeprom_t *pDevice)
{
    int8u status_data_byte = 0;

    // First, send the start header low pulse to ready the slave device to
    // synchronize to the next start header.
    unio_consecutive_command(pDevice);

    // Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Transmit the RDSR command to the target slave device.
    unio_send_data_continue(pDevice, UNIO_RDSR);

    // Finally receive the status byte from the slave.
    unio_receive_byte(pDevice);

    // Copy the received data byte to the temporary place holder.
    status_data_byte = pDevice->data_byte;

    // Transmit the No Master Acknowledge.
    unio_nomak(pDevice);

    // Wait for the Slave Acknowledge on the SCIO.
    unio_sak(pDevice);

    // Return the contents of the Status register read from the slave.
    return status_data_byte;
}


/*****************************************************************************
*
* The purpose of this function is to transmit the Write Status Register
* command to the UNI/O slave.  The WRSR is transmitted first, followed by
* the new status byte, and then followed by a 5ms delay to allow the status
* register write to complete.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_write_status_register(unio_eeprom_t *pDevice, int8u status)
{
	// First, send the standby pulse to wake up the slave device after POR.
    unio_standby(pDevice);

    // First, send the start header low pulse to ready the slave device to
	// synchronize to the next start header.
	unio_consecutive_command(pDevice);

    // Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Transmit the WRSR command to the target slave device.
    unio_send_data_continue(pDevice, UNIO_WRSR);

    // Finally transmit the new status byte and terminate the
    // the communications sequence.
    unio_send_data_terminate(pDevice, status);

    // Delay the required Write Cycle Time (Twc) for WRSR before returning.
    millisleep(5);
}


/*****************************************************************************
*
* The purpose of this function is to read a data byte from the UNI/O slave.
* The slave address and data address are stored within the unio_eeprom_t
* type passed in by reference.  Once the data is read from the slave it will
* be stored back in the data_byte member within the unio_eeprom_t type.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_read_data_byte(unio_eeprom_t *pDevice)
{
	// Send the start header low pulse to ready the slave device to
	// synchronize to the next start header.
    unio_consecutive_command(pDevice);

    // Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Transmit the READ command to the target slave device.
    unio_send_data_continue(pDevice, UNIO_READ);

    // Transmit the most significant bits of the target address to be written
    // to the target slave device.
    unio_send_data_continue(pDevice, (pDevice->data_address >> 8));

    // Transmit the least significant bits of the target address to be written
    // to the target slave device.
    unio_send_data_continue(pDevice, (pDevice->data_address & 0xFF));

    // Receive data byte from the slave device.
    unio_receive_byte(pDevice);

    // Transmit the No Master Acknowledge.
    unio_nomak(pDevice);

    // Wait for the Slave Acknowledge on the SCIO.
    unio_sak(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to read the next data byte from the UNI/O
* slave.  The slave address is stored within the unio_eeprom_t type passed
* in by reference.  However, the address read from is based upon the auto
* increment within the slave based upon the last read operation.  Once the
* data is read from the slave it will be stored back in the data_byte
* member within the unio_eeprom_t type.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_read_next_data_byte(unio_eeprom_t *pDevice)
{
	// Send the start header low pulse to ready the slave device to
	// synchronize to the next start header.
    unio_consecutive_command(pDevice);

    // Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Transmit the CRRD command to the target slave device.
    unio_send_data_continue(pDevice, UNIO_CRRD);

    // Receive data byte from the slave device.
    unio_receive_byte(pDevice);

    // Transmit the No Master Acknowledge.
    unio_nomak(pDevice);

    // Wait for the Slave Acknowledge on the SCIO.
    unio_sak(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to write a data byte to the UNI/O slave.
* The slave address, data address, and data byte are stored within the
* unio_eeprom_t type passed in by reference.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_write_data_byte(unio_eeprom_t *pDevice)
{
	int8u write_byte = pDevice->data_byte;

    // Issue the write enable command so that the data byte can be written
    // into EEPROM memory space.
    unio_command_continue(pDevice, UNIO_WREN);

    // Send the start header low pulse to ready the slave device to
    // synchronize to the next start header.
    unio_consecutive_command(pDevice);

    // Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Transmit the WRITE command to the target slave device.
    unio_send_data_continue(pDevice, UNIO_WRITE);

    // Transmit the most significant bits of the target address to be written
    // to the target slave device.
    unio_send_data_continue(pDevice, (pDevice->data_address >> 8));

    // Transmit the least significant bits of the target address to be written
    // to the target slave device.
    unio_send_data_continue(pDevice, (pDevice->data_address & 0xFF));

    // Finally transmit the new data byte and terminate the
    // the communications sequence.
    unio_send_data_terminate(pDevice, write_byte);

    // Delay the required Write Cycle Time (Twc) for WRITE before returning.
    millisleep(5);
}


/*****************************************************************************
*
* The purpose of this function is to read an array of data bytes from the
* UNI/O slave.  The slave address and data address are stored within the
* unio_eeprom_t type passed in by reference.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_read_array(unio_eeprom_t *pDevice, int8u *destination, int8u length)
{
    int8u count = 0;

    // Send the start header low pulse to ready the slave device to
    // synchronize to the next start header.
    unio_consecutive_command(pDevice);

    // Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Transmit the READ command to the target slave device.
    unio_send_data_continue(pDevice, UNIO_READ);

    // Transmit the most significant bits of the target address to be written
    // to the target slave device.
    unio_send_data_continue(pDevice, (pDevice->data_address >> 8));

    // Transmit the least significant bits of the target address to be written
    // to the target slave device.
    unio_send_data_continue(pDevice, (pDevice->data_address & 0xFF));

	// Repeat for (n - 1) bytes.
	while(count < (length - 1))
    {
        // Receive the next data byte.
        unio_receive_byte(pDevice);

        // Copy the received data byte into the destination array.
        destination[count] = pDevice->data_byte;

	    // Transmit the Master Acknowledge.
		unio_mak(pDevice);

		// Wait for the Slave Acknowledge on the SCIO.
		unio_sak(pDevice);

	    count++;
    }

    // Receive the last data byte from the slave device.
    unio_receive_byte(pDevice);

    // Copy the final received data byte into the destination array.
    destination[count] = pDevice->data_byte;

    // Transmit the No Master Acknowledge.
    unio_nomak(pDevice);

    // Wait for the Slave Acknowledge on the SCIO.
    unio_sak(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to read an array of data bytes from the
* UNI/O slave.  The slave address is stored within the unio_eeprom_t type
* passed in by reference.  However, the address read from is based upon the
* auto increment within the slave based upon the last read operation.  Once
* the data is read from the slave it will then be stored in the destination
* array.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_read_next_array(unio_eeprom_t *pDevice, int8u *destination, int8u length)
{
    int8u count = 0;

    // Send the start header low pulse to ready the slave device to
    // synchronize to the next start header.
    unio_consecutive_command(pDevice);

    // Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Transmit the CRRD command to the target slave device.
    unio_send_data_continue(pDevice, UNIO_CRRD);

 	// Repeat for (n - 1) bytes.
	while(count < (length - 1))
    {
        // Receive the next data byte.
        unio_receive_byte(pDevice);

        // Copy the received data byte into the destination array.
        destination[count] = pDevice->data_byte;

	    // Transmit the Master Acknowledge.
		unio_mak(pDevice);

		// Wait for the Slave Acknowledge on the SCIO.
		unio_sak(pDevice);

	    count++;
    }

    // Receive the last data byte from the slave device.
    unio_receive_byte(pDevice);

    // Copy the final received data byte into the destination array.
    destination[count] = pDevice->data_byte;

    // Transmit the No Master Acknowledge.
    unio_nomak(pDevice);

    // Wait for the Slave Acknowledge on the SCIO.
    unio_sak(pDevice);
}


/*****************************************************************************
*
* The purpose of this function is to write an array of data bytes to the
* UNI/O slave.  The slave address and data address are stored within the
* unio_eeprom_t type passed in by reference.
*
* @param	None.
*
* @return	0 if successful, else -1.
*
* @note		None.
*
*****************************************************************************/
void unio_write_array(unio_eeprom_t *pDevice, int8u *source, int8u length)
{
    int8u count = 0;

    // Issue the write enable command so that the data byte can be written
    // into EEPROM memory space.
    unio_command_continue(pDevice, UNIO_WREN);

    // Send the start header low pulse to ready the slave device to
    // synchronize to the next start header.
    unio_consecutive_command(pDevice);

    // Next, transmit the Start Header to sync the slave timing to the master.
    unio_send_start(pDevice);

    // Transmit the address of the target slave device.
    unio_send_data_continue(pDevice, pDevice->device_address);

    // Transmit the WRITE command to the target slave device.
    unio_send_data_continue(pDevice, UNIO_WRITE);

    // Transmit the most significant bits of the target address to be written
    // to the target slave device.
    unio_send_data_continue(pDevice, (pDevice->data_address >> 8));

    // Transmit the least significant bits of the target address to be written
    // to the target slave device.
    unio_send_data_continue(pDevice, (pDevice->data_address & 0xFF));

	// Repeat for (n - 1) bytes.
	while(count < (length - 1))
    {
		// Transmit the next data byte.
	    unio_send_data_continue(pDevice, source[count]);
	    count++;
    }

    // Finally transmit the last data byte and terminate the
    // the communications sequence.
    unio_send_data_terminate(pDevice, source[count]);

    // Delay the required Write Cycle Time (Twc) for WRITE before returning.
    millisleep(5);
}

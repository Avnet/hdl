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
// Create Date:         Jun 03, 2013
// Design Name:         TMG 120 Touch Interface
// Module Name:         tmg120.c
// Project Name:        Avnet Touch Panel
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        ZedBoard, Zed Display Kit
//
// Tool versions:       Vivado 2015.2
//
// Description:         Implementation for interface to Avnet Touch Controller
//
// Dependencies:
//
// Revision:            Jun 03, 2013: 1.00 Created for Zed Display Kit
//                      Sep 17, 2015: 1.01 Updated for ALI3 kit and 2015.2
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "zed_ali3_controller_demo.h"
#include "types.h"
#include "tmg120.h"

/* Define the maximum number of data bytes needed in a regular transfer from any controller. */
#define MAX_TOUCH_DATA_BYTES      21

/*
 * A static queue of touch events is implemented such that new incoming
 * events are added to the head of the queue or front node while oldest
 * events are removed from the tail or rear node.
 */
touch_event_queue_t touch_event_queue;


/*****************************************************************************
*
* This function probes for a target slave device and can be used to
* discover the slave address of the touch controller.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u zed_ali3_controller_demo_probe_slave(zed_ali3_controller_demo_t *pDemo, int8u slave_address)
{
    int8u RegAddress  = 0x00;
    int8u RegData     = 0x00;  // Dummy data which does not actually get written out to slave device.
    int32u ret;

    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), slave_address, RegAddress, &RegData, 1);
    if (ret == -1)
    {
        //xil_printf("Error on reading slave device at address 0x%02X\n\r", slave_address);
        return -1;
    }
    else if (ret != 1)
    {
        //xil_printf("No response slave device at address 0x%02X\n\r", slave_address);

        return -2;
    }

    return 0;
}


/*****************************************************************************
*
* This function initializes the tracking for touch events then probes all
* addresses on the I2C bus for a recognizable target slave device in order
* to discover the slave address of the touch controller that is actually
* attached to the hardware platform.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_initialize(zed_ali3_controller_demo_t *pDemo)
{
    int8u slave_address;
	int32u index;
	int32u ret;

    // Initialize the global tracker for touch events.
	pDemo->touch_events = 0;
	pDemo->touch_duplicates = 0;
	pDemo->touch_irqs   = 0;
	pDemo->touch_overflows = 0;
    pDemo->touch_posx_cal   = 0x0000;
    pDemo->touch_posy_cal   = 0x0000;
    pDemo->touch_posx_raw   = 0x0000;
    pDemo->touch_posy_raw   = 0x0000;
    pDemo->touch_valid   = 0;
	pDemo->touch_pen_down = 0;

    // Initialize the controller specific information.
    pDemo->slave_touch_data_offset = 0;
    pDemo->slave_touch_report_length = 0;
    pDemo->touch_max_finger_count_supported = 0;

    // Set the first event slot to the start of the array.
    touch_event_queue.front_event = 0;
    touch_event_queue.rear_event = 0;

    // The ISR has not been entered yet.
    touch_event_queue.isr_flag = FALSE;

    // Iterate through the touch event queue and mark each event as unused.
    for (index = 0; index < TOUCH_QUEUE_SIZE; index++)
    {
        // Initialize the touch event by zeroing it out.
        touch_event_queue.touch_events[index].event_processed = 0;
    	touch_event_queue.touch_events[index].event_registered = 0;
    	touch_event_queue.touch_events[index].touch_location.position_x = 0;
    	touch_event_queue.touch_events[index].touch_location.position_y = 0;
    }

    /* Probe for attached slave devices. */
    for (slave_address = 0; slave_address < 127; slave_address++)
    {
        ret = zed_ali3_controller_demo_probe_slave(pDemo, slave_address);
        if (ret == 0)
        {
            /* Check to see if this is a supported touch controller slave
             * device. */
            if (slave_address == (int8u) dhelectronic)
            {
                xil_printf("DH Electronic slave device discovered at address 0x%02X\n\r", slave_address);
                pDemo->controller_type = dhelectronic;
            }
            else if (slave_address == (int8u) clicktouch)
            {
                xil_printf("Clicktouch slave device discovered at address 0x%02X\n\r", slave_address);
                pDemo->controller_type = clicktouch;
            }
            else
            {
                xil_printf("Unknown slave device discovered at address 0x%02X\n\r", slave_address);
            }
        }
        else if (ret == -1)
        {
            return -1;
        }

    }

    return 0;
}


/*****************************************************************************
*
* This function disables interrupts from the DH Electronic touch controller.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_disable_touch_dhelectronic(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = (int8u) dhelectronic;
    int8u RegAddress  = 0x00;
    int8u RegData     = 0x00; // [4] = INT disable, [0] = Touch disabled
    int8u ByteCount   = 1;
    int32u ret;

    // Write the control message to the TMG120 controller.
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

    if (ret != ByteCount)
    {
        xil_printf("ERROR : Failed to write Touch Controller\n\r");
        return -1;
    }

    return 0;
}


/*****************************************************************************
*
* This function disables interrupts from the attached touch controller.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_disable_touch(zed_ali3_controller_demo_t *pDemo)
{
    int32u ret;

    /* Based upon which controller was detected, setup the controller to
     * begin providing touch information. */
    if (pDemo->controller_type == dhelectronic)
    {
        /* Enable interrupt generation on the DE Electronic touch
         * controller slave. */
        ret = tmg120_disable_touch_dhelectronic(pDemo);
    }

    /* Check to see if a recognized touch controller was properly
     * initialized. */
    if (ret != 0)
    {
        xil_printf("ERROR : Failed to disable Touch Controller\n\r");
        return -1;
    }

    return 0;
}


/*****************************************************************************
*
* This function sets up and enables interrupts from the Clicktouch touch
* controller.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_enable_touch_clicktouch(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = (int8u) clicktouch;
    int8u RegAddress  = 0x00;
    int8u RegData[0x1A];
    int8u ByteCount   = 0x1A;
    int32u ret;

    /* Perform a reset request on the touch controller. */
    RegData[0] = 0x01;
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, 0x00, RegData, 1);

    sleep(1);

    RegData[0] = 0x00;

    /* Writing a single byte to this controller to set the address pointer
     * is a bit tricky because our IIC API will tell us that zero data bytes
     * have been written, which is true since we want just the address byte
     * written out.  As a result, checking the return value doesn't make
     * much sense because if something goes wrong we see a 0 and if
     * everything goes okay, we see a 0 anyways.
     *
     * Refer to the Touch Controller manufacturer documentation if it is not
     * clear why this is being done prior to the read operation.  */
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, 0);

    /* Read the touch data from the controller. */
    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
    if (ret != ByteCount)
    {
        xil_printf( "ERROR : Failed to read Touch Controller\n\r" );
        return -1;
    }

    /* Register 0x15 contains the maximum finger count for the touch
     * controller.  Verify that one or two fingers are supported. Then store
     * the touch data address offset information for this device.  */
    if ((RegData[0x15] == 1) || (RegData[0x15] == 2))
    {
        pDemo->touch_max_finger_count_supported = RegData[0x15];
        pDemo->slave_touch_data_offset = RegData[0x18];
    }

    /* Determine the total length of the I2C structure used to report touch
     * event information. */
    pDemo->slave_touch_report_length = RegData[0x19];

    /* Writing a single byte to this controller to set the address pointer
	 * is a bit tricky because our IIC API will tell us that zero data bytes
	 * have been written, which is true since we want just the address byte
	 * written out.  As a result, checking the return value doesn't make
	 * much sense because if something goes wrong we see a 0 and if
	 * everything goes okay, we see a 0 anyways.
	 *
	 * Refer to the Touch Controller manufacturer documentation if it is not
	 * clear why this is being done prior to the read operation.  */
	ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, 0x1A, RegData, 0);

	/* Read the touch data from the controller. */
	ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
	if (ret != ByteCount)
	{
		xil_printf( "ERROR : Failed to read Touch Controller\n\r" );
		return -1;
	}

    return 0;
}


/*****************************************************************************
*
* This function forces the Clicktouch touch controller to perform the
* baseline calibration/adjustment operation.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_baseline_clicktouch(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = (int8u) clicktouch;
    int8u RegData[0x01];
    int32u ret = 0;

    /* Perform a reset baseline request on the touch controller. */
    RegData[0] = 0x13;
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, 0x02, RegData, 1);

    sleep(1);

    /* Writing a single byte to this controller to set the address pointer
	 * is a bit tricky because our IIC API will tell us that zero data bytes
	 * have been written, which is true since we want just the address byte
	 * written out.  As a result, checking the return value doesn't make
	 * much sense because if something goes wrong we see a 0 and if
	 * everything goes okay, we see a 0 anyways.
	 *
	 * Refer to the Touch Controller manufacturer documentation if it is not
	 * clear why this is being done prior to the read operation.  */
	pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, 0x1A, RegData, 0);

    return ret;
}


/*****************************************************************************
*
* This function forces the Clicktouch touch controller to re-calibrate the
* IDAC and should be called when something in the environment changes
* like turning the display on or off.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_recalibrate_idac_clicktouch(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = (int8u) clicktouch;
    int8u RegData[0x01];
    int32u ret = 0;

    /* Perform the IDAC re-calibration on the touch controller. */
    RegData[0] = 0x14;
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, 0x02, RegData, 1);

    sleep(1);

    /* Writing a single byte to this controller to set the address pointer
	 * is a bit tricky because our IIC API will tell us that zero data bytes
	 * have been written, which is true since we want just the address byte
	 * written out.  As a result, checking the return value doesn't make
	 * much sense because if something goes wrong we see a 0 and if
	 * everything goes okay, we see a 0 anyways.
	 *
	 * Refer to the Touch Controller manufacturer documentation if it is not
	 * clear why this is being done prior to the read operation.  */
	pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, 0x1A, RegData, 0);

    return ret;
}


/*****************************************************************************
*
* This function forces the Clicktouch touch controller to reset.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_reset_clicktouch(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = (int8u) clicktouch;
    int8u RegData[0x01];
    int32u ret = 0;

    /* Perform a reset request on the touch controller. */
    RegData[0] = 0x01;
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, 0x00, RegData, 1);

    sleep(1);

    /* Writing a single byte to this controller to set the address pointer
	 * is a bit tricky because our IIC API will tell us that zero data bytes
	 * have been written, which is true since we want just the address byte
	 * written out.  As a result, checking the return value doesn't make
	 * much sense because if something goes wrong we see a 0 and if
	 * everything goes okay, we see a 0 anyways.
	 *
	 * Refer to the Touch Controller manufacturer documentation if it is not
	 * clear why this is being done prior to the read operation.  */
	pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, 0x1A, RegData, 0);

    return ret;
}


/*****************************************************************************
*
* This function sets up and enables interrupts from the DH Electronic touch
* controller.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_enable_touch_dhelectronic(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = (int8u) dhelectronic;
    int8u RegAddress  = 0x00;
    int8u RegData     = 0x11; // [4] = INT enabled, [0] = Touch enabled
    int8u ByteCount   = 1;
    int32u ret;

    /* Write the control message to the TMG120 controller. */
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

    if (ret != ByteCount)
    {
        xil_printf("ERROR : Failed to write Touch Controller\n\r");
        return -1;
    }

    return 0;
}


/*****************************************************************************
*
* This function sets up and enables interrupts from the attached touch
* controller.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_enable_touch(zed_ali3_controller_demo_t *pDemo)
{
    int32u ret;

    /* Based upon which controller was detected, setup the controller to
     * begin providing touch information. */
    if (pDemo->controller_type == dhelectronic)
    {
        /* Enable interrupt generation on the DE Electronic touch
         * controller slave. */
        ret = tmg120_enable_touch_dhelectronic(pDemo);
    }
    else if (pDemo->controller_type == clicktouch)
    {
        /* If the detected controller type was the Clicktouch controller,
         * the IIC operation must be changed over to the Direct Read
         * method. */
        ret = zed_iic_axi_set_read_direct(&(pDemo->touch_iic));
        if (!ret)
        {
            xil_printf("ERROR : Failed to make reads direct in ZED-IIC driver\n\r");
            return -1;
        }

        /* Enable interrupt generation on the touch controller slave. */
        ret = tmg120_enable_touch_clicktouch(pDemo);
    }

    /* Check to see if a recognized touch controller was properly
     * initialized. */
    if (ret != 0)
    {
        xil_printf("ERROR : Failed to initialize to a recognized Touch Controller\n\r");
        return -1;
    }

    return 0;
}


/*****************************************************************************
*
* This function flushes and existing registered touch events from the queue.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_flush_touch_events(zed_ali3_controller_demo_t *pDemo)
{
	int32u index;

    // Set the start of the queue to the end of the queue.
    touch_event_queue.front_event = touch_event_queue.rear_event;

    // Iterate through the touch event queue and mark each event as unused.
    for (index = 0; index < TOUCH_QUEUE_SIZE; index++)
    {
        // Initialize the touch event by zeroing it out.
        touch_event_queue.touch_events[index].event_processed = 0;
        touch_event_queue.touch_events[index].event_registered = 0;
        touch_event_queue.touch_events[index].touch_location.position_x = 0;
        touch_event_queue.touch_events[index].touch_location.position_y = 0;
    }

    return 0;
}


/*****************************************************************************
*
* This function uses raw touch information and correlates them to known
* locations on the display to compute the calibration matrix for all future
* touch events with the display panel + touch overlay hardware combination.
*
* As long as this combination of hardware remains the same, the calibration
* matrix should work fine across reboots and power cycles so the matrix
* coefficients should get stored off to non-volatile memory so that
* calibration does not have to be performed at each power on event.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_get_calibration_matrix(zed_ali3_controller_demo_t * pDemo,
    touch_calibration_data_t * touch_calibration_data,
    touch_calibration_matrix_t * touch_calibration_matrix)
{
    /* First step is to calculate the divisor which comes from the following
     * calculation:
     *
     * divisor = (Xraw1 - Xraw3)*(Yraw2 - Yraw3) - (Xraw2 - Xraw3)*(Yraw1 - Yraw3)
     */

    touch_calibration_matrix->divisor = ((touch_calibration_data->raw_touch_position1.position_x - touch_calibration_data->raw_touch_position3.position_x) *
            (touch_calibration_data->raw_touch_position2.position_y - touch_calibration_data->raw_touch_position3.position_y)) -
        ((touch_calibration_data->raw_touch_position2.position_x - touch_calibration_data->raw_touch_position3.position_x) *
            (touch_calibration_data->raw_touch_position1.position_y - touch_calibration_data->raw_touch_position3.position_y));

    // Check to see if the divisor is 0 because dividing by zero is illegal.
    if (touch_calibration_matrix->divisor == 0)
    {
        if (pDemo->bVerbose > 0)
        {
        	xil_printf("PCAP: Calibration failed, divisor=%4d\n\r", touch_calibration_matrix->divisor);
        }
    	return -1;
    }

    /* Next step is to calculate the An coefficient which comes from the
     * following calculation:
     *
     *       (Xref1 - Xref3)*(Yraw2 - Yraw3) - (Xref2 - Xref3)*(Yraw1 - Yraw3)
     * An = -------------------------------------------------------------------
     *                                  divisor
     */

    touch_calibration_matrix->An = ((touch_calibration_data->reference_touch_position1.position_x - touch_calibration_data->reference_touch_position3.position_x) *
            (touch_calibration_data->raw_touch_position2.position_y - touch_calibration_data->raw_touch_position3.position_y)) -
        ((touch_calibration_data->reference_touch_position2.position_x - touch_calibration_data->reference_touch_position3.position_x) *
            (touch_calibration_data->raw_touch_position1.position_y - touch_calibration_data->raw_touch_position3.position_y));

    /* Next step is to calculate the Bn coefficient which comes from the
     * following calculation:
     *
     *       (Xraw1 - Xraw3)*(Xref2 - Xref3) - (Xref1 - Xref3)*(Xraw2 - Xraw3)
     * Bn = -------------------------------------------------------------------
     *                                  divisor
     */

    touch_calibration_matrix->Bn = ((touch_calibration_data->raw_touch_position1.position_x - touch_calibration_data->raw_touch_position3.position_x) *
            (touch_calibration_data->reference_touch_position2.position_x - touch_calibration_data->reference_touch_position3.position_x)) -
        ((touch_calibration_data->reference_touch_position1.position_x - touch_calibration_data->reference_touch_position3.position_x) *
            (touch_calibration_data->raw_touch_position2.position_x - touch_calibration_data->raw_touch_position3.position_x));

    /* Next step is to calculate the Cn coefficient which comes from the
     * following calculation:
     *
     *       (Xraw3*Xref2 - Xraw2*Xref3)*Yraw1 + (Xraw1*Xref3 - Xraw3*Xref1)*Yraw2 + (Xraw2*Xref1 - Xraw1*Xref2)*Yraw3
     * Cn = -----------------------------------------------------------------------------------------------------------
     *                                                  divisor
     */

    touch_calibration_matrix->Cn = (touch_calibration_data->raw_touch_position3.position_x * touch_calibration_data->reference_touch_position2.position_x -
            touch_calibration_data->raw_touch_position2.position_x * touch_calibration_data->reference_touch_position3.position_x) * touch_calibration_data->raw_touch_position1.position_y +
        (touch_calibration_data->raw_touch_position1.position_x * touch_calibration_data->reference_touch_position3.position_x -
            touch_calibration_data->raw_touch_position3.position_x * touch_calibration_data->reference_touch_position1.position_x) * touch_calibration_data->raw_touch_position2.position_y +
        (touch_calibration_data->raw_touch_position2.position_x * touch_calibration_data->reference_touch_position1.position_x -
            touch_calibration_data->raw_touch_position1.position_x * touch_calibration_data->reference_touch_position2.position_x) * touch_calibration_data->reference_touch_position3.position_y;

    /* Next step is to calculate the Dn coefficient which comes from the
     * following calculation:
     *
     *       (Yref1 - Yref3)*(Yraw2 - Yraw3) - (Yref2 - Yref3)*(Yraw1 - Yraw3)
     * Dn = -------------------------------------------------------------------
     *                                  divisor
     */

    touch_calibration_matrix->Dn = ((touch_calibration_data->reference_touch_position1.position_y - touch_calibration_data->reference_touch_position3.position_y) *
            (touch_calibration_data->raw_touch_position2.position_y - touch_calibration_data->raw_touch_position3.position_y)) -
        ((touch_calibration_data->reference_touch_position2.position_y - touch_calibration_data->reference_touch_position3.position_y) *
            (touch_calibration_data->raw_touch_position1.position_y - touch_calibration_data->raw_touch_position3.position_y));

    /* Next step is to calculate the En coefficient which comes from the
     * following calculation:
     *
     *       (Xraw1 - Xraw3)*(Yref2 - Yref3) - (Yref1 - Yref3)*(Xraw2 - Xraw3)
     * En = -------------------------------------------------------------------
     *                                  divisor
     */

    touch_calibration_matrix->En = ((touch_calibration_data->raw_touch_position1.position_x - touch_calibration_data->raw_touch_position3.position_x) *
            (touch_calibration_data->reference_touch_position2.position_y - touch_calibration_data->reference_touch_position3.position_y)) -
        ((touch_calibration_data->reference_touch_position1.position_y - touch_calibration_data->reference_touch_position3.position_y) *
            (touch_calibration_data->raw_touch_position2.position_x - touch_calibration_data->raw_touch_position3.position_x));

    /* Final step is to calculate the Fn coefficient which comes from the
     * following calculation:
     *
     *       (Xraw3*Yref2 - Xraw2*Yref3)*Yraw1 + (Xraw1*Yref3 - Xraw3*Yref1)*Yraw2 + (Xraw2*Yref1 - Xraw1*Yref2)*Yraw3
     * Fn = -----------------------------------------------------------------------------------------------------------
     *                                                  divisor
     */

    touch_calibration_matrix->Fn = (touch_calibration_data->raw_touch_position3.position_x * touch_calibration_data->reference_touch_position2.position_y -
    		touch_calibration_data->raw_touch_position2.position_x * touch_calibration_data->reference_touch_position3.position_y) * touch_calibration_data->raw_touch_position1.position_y +
        (touch_calibration_data->raw_touch_position1.position_x * touch_calibration_data->reference_touch_position3.position_y -
            touch_calibration_data->raw_touch_position3.position_x * touch_calibration_data->reference_touch_position1.position_y) * touch_calibration_data->raw_touch_position2.position_y +
        (touch_calibration_data->raw_touch_position2.position_x * touch_calibration_data->reference_touch_position1.position_y -
            touch_calibration_data->raw_touch_position1.position_x * touch_calibration_data->reference_touch_position2.position_y) * touch_calibration_data->raw_touch_position3.position_y;

    if (pDemo->bVerbose > 0)
    {
        xil_printf("PCAP: Matrix Coefficients calculated, An=%d, Bn=%d, Cn=%d, Dn=%d, En=%d, Fn=%d, divisor=%d\n\r",
            touch_calibration_matrix->divisor,
            touch_calibration_matrix->An,
            touch_calibration_matrix->Bn,
            touch_calibration_matrix->Cn,
            touch_calibration_matrix->Dn,
            touch_calibration_matrix->En,
            touch_calibration_matrix->Fn);

        xil_printf("PCAP:  _    _     _          _     _    _ \n\r");
        xil_printf("PCAP: |      |   |            |   |      |\n\r");
        xil_printf("PCAP: | Xcal |   | An  Bn  Cn |   | Xraw |\n\r");
        xil_printf("PCAP: |      | = |            | * |      |\n\r");
        xil_printf("PCAP: | Ycal |   | Dn  En  Fn |   | Yraw |\n\r");
        xil_printf("PCAP: |_    _|   |_          _|   |      |\n\r");
        xil_printf("PCAP:                             |  1   |\n\r");
        xil_printf("PCAP:                             |_    _|\n\r");
        xil_printf("\n\r");
    }

    return 0;
}


/*****************************************************************************
*
* This function retrieves the raw coordinate data from the touch controller
* and should be called following an interrupt event from the Clicktouch
* slave touch controller.
*
* This function should not get called directly from the touch ISR but should
* be called indirectly via the tmg120_handle_touch_event() function so that
* the appropriate event queue overhead can be managed properly.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_handle_touch_event_clicktouch(zed_ali3_controller_demo_t *pDemo,
	touch_event_t *touch_event)
{
    int8u ChipAddress = (int8u) clicktouch;
    int8u RegAddress  = 0x00;
    int8u RegData[MAX_TOUCH_DATA_BYTES];
    int8u ByteCount   = 0;

    int32u ret;

    pDemo->touch_irqs++;

    /* Setup to perform the reading of touch data from the slave touch
     * controller. Each supported finger takes up 7 bytes of data with the
     * data for the first finger starting at offset */
    //RegAddress = pDemo->slave_touch_data_offset;
    RegAddress = 0x1A;
    ByteCount = 18;

    if (ByteCount > MAX_TOUCH_DATA_BYTES)
    {
        ByteCount = MAX_TOUCH_DATA_BYTES;
    }

    /* Read the touch data from the controller. */
    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
    if (!ret)
    {
        xil_printf( "ERROR : Failed to read Touch Controller\n\r" );
        return -1;
    }
	
    /* Extract the touch event information from the information read from
     * the touch controller device.  */
    touch_event->touch_location.position_x = ((int16u)(RegData[0x04]) << 8) | ((int16u)(RegData[0x05]));
    touch_event->touch_location.position_y = ((int16u)(RegData[0x06]) << 8) | ((int16u)(RegData[0x07]));
    touch_event->touch_gesture = (int8u)(RegData[0x01]);  // Read GEST_ID for event.
    touch_event->touch_finger_count = (int8u) (RegData[0x03] & 0x03); // Read finger count

    /* One thing that is useful to do is to filter out any touch events
     * that do not make any sense.  Usually X and Y locations reported at 1
     * are simply incomplete measurements and can safely be ignored as
     * invalid touch events.
     */
    if ((touch_event->touch_location.position_x == 1) ||
    	(touch_event->touch_location.position_y == 1) ||
    	(touch_event->touch_location.position_x == 799) ||
    	(touch_event->touch_location.position_y == 479))
    {
    	 touch_event->touch_finger_count = 0;
    }

    return 0;
}


/*****************************************************************************
*
* This function retrieves the raw coordinate data from the touch controller
* and should be called following an interrupt event from the DH Electronic
* slave touch controller.
*
* This function should not get called directly from the touch ISR but should
* be called indirectly via the tmg120_handle_touch_event() function so that
* the appropriate event queue overhead can be managed properly.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_handle_touch_event_dhelectronic(zed_ali3_controller_demo_t *pDemo,
	touch_event_t *touch_event)
{
    int8u ChipAddress = (int8u) dhelectronic;
    int8u RegAddress  = 0x07;
    int8u RegData[5];
    int8u ByteCount   = 5;
    int32u ret;

    /* Perform an I2C read of the DH Electronic touch controller to get the
     * latest coordinate information.  */
    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
    if (!ret)
    {
        xil_printf( "ERROR : Failed to read Touch Controller\n\r" );
        touch_event_queue.isr_flag = FALSE;
        return -1;
    }

    /* Extract the touch event information from the information read from
     * the touch controller device.  */
    touch_event->touch_finger_count = RegData[0];
    touch_event->touch_location.position_x = ((int16u)(RegData[1]) << 8) | ((int16u)(RegData[2]));
    touch_event->touch_location.position_y = ((int16u)(RegData[3]) << 8) | ((int16u)(RegData[4]));
    touch_event->touch_gesture = 0xFF;  // All touches have the same gesture.

    return 0;
}


/*****************************************************************************
*
* This function should get called from the touch ISR so that the appropriate
* slave touch controller can be probed to retrieve the coordinate data for
* the latest touch event.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_handle_touch_event(zed_ali3_controller_demo_t *pDemo)
{
    static int8u previous_touch_event;
    touch_event_t next_touch_event;
    int32u ret;

    next_touch_event.touch_finger_count = 0;
    next_touch_event.touch_gesture = 0;
    next_touch_event.touch_location.position_x = 0;
    next_touch_event.touch_location.position_y = 0;

    // Track each new IRQ being handled.
    pDemo->touch_irqs++;

    if (touch_event_queue.isr_flag == FALSE)
    {
        touch_event_queue.isr_flag = TRUE;
        pDemo->touch_valid++;
    }
    else
    {
        return -1;
    }

    /* Based upon which controller was detected, read coordinate information
     * from the controller. */
    if (pDemo->controller_type == dhelectronic)
    {
        /* Read touch information from the DE Electronic touch
         * controller slave. */
        ret = tmg120_handle_touch_event_dhelectronic(pDemo, &next_touch_event);
    }
    else if (pDemo->controller_type == clicktouch)
    {
        /* Read touch information from the Clicktouch touch
         * controller slave. */
        ret = tmg120_handle_touch_event_clicktouch(pDemo, &next_touch_event);
    }

    /* Check to see if a recognized touch controller was properly
     * initialized. */
    if (ret != 0)
    {
        xil_printf("ERROR : Failed to handle touch event from slave Touch Controller\n\r");
        return -1;
    }

    // Determine if the queue is empty or if it needs maintenance.
    if (touch_event_queue.front_event != touch_event_queue.rear_event)
    {
        /*
         * Do maintenance on the touch event queue by looking at the tail of
         * the queue and removing any registered events that are marked as
         * processed.
         */
        while (touch_event_queue.touch_events[touch_event_queue.rear_event].event_processed == 1)
        {
        	// Zero out the old touch event info to make debugging easier.
            touch_event_queue.touch_events[touch_event_queue.rear_event].event_processed = 0;
            touch_event_queue.touch_events[touch_event_queue.rear_event].event_registered = 0;
            touch_event_queue.touch_events[touch_event_queue.rear_event].touch_gesture = 0;
            touch_event_queue.touch_events[touch_event_queue.rear_event].touch_location.position_x = 0;
            touch_event_queue.touch_events[touch_event_queue.rear_event].touch_location.position_y = 0;

            // Update the rear of the queue to remove this event.
            if (touch_event_queue.rear_event == (TOUCH_QUEUE_SIZE - 1))
            {
                // The rear of the queue was at the top boundary of the array.
                touch_event_queue.rear_event = 0;
            }
            else
            {
                // The rear of the queue moves to the next location in the array.
                touch_event_queue.rear_event += 1;
            }
        }
    }

    /* If this is the first event that reports fingers down since they have
     * been lifted, then set the pen down indicator.
	 */
	if ((pDemo->touch_pen_down == 0) &&
		(next_touch_event.touch_finger_count == 1))
	{
		pDemo->touch_pen_down = 1;
		pDemo->touch_pen_down_transition = 1;
	}
	else if ((pDemo->touch_pen_down == 1) &&
			(next_touch_event.touch_finger_count == 0))
	{
		pDemo->touch_pen_down = 0;
		pDemo->touch_pen_down_transition = 0;
	}
	else
	{
		pDemo->touch_pen_down_transition = 0;
	}

    // If a new touch event has occurred, register it.
    if (((next_touch_event.touch_finger_count == 1) && (previous_touch_event == 0)) ||
    	((next_touch_event.touch_finger_count == 1) &&
        !((next_touch_event.touch_location.position_x == pDemo->touch_posx_raw) &&
          (next_touch_event.touch_location.position_y == pDemo->touch_posy_raw))))
    {
    	pDemo->touch_events++;
    }
    else
    {
    	// Duplicate touch information won't be recorded as an event.
    	touch_event_queue.isr_flag = FALSE;
    	pDemo->touch_duplicates++;

    	/*
		 * Record the touch event so that an up/down transition can be detected.
		 */
    	previous_touch_event = next_touch_event.touch_finger_count;
    	return 0;
    }

    /*
     * Record the touch event so that an up/down transition can be detected.
     */
    previous_touch_event = next_touch_event.touch_finger_count;

    // Determine if the touch event queue is full.
    if (((touch_event_queue.rear_event == 0) && (touch_event_queue.front_event == (TOUCH_QUEUE_SIZE - 1))) ||
        (touch_event_queue.front_event == (touch_event_queue.rear_event - 1)))
    {
        // The touch queue is full, the new event will be dropped.
    	touch_event_queue.isr_flag = FALSE;
    	pDemo->touch_overflows++;
        return -1;
    }
    else
    {
        // Add the new touch event to the current front of the queue.
        touch_event_queue.touch_events[touch_event_queue.front_event].event_registered = 1;
        touch_event_queue.touch_events[touch_event_queue.front_event].touch_gesture = next_touch_event.touch_gesture;
        touch_event_queue.touch_events[touch_event_queue.front_event].touch_location.position_x = next_touch_event.touch_location.position_x;
        touch_event_queue.touch_events[touch_event_queue.front_event].touch_location.position_y = next_touch_event.touch_location.position_y;
        touch_event_queue.touch_events[touch_event_queue.front_event].event_processed = 0;

        // Update the front of the queue.
        if (touch_event_queue.front_event == (TOUCH_QUEUE_SIZE - 1))
        {
            // The front of the queue was at the top boundary of the array.
            touch_event_queue.front_event = 0;
        }
        else
        {
            // The front of the queue moves to the next location in the array.
            touch_event_queue.front_event += 1;
    	}
    }

    touch_event_queue.isr_flag = FALSE;
    return 0;
}


/*****************************************************************************
*
* This function grabs the oldest touch event from the queue and updates the
* event queue accordingly.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_process_touch_event(zed_ali3_controller_demo_t *pDemo)
{
    int32u index;

    // Check to see if any touch locations are ready to be processed, this is done by determining if the queue is empty or if it needs maintenance.
    if (touch_event_queue.front_event == touch_event_queue.rear_event)
    {
    	return 0;
    }

    /*
     * Another possibility is that the queue has not been maintained yet, but
     * there are still unprocessed events in the queue.  Go through the queue
     * and search for unprocessed events and remove the one closest to the
     * current queue tail.
     */
    index = touch_event_queue.rear_event;

    while (touch_event_queue.touch_events[index].event_registered == 1)
    {
        // Check to see if the current event has been processed yet.
    	if (touch_event_queue.touch_events[index].event_processed == 0)
    	{
            /*
             * An unprocessed event has been found.  Copy the location and
             * gesture data before marking it as processed.
             */
    	    pDemo->touch_posx_raw = touch_event_queue.touch_events[index].touch_location.position_x;
            pDemo->touch_posy_raw = touch_event_queue.touch_events[index].touch_location.position_y;
            pDemo->touch_gesture = touch_event_queue.touch_events[index].touch_gesture;

            /* This touch event has now been processed and can be marked for
             * reuse.
             */
            touch_event_queue.touch_events[index].event_processed = 1;

            return 1;
        }

        // Check to see if the entire queue contents have been searched yet.
        if (index == touch_event_queue.front_event)
        {
        	// An exhaustive search with no unprocessed events.
        	return 0;
        }
        else
        {
            // Update the index to stay within queue bounds.
            if (index == (TOUCH_QUEUE_SIZE - 1))
        	{
                // The index was at the top boundary of the array.
                index = 0;
        	 }
        	 else
        	 {
        		 // The index moves to the next location in the array.
        		 index += 1;
        	 }
        }
    }

	return 0;
}

/*****************************************************************************
*
* This function reads touch coordinate data from the Clicktouch controller
* but does not update the event queue so it really should not get called
* except for debug purposes.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_read_touch_data_clicktouch(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = (int8u) clicktouch;
    int8u RegAddress  = 0x00;
    int8u RegData[0x1A];
    int8u ByteCount   = 0x1A;
    int32u ret;

    /* Writing a single byte to this controller to set the address pointer
     * is a bit tricky because our IIC API will tell us that zero data bytes
     * have been written, which is true since we want just the address byte
     * written out.  As a result, checking the return value doesn't make
     * much sense because if something goes wrong we see a 0 and if
     * everything goes okay, we see a 0 anyways.
     *
     * Refer to the Touch Controller manufacturer documentation if it is not
     * clear why this is being done prior to the read operation.  */
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, 0);

    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
    if (!ret)
    {
        xil_printf( "ERROR : Failed to read Touch Controller\n\r" );
        return -1;
    }

    xil_printf("PCAP: Host Mode: 0x%02X\n\r", RegData[0x00]);

    xil_printf("PCAP: FW: 0x%02X, Device: 0x%02X, Command=0x%02X, Status=0x%02X, XCOUNT=0x%02X, YCOUNT=0x%02X, XRES=0x%02X%02X, YRES=0x%02X%02X\n\r",
            RegData[0x0B], RegData[0x0C],
            RegData[0x02], RegData[0x0D],
            RegData[0x0F], RegData[0x10],
            RegData[0x11], RegData[0x12],
            RegData[0x13], RegData[0x14]);

    /* Print out details of device operation based upon data provided by
     * standard Clicktouch interface documentation.
     */

    /* Check to see what type of chip is being used on the touch controller. */
    if (RegData[0x0C] == 0x0A)
    {
        xil_printf("PCAP: Device Type:  CY8CTMG120, Gesture Support, Self Capacitive, GEN1\n\r");
    }

    /* Print out data on the sensor configuration. */
    xil_printf("PCAP: Sensor Config:  %d X plus %d Y sensors --> max. resolution of %dx%d\n\r", RegData[0x0F], RegData[0x10], ((int16u)(RegData[0x11]) << 8) | ((int16u)(RegData[0x12])), ((int16u)(RegData[0x13]) << 8) | ((int16u)(RegData[0x14])));
    xil_printf("PCAP: Sensor Config:  %d fingers supported at offset 0x%02X\n\r", RegData[0x15], RegData[0x18]);
    xil_printf("PCAP: Sensor Config:  %d buttons supported at offset 0x%02X\n\r", RegData[0x16], RegData[0x17]);

    return 0;
}


/*****************************************************************************
*
* This function reads touch coordinate data from the DH Electronic controller
* but does not update the event queue so it really should not get called
* except for debug purposes.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_read_touch_data_dhelectronic(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = 0x20;
    int8u RegAddress  = 0x00;
    int8u RegData[16];
    int8u ByteCount   = 16;
    int32u ret;

    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
    if (!ret)
    {
        xil_printf("ERROR : Failed to read Touch Controller\n\r");
        return -1;
    }

    xil_printf("PCAP: Command=0x%02X, Status=0x%02X, FWVersion=%d.%d, TouchDetect=%d, PosX=0x%02X%02X, PoxY=0x%02X%02X\n\r",
        RegData[ 0], RegData[ 1],
        RegData[ 2], RegData[ 3],
        RegData[ 7],
        RegData[ 8], RegData[ 9],
        RegData[10], RegData[11]
        );

    return 0;
}


/*****************************************************************************
*
* This function reads touch coordinate data from the appropriate slave touch
* controller but does not update the event queue so it really should not get
* called except for debug purposes.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_read_touch_data(zed_ali3_controller_demo_t *pDemo)
{
    int32u ret;

    /* Based upon which controller was detected, read coordinate information
     * from the controller. */
    if (pDemo->controller_type == dhelectronic)
    {
        /* Read touch information from the DE Electronic touch
         * controller slave. */
        ret = tmg120_read_touch_data_dhelectronic(pDemo);
    }
    else if (pDemo->controller_type == clicktouch)
    {
        /* Read touch information from the Clicktouch touch
         * controller slave. */
        ret = tmg120_read_touch_data_clicktouch(pDemo);
    }

    return ret;
}


/*****************************************************************************
*
* This function translates raw coordinate data (obtained directly from the
* touch controller) and uses the calibration matrix to translate the raw
* coordinate data into coordinates that are accurately mapped to the nearest
* adjacent pixel on the display panel.
*
* @param   None.
*
* @return  A status indicating 0 for success or something else for an error.
*
* @note        None.
*
****************************************************************************/
int32u tmg120_translate_location(zed_ali3_controller_demo_t * pDemo,
	touch_location_t * touch_location_raw,
	touch_location_t * touch_location_cal,
    touch_calibration_matrix_t * touch_calibration_matrix)
{
	/*
	 * Depending upon the sensor being used, the raw coordinate data
	 * requires translation using the calibration matrix.  Translate
	 * the touch location by using the latest touch calibration
	 * parameters.  For some sensors, the raw coordinate data can be used
	 * directly.
	 */
	if (pDemo->controller_type == dhelectronic)
	{
	    /*
	     * Use the supplied coefficients to calibrate the raw touch location
	     * to one that is mapped properly to the display.
	     */

	    /*
	     * For the calibrated x location, calculate according to this formula:
	     *
	     *         ((An * Xraw) + (Bn * Yraw) + Cn)
	     * Xcal = ---------------------------------
	     *                     divisor
	     */
	    touch_location_cal->position_x = ((touch_calibration_matrix->An * touch_location_raw->position_x) +
	        (touch_calibration_matrix->Bn * touch_location_raw->position_y) +
	        touch_calibration_matrix->Cn) / touch_calibration_matrix->divisor;

	    /*
	     * For the calibrated y location, calculate according to this formula:
	     *
	     *         ((Dn * Xraw) + (En * Yraw) + Fn)
	     * Ycal = ---------------------------------
	     *                     divisor
	     */
	    touch_location_cal->position_y = ((touch_calibration_matrix->Dn * touch_location_raw->position_x) +
	        (touch_calibration_matrix->En * touch_location_raw->position_y) +
	        touch_calibration_matrix->Fn) / touch_calibration_matrix->divisor;
	}
	else
	{
		touch_location_cal->position_x = touch_location_raw->position_x;
		touch_location_cal->position_y = touch_location_raw->position_y;
	}

    return 0;
}

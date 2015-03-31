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
// Tool versions:       ISE 14.4
//
// Description:         Implementation for interface to Avnet Touch Controller
//
// Dependencies:
//
// Revision:            Jun 03, 2013: 1.00 Created for Zed Display Kit
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "zed_ali3_controller_demo.h"
#include "types.h"
#include "tmg120.h"

/*
 * A static queue of touch events is implemented such that new incoming
 * events are added to the head of the queue or front node while oldest
 * events are removed from the tail or rear node.
 */
touch_event_queue_t touch_event_queue;

int32u tmg120_initialize(zed_ali3_controller_demo_t *pDemo)
{
	int32u index;

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

    return 0;
}

int32u tmg120_disable_touch(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = 0x20;
    int8u RegAddress  = 0x00;
    int8u RegData     = 0x00; // [4] = INT disable, [0] = Touch disabled
    int8u ByteCount   = 1;
    int32u ret;

    // Write the control message to the TMG120 controller.
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

    if (!ret)
    {
        xil_printf("ERROR : Failed to write Touch Controller\n\r");
        return -1;
    }

    return 0;
}

int32u tmg120_enable_touch(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = 0x20;
    int8u RegAddress  = 0x00;
    int8u RegData     = 0x11; // [4] = INT enabled, [0] = Touch enabled
    int8u ByteCount   = 1;
    int32u ret;

    // Write the control message to the TMG120 controller.
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, &RegData, ByteCount);

    if (!ret)
    {
        xil_printf("ERROR : Failed to write Touch Controller\n\r");
        return -1;
    }

    return 0;
}

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

int32u tmg120_handle_touch_event(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = 0x20;
    int8u RegAddress  = 0x07;
    int8u RegData[5];
    int8u ByteCount   = 5;
    static int8u previous_touch_event;
    int8u touch_event = RegData[0];
	int16u touch_posx = ((int16u)(RegData[1]) << 8) | ((int16u)(RegData[2]));
	int16u touch_posy = ((int16u)(RegData[3]) << 8) | ((int16u)(RegData[4]));
    int32u ret;

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

    // Perform an I2C read of the touch controller to get the latest coordinate information.
    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
    if (!ret)
    {
        xil_printf( "ERROR : Failed to read Touch Controller\n\r" );
        touch_event_queue.isr_flag = FALSE;
        return -1;
    }

    /*
     * Extract the touch event information from the information read from
     * the touch controller device.
     */
    touch_event = RegData[0];
	touch_posx = ((int16u)(RegData[1]) << 8) | ((int16u)(RegData[2]));
	touch_posy = ((int16u)(RegData[3]) << 8) | ((int16u)(RegData[4]));

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

    // If a new touch event has occurred, register it.
    if (((touch_event == 1) && (previous_touch_event == 0)) ||
    	((touch_event == 1) &&
        !((touch_posx == pDemo->touch_posx_raw) && (touch_posy == pDemo->touch_posy_raw))))
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
    	previous_touch_event = RegData[0];
    	return 0;
    }

   /*
    * Record the touch event so that an up/down transition can be detected.
    */
    previous_touch_event = RegData[0];

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
        touch_event_queue.touch_events[touch_event_queue.front_event].touch_location.position_x = touch_posx;
        touch_event_queue.touch_events[touch_event_queue.front_event].touch_location.position_y = touch_posy;
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
             * An unprocessed event has been found.  Copy the location data
             * and mark it as processed.
             */
            pDemo->touch_posx_raw = touch_event_queue.touch_events[index].touch_location.position_x;
            pDemo->touch_posy_raw = touch_event_queue.touch_events[index].touch_location.position_y;
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

int32u tmg120_read_touch_data(zed_ali3_controller_demo_t *pDemo)
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

int32u tmg120_translate_location(zed_ali3_controller_demo_t * pDemo,
	touch_location_t * touch_location_raw,
	touch_location_t * touch_location_cal,
    touch_calibration_matrix_t * touch_calibration_matrix)
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

    return 0;
}

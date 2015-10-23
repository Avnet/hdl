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
//                     Copyright(c) 2015 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         Oct 16, 2015
// Design Name:         Ampire Touch Interface
// Module Name:         ampire10.c
// Project Name:        ZedBoard ALI3 Display Kit
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        ZedBoard + ALI3 Display Kit
//
// Tool versions:       Vivado 2015.2
//
// Description:         Implemenation for interface to Touch Controller on 
//                      Avnet 10 inch display kit
//
// Dependencies:
//
// Revision:            Oct 16, 2015: 1.00 Created for Zed Display Kit
//
//----------------------------------------------------------------------------

#include <stdio.h>
#include "zed_ali3_controller_demo.h"
#include "types.h"
#include "ampire10.h"

/*
 * A static queue of touch events is implemented such that new incoming
 * events are added to the head of the queue or front node while oldest
 * events are removed from the tail or rear node.
 */
touch_event_queue_t touch_event_queue;

int32u ampire10_initialize(zed_ali3_controller_demo_t *pDemo)
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
    	touch_event_queue.touch_events[index].touch_pen_down_transition = 0;
    	touch_event_queue.touch_events[index].touch_location.position_x = 0;
    	touch_event_queue.touch_events[index].touch_location.position_y = 0;
    }

    return 0;
}

int32u ampire10_read_touch_model(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = 0x2a;
    int8u RegAddress  = 0x67;
    int8u RegData[67];
    int8u ByteCount   = 67;
    int32u ret;
    int i;

    // This reads the model number from the touch controller. The command must be sent twice to properly retrieve the data.

    RegData[0]=0x00;
    RegData[1]=0x42;
    RegData[2]=0x00;
    RegData[3]=0x03;
    RegData[4]=0x01;
    RegData[5]='E';
    RegData[6]=0x00;
    RegData[7]=0x00;
    RegData[8]=0x00;
//
    for (i=9;i<67;i++){
   	RegData[i]=0x00;
    }
    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);

    if (!ret)
    {
        xil_printf("ERROR : Failed to write Touch Controller\n\r");
        return -1;
    }


    ByteCount = 66;

    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
	if (!ret)
	{
		xil_printf("ERROR : Failed to read Touch Controller\n\r");
		return -1;
	}

	// This reads the model number from the touch controller. The command must be sent twice to properly retrieve the data.

    RegData[0]=0x00;
    RegData[1]=0x42;
    RegData[2]=0x00;
    RegData[3]=0x03;
    RegData[4]=0x01;
    RegData[5]='E';
    RegData[6]=0x00;
    RegData[7]=0x00;
    RegData[8]=0x00;
//
    for (i=9;i<67;i++){
   	RegData[i]=0x00;
    }

    ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);


    if (!ret)
    {
        xil_printf("ERROR : Failed to write Touch Controller\n\r");
        return -1;
    }

    ByteCount = 66;
    ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
	if (!ret)
	{
		xil_printf("ERROR : Failed to read Touch Controller\n\r");
		return -1;
	}


	RegData[16] = '\0';
	xil_printf("Touch Controller model: %s\n\r", &RegData[5]);

	// This section of code ensures that the touch controller internal data buffer is cleared before proceeding. If this is not done, data could be present in the internal buffer and the IRQ line won't reset
	while(1){
		RegData[0]=0x00;
		RegData[1]=0x42;
		RegData[2]=0x00;
		RegData[3]=0x06;
		RegData[4]=0x01;
		RegData[5]='A';
		RegData[6]=0x00;
		RegData[7]=0x00;
		RegData[8]=0x00;
	//
		for (i=9;i<67;i++){
		RegData[i]=0x00;
		}



		ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);

		if (!ret)
		{
			xil_printf("ERROR : Failed to write Touch Controller\n\r");
			return -1;
		}

		ByteCount = 66;
		ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
		if (!ret)
		{
			xil_printf("ERROR : Failed to read Touch Controller\n\r");
			return -1;
		}

		if ((RegData[7] == 255) &&(RegData[6] == 255)){   // this means that the internal buffer is clear and the IRQ line should now be reset
			return 0;
		}
	}

    return 0;
}

int32u ampire10_flush_touch_events(zed_ali3_controller_demo_t *pDemo)
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

int32u ampire10_get_calibration_matrix(zed_ali3_controller_demo_t * pDemo,
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
            touch_calibration_matrix->An,
            touch_calibration_matrix->Bn,
            touch_calibration_matrix->Cn,
            touch_calibration_matrix->Dn,
            touch_calibration_matrix->En,
            touch_calibration_matrix->Fn,
            touch_calibration_matrix->divisor
            );

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

int32u ampire10_handle_touch_event(zed_ali3_controller_demo_t *pDemo)
{
    int8u ChipAddress = 0x2A;
    int8u RegAddress  = 0x67;
    int8u RegData[65];
    int8u ByteCount   = 65;
    static int8u previous_touch_event;
    int8u pen_down_transition = 0;
    int8u touch_event;
    int8u touch_finger_count;
    int16u touch_posx;
	int16u touch_posy;
    int32u ret;
	int index;

    /////////////////////////////////////////////////////// This section inserted to handle Ampire 10" touch controller /////////////////////////////////////////////////////////
	//
	//    The ampire controller operates differently than previous touch conrtollers. The controller has an internal data buffer and the interrupt signal is held low any
	//	  time there is data in the buffer. It does NOT reset until all data has been read from the buffer. For a multi-touch even (like a swipe across the screen), the
	//	  controller could read multiple touch events and all of those events must be read before the IRQ line will be released. In addidtion, the controller packets must
	//    be the full 66 bytes in length, even though the data is only present in 4 of those bytes. Finally, the host must first write a 66 byte command packet to the
	//	  touch controller and then read a 66 byte packet back to retrieve each data event. Because of this overhead, it is highly recommended that the system be configured
	//    for the fastest I2C rate possible (ideally 400kHz). Slower data rates can result in problems because the host is not capable of reading the data fast enough to clear
	//    the controllers internal buffer.
	//
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
do{
	//Poll Touch Controller
	ByteCount = 65;

	RegData[0]=0x00;
	RegData[1]=0x42;
	RegData[2]=0x00;
	RegData[3]=0x06;
	RegData[4]=0x01;
	RegData[5]='A';
	RegData[6]=0x00;
	RegData[7]=0x00;
	RegData[8]=0x00;
//
	for (index=9; index < 67; index++)
	{
		RegData[index] = 0x00;
	}

	ret = pDemo->touch_iic.fpIicWrite(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);

	if (!ret)
	{
		xil_printf("ERROR : Failed to write Touch Controller\n\r");
		return -1;
	}

	ByteCount = 66;
	ret = pDemo->touch_iic.fpIicRead(&(pDemo->touch_iic), ChipAddress, RegAddress, RegData, ByteCount);
	if (!ret)
	{
		xil_printf("ERROR : Failed to read Touch Controller\n\r");
		return -1;
	}

	if ((RegData[7] == 255) &&(RegData[6] == 255))			// Queue is empty
	{
		return 0;
	}

	// configure data to match the byte structure from the touch panel
	RegData[0] = RegData[4];
	RegData[1] = RegData[7];
	RegData[2] = RegData[6];
	RegData[3] = RegData[9];
	RegData[4] = RegData[8];
	RegData[5] = RegData[5];

    /////////////////////////////////////////////////////// End of section added for Ampire 10" touch controller

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

    /*
     * Extract the touch event information from the information read from
     * the touch controller device.
     */
    touch_event = RegData[0];
	touch_posx = ((int16u)(RegData[1]) << 8) | ((int16u)(RegData[2]));
	touch_posy = ((int16u)(RegData[3]) << 8) | ((int16u)(RegData[4]));
	//touch_finger_count = RegData[5];
	touch_finger_count = RegData[0];

    /* If this is the first event that reports fingers down since they have
     * been lifted, then set the pen down indicator.
	 */
	if ((pDemo->touch_pen_down == 0) &&
		(touch_finger_count == 1))
	{
		pDemo->touch_pen_down = 1;
		pen_down_transition = 1;
	}
	else if ((pDemo->touch_pen_down == 1) &&
			(touch_finger_count == 0))
	{
		pDemo->touch_pen_down = 0;
		pen_down_transition = 0;
	}
	else
	{
		pen_down_transition = 0;
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
            touch_event_queue.touch_events[touch_event_queue.rear_event].touch_location.position_x = 0;
            touch_event_queue.touch_events[touch_event_queue.rear_event].touch_location.position_y = 0;
            touch_event_queue.touch_events[touch_event_queue.rear_event].touch_pen_down_transition = 0;

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
    previous_touch_event = touch_finger_count;;

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
        touch_event_queue.touch_events[touch_event_queue.front_event].touch_pen_down_transition = pen_down_transition;
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

}while (1);
    return 0;
}

int32u ampire10_process_touch_event(zed_ali3_controller_demo_t *pDemo)
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
            pDemo->touch_pen_down_transition = touch_event_queue.touch_events[index].touch_pen_down_transition;
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

int32u ampire10_read_touch_data(zed_ali3_controller_demo_t *pDemo)
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

int32u ampire10_translate_location(zed_ali3_controller_demo_t * pDemo,
	touch_location_t * touch_location_raw,
	touch_location_t * touch_location_cal,
    touch_calibration_matrix_t * touch_calibration_matrix)
{
	long long temp;
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
    temp = ((long long)((long long)touch_calibration_matrix->An * (long long)touch_location_raw->position_x) +
        ((long long)touch_calibration_matrix->Bn * (long long)touch_location_raw->position_y) +
        (long long)touch_calibration_matrix->Cn) / (long long)touch_calibration_matrix->divisor;
    touch_location_cal->position_x = temp;
    /*
     * For the calibrated y location, calculate according to this formula:
     *
     *         ((Dn * Xraw) + (En * Yraw) + Fn)
     * Ycal = ---------------------------------
     *                     divisor
     */
    temp = ((long long)((long long)touch_calibration_matrix->Dn * (long long)touch_location_raw->position_x) +
        ((long long)touch_calibration_matrix->En * (long long)touch_location_raw->position_y) +
        (long long)touch_calibration_matrix->Fn) / (long long)touch_calibration_matrix->divisor;
    touch_location_cal->position_y = temp;
    return 0;
}

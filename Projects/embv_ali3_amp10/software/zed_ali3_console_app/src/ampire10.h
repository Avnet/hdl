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
//    http://www.microzed.org
//
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
// Module Name:         ampire10.h
// Project Name:        ZedBoard ALI3 Display Kit
// Target Devices:      Zynq-7000 SoC
// Avnet Boards:        ZedBoard + ALI3 Display Kit
//
// Tool versions:       Vivado 2015.2
//
// Description:         Definitions for interface to Touch Controller on 
//                      Avnet 10 inch display kit
//
// Dependencies:
//
// Revision:            Oct 16, 2015: 1.00 Created for Zed Display Kit
//
//----------------------------------------------------------------------------

#ifndef __AMPIRE10_H__
#define __AMPIRE10_H__

#include "zed_ali3_controller_demo.h"
#include "types.h"

// Expand the touch queue size if the main processing loop takes a long time.
#define TOUCH_QUEUE_SIZE 100

/*
 * The touch location holds the raw X and Y coordinate data reported by the
 * touch sensor.
 */
struct struct_touch_location_t
{
    // Touch co-ordinate information.
    int16u position_x;
    int16u position_y;
};
typedef struct struct_touch_location_t touch_location_t;

// The touch event holds data relating to a touch event which includes
// the location reported by the touch sensor.
struct struct_touch_event_t
{
    /*
     * Main loop flag, if event registered and event processed is set to 0,
     * an ISR cannot cleanup this event.
     */
    int8u event_processed;

    // ISR flag, if set to 1, the ISR has written data to the event.
    int8u event_registered;

    // Indicates if the event occurred co-incident to an up to down
    // pen transition.
    int8u touch_pen_down_transition;

    // Touch co-ordinate information.
    touch_location_t touch_location;
};
typedef struct struct_touch_event_t touch_event_t;

struct struct_touch_event_queue_t
{
    int front_event;
    int rear_event;
    // ISR entry flag.
    BOOL isr_flag;
    touch_event_t touch_events[TOUCH_QUEUE_SIZE];
};
typedef struct struct_touch_event_queue_t touch_event_queue_t;

/*
 * The touch calibration data type holds the raw X and Y coordinate data
 * reported by the touch sensor which are referenced to the display points
 * on the display.  From this data, the calibration matrix can be determined
 * to map raw touch data to scaled/calibrated touch input.
 */
struct struct_touch_calibration_data_t
{
    // Raw touch co-ordinate information.
    touch_location_t raw_touch_position1;
    touch_location_t raw_touch_position2;
    touch_location_t raw_touch_position3;

    // Reference touch co-ordinate information.
    touch_location_t reference_touch_position1;
    touch_location_t reference_touch_position2;
    touch_location_t reference_touch_position3;
};
typedef struct struct_touch_calibration_data_t touch_calibration_data_t;

/*
 * The touch calibration matrix type holds the coordinate translation
 * coefficients needed to adjust a raw touch input location to the
 * a location that is mapped to the display geometry.
 */
struct struct_touch_calibration_matrix_t
{
    // Matrix coefficients.
    int32s An;
    int32s Bn;
    int32s Cn;
    int32s Dn;
    int32s En;
    int32s Fn;
    int32s divisor;
};
typedef struct struct_touch_calibration_matrix_t touch_calibration_matrix_t;

/*
 * Read the model number from the touch controller.
 */
int32u ampire10_read_touch_model(zed_ali3_controller_demo_t * pDemo);

/*
 * Call this from the main loop to remove all pending touch events.
 */
int32u ampire10_flush_touch_events(zed_ali3_controller_demo_t * pDemo);

/*
 * Calculates calibration matrix coefficients based upon raw touch data
 * and reference display location points.
 */
int32u ampire10_get_calibration_matrix(zed_ali3_controller_demo_t * pDemo,
    touch_calibration_data_t * touch_calibration_data,
    touch_calibration_matrix_t * touch_calibration_matrix);

/*
 * Call this initialize function before calling any other interfaces.
 */
int32u ampire10_initialize(zed_ali3_controller_demo_t * pDemo);

/*
 * Safe to call this from an ISR to add an event to the queue.
 */
int32u ampire10_handle_touch_event(zed_ali3_controller_demo_t * pDemo);

/*
 * Call this from the main loop to remove the next event.
 */
int32u ampire10_process_touch_event(zed_ali3_controller_demo_t * pDemo);

/*
 * Call this from the main loop to read raw touch data from the touch
 * controller.
 */
int32u ampire10_read_touch_data(zed_ali3_controller_demo_t * pDemo);

/*
 * Calculates a calibrated touch point from raw touch location using
 * calibration matrix coefficients.
 */
int32u ampire10_translate_location(zed_ali3_controller_demo_t * pDemo,
    touch_location_t * touch_location_raw,
    touch_location_t * touch_location_cal,
    touch_calibration_matrix_t * touch_calibration_matrix);

#endif // __AMPIRE10_H__

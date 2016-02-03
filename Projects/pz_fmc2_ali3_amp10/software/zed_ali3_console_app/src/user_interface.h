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
// Create Date:         May 31, 2013
// Design Name:         Zed Display Kit Getting Started Demo
// Module Name:         user_interface.h
// Project Name:        Zed Display Kit Getting Started Demo
// Target Devices:      Zynq-7
// Hardware Boards:     ZedBoard
//
//
// Tool versions:       ISE 14.5
//
// Description:
//                      ZedBoard ALI3 Controller Demonstration User Interface
//
// Dependencies:
//
// Revision:            May 31, 2013: 1.00 Initial version
//
//----------------------------------------------------------------------------

#ifndef __USER_INTERFACE_H__
#define __USER_INTERFACE_H__

#include "xparameters.h"
#include "types.h"

#include "sleep.h"

#include "zed_iic.h"

#include "xaxivdma.h"
#include "video_resolution.h"
#include "video_frame_buffer.h"

// Define some basic colors:
#define COLOR_BLACK          0x00000000
#define COLOR_WHITE          0x00FFFFFF

// Define the Alpha Channel Mask
#define ALPHA_MASK          0xFF000000
/*
 * The touch location holds the raw X and Y coordinate data reported by the
 * touch sensor.
 */
struct struct_display_location_t
{
    // Display co-ordinate information.
    int16u position_x;
    int16u position_y;
};
typedef struct struct_display_location_t display_location_t;

// This structure defines information needed for interface graphics on the
// Zed Display Kit Demonstration
struct struct_interface_graphic_t
{
    int32u location_x;
    int32u location_y;
    int32u size_x;
    int32u size_y;
    int32u* default_image_data;
    int32u* alternate_image_data;
};
typedef struct struct_interface_graphic_t interface_graphic_t;

int draw_blank_screen(zed_ali3_controller_demo_t * pDemo, int32u screen_color);
int draw_image_data(zed_ali3_controller_demo_t * pDemo, interface_graphic_t * pGraphic);
int draw_touch_target(zed_ali3_controller_demo_t * pDemo, interface_graphic_t * pGraphic, display_location_t * pLocation);

#endif // __USER_INTERFACE__

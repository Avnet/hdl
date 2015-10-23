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
//                     Copyright(c) 2013 Avnet, Inc.
//                             All rights reserved.
//
//----------------------------------------------------------------------------
//
// Create Date:         May 31, 2013
// Design Name:         ZedBoard ALI3 Controller Demonstration
// Module Name:         user_interface.c
// Project Name:        ZedBoard ALI3 Display Kit
// Target Devices:      Zynq-7000
// Hardware Boards:     ZedBoard + ALI3 Display Kit
//
// Tool versions:       ISE Design Suite 14.5 / Vivado 2013.1
//
// Description:         ZedBoard ALI3 Controller Demonstration User Interface
//
// Dependencies:
//
// Revision:            May 31, 2013: 1.00 Initial version
//
//----------------------------------------------------------------------------

#include <stdio.h>

#include "zed_ali3_controller_demo.h"
#include "user_interface.h"

int draw_blank_screen(zed_ali3_controller_demo_t * pDemo, int32u screen_color)
{
    int32u frame, row, col;
    int32u pixel;
    volatile int32u *pStorageMem = (int32u *) pDemo->uBaseAddr_MEM_FrameBuffer;

    // Blank the screen,
    for (frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++)
    {
        for (row = 0; row < pDemo->ali3_height; row++)
        {
            for (col = 0; col < pDemo->ali3_width; col++)
            {
                pixel = screen_color;
                *pStorageMem++ = pixel;
            }
        }
    }

    return 0;
}

int draw_image_data(zed_ali3_controller_demo_t *pDemo, interface_graphic_t * pGraphic)
{
    int32u frame, row, col;
    int32u pixel;
    volatile int32u *pStorageMem = (int32u *) pDemo->uBaseAddr_MEM_FrameBuffer;

    for (frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++)
    {
        // Move memory pointer to the first row to be modified.
        pStorageMem += pDemo->ali3_width * (pGraphic->location_y);

        for (row = 0; row < pGraphic->size_y; row++)
        {
        	// Move memory pointer to the first row to be modified.
        	pStorageMem += pGraphic->location_x;

            for (col = 0; col < pGraphic->size_x; col++)
            {
                // Grab the next pixel data from the static image array.
                pixel = pGraphic->default_image_data[((row * pGraphic->size_x) + col)];

                /*
                 * Check to see if the alpha mask on this pixel indicates a
                 * transparency.  Right now we only support 0% and 100%
                 * transparency modes.
                 */
                if ((pixel & ALPHA_MASK) != ALPHA_MASK)
                {
                    // Store the next pixel into the frame buffer space.
                    *(volatile int32u *) pStorageMem = pixel;
                }

                // Increment the display memory pointer.
                pStorageMem += 1;
            }

            // Move memory pointer to the next row.
            pStorageMem += (pDemo->ali3_width - (pGraphic->size_x + pGraphic->location_x));
        }

        // Move memory pointer to the next frame.
        pStorageMem += pDemo->ali3_width * (pDemo->ali3_height - (pGraphic->size_y + pGraphic->location_y));
    }

    return 0;
}

int draw_touch_target(zed_ali3_controller_demo_t * pDemo, interface_graphic_t * pGraphic, display_location_t * pLocation)
{
    int32u frame, row, col;
    int32u pixel;
    volatile int32u *pStorageMem = (int32u *) pDemo->uBaseAddr_MEM_FrameBuffer;

    // Blank the screen,
    draw_blank_screen(pDemo, COLOR_BLACK);

    // Draw touch target cross hair to the display.
    for (frame = 0; frame < pDemo->uNumFrames_FrameBuffer; frame++)
    {
        // Move memory pointer to the first row to be modified.
        pStorageMem += pDemo->ali3_width * (pGraphic->location_y);

        for (row = 0; row < pGraphic->size_y; row++)
        {
            // Move memory pointer to the first row to be modified.
            pStorageMem += pGraphic->location_x;

            for (col = 0; col < pGraphic->size_x; col++)
            {
                // Grab the next pixel data from the static image array.
                pixel = pGraphic->default_image_data[((row * pGraphic->size_x) + col)];
                // Store the next pixel into the frame buffer space.
                *(volatile int32u *) pStorageMem++ = pixel;
            }

            // Move memory pointer to the next row.
            pStorageMem += (pDemo->ali3_width - (pGraphic->size_x + pGraphic->location_x));
        }

        // Move memory pointer to the next frame.
        pStorageMem += pDemo->ali3_width * (pDemo->ali3_height - (pGraphic->size_y + pGraphic->location_y));
    }

    return 0;
}

#ifndef ADV7511_H_
#define ADV7511_H_

#include "xil_types.h"
#include "xiicps.h"
#include "xiicps_ext.h"

////////////////////////////////////////////////////////////////////////
// HDMI Output Configuration Functions
////////////////////////////////////////////////////////////////////////

static u8 iic_hdmi_config[][2] = {
	{ 0xD6, 0xC0 }, // Fix HPD high
	{ 0x41, 0x10 }, // Power down control

    { 0x98, 0x03 }, // ADI Recommended Write
    { 0x99, 0x02 }, // ADI Recommended Write
    { 0x9A, 0xE0 }, // ADI Recommended Write
    { 0x9C, 0x30 }, // PLL Filter R1 Value
    { 0x9D, 0x61 }, // Set clock divide
    { 0xA2, 0xA4 }, // ADI Recommended Write
    { 0xA3, 0xA4 }, // ADI Recommended Write
    { 0xA5, 0x44 }, // ADI Recommended Write
    { 0xAB, 0x40 }, // ADI Recommended Write

    { 0xBA, 0xA0 }, // Programmable delay for input video clock = 101 = +0.8ns
    { 0xD0, 0x00 }, // Delay adjust for negative DDR capture = disabled
    { 0xD1, 0xFF }, // ADI Recommended Write
    { 0xDE, 0x9C }, // ADI Recommended Write
    { 0xE0, 0xD0 }, // ADI Recommended Write
    { 0xE4, 0x60 }, // VCO_Swing_Reference_Voltage
    { 0xF9, 0x00 }, // VCO_Swing_Reference_Voltage

    { 0x15, 0x02 }, // Input YCbCr 4:2:2 with embedded syncs
    { 0x16, 0x38 }, // Output Format 444, Input Color Depth = 8
    { 0x18, 0xC6 }, // CSC

    { 0x40, 0x80 }, // General Control packet enable
    { 0x48, 0x10 }, // Video Input Justification
    { 0x49, 0xA8 }, // Bit trimming mode = 101010 (truncate)
    { 0x4C, 0x00 }, // Color Depth = 0000 (color depth not indicated)
    { 0x55, 0x00 }, // Set RGB in AVinfo Frame

    { 0x56, 0x08 }, // Aspect Ratio
    { 0xAF, 0x04 }, // Set HDMI Mode

    { 0x01, 0x00 }, // Set N Value = 6144 (0x001800) for 48 kHz
    { 0x02, 0x18 }, //
    { 0x03, 0x00 }, //

    { 0x0A, 0x10 }, //
    { 0x0B, 0x8E }, //
    { 0x0C, 0x00 }, //
    { 0x73, 0x01 }, //
    { 0x14, 0x02 }, //

    { 0x96, 0x20 }, // HPD interrupt clear
    { 0xFA, 0x00 }, //

    { 0x30, 0x16 }, // Hsync placement = 0001011000 (0x58) = 88
    { 0x31, 0x02 }, // Hsync duration  = 0000101100 (0x2C) = 44
    { 0x32, 0xC0 }, //
    { 0x33, 0x10 }, // Vsync placement = 0000000100 (0x04) =  4
    { 0x34, 0x05 }, // Vsync duration  = 0000000101 (0x05) =  5
    { 0x17, 0x00 },  // VSync Polarity = 0(high), HSync Polarity = 0(high)

    { 0xDE, 0xAD } //
};

void adv7511_configure(XIicPs *pInstance);

#endif /* ADV7511_H_ */

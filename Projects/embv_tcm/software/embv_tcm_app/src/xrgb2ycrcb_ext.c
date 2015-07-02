/*
 * xrgb2ycrcb_ext.c
 *
 *  Created on: Jun 23, 2015
 *      Author: 910560
 */

#include "xrgb2ycrcb_ext.h"

void XRgb2YCrCb_Configuration(XRgb2YCrCb *InstancePtr,
				enum XRgb_Standards StandardSel,
				enum XRgb_OutputRanges InputRange, u32 DataWidth) {

	struct XRgb2YCrCb_Coef_Inputs CoefIn;
	struct XRgb2YCrCb_Coef_Outputs CoefOut;

	/* Setup CoefIn for XRGB_STANDARD_ITU_601_SD, 16_to_240_for_TV
	 * and data width of 8-bits.
	 * enum Standards are:
	 *	0 = XRGB_STANDARD_ITU_601_SD
	 *	1 = XRGB_STANDARD_ITU_709_NTSC
	 *	2 = XRGB_STANDARD_ITU_709_PAL
	 *	3 = XRGB_STANDARD_YUV.
	 */
	XRgb2YCrCb_Select_Standard(InstancePtr, StandardSel,
				XRGB_TV_16_TO_240, DataWidth,
					&CoefIn);

	/* Translate into RGB2YCrCb core coefficients */
	XRgb2YCrCb_Coefficient_Translation(InstancePtr,
				&CoefIn, &CoefOut, DataWidth);

	/* Program the new RGB2YCrCb core coefficients */
	XRgb2YCrCb_SetCoefs(InstancePtr, CoefIn.ACoef, CoefIn.BCoef,
				CoefIn.CCoef, CoefIn.DCoef);

	/* Set output range */
	XRgb2YCrCb_Select_OutputRange(InstancePtr, InputRange);

	/* Set the offsets
	 * For 8-bit color:  Valid range = [0, 255]
	 * For 10-bit color: Valid range = [0, 1023]
	 * For 12-bit color: Valid range = [0, 4095]
	 * For 16-bit color: Valid range = [0, 65535]
	 */
	XRgb2YCrCb_SetYOffset(InstancePtr, CoefOut.YOffset);
	XRgb2YCrCb_SetCbOffset(InstancePtr, CoefOut.CbOffset);
	XRgb2YCrCb_SetCrOffset(InstancePtr, CoefOut.CrOffset);

	/* Set the Clip/Clamp
	 * For 8-bit color:  Valid range = [0,   255]
	 * For 10-bit color: Valid range = [0,  1023]
	 * For 12-bit color: Valid range = [0,  4095]
	 * For 16-bit color: Valid range = [0, 65535]
	 */
	XRgb2YCrCb_SetYMax(InstancePtr, CoefOut.YMax);
	XRgb2YCrCb_SetYMin(InstancePtr, CoefOut.YMin);
	XRgb2YCrCb_SetCbMax(InstancePtr, CoefOut.CbMax);
	XRgb2YCrCb_SetCbMin(InstancePtr, CoefOut.CbMin);
	XRgb2YCrCb_SetCrMax(InstancePtr, CoefOut.CrMax);
	XRgb2YCrCb_SetCrMin(InstancePtr, CoefOut.CrMin);
}

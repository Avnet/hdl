/*
 * xcresample_ext.c
 *
 *  Created on: Jun 23, 2015
 *      Author: 910560
 */

#include "xcresample_ext.h"

void XCresample_Configuration(XCresample *InstancePtr) {

	XHorizontal_Coeffs CoefH =
		{.HCoeff = {{-2,-1,-1.23,0,0.1234,-1.78,0,0.9,0.8,0.0123,0,-1,
			     -1.23,-1.567,-1,0,1.527,1,1.9,0,-1,0,1.89,-2},
		      {-1,-1,0,0,1,0,1,-1,0,1,0,1,0,1,-1,1,-1,1,0,1,0,1,1,1}}};
	XVertical_Coeffs CoefV = {.VCoeff = {{-2,1.1,-1,0,0.1,-2,-1.98,1.98},
			   {0,1,0,1,-2,1,0,1} }};
	u32 HPhases;
	u32 VPhases;

	/* For 4:4:4 to 4:2:2 conversion */
	/*
	 * Horizontal filter phase 0 coefficients needs to be set.
	 * NumHTaps should be configured to odd numbers
	 * (3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23).
	 * API used is XCresample_SetHCoefs.
	 */
	if ((InstancePtr->Config.NumHTaps % 2) != 0) {
	HPhases = 0;
	/* Clear all Horizontal and Vertical coefficients before setting */
	XCresample_Clear_VCoef_Values(InstancePtr);
	XCresample_SetHCoefs(InstancePtr, &CoefH, HPhases);
	}

	/* For 4:2:2 to 4:4:4 conversion */
	/*
	 * Horizontal filter phase 1 coefficients needs to be set.
	 * NumHTaps should be configured to even numbers
	 * (2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24).
	 * API used is XCresample_SetHCoefs.
	 */
	if ((InstancePtr->Config.NumHTaps % 2) == 0) {
	HPhases = 1;
	/* Clear all Horizontal and Vertical coefficients before setting */
	XCresample_Clear_VCoef_Values(InstancePtr);
	XCresample_SetHCoefs(InstancePtr, &CoefH, HPhases);
	}

	/* For 4:2:2 to 4:2:0 conversion */
	/*
	 * Vertical filter phase 0 coefficients needs to be set.
	 * NumVTaps should be configured to even numbers(2, 4, 6, 8).
	 * API used is XCresample_SetVCoefs.
	 */
	if ((InstancePtr->Config.NumVTaps % 2) == 0) {
	VPhases = 0;
	/* Clear all Horizontal and Vertical coefficients before setting */
	XCresample_Clear_HCoef_Values(InstancePtr);
	XCresample_SetVCoefs(InstancePtr, &CoefV, VPhases);
	}

	/* For 4:2:0 to 4:2:2 conversion */
	/*
	 * Vertical filter phase 1 coefficients needs to be set.
	 * NumVTaps should be configured to even numbers(2, 4, 6, 8).
	 * API used is XCresample_SetVCoefs.
	 */
	if ((InstancePtr->Config.NumVTaps % 2) == 0) {
	VPhases = 0;
	/* Clear all Horizontal and Vertical coefficients before setting */
	XCresample_Clear_HCoef_Values(InstancePtr);
	XCresample_SetVCoefs(InstancePtr, &CoefV, VPhases);
	}

	/* For 4:4:4 to 4:2:0 conversion */
	/*
	 * Vertical filter phase 0 and Horizontal filter phase 0
	 * coefficients needs to be set.
	 * NumVTaps should be configured to even numbers(2, 4, 6, 8).
	 * NumHTaps should be configured to odd numbers
	 * (3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23).
	 * APIs used are XCresample_SetHCoefs and XCresample_SetVCoefs.
	 */
	if (((InstancePtr->Config.NumVTaps % 2) == 0) &&
			((InstancePtr->Config.NumHTaps % 2) != 0)) {
	VPhases = 0;
	HPhases = 0;
	XCresample_SetHCoefs(InstancePtr, &CoefH, HPhases);
	XCresample_SetVCoefs(InstancePtr, &CoefV, VPhases);
	}

	/* For 4:2:0 to 4:4:4 conversion */
	/*
	 * Vertical filter phase 0 and 1 and Horizontal filter phase 1
	 * coefficients needs to be set.
	 * NumVTaps should be configured to even numbers(2, 4, 6, 8).
	 * NumHTaps should be configured to even numbers
	 * (2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24).
	 * APIs used are XCresample_SetHCoefs and XCresample_SetVCoefs.
	 */
	if (((InstancePtr->Config.NumVTaps % 2) == 0) &&
			((InstancePtr->Config.NumHTaps % 2) == 0)) {
	VPhases = 2;
	HPhases = 1;
	XCresample_SetHCoefs(InstancePtr, &CoefH, HPhases);
	XCresample_SetVCoefs(InstancePtr, &CoefV, VPhases);
	}
}

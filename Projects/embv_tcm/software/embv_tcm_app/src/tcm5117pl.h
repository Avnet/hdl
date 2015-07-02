/*
 * tcm5117pl.h
 *
 *  Created on: Nov 5, 2014
 *      Author: 910560
 */

#ifndef TCM5117PL_H_
#define TCM5117PL_H_

#include "xiicps.h"

#define TCM5117PL_VGAP60	0x00
#define TCM5117PL_720P60	0x01
#define TCM5117PL_1080P15	0x02
#define TCM5117PL_1080P30   0x03
#define TCM5117PL_1080P60   0x04

void tcm5117pl_get_chip_id(XIicPs *pInstance);
void tcm5117pl_init(XIicPs *pInstance, int configuration);

#endif /* TCM5117PL_H_ */

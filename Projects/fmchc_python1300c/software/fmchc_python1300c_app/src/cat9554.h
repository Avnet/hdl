// ----------------------------------------------------------------------------
//  
//        ** **        **          **  ****      **  **********  ********** ® 
//       **   **        **        **   ** **     **  **              ** 
//      **     **        **      **    **  **    **  **              ** 
//     **       **        **    **     **   **   **  *********       ** 
//    **         **        **  **      **    **  **  **              ** 
//   **           **        ****       **     ** **  **              ** 
//  **  .........  **        **        **      ****  **********      ** 
//     ........... 
//                                     Reach Further™ 
//  
// ----------------------------------------------------------------------------
// 
// This design is the property of Avnet.  Publication of this 
// design is not authorized without written consent from Avnet. 
// 
// Please direct any questions to the PicoZed community support forum: 
//    http://www.zedboard.org/forum 
// 
// Disclaimer: 
//    Avnet, Inc. makes no warranty for the use of this code or design. 
//    This code is provided  "As Is". Avnet, Inc assumes no responsibility for 
//    any errors, which may appear in this code, nor does it make a commitment 
//    to update the information contained herein. Avnet, Inc specifically 
//    disclaims any implied warranties of fitness for a particular purpose. 
//                     Copyright(c) 2017 Avnet, Inc. 
//                             All rights reserved. 
// 
// ----------------------------------------------------------------------------

#ifndef PCA9534_H_
#define PCA9534_H_

#include "fmc_iic.h"

#define PCA9534_INPUT_REG  0x00
#define PCA9534_OUTPUT_REG  0x01
#define PCA9534_POLINV_REG  0x02
#define PCA9534_CONFIG_REG  0x03

void cat9554_initialize(fmc_iic_t *pInstance);
void cat9554_vdd18_en(fmc_iic_t *pInstance);
void cat9554_vdd33_en(fmc_iic_t *pInstance);
void cat9554_vddpix_en(fmc_iic_t *pInstance);

void cat9554_vdd18_off(fmc_iic_t *pInstance);
void cat9554_vdd33_off(fmc_iic_t *pInstance);
void cat9554_vddpix_off(fmc_iic_t *pInstance);

#endif /* PCA9534_H_ */

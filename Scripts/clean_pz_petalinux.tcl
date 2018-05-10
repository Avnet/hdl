# ----------------------------------------------------------------------------
#
#        ** **        **          **  ****      **  **********  ********** ®
#       **   **        **        **   ** **     **  **              **
#      **     **        **      **    **  **    **  **              **
#     **       **        **    **     **   **   **  *********       **
#    **         **        **  **      **    **  **  **              **
#   **           **        ****       **     ** **  **              **
#  **  .........  **        **        **      ****  **********      **
#     ...........
#                                     Reach Further™
#
# ----------------------------------------------------------------------------
# 
#  This design is the property of Avnet.  Publication of this
#  design is not authorized without written consent from Avnet.
# 
#  Please direct any questions to the PicoZed community support forum:
#     http://www.picozed.org/forum
# 
#  Product information is available at:
#     http://www.picozed.org/product/picozed
# 
#  Disclaimer:
#     Avnet, Inc. makes no warranty for the use of this code or design.
#     This code is provided  "As Is". Avnet, Inc assumes no responsibility for
#     any errors, which may appear in this code, nor does it make a commitment
#     to update the information contained herein. Avnet, Inc specifically
#     disclaims any implied warranties of fitness for a particular purpose.
#                      Copyright(c) 2018 Avnet, Inc.
#                              All rights reserved.
# 
# ----------------------------------------------------------------------------

#
# Remove PicoZed FMC2 Carrier project folders
#

# Clean PetaLinux BSP hardware platform design for PicoZed FMC2 Carrier
cd ../Projects/pz_petalinux/

# Remove .Xil folder.
file delete -force .Xil/

# Remove PZ7010_FMC2 folder.
file delete -force PZ7010_FMC2/

# Remove PZ7015_FMC2 folder.
file delete -force PZ7015_FMC2/

# Remove PZ7020_FMC2 folder.
file delete -force PZ7020_FMC2/

# Remove PZ7030_FMC2 folder.
file delete -force PZ7030_FMC2/

# Go back to the scripts folder so that the next make script can be launched.
cd ../../Scripts/
##----------------------------------------------------------------
##      _____
##     /     \
##    /____   \____
##   / \===\   \==/
##  /___\===\___\/  AVNET
##       \======/
##        \====/    
##---------------------------------------------------------------
##
## This design is the property of Avnet.  Publication of this
## design is not authorized without written consent from Avnet.
## 
## Please direct any questions to:  technical.support@avnet.com
##
## Disclaimer:
##    Avnet, Inc. makes no warranty for the use of this code or design.
##    This code is provided  "As Is". Avnet, Inc assumes no responsibility for
##    any errors, which may appear in this code, nor does it make a commitment
##    to update the information contained herein. Avnet, Inc specifically
##    disclaims any implied warranties of fitness for a particular purpose.
##                     Copyright(c) 2011 Avnet, Inc.
##                             All rights reserved.
##
##----------------------------------------------------------------
##
## Create Date:         June 16, 2015
## Design Name:         FMC-HDMI-CAM
## Module Name:         fmc_imageon_sw_v2_1_0.mld
## Project Name:        FMC-HDMI-CAM
## Target Devices:      Artix-7, Kintex-7, Virtex-7, Zynq
## Avnet Boards:        FMC-HDMI-CAM
##
## Tool versions:       Vivado 2014.4
##
## Description:         FMC-HDMI-CAM Software Services
##                      Makefile
##
## Dependencies:        
##
## Revision:            Jun 16, 2015: 2.01 Copied from FMC-IMAGEON
##
##----------------------------------------------------------------

COMPILER=
ARCHIVER=
CP=cp
COMPILER_FLAGS=
EXTRA_COMPILER_FLAGS=
LIB=libxil.a

RELEASEDIR=../../../lib
INCLUDEDIR=../../../include
INCLUDES=-I./. -I${INCLUDEDIR}

INCLUDEFILES=*.h
LIBSOURCES=*.c
OUTS = *.o

libs:
	echo "Compiling fmc_hdmi_cam_sw"
	$(COMPILER) $(COMPILER_FLAGS) $(EXTRA_COMPILER_FLAGS) $(INCLUDES) $(LIBSOURCES)
	$(ARCHIVER) -r ${RELEASEDIR}/${LIB} ${OUTS}
	make clean

include:
	${CP} $(INCLUDEFILES) $(INCLUDEDIR)

clean:
	rm -rf ${OUTS}


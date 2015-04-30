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
##                     Copyright(c) 2010 Avnet, Inc.
##                             All rights reserved.
##
##----------------------------------------------------------------
##
## Create Date:         Jan 08, 2010
## Design Name:         FMC-IIC
## Module Name:         Makefile
## Project Name:        FMC-IIC
## Target Devices:      Spartan-6, Virtex-6, Kintex-7, Zynq
## Avnet Boards:        FMC-IMAGEOV, FMC-DVI/DP, FMC-ISM
##                      FMC-IMAGEON, FMC-MOTORTI
##
## Tool versions:       ISE 13.4
##
## Description:         FMC-IIC Software Services
##                      Makefile
##
## Dependencies:        
##
## Revision:            Jan 08, 2010: 1.00 Initial version
##                      Jan 12, 2010: 1.01 Add support for >256 EEPROMs
##                      Jun 23, 2010: 1.02 Remove malloc from code
##                      ------------------------------------------
##                      Apr 12, 2011: 2.01 Update code to support iic_v2_02_a
##                      Aug 31, 2011: 2.02 Make sure all the Fifo's are cleared and Bus is Not busy
##                      Feb 20, 2012: 2.03 Rename file "fmc_iic_axi.c" to "fmc_iic_axi.c"
##                                         Use "xil_io.h" instead of "xio.h"
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
	echo "Compiling fmc_iic_sw"
	$(COMPILER) $(COMPILER_FLAGS) $(EXTRA_COMPILER_FLAGS) $(INCLUDES) $(LIBSOURCES)
	$(ARCHIVER) -r ${RELEASEDIR}/${LIB} ${OUTS}
	make clean

include:
	${CP} $(INCLUDEFILES) $(INCLUDEDIR)

clean:
	rm -rf ${OUTS}


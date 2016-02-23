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
## Create Date:         Sep 01, 2011
## Design Name:         PYTHON-1300-C Camera Module
## Module Name:         Makefile
## Project Name:        PYTHON-1300-C Camera Module
## Target Devices:      Artix-7, Kintex-7, Virtex-7, Zynq
##
## Avnet Boards:        PYTHON-1300-C Camera Module
##
## Tool versions:       Vivado 2014.4
##
## Description:         PYTHON-1300-C Software Services
##                      Makefile
##
## Dependencies:        
##
## Revision:            Mar 11, 2015: 3.1  Update contents based on 2014.4 examples
##                      Jul 09, 2015: 3.2  Change sensor's sample point to fix
##                                         sampling issue (intermittent across different hw)
##                       Nov 17, 2015: 3.3  Update driver 
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
	echo "Compiling ON Semiconductor PYTHON Camera Receiver Library..."
	$(COMPILER) $(COMPILER_FLAGS) $(EXTRA_COMPILER_FLAGS) $(INCLUDES) $(LIBSOURCES)
	$(ARCHIVER) -r ${RELEASEDIR}/${LIB} ${OUTS}
	make clean

include:
	${CP} $(INCLUDEFILES) $(INCLUDEDIR)

clean:
	rm -rf ${OUTS}

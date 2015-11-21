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
## Create Date:         Mar 11, 2015
## Design Name:         VITA-2000-C Camera Module
## Module Name:         onsemi_vita_sw.tcl
## Project Name:        VITA-2000-C Camera Module
## Target Devices:      Artix-7, Kintex-7, Virtex-7, Zynq
##
## Avnet Boards:        FMC-IMAGEON + VITA-2000-C Camera Module
##
## Tool versions:       Vivado 2014.4
##
## Description:         VITA-2000-C Software Services
##                      TCL
##
## Dependencies:        
##
## Revision:             Mar 11, 2015: 3.1  New TCL file based on 2014.4 examples
##                       Nov 17, 2015: 3.3  Update driver 
##----------------------------------------------------------------

#---------------------------------------------
# onsemi_vita_sw_drc 
#---------------------------------------------
proc onsemi_vita_sw_drc {libhandle} {

}

proc generate {libhandle} {

}

#-------
# post_generate: called after generate called on all libraries
#-------
proc post_generate {libhandle} {
	
	xgen_opts_file $libhandle
}

#-------
# execs_generate: called after BSP's, libraries and drivers have been compiled
#	This procedure builds the libonsemi_python_sw.a library
#-------
proc execs_generate {libhandle} {

}

proc xgen_opts_file {libhandle} {

	
	# Copy the include files to the include directory
	set srcdir [file join src include]
	set dstdir [file join .. .. include]

	# Create dstdir if it does not exist
	if { ! [file exists $dstdir] } {
		file mkdir $dstdir
	}

	# Get list of files in the srcdir
	set sources [glob -join $srcdir *.h]

	# Copy each of the files in the list to dstdir
	foreach source $sources {
		file copy -force $source $dstdir
	}
}

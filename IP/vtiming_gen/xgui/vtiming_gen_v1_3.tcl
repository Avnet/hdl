#Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
	set Page0 [ ipgui::add_page $IPINST  -name "Page 0" -layout vertical]
	set Component_Name [ ipgui::add_param  $IPINST  -parent  $Page0  -name Component_Name ]
	set C_VIDEO_RESOLUTION [ipgui::add_param $IPINST -parent $Page0 -name C_VIDEO_RESOLUTION]
set_property tooltip {Video Output Resolution} $C_VIDEO_RESOLUTION
	set C_DEBUG_PORT [ipgui::add_param $IPINST -parent $Page0 -name C_DEBUG_PORT]
set_property tooltip {Enable Debug Port} $C_DEBUG_PORT
}

proc update_PARAM_VALUE.C_VIDEO_RESOLUTION { PARAM_VALUE.C_VIDEO_RESOLUTION } {
	# Procedure called to update C_VIDEO_RESOLUTION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_VIDEO_RESOLUTION { PARAM_VALUE.C_VIDEO_RESOLUTION } {
	# Procedure called to validate C_VIDEO_RESOLUTION
	return true
}

proc update_PARAM_VALUE.C_DEBUG_PORT { PARAM_VALUE.C_DEBUG_PORT } {
	# Procedure called to update C_DEBUG_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DEBUG_PORT { PARAM_VALUE.C_DEBUG_PORT } {
	# Procedure called to validate C_DEBUG_PORT
	return true
}


proc update_MODELPARAM_VALUE.C_VIDEO_RESOLUTION { MODELPARAM_VALUE.C_VIDEO_RESOLUTION PARAM_VALUE.C_VIDEO_RESOLUTION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_VIDEO_RESOLUTION}] ${MODELPARAM_VALUE.C_VIDEO_RESOLUTION}
}


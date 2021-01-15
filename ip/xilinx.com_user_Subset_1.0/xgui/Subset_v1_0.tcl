# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_COLOR_FORMAT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_INPUT_DATAWIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_OUTPUT_DATAWIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_COLOR_FORMAT { PARAM_VALUE.C_COLOR_FORMAT } {
	# Procedure called to update C_COLOR_FORMAT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_COLOR_FORMAT { PARAM_VALUE.C_COLOR_FORMAT } {
	# Procedure called to validate C_COLOR_FORMAT
	return true
}

proc update_PARAM_VALUE.C_INPUT_DATAWIDTH { PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to update C_INPUT_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_INPUT_DATAWIDTH { PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to validate C_INPUT_DATAWIDTH
	return true
}

proc update_PARAM_VALUE.C_OUTPUT_DATAWIDTH { PARAM_VALUE.C_OUTPUT_DATAWIDTH } {
	# Procedure called to update C_OUTPUT_DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_OUTPUT_DATAWIDTH { PARAM_VALUE.C_OUTPUT_DATAWIDTH } {
	# Procedure called to validate C_OUTPUT_DATAWIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_COLOR_FORMAT { MODELPARAM_VALUE.C_COLOR_FORMAT PARAM_VALUE.C_COLOR_FORMAT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_COLOR_FORMAT}] ${MODELPARAM_VALUE.C_COLOR_FORMAT}
}

proc update_MODELPARAM_VALUE.C_INPUT_DATAWIDTH { MODELPARAM_VALUE.C_INPUT_DATAWIDTH PARAM_VALUE.C_INPUT_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_INPUT_DATAWIDTH}] ${MODELPARAM_VALUE.C_INPUT_DATAWIDTH}
}

proc update_MODELPARAM_VALUE.C_OUTPUT_DATAWIDTH { MODELPARAM_VALUE.C_OUTPUT_DATAWIDTH PARAM_VALUE.C_OUTPUT_DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_OUTPUT_DATAWIDTH}] ${MODELPARAM_VALUE.C_OUTPUT_DATAWIDTH}
}


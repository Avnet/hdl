# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "Component_Name" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_USE_BUFR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_IOBFF_ON_NEGEDGE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_DEBUG_PORT" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_IOBFF_ON_NEGEDGE { PARAM_VALUE.C_IOBFF_ON_NEGEDGE } {
	# Procedure called to update C_IOBFF_ON_NEGEDGE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_IOBFF_ON_NEGEDGE { PARAM_VALUE.C_IOBFF_ON_NEGEDGE } {
	# Procedure called to validate C_IOBFF_ON_NEGEDGE
	return true
}

proc update_PARAM_VALUE.C_USE_BUFR { PARAM_VALUE.C_USE_BUFR } {
	# Procedure called to update C_USE_BUFR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_USE_BUFR { PARAM_VALUE.C_USE_BUFR } {
	# Procedure called to validate C_USE_BUFR
	return true
}

proc update_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to update C_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to validate C_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_DEBUG_PORT { PARAM_VALUE.C_DEBUG_PORT } {
	# Procedure called to update C_DEBUG_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DEBUG_PORT { PARAM_VALUE.C_DEBUG_PORT } {
	# Procedure called to validate C_DEBUG_PORT
	return true
}


proc update_MODELPARAM_VALUE.C_DATA_WIDTH { MODELPARAM_VALUE.C_DATA_WIDTH PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DATA_WIDTH}] ${MODELPARAM_VALUE.C_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_IOBFF_ON_NEGEDGE { MODELPARAM_VALUE.C_IOBFF_ON_NEGEDGE PARAM_VALUE.C_IOBFF_ON_NEGEDGE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_IOBFF_ON_NEGEDGE}] ${MODELPARAM_VALUE.C_IOBFF_ON_NEGEDGE}
}

proc update_MODELPARAM_VALUE.C_USE_BUFR { MODELPARAM_VALUE.C_USE_BUFR PARAM_VALUE.C_USE_BUFR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_USE_BUFR}] ${MODELPARAM_VALUE.C_USE_BUFR}
}


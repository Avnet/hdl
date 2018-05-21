# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"


}

proc update_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to update C_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to validate C_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.EXT_PIPE_SIM { PARAM_VALUE.EXT_PIPE_SIM } {
	# Procedure called to update EXT_PIPE_SIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXT_PIPE_SIM { PARAM_VALUE.EXT_PIPE_SIM } {
	# Procedure called to validate EXT_PIPE_SIM
	return true
}

proc update_PARAM_VALUE.KEEP_WIDTH { PARAM_VALUE.KEEP_WIDTH } {
	# Procedure called to update KEEP_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KEEP_WIDTH { PARAM_VALUE.KEEP_WIDTH } {
	# Procedure called to validate KEEP_WIDTH
	return true
}

proc update_PARAM_VALUE.PCIE_EXT_CLK { PARAM_VALUE.PCIE_EXT_CLK } {
	# Procedure called to update PCIE_EXT_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCIE_EXT_CLK { PARAM_VALUE.PCIE_EXT_CLK } {
	# Procedure called to validate PCIE_EXT_CLK
	return true
}

proc update_PARAM_VALUE.PCIE_EXT_GT_COMMON { PARAM_VALUE.PCIE_EXT_GT_COMMON } {
	# Procedure called to update PCIE_EXT_GT_COMMON when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PCIE_EXT_GT_COMMON { PARAM_VALUE.PCIE_EXT_GT_COMMON } {
	# Procedure called to validate PCIE_EXT_GT_COMMON
	return true
}

proc update_PARAM_VALUE.PL_FAST_TRAIN { PARAM_VALUE.PL_FAST_TRAIN } {
	# Procedure called to update PL_FAST_TRAIN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PL_FAST_TRAIN { PARAM_VALUE.PL_FAST_TRAIN } {
	# Procedure called to validate PL_FAST_TRAIN
	return true
}

proc update_PARAM_VALUE.REF_CLK_FREQ { PARAM_VALUE.REF_CLK_FREQ } {
	# Procedure called to update REF_CLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REF_CLK_FREQ { PARAM_VALUE.REF_CLK_FREQ } {
	# Procedure called to validate REF_CLK_FREQ
	return true
}


proc update_MODELPARAM_VALUE.PL_FAST_TRAIN { MODELPARAM_VALUE.PL_FAST_TRAIN PARAM_VALUE.PL_FAST_TRAIN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PL_FAST_TRAIN}] ${MODELPARAM_VALUE.PL_FAST_TRAIN}
}

proc update_MODELPARAM_VALUE.EXT_PIPE_SIM { MODELPARAM_VALUE.EXT_PIPE_SIM PARAM_VALUE.EXT_PIPE_SIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXT_PIPE_SIM}] ${MODELPARAM_VALUE.EXT_PIPE_SIM}
}

proc update_MODELPARAM_VALUE.PCIE_EXT_CLK { MODELPARAM_VALUE.PCIE_EXT_CLK PARAM_VALUE.PCIE_EXT_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCIE_EXT_CLK}] ${MODELPARAM_VALUE.PCIE_EXT_CLK}
}

proc update_MODELPARAM_VALUE.PCIE_EXT_GT_COMMON { MODELPARAM_VALUE.PCIE_EXT_GT_COMMON PARAM_VALUE.PCIE_EXT_GT_COMMON } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PCIE_EXT_GT_COMMON}] ${MODELPARAM_VALUE.PCIE_EXT_GT_COMMON}
}

proc update_MODELPARAM_VALUE.REF_CLK_FREQ { MODELPARAM_VALUE.REF_CLK_FREQ PARAM_VALUE.REF_CLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REF_CLK_FREQ}] ${MODELPARAM_VALUE.REF_CLK_FREQ}
}

proc update_MODELPARAM_VALUE.C_DATA_WIDTH { MODELPARAM_VALUE.C_DATA_WIDTH PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DATA_WIDTH}] ${MODELPARAM_VALUE.C_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.KEEP_WIDTH { MODELPARAM_VALUE.KEEP_WIDTH PARAM_VALUE.KEEP_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KEEP_WIDTH}] ${MODELPARAM_VALUE.KEEP_WIDTH}
}


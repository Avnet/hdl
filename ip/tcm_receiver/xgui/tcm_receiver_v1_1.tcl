
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/tcm_receiver_v1_1.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_PIXEL_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "Component_Name" -parent ${Page_0}
  #Adding Group
  set AXI_Lite_Interface [ipgui::add_group $IPINST -name "AXI Lite Interface" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "C_S00_AXI_DATA_WIDTH" -parent ${AXI_Lite_Interface}
  ipgui::add_param $IPINST -name "C_S00_AXI_ADDR_WIDTH" -parent ${AXI_Lite_Interface}
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${AXI_Lite_Interface}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${AXI_Lite_Interface}



}

proc update_PARAM_VALUE.C_PIXEL_WIDTH { PARAM_VALUE.C_PIXEL_WIDTH } {
	# Procedure called to update C_PIXEL_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_PIXEL_WIDTH { PARAM_VALUE.C_PIXEL_WIDTH } {
	# Procedure called to validate C_PIXEL_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to update C_S00_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_DATA_WIDTH { PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S00_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S00_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_ADDR_WIDTH { PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S00_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH PARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH PARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_PIXEL_WIDTH { MODELPARAM_VALUE.C_PIXEL_WIDTH PARAM_VALUE.C_PIXEL_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PIXEL_WIDTH}] ${MODELPARAM_VALUE.C_PIXEL_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXIS_DATA_WIDTH { MODELPARAM_VALUE.C_AXIS_DATA_WIDTH PARAM_VALUE.C_PIXEL_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	
	set C_AXIS_DATA_WIDTH ${MODELPARAM_VALUE.C_AXIS_DATA_WIDTH}
	set C_PIXEL_WIDTH ${PARAM_VALUE.C_PIXEL_WIDTH}
	set values(C_PIXEL_WIDTH) [get_property value $C_PIXEL_WIDTH]
	set_property value [gen_HDLPARAMETER_C_AXIS_DATA_WIDTH_VALUE $values(C_PIXEL_WIDTH)] $C_AXIS_DATA_WIDTH
}


#######################################################################
# DisplayPort HPD & AUX
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports {dp_hot_plug_detect*}]
set_property IOSTANDARD LVCMOS18 [get_ports {dp_aux_data*}]
set_property PACKAGE_PIN D2 [get_ports dp_aux_data_out ]; # HPA19_P
set_property PACKAGE_PIN E2 [get_ports dp_hot_plug_detect ]; # HPA19_N
set_property PACKAGE_PIN V6 [get_ports dp_aux_data_oe ]; # HPA22_P
set_property PACKAGE_PIN V5 [get_ports dp_aux_data_in ]; # HPA22_N

#######################################################################
# SDIO
#######################################################################
set_property IOSTANDARD LVCMOS18 [get_ports {sdio*}]
set_property PACKAGE_PIN L2 [get_ports sdio_data_io[0] ]; # HPA11_P
set_property PACKAGE_PIN M1 [get_ports sdio_data_io[1] ]; # HPA11_N
set_property PACKAGE_PIN H8 [get_ports sdio_data_io[2] ]; # HPA12_P
set_property PACKAGE_PIN J7 [get_ports sdio_data_io[3] ]; # HPA12_N
set_property PACKAGE_PIN J1 [get_ports sdio_data_io[4] ]; # HPA13_P
set_property PACKAGE_PIN K1 [get_ports sdio_data_io[5] ]; # HPA13_N
set_property PACKAGE_PIN G7 [get_ports sdio_data_io[6] ]; # HPA14_P
set_property PACKAGE_PIN H7 [get_ports sdio_data_io[7] ]; # HPA14_N
set_property PACKAGE_PIN F7 [get_ports sdio_cmd_io ]; # HPA16_P
set_property PACKAGE_PIN G6 [get_ports sdio_clk ]; # HPA16_N

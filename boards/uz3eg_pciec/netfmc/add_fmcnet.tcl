#Enable PS GEM0 and GEM1 and set to EMIO
set_property -dict [list \
  CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
  CONFIG.PSU__ENET0__GRP_MDIO__IO {EMIO} \
  CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__ENET0__PERIPHERAL__IO {EMIO} \
  CONFIG.PSU__ENET1__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__ENET1__PERIPHERAL__IO {EMIO} \
  CONFIG.PSU__ENET1__GRP_MDIO__ENABLE {1} \
  CONFIG.PSU__ENET1__GRP_MDIO__IO {EMIO}] [get_bd_cells zynq_ultra_ps_e_0]

set_property -dict [list CONFIG.NUM_MI {8}] [get_bd_cells ps8_0_axi_periph]

set_property -dict [list CONFIG.NUM_PORTS {6}] [get_bd_cells xlconcat_0]

save_bd_design

create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii:4.1 gmii_to_rgmii_0
set_property -dict [list CONFIG.C_USE_IDELAY_CTRL {false}] [get_bd_cells gmii_to_rgmii_0]
make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_0/MDIO_PHY]
make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_0/RGMII]
set_property name mdio_port_0 [get_bd_intf_ports MDIO_PHY_0]
set_property name rgmii_port_0 [get_bd_intf_ports RGMII_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii:4.1 gmii_to_rgmii_1
set_property -dict [list CONFIG.SupportLevel {Include_Shared_Logic_in_Core}] [get_bd_cells gmii_to_rgmii_1]
make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_1/MDIO_PHY]
make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_1/RGMII]
set_property name mdio_port_1 [get_bd_intf_ports MDIO_PHY_1]
set_property name rgmii_port_1 [get_bd_intf_ports RGMII_1]

save_bd_design

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_3
set_property -dict [list \
  CONFIG.C_GPIO_WIDTH {10} \
  CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells axi_gpio_3]
make_bd_intf_pins_external  [get_bd_intf_pins axi_gpio_3/GPIO]
set_property name leds_fmcnet_10bits [get_bd_intf_ports GPIO_0]

save_bd_design

create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1
set_property -dict [list \
  CONFIG.PRIM_IN_FREQ.VALUE_SRC {USER} \
  CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
  CONFIG.PRIM_IN_FREQ {125} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {375} \
  CONFIG.USE_LOCKED {false} \
  CONFIG.USE_RESET {false} \
  CONFIG.CLKIN1_JITTER_PS {80.0} \
  CONFIG.MMCM_DIVCLK_DIVIDE {1} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {9.750} \
  CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.250} \
  CONFIG.CLKOUT1_JITTER {86.562} \
  CONFIG.CLKOUT1_PHASE_ERROR {84.521}] [get_bd_cells clk_wiz_1]
make_bd_intf_pins_external  [get_bd_intf_pins clk_wiz_1/CLK_IN1_D]
set_property name ref_clk [get_bd_intf_ports CLK_IN1_D_0]

save_bd_design

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
make_bd_pins_external  [get_bd_pins xlconstant_0/dout]
set_property name ref_clk_fsel [get_bd_ports dout_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1
make_bd_pins_external  [get_bd_pins xlconstant_1/dout]
set_property name ref_clk_oe [get_bd_ports dout_1]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_0
make_bd_intf_pins_external  [get_bd_intf_pins axi_iic_0/IIC]
set_property name iic_rtl_0 [get_bd_intf_ports IIC_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_1
make_bd_intf_pins_external  [get_bd_intf_pins axi_iic_1/IIC]
set_property name iic_rtl_1 [get_bd_intf_ports IIC_1]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 axi_iic_2
make_bd_intf_pins_external  [get_bd_intf_pins axi_iic_2/IIC]
set_property name iic_rtl_2 [get_bd_intf_ports IIC_2]

save_bd_design

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins ps8_0_axi_periph/M04_ACLK]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins ps8_0_axi_periph/M05_ACLK]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins ps8_0_axi_periph/M06_ACLK]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins ps8_0_axi_periph/M07_ACLK]

save_bd_design

connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins ps8_0_axi_periph/M04_ARESETN]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins ps8_0_axi_periph/M05_ARESETN]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins ps8_0_axi_periph/M06_ARESETN]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins ps8_0_axi_periph/M07_ARESETN]

save_bd_design

connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M04_AXI] [get_bd_intf_pins axi_gpio_3/S_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M05_AXI] [get_bd_intf_pins axi_iic_0/S_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M06_AXI] [get_bd_intf_pins axi_iic_1/S_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ps8_0_axi_periph/M07_AXI] [get_bd_intf_pins axi_iic_2/S_AXI]

save_bd_design

connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_gpio_3/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_iic_0/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_iic_1/s_axi_aclk]
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins axi_iic_2/s_axi_aclk]

save_bd_design

connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins axi_gpio_3/s_axi_aresetn]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins axi_iic_1/s_axi_aresetn]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins axi_iic_2/s_axi_aresetn]


save_bd_design

connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/GMII_ENET0] [get_bd_intf_pins gmii_to_rgmii_0/GMII]
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/MDIO_ENET0] [get_bd_intf_pins gmii_to_rgmii_0/MDIO_GEM]
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/GMII_ENET1] [get_bd_intf_pins gmii_to_rgmii_1/GMII]
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/MDIO_ENET1] [get_bd_intf_pins gmii_to_rgmii_1/MDIO_GEM]

save_bd_design

connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_reset] [get_bd_pins gmii_to_rgmii_0/tx_reset]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_reset] [get_bd_pins gmii_to_rgmii_0/rx_reset]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_reset] [get_bd_pins gmii_to_rgmii_1/tx_reset]
connect_bd_net [get_bd_pins rst_ps8_0_100M/peripheral_reset] [get_bd_pins gmii_to_rgmii_1/rx_reset]

save_bd_design

connect_bd_net [get_bd_pins gmii_to_rgmii_1/ref_clk_out] [get_bd_pins gmii_to_rgmii_0/ref_clk_in]
connect_bd_net [get_bd_pins gmii_to_rgmii_1/mmcm_locked_out] [get_bd_pins gmii_to_rgmii_0/mmcm_locked_in]
connect_bd_net [get_bd_pins gmii_to_rgmii_1/gmii_clk_125m_out] [get_bd_pins gmii_to_rgmii_0/gmii_clk_125m_in]
connect_bd_net [get_bd_pins gmii_to_rgmii_1/gmii_clk_25m_out] [get_bd_pins gmii_to_rgmii_0/gmii_clk_25m_in]
connect_bd_net [get_bd_pins gmii_to_rgmii_1/gmii_clk_2_5m_out] [get_bd_pins gmii_to_rgmii_0/gmii_clk_2_5m_in]

save_bd_design

connect_bd_net [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins gmii_to_rgmii_1/clkin]

connect_bd_net [get_bd_pins xlconcat_0/In2] [get_bd_pins axi_iic_0/iic2intc_irpt]
connect_bd_net [get_bd_pins xlconcat_0/In3] [get_bd_pins axi_iic_1/iic2intc_irpt]
connect_bd_net [get_bd_pins xlconcat_0/In4] [get_bd_pins axi_iic_2/iic2intc_irpt]

save_bd_design

create_bd_port -dir O reset_port_0
create_bd_port -dir O reset_port_1
connect_bd_net [get_bd_ports reset_port_0] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn]
connect_bd_net [get_bd_ports reset_port_1] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn]

save_bd_design


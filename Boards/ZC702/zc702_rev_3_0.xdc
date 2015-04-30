#NET  FPGA_DONE                 LOC = T12 ; # Bank   0 - DONE_0
#NET  XADC_DXP                  LOC = N11 ; # Bank   0 - DXP_0
#NET  XADC_AGND                 LOC = K12 ; # Bank   0 - GNDADC_0
#NET  XADC_VCC                  LOC = K11 ; # Bank   0 - VCCADC_0
#NET  XADC_VREFP                LOC = M11 ; # Bank   0 - VREFP_0
#NET  XADC_VN_R                 LOC = M12 ; # Bank   0 - VN_0
#NET  FPGA_VBATT                LOC = G9  ; # Bank   0 - VCCBATT_0
#NET  FPGA_TCK_BUF              LOC = G11 ; # Bank   0 - TCK_0
#NET  XADC_DXN                  LOC = N12 ; # Bank   0 - DXN_0
#NET  XADC_AGND                 LOC = L12 ; # Bank   0 - VREFN_0
#NET  XADC_VP_R                 LOC = L11 ; # Bank   0 - VP_0
#NET  GND                       LOC = G10 ; # Bank   0 - RSVDGND
#NET  VCC2V5                    LOC = T10 ; # Bank   0 - RSVDVCC
#NET  VCC2V5                    LOC = T8  ; # Bank   0 - RSVDVCC
#NET  FPGA_INIT_B               LOC = T14 ; # Bank   0 - INIT_B_0
#NET  FPGA_TDI_BUF              LOC = H13 ; # Bank   0 - TDI_0
#NET  JTAG_TDO_BUF              LOC = G14 ; # Bank   0 - TDO_0
#NET  VCC2V5                    LOC = T7  ; # Bank   0 - RSVDVCC
#NET  3N579                     LOC = T13 ; # Bank   0 - CFGBVS_0
#NET  FPGA_PROG_B               LOC = T11 ; # Bank   0 - PROGRAM_B_0
#NET  FPGA_TMS_BUF              LOC = G12 ; # Bank   0 - TMS_0
set_property PACKAGE_PIN R7 [get_ports PL_PJTAG_TDO_R]
set_property IOSTANDARD LVCMOS25 [get_ports PL_PJTAG_TDO_R]
set_property PACKAGE_PIN V10 [get_ports PL_PJTAG_TCK]
set_property IOSTANDARD LVCMOS25 [get_ports PL_PJTAG_TCK]
set_property PACKAGE_PIN V9 [get_ports PL_PJTAG_TMS]
set_property IOSTANDARD LVCMOS25 [get_ports PL_PJTAG_TMS]
set_property PACKAGE_PIN V8 [get_ports PL_PJTAG_TDI]
set_property IOSTANDARD LVCMOS25 [get_ports PL_PJTAG_TDI]
set_property PACKAGE_PIN W8 [get_ports IIC_SDA_MAIN_LS]
set_property IOSTANDARD LVCMOS25 [get_ports IIC_SDA_MAIN_LS]
set_property PACKAGE_PIN W11 [get_ports IIC_SCL_MAIN_LS]
set_property IOSTANDARD LVCMOS25 [get_ports IIC_SCL_MAIN_LS]
set_property PACKAGE_PIN W10 [get_ports PMOD2_1_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PMOD2_1_LS]
set_property PACKAGE_PIN V12 [get_ports FMC2_LPC_LA23_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA23_P]
set_property PACKAGE_PIN W12 [get_ports FMC2_LPC_LA23_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA23_N]
set_property PACKAGE_PIN U12 [get_ports FMC2_LPC_LA26_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA26_P]
set_property PACKAGE_PIN U11 [get_ports FMC2_LPC_LA26_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA26_N]
set_property PACKAGE_PIN U10 [get_ports FMC2_LPC_LA22_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA22_P]
set_property PACKAGE_PIN U9 [get_ports FMC2_LPC_LA22_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA22_N]
set_property PACKAGE_PIN AA12 [get_ports FMC2_LPC_LA25_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA25_P]
set_property PACKAGE_PIN AB12 [get_ports FMC2_LPC_LA25_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA25_N]
set_property PACKAGE_PIN AA11 [get_ports FMC2_LPC_LA29_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA29_P]
set_property PACKAGE_PIN AB11 [get_ports FMC2_LPC_LA29_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA29_N]
set_property PACKAGE_PIN AB10 [get_ports FMC2_LPC_LA31_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA31_P]
set_property PACKAGE_PIN AB9 [get_ports FMC2_LPC_LA31_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA31_N]
set_property PACKAGE_PIN Y11 [get_ports FMC2_LPC_LA33_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA33_P]
set_property PACKAGE_PIN Y10 [get_ports FMC2_LPC_LA33_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA33_N]
set_property PACKAGE_PIN AA9 [get_ports FMC2_LPC_LA18_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA18_CC_P]
set_property PACKAGE_PIN AA8 [get_ports FMC2_LPC_LA18_CC_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA18_CC_N]
set_property PACKAGE_PIN Y9 [get_ports USRCLK_P]
set_property IOSTANDARD LVDS_25 [get_ports USRCLK_P]
set_property PACKAGE_PIN Y8 [get_ports USRCLK_N]
set_property IOSTANDARD LVDS_25 [get_ports USRCLK_N]
set_property PACKAGE_PIN Y6 [get_ports FMC2_LPC_CLK1_M2C_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_CLK1_M2C_P]
set_property PACKAGE_PIN Y5 [get_ports FMC2_LPC_CLK1_M2C_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_CLK1_M2C_N]
set_property PACKAGE_PIN AA7 [get_ports FMC2_LPC_LA17_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA17_CC_P]
set_property PACKAGE_PIN AA6 [get_ports FMC2_LPC_LA17_CC_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA17_CC_N]
set_property PACKAGE_PIN AB2 [get_ports FMC2_LPC_LA27_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA27_P]
set_property PACKAGE_PIN AB1 [get_ports FMC2_LPC_LA27_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA27_N]
set_property PACKAGE_PIN AB5 [get_ports FMC2_LPC_LA28_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA28_P]
set_property PACKAGE_PIN AB4 [get_ports FMC2_LPC_LA28_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA28_N]
set_property PACKAGE_PIN AB7 [get_ports FMC2_LPC_LA30_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA30_P]
set_property PACKAGE_PIN AB6 [get_ports FMC2_LPC_LA30_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA30_N]
set_property PACKAGE_PIN Y4 [get_ports FMC2_LPC_LA32_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA32_P]
set_property PACKAGE_PIN AA4 [get_ports FMC2_LPC_LA32_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA32_N]
set_property PACKAGE_PIN R6 [get_ports FMC2_LPC_LA19_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA19_P]
set_property PACKAGE_PIN T6 [get_ports FMC2_LPC_LA19_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA19_N]
set_property PACKAGE_PIN T4 [get_ports FMC2_LPC_LA20_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA20_P]
set_property PACKAGE_PIN U4 [get_ports FMC2_LPC_LA20_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA20_N]
set_property PACKAGE_PIN V5 [get_ports FMC2_LPC_LA21_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA21_P]
set_property PACKAGE_PIN V4 [get_ports FMC2_LPC_LA21_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA21_N]
set_property PACKAGE_PIN U6 [get_ports FMC2_LPC_LA24_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA24_P]
set_property PACKAGE_PIN U5 [get_ports FMC2_LPC_LA24_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA24_N]
set_property PACKAGE_PIN V7 [get_ports PMOD2_0_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PMOD2_0_LS]
set_property PACKAGE_PIN W7 [get_ports GPIO_DIP_SW1]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_DIP_SW1]
set_property PACKAGE_PIN W6 [get_ports GPIO_DIP_SW0]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_DIP_SW0]
set_property PACKAGE_PIN W5 [get_ports PMOD1_3_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PMOD1_3_LS]
set_property PACKAGE_PIN U7 [get_ports IIC_RTC_IRQ_1_B]
set_property IOSTANDARD LVCMOS25 [get_ports IIC_RTC_IRQ_1_B]
set_property PACKAGE_PIN U19 [get_ports HDMI_R_D12]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D12]
set_property PACKAGE_PIN T21 [get_ports FMC2_LPC_LA07_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA07_P]
set_property PACKAGE_PIN U21 [get_ports FMC2_LPC_LA07_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA07_N]
set_property PACKAGE_PIN T22 [get_ports FMC2_LPC_LA14_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA14_P]
set_property PACKAGE_PIN U22 [get_ports FMC2_LPC_LA14_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA14_N]
set_property PACKAGE_PIN V22 [get_ports FMC2_LPC_LA13_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA13_P]
set_property PACKAGE_PIN W22 [get_ports FMC2_LPC_LA13_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA13_N]
set_property PACKAGE_PIN W20 [get_ports HDMI_R_D9]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D9]
set_property PACKAGE_PIN W21 [get_ports HDMI_R_D8]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D8]
set_property PACKAGE_PIN U20 [get_ports HDMI_R_D7]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D7]
set_property PACKAGE_PIN V20 [get_ports HDMI_R_D6]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D6]
set_property PACKAGE_PIN V18 [get_ports HDMI_R_D5]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D5]
set_property PACKAGE_PIN V19 [get_ports HDMI_R_D4]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D4]
set_property PACKAGE_PIN AA22 [get_ports HDMI_R_D3]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D3]
set_property PACKAGE_PIN AB22 [get_ports HDMI_R_D2]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D2]
set_property PACKAGE_PIN AA21 [get_ports HDMI_R_D1]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D1]
set_property PACKAGE_PIN AB21 [get_ports HDMI_R_D0]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D0]
set_property PACKAGE_PIN Y20 [get_ports FMC2_LPC_LA10_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA10_P]
set_property PACKAGE_PIN Y21 [get_ports FMC2_LPC_LA10_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA10_N]
set_property PACKAGE_PIN AB19 [get_ports FMC2_LPC_LA05_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA05_P]
set_property PACKAGE_PIN AB20 [get_ports FMC2_LPC_LA05_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA05_N]
set_property PACKAGE_PIN Y19 [get_ports FMC2_LPC_LA00_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA00_CC_P]
set_property PACKAGE_PIN AA19 [get_ports FMC2_LPC_LA00_CC_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA00_CC_N]
set_property PACKAGE_PIN Y18 [get_ports FMC2_LPC_CLK0_M2C_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_CLK0_M2C_P]
set_property PACKAGE_PIN AA18 [get_ports FMC2_LPC_CLK0_M2C_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_CLK0_M2C_N]
set_property PACKAGE_PIN W17 [get_ports PMOD1_2_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PMOD1_2_LS]
set_property PACKAGE_PIN W18 [get_ports HDMI_R_D10]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D10]
set_property PACKAGE_PIN W16 [get_ports FMC2_LPC_LA01_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA01_CC_P]
set_property PACKAGE_PIN Y16 [get_ports FMC2_LPC_LA01_CC_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA01_CC_N]
set_property PACKAGE_PIN U15 [get_ports FMC2_LPC_LA09_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA09_P]
set_property PACKAGE_PIN U16 [get_ports FMC2_LPC_LA09_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA09_N]
set_property PACKAGE_PIN U17 [get_ports FMC2_LPC_LA06_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA06_P]
set_property PACKAGE_PIN V17 [get_ports FMC2_LPC_LA06_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA06_N]
set_property PACKAGE_PIN AA17 [get_ports FMC2_LPC_LA08_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA08_P]
set_property PACKAGE_PIN AB17 [get_ports FMC2_LPC_LA08_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA08_N]
set_property PACKAGE_PIN AA16 [get_ports FMC2_LPC_LA03_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA03_P]
set_property PACKAGE_PIN AB16 [get_ports FMC2_LPC_LA03_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA03_N]
set_property PACKAGE_PIN V14 [get_ports FMC2_LPC_LA02_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA02_P]
set_property PACKAGE_PIN V15 [get_ports FMC2_LPC_LA02_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA02_N]
set_property PACKAGE_PIN V13 [get_ports FMC2_LPC_LA04_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA04_P]
set_property PACKAGE_PIN W13 [get_ports FMC2_LPC_LA04_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA04_N]
set_property PACKAGE_PIN W15 [get_ports FMC2_LPC_LA12_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA12_P]
set_property PACKAGE_PIN Y15 [get_ports FMC2_LPC_LA12_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA12_N]
set_property PACKAGE_PIN Y14 [get_ports FMC2_LPC_LA11_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA11_P]
set_property PACKAGE_PIN AA14 [get_ports FMC2_LPC_LA11_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA11_N]
set_property PACKAGE_PIN Y13 [get_ports FMC2_LPC_LA15_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA15_P]
set_property PACKAGE_PIN AA13 [get_ports FMC2_LPC_LA15_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA15_N]
set_property PACKAGE_PIN AB14 [get_ports FMC2_LPC_LA16_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA16_P]
set_property PACKAGE_PIN AB15 [get_ports FMC2_LPC_LA16_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC2_LPC_LA16_N]
set_property PACKAGE_PIN U14 [get_ports HDMI_INT]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_INT]
set_property PACKAGE_PIN H15 [get_ports HDMI_R_VSYNC]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_VSYNC]
set_property PACKAGE_PIN J15 [get_ports FMC1_LPC_LA07_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA07_P]
set_property PACKAGE_PIN K15 [get_ports FMC1_LPC_LA07_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA07_N]
set_property PACKAGE_PIN J16 [get_ports FMC1_LPC_LA14_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA14_P]
set_property PACKAGE_PIN J17 [get_ports FMC1_LPC_LA14_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA14_N]
set_property PACKAGE_PIN K16 [get_ports 6N1412]
set_property IOSTANDARD LVCMOS25 [get_ports 6N1412]
set_property PACKAGE_PIN L16 [get_ports HDMI_R_CLK]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_CLK]
set_property PACKAGE_PIN L17 [get_ports FMC1_LPC_LA10_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA10_P]
set_property PACKAGE_PIN M17 [get_ports FMC1_LPC_LA10_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA10_N]
set_property PACKAGE_PIN N17 [get_ports FMC1_LPC_LA05_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA05_P]
set_property PACKAGE_PIN N18 [get_ports FMC1_LPC_LA05_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA05_N]
set_property PACKAGE_PIN M15 [get_ports FMC1_LPC_LA09_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA09_P]
set_property PACKAGE_PIN M16 [get_ports FMC1_LPC_LA09_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA09_N]
set_property PACKAGE_PIN J18 [get_ports FMC1_LPC_LA06_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA06_P]
set_property PACKAGE_PIN K18 [get_ports FMC1_LPC_LA06_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA06_N]
set_property PACKAGE_PIN J21 [get_ports FMC1_LPC_LA08_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA08_P]
set_property PACKAGE_PIN J22 [get_ports FMC1_LPC_LA08_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA08_N]
set_property PACKAGE_PIN J20 [get_ports FMC1_LPC_LA03_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA03_P]
set_property PACKAGE_PIN K21 [get_ports FMC1_LPC_LA03_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA03_N]
set_property PACKAGE_PIN L21 [get_ports FMC1_LPC_LA02_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA02_P]
set_property PACKAGE_PIN L22 [get_ports FMC1_LPC_LA02_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA02_N]
set_property PACKAGE_PIN K19 [get_ports FMC1_LPC_LA00_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA00_CC_P]
set_property PACKAGE_PIN K20 [get_ports FMC1_LPC_LA00_CC_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA00_CC_N]
set_property PACKAGE_PIN L18 [get_ports FMC1_LPC_CLK0_M2C_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_CLK0_M2C_P]
set_property PACKAGE_PIN L19 [get_ports FMC1_LPC_CLK0_M2C_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_CLK0_M2C_N]
set_property PACKAGE_PIN M19 [get_ports FMC1_LPC_CLK1_M2C_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_CLK1_M2C_P]
set_property PACKAGE_PIN M20 [get_ports FMC1_LPC_CLK1_M2C_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_CLK1_M2C_N]
set_property PACKAGE_PIN N19 [get_ports FMC1_LPC_LA01_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA01_CC_P]
set_property PACKAGE_PIN N20 [get_ports FMC1_LPC_LA01_CC_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA01_CC_N]
set_property PACKAGE_PIN M21 [get_ports FMC1_LPC_LA04_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA04_P]
set_property PACKAGE_PIN M22 [get_ports FMC1_LPC_LA04_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA04_N]
set_property PACKAGE_PIN N22 [get_ports FMC1_LPC_LA12_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA12_P]
set_property PACKAGE_PIN P22 [get_ports FMC1_LPC_LA12_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA12_N]
set_property PACKAGE_PIN R20 [get_ports FMC1_LPC_LA11_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA11_P]
set_property PACKAGE_PIN R21 [get_ports FMC1_LPC_LA11_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA11_N]
set_property PACKAGE_PIN P20 [get_ports FMC1_LPC_LA15_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA15_P]
set_property PACKAGE_PIN P21 [get_ports FMC1_LPC_LA15_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA15_N]
set_property PACKAGE_PIN N15 [get_ports FMC1_LPC_LA16_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA16_P]
set_property PACKAGE_PIN P15 [get_ports FMC1_LPC_LA16_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA16_N]
set_property PACKAGE_PIN P17 [get_ports PMOD2_3_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PMOD2_3_LS]
set_property PACKAGE_PIN P18 [get_ports PMOD2_2_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PMOD2_2_LS]
set_property PACKAGE_PIN T16 [get_ports HDMI_R_D15]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D15]
set_property PACKAGE_PIN T17 [get_ports HDMI_R_D14]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D14]
set_property PACKAGE_PIN R19 [get_ports HDMI_R_D13]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D13]
set_property PACKAGE_PIN T19 [get_ports HDMI_R_D11]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_D11]
set_property PACKAGE_PIN R18 [get_ports HDMI_R_HSYNC]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_HSYNC]
set_property PACKAGE_PIN T18 [get_ports HDMI_R_DE]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_DE]
set_property PACKAGE_PIN P16 [get_ports FMC1_LPC_LA13_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA13_P]
set_property PACKAGE_PIN R16 [get_ports FMC1_LPC_LA13_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA13_N]
set_property PACKAGE_PIN R15 [get_ports HDMI_R_SPDIF]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_R_SPDIF]
set_property PACKAGE_PIN H17 [get_ports XADC_GPIO_0]
set_property IOSTANDARD LVCMOS25 [get_ports XADC_GPIO_0]
set_property PACKAGE_PIN F16 [get_ports XADC_VAUX0P_R]
set_property IOSTANDARD LVCMOS25 [get_ports XADC_VAUX0P_R]
set_property PACKAGE_PIN E16 [get_ports XADC_VAUX0N_R]
set_property IOSTANDARD LVCMOS25 [get_ports XADC_VAUX0N_R]
set_property PACKAGE_PIN D16 [get_ports XADC_VAUX8P_R]
set_property IOSTANDARD LVCMOS25 [get_ports XADC_VAUX8P_R]
set_property PACKAGE_PIN D17 [get_ports XADC_VAUX8N_R]
set_property IOSTANDARD LVCMOS25 [get_ports XADC_VAUX8N_R]
set_property PACKAGE_PIN E15 [get_ports PMOD1_0_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PMOD1_0_LS]
set_property PACKAGE_PIN D15 [get_ports PMOD1_1_LS]
set_property IOSTANDARD LVCMOS25 [get_ports PMOD1_1_LS]
set_property PACKAGE_PIN G15 [get_ports FMC1_LPC_LA23_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA23_P]
set_property PACKAGE_PIN G16 [get_ports FMC1_LPC_LA23_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA23_N]
set_property PACKAGE_PIN F18 [get_ports FMC1_LPC_LA26_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA26_P]
set_property PACKAGE_PIN E18 [get_ports FMC1_LPC_LA26_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA26_N]
set_property PACKAGE_PIN G17 [get_ports FMC1_LPC_LA22_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA22_P]
set_property PACKAGE_PIN F17 [get_ports FMC1_LPC_LA22_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA22_N]
set_property PACKAGE_PIN C15 [get_ports FMC1_LPC_LA25_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA25_P]
set_property PACKAGE_PIN B15 [get_ports FMC1_LPC_LA25_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA25_N]
set_property PACKAGE_PIN B16 [get_ports FMC1_LPC_LA29_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA29_P]
set_property PACKAGE_PIN B17 [get_ports FMC1_LPC_LA29_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA29_N]
set_property PACKAGE_PIN A16 [get_ports FMC1_LPC_LA31_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA31_P]
set_property PACKAGE_PIN A17 [get_ports FMC1_LPC_LA31_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA31_N]
set_property PACKAGE_PIN A18 [get_ports FMC1_LPC_LA33_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA33_P]
set_property PACKAGE_PIN A19 [get_ports FMC1_LPC_LA33_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA33_N]
set_property PACKAGE_PIN C17 [get_ports FMC1_LPC_LA27_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA27_P]
set_property PACKAGE_PIN C18 [get_ports FMC1_LPC_LA27_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA27_N]
set_property PACKAGE_PIN D18 [get_ports SYSCLK_P]
set_property IOSTANDARD LVDS_25 [get_ports SYSCLK_P]
set_property PACKAGE_PIN C19 [get_ports SYSCLK_N]
set_property IOSTANDARD LVDS_25 [get_ports SYSCLK_N]
set_property PACKAGE_PIN B19 [get_ports FMC1_LPC_LA17_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA17_CC_P]
set_property PACKAGE_PIN B20 [get_ports FMC1_LPC_LA17_CC_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA17_CC_N]
set_property PACKAGE_PIN D20 [get_ports FMC1_LPC_LA18_CC_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA18_CC_P]
set_property PACKAGE_PIN C20 [get_ports FMC1_LPC_LA18_CC_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA18_CC_N]
set_property PACKAGE_PIN A21 [get_ports FMC1_LPC_LA24_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA24_P]
set_property PACKAGE_PIN A22 [get_ports FMC1_LPC_LA24_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA24_N]
set_property PACKAGE_PIN D22 [get_ports FMC1_LPC_LA28_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA28_P]
set_property PACKAGE_PIN C22 [get_ports FMC1_LPC_LA28_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA28_N]
set_property PACKAGE_PIN E21 [get_ports FMC1_LPC_LA30_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA30_P]
set_property PACKAGE_PIN D21 [get_ports FMC1_LPC_LA30_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA30_N]
set_property PACKAGE_PIN B21 [get_ports FMC1_LPC_LA32_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA32_P]
set_property PACKAGE_PIN B22 [get_ports FMC1_LPC_LA32_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA32_N]
set_property PACKAGE_PIN H19 [get_ports FMC_C2M_PG_LS]
set_property IOSTANDARD LVCMOS25 [get_ports FMC_C2M_PG_LS]
set_property PACKAGE_PIN H20 [get_ports HDMI_SPDIF_OUT_LS]
set_property IOSTANDARD LVCMOS25 [get_ports HDMI_SPDIF_OUT_LS]
set_property PACKAGE_PIN G19 [get_ports GPIO_SW_N]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_SW_N]
set_property PACKAGE_PIN F19 [get_ports GPIO_SW_S]
set_property IOSTANDARD LVCMOS25 [get_ports GPIO_SW_S]
set_property PACKAGE_PIN E19 [get_ports FMC1_LPC_LA19_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA19_P]
set_property PACKAGE_PIN E20 [get_ports FMC1_LPC_LA19_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA19_N]
set_property PACKAGE_PIN G20 [get_ports FMC1_LPC_LA20_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA20_P]
set_property PACKAGE_PIN G21 [get_ports FMC1_LPC_LA20_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA20_N]
set_property PACKAGE_PIN F21 [get_ports FMC1_LPC_LA21_P]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA21_P]
set_property PACKAGE_PIN F22 [get_ports FMC1_LPC_LA21_N]
set_property IOSTANDARD LVCMOS25 [get_ports FMC1_LPC_LA21_N]
set_property PACKAGE_PIN H22 [get_ports XADC_GPIO_1]
set_property IOSTANDARD LVCMOS25 [get_ports XADC_GPIO_1]
set_property PACKAGE_PIN G22 [get_ports XADC_GPIO_2]
set_property IOSTANDARD LVCMOS25 [get_ports XADC_GPIO_2]
set_property PACKAGE_PIN H18 [get_ports XADC_GPIO_3]
set_property IOSTANDARD LVCMOS25 [get_ports XADC_GPIO_3]
#NET  PS_CLK                    LOC = F7  ; # Bank 500 - PS_CLK_500
#NET  8N2                       LOC = F8  ; # Bank 501 - PS_MIO_VREF_501
#NET  PS_POR_B                  LOC = B5  ; # Bank 500 - PS_POR_B_500
#NET  SDIO_SDWP                 LOC = E6  ; # Bank 500 - PS_MIO15_500
#NET  PHY_TXD0                  LOC = E9  ; # Bank 501 - PS_MIO17_501
#NET  PHY_TXD2                  LOC = E10 ; # Bank 501 - PS_MIO19_501
#NET  PHY_TX_CTRL               LOC = F11 ; # Bank 501 - PS_MIO21_501
#NET  PHY_RXD0                  LOC = E11 ; # Bank 501 - PS_MIO23_501
#NET  PHY_RXD2                  LOC = F12 ; # Bank 501 - PS_MIO25_501
#NET  PHY_RX_CTRL               LOC = D7  ; # Bank 501 - PS_MIO27_501
#NET  USB_DIR                   LOC = E8  ; # Bank 501 - PS_MIO29_501
#NET  USB_NXT                   LOC = F9  ; # Bank 501 - PS_MIO31_501
#NET  USB_DATA1                 LOC = G13 ; # Bank 501 - PS_MIO33_501
#NET  USB_DATA3                 LOC = F14 ; # Bank 501 - PS_MIO35_501
#NET  USB_DATA6                 LOC = F13 ; # Bank 501 - PS_MIO38_501
#NET  SDIO_CLK_LS               LOC = E14 ; # Bank 501 - PS_MIO40_501
#NET  SDIO_DAT0_LS              LOC = D8  ; # Bank 501 - PS_MIO42_501
#NET  SDIO_DAT2_LS              LOC = E13 ; # Bank 501 - PS_MIO44_501
#NET  CAN_RXD_LS                LOC = D12 ; # Bank 501 - PS_MIO46_501
#NET  USB_UART_RX               LOC = D11 ; # Bank 501 - PS_MIO48_501
#NET  PS_SCL_MAIN               LOC = D13 ; # Bank 501 - PS_MIO50_501
#NET  PHY_MDC                   LOC = D10 ; # Bank 501 - PS_MIO52_501
#NET  PS_SRST_B                 LOC = C9  ; # Bank 501 - PS_SRST_B_501
#NET  PS_DIP_SW0                LOC = B6  ; # Bank 500 - PS_MIO14_500
#NET  PHY_TX_CLK                LOC = D6  ; # Bank 501 - PS_MIO16_501
#NET  PHY_TXD1                  LOC = A7  ; # Bank 501 - PS_MIO18_501
#NET  PHY_TXD3                  LOC = A8  ; # Bank 501 - PS_MIO20_501
#NET  PHY_RX_CLK                LOC = A14 ; # Bank 501 - PS_MIO22_501
#NET  PHY_RXD1                  LOC = B7  ; # Bank 501 - PS_MIO24_501
#NET  PHY_RXD3                  LOC = A13 ; # Bank 501 - PS_MIO26_501
#NET  USB_DATA4                 LOC = A12 ; # Bank 501 - PS_MIO28_501
#NET  USB_STP                   LOC = A11 ; # Bank 501 - PS_MIO30_501
#NET  USB_DATA0                 LOC = C7  ; # Bank 501 - PS_MIO32_501
#NET  USB_DATA2                 LOC = B12 ; # Bank 501 - PS_MIO34_501
#NET  USB_CLKOUT                LOC = A9  ; # Bank 501 - PS_MIO36_501
#NET  USB_DATA5                 LOC = B14 ; # Bank 501 - PS_MIO37_501
#NET  USB_DATA7                 LOC = C13 ; # Bank 501 - PS_MIO39_501
#NET  SDIO_CMD_LS               LOC = C8  ; # Bank 501 - PS_MIO41_501
#NET  SDIO_DAT1_LS              LOC = B11 ; # Bank 501 - PS_MIO43_501
#NET  SDIO_CD_DAT3_LS           LOC = B9  ; # Bank 501 - PS_MIO45_501
#NET  CAN_TXD_LS                LOC = B10 ; # Bank 501 - PS_MIO47_501
#NET  USB_UART_TX               LOC = C14 ; # Bank 501 - PS_MIO49_501
#NET  PS_SDA_MAIN               LOC = C10 ; # Bank 501 - PS_MIO51_501
#NET  PHY_MDIO                  LOC = C12 ; # Bank 501 - PS_MIO53_501
#NET  IIC_MUX_RESET_B_LS        LOC = A6  ; # Bank 500 - PS_MIO13_500
#NET  PS_DIP_SW1                LOC = C5  ; # Bank 500 - PS_MIO12_500
#NET  PHY_RESET_B_AND           LOC = B4  ; # Bank 500 - PS_MIO11_500
#NET  PS_LED1                   LOC = G7  ; # Bank 500 - PS_MIO10_500
#NET  CAN_STB_B_LS              LOC = C4  ; # Bank 500 - PS_MIO9_500
#NET  PS_MIO8_LED0              LOC = E5  ; # Bank 500 - PS_MIO8_500
#NET  USB_RESET_B_AND           LOC = D5  ; # Bank 500 - PS_MIO7_500
#NET  QSPI_CLK                  LOC = A4  ; # Bank 500 - PS_MIO6_500
#NET  QSPI_IO3                  LOC = A3  ; # Bank 500 - PS_MIO5_500
#NET  QSPI_IO2                  LOC = E4  ; # Bank 500 - PS_MIO4_500
#NET  QSPI_IO1                  LOC = F6  ; # Bank 500 - PS_MIO3_500
#NET  QSPI_IO0                  LOC = A2  ; # Bank 500 - PS_MIO2_500
#NET  QSPI_CS_B                 LOC = A1  ; # Bank 500 - PS_MIO1_500
#NET  SDIO_SDDET                LOC = G6  ; # Bank 500 - PS_MIO0_500
#NET  PS_DDR3_RESET_B           LOC = F3  ; # Bank 502 - PS_DDR_DRST_B_502
#NET  PS_DDR3_DQ3               LOC = D1  ; # Bank 502 - PS_DDR_DQ0_502
#NET  PS_DDR3_DQ1               LOC = C3  ; # Bank 502 - PS_DDR_DQ1_502
#NET  PS_DDR3_DQ6               LOC = B2  ; # Bank 502 - PS_DDR_DQ2_502
#NET  PS_DDR3_DQ7               LOC = D3  ; # Bank 502 - PS_DDR_DQ3_502
#NET  PS_DDR3_DM0               LOC = B1  ; # Bank 502 - PS_DDR_DM0_502
#NET  PS_DDR3_DQS0_P            LOC = C2  ; # Bank 502 - PS_DDR_DQS_P0_502
#NET  PS_DDR3_DQS0_N            LOC = D2  ; # Bank 502 - PS_DDR_DQS_N0_502
#NET  PS_DDR3_DQ0               LOC = E3  ; # Bank 502 - PS_DDR_DQ4_502
#NET  PS_DDR3_DQ5               LOC = E1  ; # Bank 502 - PS_DDR_DQ5_502
#NET  PS_DDR3_DQ2               LOC = F2  ; # Bank 502 - PS_DDR_DQ6_502
#NET  PS_DDR3_DQ4               LOC = F1  ; # Bank 502 - PS_DDR_DQ7_502
#NET  PS_DDR3_DQ8               LOC = G2  ; # Bank 502 - PS_DDR_DQ8_502
#NET  PS_DDR3_DQ10              LOC = G1  ; # Bank 502 - PS_DDR_DQ9_502
#NET  PS_DDR3_DQ9               LOC = L1  ; # Bank 502 - PS_DDR_DQ10_502
#NET  PS_DDR3_DQ13              LOC = L2  ; # Bank 502 - PS_DDR_DQ11_502
#NET  PS_DDR3_DM1               LOC = H3  ; # Bank 502 - PS_DDR_DM1_502
#NET  PS_DDR3_DQS1_P            LOC = H2  ; # Bank 502 - PS_DDR_DQS_P1_502
#NET  PS_DDR3_DQS1_N            LOC = J2  ; # Bank 502 - PS_DDR_DQS_N1_502
#NET  PS_DDR3_DQ12              LOC = L3  ; # Bank 502 - PS_DDR_DQ12_502
#NET  PS_DDR3_DQ11              LOC = K1  ; # Bank 502 - PS_DDR_DQ13_502
#NET  PS_DDR3_DQ14              LOC = J1  ; # Bank 502 - PS_DDR_DQ14_502
#NET  PS_DDR3_DQ15              LOC = K3  ; # Bank 502 - PS_DDR_DQ15_502
#NET  PS_DDR3_A14               LOC = G4  ; # Bank 502 - PS_DDR_A14_502
#NET  PS_DDR3_A13               LOC = F4  ; # Bank 502 - PS_DDR_A13_502
#NET  PS_DDR3_A12               LOC = H4  ; # Bank 502 - PS_DDR_A12_502
#NET  PS_DDR3_A11               LOC = G5  ; # Bank 502 - PS_DDR_A11_502
#NET  PS_DDR3_A10               LOC = J3  ; # Bank 502 - PS_DDR_A10_502
#NET  PS_DDR3_A9                LOC = H5  ; # Bank 502 - PS_DDR_A9_502
#NET  PS_DDR3_A8                LOC = J5  ; # Bank 502 - PS_DDR_A8_502
#NET  PS_DDR3_A7                LOC = J6  ; # Bank 502 - PS_DDR_A7_502
#NET  PS_DDR3_A6                LOC = J7  ; # Bank 502 - PS_DDR_A6_502
#NET  PS_DDR3_A5                LOC = K5  ; # Bank 502 - PS_DDR_A5_502
#NET  PS_DDR3_A4                LOC = K6  ; # Bank 502 - PS_DDR_A4_502
#NET  PS_DDR3_A3                LOC = L4  ; # Bank 502 - PS_DDR_A3_502
#NET  PS_VRN                    LOC = M7  ; # Bank 502 - PS_DDR_VRN_502
#NET  PS_VRP                    LOC = N7  ; # Bank 502 - PS_DDR_VRP_502
#NET  PS_DDR3_CLK_P             LOC = N4  ; # Bank 502 - PS_DDR_CKP_502
#NET  PS_DDR3_CLK_N             LOC = N5  ; # Bank 502 - PS_DDR_CKN_502
#NET  PS_DDR3_A2                LOC = K4  ; # Bank 502 - PS_DDR_A2_502
#NET  PS_DDR3_A1                LOC = M5  ; # Bank 502 - PS_DDR_A1_502
#NET  PS_DDR3_A0                LOC = M4  ; # Bank 502 - PS_DDR_A0_502
#NET  PS_DDR3_BA2               LOC = M6  ; # Bank 502 - PS_DDR_BA2_502
#NET  PS_DDR3_BA1               LOC = L6  ; # Bank 502 - PS_DDR_BA1_502 = 1.5v
#NET  PS_DDR3_BA0               LOC = L7  ; # Bank 502 - PS_DDR_BA0_502
#NET  PS_DDR3_ODT               LOC = P5  ; # Bank 502 - PS_DDR_ODT_502
#NET  PS_DDR3_CS_B              LOC = P6  ; # Bank 502 - PS_DDR_CS_B_502
#NET  PS_DDR3_CKE               LOC = V3  ; # Bank 502 - PS_DDR_CKE_502
#NET  PS_DDR3_WE_B              LOC = R4  ; # Bank 502 - PS_DDR_WE_B_502
#NET  PS_DDR3_CAS_B             LOC = P3  ; # Bank 502 - PS_DDR_CAS_B_502
#NET  PS_DDR3_RAS_B             LOC = R5  ; # Bank 502 - PS_DDR_RAS_B_502
#NET  PS_DDR3_DQ16              LOC = M1  ; # Bank 502 - PS_DDR_DQ16_502
#NET  PS_DDR3_DQ17              LOC = T3  ; # Bank 502 - PS_DDR_DQ17_502
#NET  PS_DDR3_DQ18              LOC = N3  ; # Bank 502 - PS_DDR_DQ18_502
#NET  PS_DDR3_DQ19              LOC = T1  ; # Bank 502 - PS_DDR_DQ19_502
#NET  PS_DDR3_DM2               LOC = P1  ; # Bank 502 - PS_DDR_DM2_502
#NET  PS_DDR3_DQS2_P            LOC = N2  ; # Bank 502 - PS_DDR_DQS_P2_502
#NET  PS_DDR3_DQS2_N            LOC = P2  ; # Bank 502 - PS_DDR_DQS_N2_502
#NET  PS_DDR3_DQ20              LOC = R3  ; # Bank 502 - PS_DDR_DQ20_502
#NET  PS_DDR3_DQ21              LOC = T2  ; # Bank 502 - PS_DDR_DQ21_502
#NET  PS_DDR3_DQ22              LOC = M2  ; # Bank 502 - PS_DDR_DQ22_502
#NET  PS_DDR3_DQ23              LOC = R1  ; # Bank 502 - PS_DDR_DQ23_502
#NET  PS_DDR3_DQ27              LOC = AA3 ; # Bank 502 - PS_DDR_DQ24_502
#NET  PS_DDR3_DQ24              LOC = U1  ; # Bank 502 - PS_DDR_DQ25_502
#NET  PS_DDR3_DQ25              LOC = AA1 ; # Bank 502 - PS_DDR_DQ26_502
#NET  PS_DDR3_DQ26              LOC = U2  ; # Bank 502 - PS_DDR_DQ27_502
#NET  PS_DDR3_DM3               LOC = AA2 ; # Bank 502 - PS_DDR_DM3_502
#NET  PS_DDR3_DQS3_P            LOC = V2  ; # Bank 502 - PS_DDR_DQS_P3_502
#NET  PS_DDR3_DQS3_N            LOC = W2  ; # Bank 502 - PS_DDR_DQS_N3_502
#NET  PS_DDR3_DQ28              LOC = W1  ; # Bank 502 - PS_DDR_DQ28_502
#NET  PS_DDR3_DQ29              LOC = Y3  ; # Bank 502 - PS_DDR_DQ29_502
#NET  PS_DDR3_DQ30              LOC = W3  ; # Bank 502 - PS_DDR_DQ30_502
#NET  PS_DDR3_DQ31              LOC = Y1  ; # Bank 502 - PS_DDR_DQ31_502
#NET  GND                       LOC = A5  ; # Bank 999 - GND
#NET  GND                       LOC = A15 ; # Bank 999 - GND
#NET  GND                       LOC = AA5 ; # Bank 999 - GND
#NET  GND                       LOC = AA15; # Bank 999 - GND
#NET  GND                       LOC = AB8 ; # Bank 999 - GND
#NET  GND                       LOC = AB18; # Bank 999 - GND
#NET  GND                       LOC = B8  ; # Bank 999 - GND
#NET  GND                       LOC = B18 ; # Bank 999 - GND
#NET  GND                       LOC = C1  ; # Bank 999 - GND
#NET  GND                       LOC = C11 ; # Bank 999 - GND
#NET  GND                       LOC = C21 ; # Bank 999 - GND
#NET  GND                       LOC = D4  ; # Bank 999 - GND
#NET  GND                       LOC = D14 ; # Bank 999 - GND
#NET  GND                       LOC = E7  ; # Bank 999 - GND
#NET  GND                       LOC = E17 ; # Bank 999 - GND
#NET  GND                       LOC = F10 ; # Bank 999 - GND
#NET  GND                       LOC = F20 ; # Bank 999 - GND
#NET  GND                       LOC = G3  ; # Bank 999 - GND
#NET  GND                       LOC = H6  ; # Bank 999 - GND
#NET  GND                       LOC = H8  ; # Bank 999 - GND
#NET  GND                       LOC = H12 ; # Bank 999 - GND
#NET  GND                       LOC = H14 ; # Bank 999 - GND
#NET  GND                       LOC = H16 ; # Bank 999 - GND
#NET  GND                       LOC = J9  ; # Bank 999 - GND
#NET  GND                       LOC = J11 ; # Bank 999 - GND
#NET  GND                       LOC = J13 ; # Bank 999 - GND
#NET  GND                       LOC = J19 ; # Bank 999 - GND
#NET  GND                       LOC = K2  ; # Bank 999 - GND
#NET  GND                       LOC = K8  ; # Bank 999 - GND
#NET  GND                       LOC = K10 ; # Bank 999 - GND
#NET  GND                       LOC = K14 ; # Bank 999 - GND
#NET  GND                       LOC = K22 ; # Bank 999 - GND
#NET  GND                       LOC = L5  ; # Bank 999 - GND
#NET  GND                       LOC = L9  ; # Bank 999 - GND
#NET  GND                       LOC = L13 ; # Bank 999 - GND
#NET  GND                       LOC = L15 ; # Bank 999 - GND
#NET  GND                       LOC = M8  ; # Bank 999 - GND
#NET  GND                       LOC = M10 ; # Bank 999 - GND
#NET  GND                       LOC = M14 ; # Bank 999 - GND
#NET  GND                       LOC = M18 ; # Bank 999 - GND
#NET  GND                       LOC = N1  ; # Bank 999 - GND
#NET  GND                       LOC = N9  ; # Bank 999 - GND
#NET  GND                       LOC = N13 ; # Bank 999 - GND
#NET  GND                       LOC = N21 ; # Bank 999 - GND
#NET  GND                       LOC = P4  ; # Bank 999 - GND
#NET  GND                       LOC = P8  ; # Bank 999 - GND
#NET  GND                       LOC = P10 ; # Bank 999 - GND
#NET  GND                       LOC = P12 ; # Bank 999 - GND
#NET  GND                       LOC = P14 ; # Bank 999 - GND
#NET  GND                       LOC = R9  ; # Bank 999 - GND
#NET  GND                       LOC = R11 ; # Bank 999 - GND
#NET  GND                       LOC = R13 ; # Bank 999 - GND
#NET  GND                       LOC = R17 ; # Bank 999 - GND
#NET  GND                       LOC = T20 ; # Bank 999 - GND
#NET  GND                       LOC = U3  ; # Bank 999 - GND
#NET  GND                       LOC = U13 ; # Bank 999 - GND
#NET  GND                       LOC = V6  ; # Bank 999 - GND
#NET  GND                       LOC = V16 ; # Bank 999 - GND
#NET  GND                       LOC = W9  ; # Bank 999 - GND
#NET  GND                       LOC = W19 ; # Bank 999 - GND
#NET  GND                       LOC = Y2  ; # Bank 999 - GND
#NET  GND                       LOC = Y12 ; # Bank 999 - GND
#NET  GND                       LOC = Y22 ; # Bank 999 - GND
#NET  VCCINT                    LOC = J12 ; # Bank 999 - VCCINT
#NET  VCCINT                    LOC = J14 ; # Bank 999 - VCCINT
#NET  VCCINT                    LOC = K13 ; # Bank 999 - VCCINT
#NET  VCCINT                    LOC = L14 ; # Bank 999 - VCCINT
#NET  VCCINT                    LOC = M13 ; # Bank 999 - VCCINT
#NET  VCCINT                    LOC = N14 ; # Bank 999 - VCCINT
#NET  VCCINT                    LOC = P13 ; # Bank 999 - VCCINT
#NET  VCCINT                    LOC = R14 ; # Bank 999 - VCCINT
#NET  VCCAUX                    LOC = L10 ; # Bank 999 - VCCAUX
#NET  VCCAUX                    LOC = N10 ; # Bank 999 - VCCAUX
#NET  VCCAUX                    LOC = P11 ; # Bank 999 - VCCAUX
#NET  VCCAUX                    LOC = R10 ; # Bank 999 - VCCAUX
#NET  VCC2V5_PL                 LOC = R12 ; # Bank   0 - VCCO_0
#NET  VADJ                      LOC = AA10; # Bank  13 - VCCO_13
#NET  VADJ                      LOC = AB3 ; # Bank  13 - VCCO_13
#NET  VADJ                      LOC = T5  ; # Bank  13 - VCCO_13
#NET  VADJ                      LOC = U8  ; # Bank  13 - VCCO_13
#NET  VADJ                      LOC = V11 ; # Bank  13 - VCCO_13
#NET  VADJ                      LOC = W4  ; # Bank  13 - VCCO_13
#NET  VADJ                      LOC = Y7  ; # Bank  13 - VCCO_13
#NET  VADJ                      LOC = AA20; # Bank  33 - VCCO_33
#NET  VADJ                      LOC = AB13; # Bank  33 - VCCO_33
#NET  VADJ                      LOC = U18 ; # Bank  33 - VCCO_33
#NET  VADJ                      LOC = V21 ; # Bank  33 - VCCO_33
#NET  VADJ                      LOC = W14 ; # Bank  33 - VCCO_33
#NET  VADJ                      LOC = Y17 ; # Bank  33 - VCCO_33
#NET  VADJ                      LOC = K17 ; # Bank  34 - VCCO_34
#NET  VADJ                      LOC = L20 ; # Bank  34 - VCCO_34
#NET  VADJ                      LOC = N16 ; # Bank  34 - VCCO_34
#NET  VADJ                      LOC = P19 ; # Bank  34 - VCCO_34
#NET  VADJ                      LOC = R22 ; # Bank  34 - VCCO_34
#NET  VADJ                      LOC = T15 ; # Bank  34 - VCCO_34
#NET  VADJ                      LOC = A20 ; # Bank  35 - VCCO_35
#NET  VADJ                      LOC = C16 ; # Bank  35 - VCCO_35
#NET  VADJ                      LOC = D19 ; # Bank  35 - VCCO_35
#NET  VADJ                      LOC = E22 ; # Bank  35 - VCCO_35
#NET  VADJ                      LOC = F15 ; # Bank  35 - VCCO_35
#NET  VADJ                      LOC = G18 ; # Bank  35 - VCCO_35
#NET  VADJ                      LOC = H21 ; # Bank  35 - VCCO_35
#NET  VCCBRAM                   LOC = H11 ; # Bank 999 - VCCBRAM
#NET  VCCBRAM                   LOC = J10 ; # Bank 999 - VCCBRAM
#NET  VCC1V5_PS                 LOC = E2  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  VCC1V5_PS                 LOC = F5  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  VCC1V5_PS                 LOC = H1  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  VCC1V5_PS                 LOC = J4  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  VCC1V5_PS                 LOC = K7  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  VCC1V5_PS                 LOC = M3  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  VCC1V5_PS                 LOC = N6  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  VCC1V5_PS                 LOC = R2  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  VCC1V5_PS                 LOC = V1  ; # Bank 502 - VCCO_DDR_502 = 1.5v
#NET  10N519                    LOC = H10 ; # Bank 999 - VCCPLL
#NET  VCCPAUX                   LOC = K9  ; # Bank 999 - VCCPAUX
#NET  VCCPAUX                   LOC = M9  ; # Bank 999 - VCCPAUX
#NET  VCCPAUX                   LOC = P9  ; # Bank 999 - VCCPAUX
#NET  VCCPAUX                   LOC = T9  ; # Bank 999 - VCCPAUX
#NET  VCCPINT                   LOC = G8  ; # Bank 999 - VCCPINT
#NET  VCCPINT                   LOC = H9  ; # Bank 999 - VCCPINT
#NET  VCCPINT                   LOC = J8  ; # Bank 999 - VCCPINT 
#NET  VCCPINT                   LOC = L8  ; # Bank 999 - VCCPINT
#NET  VCCPINT                   LOC = N8  ; # Bank 999 - VCCPINT
#NET  VCCPINT                   LOC = R8  ; # Bank 999 - VCCPINT
#NET  VCCMIO_PS                 LOC = B3  ; # Bank 500 - VCCO_MIO0_500 = 1.8v
#NET  VCCMIO_PS                 LOC = C6  ; # Bank 500 - VCCO_MIO0_500 = 1.8v
#NET  VCCMIO_PS                 LOC = A10 ; # Bank 501 - VCCO_MIO1_501 = 1.8v
#NET  VCCMIO_PS                 LOC = B13 ; # Bank 501 - VCCO_MIO1_501 = 1.8v
#NET  VCCMIO_PS                 LOC = D9  ; # Bank 501 - VCCO_MIO1_501 = 1.8v
#NET  VCCMIO_PS                 LOC = E12 ; # Bank 501 - VCCO_MIO1_501 = 1.8v
#NET  VTTVREF_PS                LOC = H7  ; # Bank 502 - PS_DDR_VREF0_502 = 0.75v
#NET  VTTVREF_PS                LOC = P7  ; # Bank 502 - PS_DDR_VREF1_502 = 0.75v

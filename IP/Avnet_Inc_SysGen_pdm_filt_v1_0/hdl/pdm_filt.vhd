-- Generated from Simulink block dspsdadc_sg_LL03/PDM_Filt/unipolar_to_bipolar
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity pdm_filt_unipolar_to_bipolar is
  port (
    in1 : in std_logic_vector( 1-1 downto 0 );
    clk_64 : in std_logic;
    ce_64 : in std_logic;
    out1 : out std_logic_vector( 2-1 downto 0 )
  );
end pdm_filt_unipolar_to_bipolar;
architecture structural of pdm_filt_unipolar_to_bipolar is 
  signal clk_net : std_logic;
  signal ce_net : std_logic;
  signal concat_y_net : std_logic_vector( 2-1 downto 0 );
  signal inverter_op_net : std_logic_vector( 1-1 downto 0 );
  signal constant_op_net : std_logic_vector( 1-1 downto 0 );
  signal convert_dout_net : std_logic_vector( 2-1 downto 0 );
  signal pdm_in_net : std_logic_vector( 1-1 downto 0 );
begin
  out1 <= convert_dout_net;
  pdm_in_net <= in1;
  clk_net <= clk_64;
  ce_net <= ce_64;
  concat : entity xil_defaultlib.sysgen_concat_f28f7ae7b2 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    in0 => inverter_op_net,
    in1 => constant_op_net,
    y => concat_y_net
  );
  constant_x0 : entity xil_defaultlib.sysgen_constant_8e7d267405 
  port map (
    clk => '0',
    ce => '0',
    clr => '0',
    op => constant_op_net
  );
  convert : entity xil_defaultlib.pdm_filt_xlconvert 
  generic map (
    bool_conversion => 0,
    din_arith => 1,
    din_bin_pt => 0,
    din_width => 2,
    dout_arith => 2,
    dout_bin_pt => 0,
    dout_width => 2,
    latency => 1,
    overflow => xlWrap,
    quantization => xlTruncate
  )
  port map (
    clr => '0',
    en => "1",
    din => concat_y_net,
    clk => clk_net,
    ce => ce_net,
    dout => convert_dout_net
  );
  inverter : entity xil_defaultlib.sysgen_inverter_6d666fb85e 
  port map (
    clr => '0',
    ip => pdm_in_net,
    clk => clk_net,
    ce => ce_net,
    op => inverter_op_net
  );
end structural;
-- Generated from Simulink block dspsdadc_sg_LL03/PDM_Filt_struct
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity pdm_filt_struct is
  port (
    pdm_in : in std_logic_vector( 1-1 downto 0 );
    clk_1 : in std_logic;
    ce_1 : in std_logic;
    clk_64 : in std_logic;
    ce_64 : in std_logic;
    clk_4096 : in std_logic;
    ce_4096 : in std_logic;
    audio_ce : out std_logic_vector( 1-1 downto 0 );
    audio_out : out std_logic_vector( 16-1 downto 0 )
  );
end pdm_filt_struct;
architecture structural of pdm_filt_struct is 
  signal fir_7_2_s_axis_data_tready_net : std_logic;
  signal fir_7_2_m_axis_data_tvalid_net : std_logic;
  signal fir_7_2_m_axis_data_tdata_real_net : std_logic_vector( 21-1 downto 0 );
  signal fir_7_2_1_s_axis_data_tready_net : std_logic;
  signal fir_7_2_1_m_axis_data_tvalid_net : std_logic;
  signal fir_7_2_1_m_axis_data_tdata_real_net : std_logic_vector( 16-1 downto 0 );
  signal requantize_dout_net : std_logic_vector( 14-1 downto 0 );
  signal clock_enable_probe_q_net : std_logic_vector( 1-1 downto 0 );
  signal requantize1_dout_net : std_logic_vector( 16-1 downto 0 );
  signal pdm_in_net : std_logic_vector( 1-1 downto 0 );
  signal clk_net : std_logic;
  signal ce_net : std_logic;
  signal clk_net_x1 : std_logic;
  signal ce_net_x1 : std_logic;
  signal clk_net_x0 : std_logic;
  signal ce_net_x0 : std_logic;
  signal convert_dout_net : std_logic_vector( 2-1 downto 0 );
begin
  audio_ce <= clock_enable_probe_q_net;
  audio_out <= requantize1_dout_net;
  pdm_in_net <= pdm_in;
  clk_net <= clk_1;
  ce_net <= ce_1;
  clk_net_x1 <= clk_64;
  ce_net_x1 <= ce_64;
  clk_net_x0 <= clk_4096;
  ce_net_x0 <= ce_4096;
  unipolar_to_bipolar : entity xil_defaultlib.pdm_filt_unipolar_to_bipolar 
  port map (
    in1 => pdm_in_net,
    clk_64 => clk_net_x1,
    ce_64 => ce_net_x1,
    out1 => convert_dout_net
  );
  clock_enable_probe : entity xil_defaultlib.pdm_filt_xlceprobe 
  generic map (
    d_width => 16,
    q_width => 1
  )
  port map (
    d => requantize1_dout_net,
    clk => clk_net_x0,
    ce => ce_net_x0,
    q => clock_enable_probe_q_net
  );
  fir_7_2 : entity xil_defaultlib.xlfir_compiler_8e0b665c0fbdaa5012b8b3a78d0f3ea2 
  port map (
    s_axis_data_tdata_real => convert_dout_net,
    src_clk => clk_net_x1,
    src_ce => ce_net_x1,
    clk => clk_net,
    ce => ce_net,
    clk_64 => clk_net_x1,
    ce_64 => ce_net_x1,
    clk_4096 => clk_net_x0,
    ce_4096 => ce_net_x0,
    clk_logic_64 => clk_net_x1,
    ce_logic_64 => ce_net_x1,
    s_axis_data_tready => fir_7_2_s_axis_data_tready_net,
    m_axis_data_tvalid => fir_7_2_m_axis_data_tvalid_net,
    m_axis_data_tdata_real => fir_7_2_m_axis_data_tdata_real_net
  );
  fir_7_2_1 : entity xil_defaultlib.xlfir_compiler_010a411783fc1134e3d7952b43113c76 
  port map (
    s_axis_data_tdata_real => requantize_dout_net,
    src_clk => clk_net_x0,
    src_ce => ce_net_x0,
    clk => clk_net,
    ce => ce_net,
    clk_4096 => clk_net_x0,
    ce_4096 => ce_net_x0,
    clk_logic_4096 => clk_net_x0,
    ce_logic_4096 => ce_net_x0,
    s_axis_data_tready => fir_7_2_1_s_axis_data_tready_net,
    m_axis_data_tvalid => fir_7_2_1_m_axis_data_tvalid_net,
    m_axis_data_tdata_real => fir_7_2_1_m_axis_data_tdata_real_net
  );
  requantize : entity xil_defaultlib.pdm_filt_xlrequantize 
  generic map (
    din_arith => 2,
    din_bin_pt => 11,
    din_width => 21,
    dout_arith => 2,
    dout_bin_pt => 11,
    dout_width => 14,
    latency => 3
  )
  port map (
    en => "1",
    clr => '0',
    din => fir_7_2_m_axis_data_tdata_real_net,
    clk => clk_net_x0,
    ce => ce_net_x0,
    dout => requantize_dout_net
  );
  requantize1 : entity xil_defaultlib.pdm_filt_xlrequantize 
  generic map (
    din_arith => 2,
    din_bin_pt => 11,
    din_width => 16,
    dout_arith => 2,
    dout_bin_pt => 13,
    dout_width => 16,
    latency => 3
  )
  port map (
    en => "1",
    clr => '0',
    din => fir_7_2_1_m_axis_data_tdata_real_net,
    clk => clk_net_x0,
    ce => ce_net_x0,
    dout => requantize1_dout_net
  );
end structural;
-- Generated from Simulink block 
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity pdm_filt_default_clock_driver is
  port (
    pdm_filt_sysclk : in std_logic;
    pdm_filt_sysce : in std_logic;
    pdm_filt_sysclr : in std_logic;
    pdm_filt_clk1 : out std_logic;
    pdm_filt_ce1 : out std_logic;
    pdm_filt_clk64 : out std_logic;
    pdm_filt_ce64 : out std_logic;
    pdm_filt_clk4096 : out std_logic;
    pdm_filt_ce4096 : out std_logic
  );
end pdm_filt_default_clock_driver;
architecture structural of pdm_filt_default_clock_driver is 
begin
  clockdriver_x1 : entity xil_defaultlib.xlclockdriver 
  generic map (
    period => 1,
    log_2_period => 1
  )
  port map (
    sysclk => pdm_filt_sysclk,
    sysce => pdm_filt_sysce,
    sysclr => pdm_filt_sysclr,
    clk => pdm_filt_clk1,
    ce => pdm_filt_ce1
  );
  clockdriver_x0 : entity xil_defaultlib.xlclockdriver 
  generic map (
    period => 64,
    log_2_period => 7
  )
  port map (
    sysclk => pdm_filt_sysclk,
    sysce => pdm_filt_sysce,
    sysclr => pdm_filt_sysclr,
    clk => pdm_filt_clk64,
    ce => pdm_filt_ce64
  );
  clockdriver : entity xil_defaultlib.xlclockdriver 
  generic map (
    period => 4096,
    log_2_period => 13
  )
  port map (
    sysclk => pdm_filt_sysclk,
    sysce => pdm_filt_sysce,
    sysclr => pdm_filt_sysclr,
    clk => pdm_filt_clk4096,
    ce => pdm_filt_ce4096
  );
end structural;
-- Generated from Simulink block 
library IEEE;
use IEEE.std_logic_1164.all;
library xil_defaultlib;
use xil_defaultlib.conv_pkg.all;
entity pdm_filt is
  port (
    pdm_in : in std_logic;
    clk : in std_logic;
    audio_ce : out std_logic;
    audio_out : out std_logic_vector( 16-1 downto 0 )
  );
end pdm_filt;
architecture structural of pdm_filt is 
  attribute core_generation_info : string;
  attribute core_generation_info of structural : architecture is "pdm_filt,sysgen_core_2017_1,{,compilation=IP Catalog,block_icon_display=Default,family=zynq,part=xc7z007s,speed=-1,package=clg225,synthesis_language=vhdl,hdl_library=xil_defaultlib,synthesis_strategy=Vivado Synthesis Defaults,implementation_strategy=Vivado Implementation Defaults,testbench=0,interface_doc=0,ce_clr=0,clock_period=6.25,system_simulink_period=6.25e-09,waveform_viewer=0,axilite_interface=0,ip_catalog_plugin=0,hwcosim_burst_mode=0,simulation_time=0.523599,ceprobe=1,concat=1,constant=1,convert=1,fir_compiler_v7_2=2,inv=1,requantizer=2,}";
  signal clk_1_net : std_logic;
  signal ce_1_net : std_logic;
  signal clk_64_net : std_logic;
  signal ce_64_net : std_logic;
  signal clk_4096_net : std_logic;
  signal ce_4096_net : std_logic;
begin
  pdm_filt_default_clock_driver : entity xil_defaultlib.pdm_filt_default_clock_driver 
  port map (
    pdm_filt_sysclk => clk,
    pdm_filt_sysce => '1',
    pdm_filt_sysclr => '0',
    pdm_filt_clk1 => clk_1_net,
    pdm_filt_ce1 => ce_1_net,
    pdm_filt_clk64 => clk_64_net,
    pdm_filt_ce64 => ce_64_net,
    pdm_filt_clk4096 => clk_4096_net,
    pdm_filt_ce4096 => ce_4096_net
  );
  pdm_filt_struct : entity xil_defaultlib.pdm_filt_struct 
  port map (
    pdm_in(0) => pdm_in,
    clk_1 => clk_1_net,
    ce_1 => ce_1_net,
    clk_64 => clk_64_net,
    ce_64 => ce_64_net,
    clk_4096 => clk_4096_net,
    ce_4096 => ce_4096_net,
    audio_ce(0) => audio_ce,
    audio_out => audio_out
  );
end structural;

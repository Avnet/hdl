  sysgen_dut : entity xil_defaultlib.pdm_filter_sysgen 
  port map (
    pdm_in => pdm_in,
    clk => clk,
    audio_ce => audio_ce,
    audio_out => audio_out
  );

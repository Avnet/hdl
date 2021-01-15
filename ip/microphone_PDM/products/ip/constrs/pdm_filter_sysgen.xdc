set rateCepdm_filter_sysgen64 pdm_filter_sysgen_default_clock_driver/clockdriver_x0/pipelined_ce.ce_pipeline[1].ce_reg/latency_gt_0.fd_array[1].reg_comp/fd_prim_array[0].bit_is_0.fdre_comp
set rateCellspdm_filter_sysgen64 [get_cells -of [filter [all_fanout -flat -endpoints [get_pins $rateCepdm_filter_sysgen64/Q]] IS_ENABLE]]
set rateCepdm_filter_sysgen4096 pdm_filter_sysgen_default_clock_driver/clockdriver/pipelined_ce.ce_pipeline[1].ce_reg/latency_gt_0.fd_array[1].reg_comp/fd_prim_array[0].bit_is_0.fdre_comp
set rateCellspdm_filter_sysgen4096 [get_cells -of [filter [all_fanout -flat -endpoints [get_pins $rateCepdm_filter_sysgen4096/Q]] IS_ENABLE]]
set_multicycle_path -from $rateCellspdm_filter_sysgen64 -to $rateCellspdm_filter_sysgen64 -setup 64
set_multicycle_path -from $rateCellspdm_filter_sysgen64 -to $rateCellspdm_filter_sysgen64 -hold 63
set_multicycle_path -from $rateCellspdm_filter_sysgen64 -to $rateCellspdm_filter_sysgen4096 -setup 64
set_multicycle_path -from $rateCellspdm_filter_sysgen64 -to $rateCellspdm_filter_sysgen4096 -hold 63
set_multicycle_path -from $rateCellspdm_filter_sysgen4096 -to $rateCellspdm_filter_sysgen64 -setup 64
set_multicycle_path -from $rateCellspdm_filter_sysgen4096 -to $rateCellspdm_filter_sysgen64 -hold 63
set_multicycle_path -from $rateCellspdm_filter_sysgen4096 -to $rateCellspdm_filter_sysgen4096 -setup 4096
set_multicycle_path -from $rateCellspdm_filter_sysgen4096 -to $rateCellspdm_filter_sysgen4096 -hold 4095

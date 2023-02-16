create_clock -name clk -period $my_period [get_ports $my_clk]
set_clock_uncertainty $my_uncertainty [get_clocks $my_clk]
set_input_delay -max 0.0 [get_ports $all_in_ex_clk] -clock [get_clocks $my_clk]
set_output_delay -max 0.0 [get_ports $all_out] -clock [get_clocks $my_clk]
set_load [expr [load_of sky130_osu_sc_18T_ms_TT_1P8_25C.ccs/sky130_osu_sc_18T_ms__dff_1/D] * 1] [all_outputs]
set_driving_cell  -lib_cell sky130_osu_sc_18T_ms__dff_1 -pin Q $all_in_ex_clk

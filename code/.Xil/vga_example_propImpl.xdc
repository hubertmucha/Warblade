set_property SRC_FILE_INFO {cfile:E:/warblade/Warblade/code/constr/clk_wiz_0.xdc rfile:../constr/clk_wiz_0.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.1
set_property src_info {type:XDC file:1 line:60 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]

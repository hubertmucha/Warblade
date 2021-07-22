set project vga_project
set top_module vga_example
set target xc7a35tcpg236-1
set bitstream_file build/${project}.runs/impl_1/${top_module}.bit

proc usage {} {
    puts "usage: vivado -mode tcl -source [info script] -tclargs \[simulation/bitstream/program\gui/]"
    exit 1
}

if {($argc != 1) || ([lindex $argv 0] ni {"simulation" "bitstream" "program"})} {
    usage
}



if {[lindex $argv 0] == "program"} {
	open_hw
    connect_hw_server
    current_hw_target [get_hw_targets *]
    open_hw_target
    current_hw_device [lindex [get_hw_devices] 0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]

    set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
    set_property FULL_PROBES.FILE {} [lindex [get_hw_devices] 0]
    set_property PROGRAM.FILE ${bitstream_file} [lindex [get_hw_devices] 0]

    program_hw_devices [lindex [get_hw_devices] 0]
    refresh_hw_device [lindex [get_hw_devices] 0]
    
    exit
} else {
    file mkdir build
    create_project ${project} build -part ${target} -force
}

read_xdc {
    constr/vga_example.xdc
    constr/clk_wiz_0.xdc
}

read_verilog {
    src/vga_example.v
    src/vga_timing.v
    src/draw_background.v
    src/draw_react.v

    src/clk_wiz_0_clk_wiz.v
    src/clk_wiz_0.v

    src/dff.v
    src/lock_reset.v

    src/image_rom.v
    src/dff_image.v
    src/dff_hs_vs.v

    src/font_rom.v
    src/draw_rect_char.v
    src/delay.v
    src/char_rom_16x16.v
}

add_files -fileset sim_1 {
    sim/testbench.v
    sim/tiff_writer.v
    sim/draw_rect_ctl_tb.v
    sim/draw_rect_ctl_test.v
}

set_property top ${top_module} [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

if {[lindex $argv 0] == "simulation"} {
    launch_simulation
    add_wave {{/draw_rect_ctl_test/my_draw_rect_ctl}} 
    start_gui
} else {
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1

    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1
    exit
}
if {[lindex $argv 0] == "gui"} {
    start_gui
}
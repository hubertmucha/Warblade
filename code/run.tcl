set project vga_project
set top_module main
set target xc7a35tcpg236-1
set bitstream_file build/${project}.runs/impl_1/${top_module}.bit

proc usage {} {
    puts "usage: vivado -mode tcl -source [info script] -tclargs \[simulation/bitstream/program/gui]"
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
    src/main.v
    src/vga_timing.v
    src/draw_background.v

    src/clk_wiz_0_clk_wiz.v
    src/clk_wiz_0.v

    src/dff.v
    src/lock_reset.v

    src/dff_image.v
    src/dff_hs_vs.v
    src/delay.v

    src/text/font_rom.v
    src/text/draw_rect_char.v
    src/text/char_rom_16x16.v
    src/text/textbox.v

    src/ship/ctl_ship.v
    src/ship/missle_ctl.v
    src/ship/draw_missile.v
    src/ship/draw_ship.v
    src/ship/image_rom.v
    src/ship/draw_react.v

    src/enemies/enemies.v
    src/enemies/draw_enemy.v
    src/enemies/ctl_enemy.v
    src/enemies/en_one.v
    src/enemies/detec_col.v
    src/enemies/draw_missile_en.v
    src/enemies/ctl_missile_en.v
}

add_files -fileset sim_1 {
    sim/testbench.v
    sim/tiff_writer.v
    sim/draw_rect_ctl_tb.v
    sim/draw_rect_ctl_test.v

    sim/ctl_enemy_test.v
}

set_property top ${top_module} [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

if {[lindex $argv 0] == "simulation"} {
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
# Constraints for CLK
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -name external_clock -period 10.00 [get_ports clk]

# Constraints for VS and HS
set_property PACKAGE_PIN R19 [get_ports vs]
set_property IOSTANDARD LVCMOS33 [get_ports vs]
set_property PACKAGE_PIN P19 [get_ports hs]
set_property IOSTANDARD LVCMOS33 [get_ports hs]

# Constraints for RED
set_property PACKAGE_PIN G19 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property PACKAGE_PIN H19 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property PACKAGE_PIN J19 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property PACKAGE_PIN N19 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]

# Constraints for GRN
set_property PACKAGE_PIN J17 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property PACKAGE_PIN H17 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property PACKAGE_PIN G17 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property PACKAGE_PIN D17 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]

# Constraints for BLU
set_property PACKAGE_PIN N18 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property PACKAGE_PIN L18 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN K18 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property PACKAGE_PIN J18 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]

# Constraints for PCLK_MIRROR
set_property PACKAGE_PIN R18 [get_ports pclk_mirror]
set_property IOSTANDARD LVCMOS33 [get_ports pclk_mirror]

# Constraints for CFGBVS
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Switches
# U17 - reset
set_property PACKAGE_PIN U17 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]


## Constrains for keypad 4x4
###Pmod Header JA
###Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {rows[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rows[0]}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {rows[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rows[1]}]
#Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {rows[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rows[2]}]
#Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {rows[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rows[3]}]
#Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {columns[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {columns[0]}]
#Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {columns[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {columns[1]}]
#Sch name = JA9
set_property PACKAGE_PIN H2 [get_ports {columns[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {columns[2]}]
###Sch name = JA10
##set_property PACKAGE_PIN G3 [get_ports {JA[7]}]
#	#set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]


## Constrains for 7 segment display
set_property PACKAGE_PIN W7 [get_ports {sseg_ca[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[0]}]
set_property PACKAGE_PIN W6 [get_ports {sseg_ca[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[1]}]
set_property PACKAGE_PIN U8 [get_ports {sseg_ca[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[2]}]
set_property PACKAGE_PIN V8 [get_ports {sseg_ca[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[3]}]
set_property PACKAGE_PIN U5 [get_ports {sseg_ca[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[4]}]
set_property PACKAGE_PIN V5 [get_ports {sseg_ca[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[5]}]
set_property PACKAGE_PIN U7 [get_ports {sseg_ca[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[6]}]
set_property PACKAGE_PIN V7 [get_ports {sseg_ca[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_ca[7]}]

set_property PACKAGE_PIN U2 [get_ports {sseg_an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[0]}]
set_property PACKAGE_PIN U4 [get_ports {sseg_an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[1]}]
set_property PACKAGE_PIN V4 [get_ports {sseg_an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[2]}]
set_property PACKAGE_PIN W4 [get_ports {sseg_an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sseg_an[3]}]


# pin JB1 - A14 RX
set_property PACKAGE_PIN A14 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
# pin JB2 - A16 RX
set_property PACKAGE_PIN A16 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]



create_generated_clock -name pclk_mirror -source [get_pins pclk_oddr/C] -divide_by 1 [get_ports pclk_mirror]
create_clock -period 76.923 -name VIRTUAL_clk_13Mhz_clk_wiz -waveform {0.000 38.462}
create_clock -period 15.385 -name VIRTUAL_clk_65Mhz_clk_wiz -waveform {0.000 7.692}
set_input_delay -clock [get_clocks VIRTUAL_clk_13Mhz_clk_wiz] -min -add_delay 0.400 [get_ports {columns[*]}]
set_input_delay -clock [get_clocks VIRTUAL_clk_13Mhz_clk_wiz] -max -add_delay 0.600 [get_ports {columns[*]}]
set_input_delay -clock [get_clocks VIRTUAL_clk_13Mhz_clk_wiz] -min -add_delay 0.400 [get_ports rst]
set_input_delay -clock [get_clocks VIRTUAL_clk_13Mhz_clk_wiz] -max -add_delay 0.600 [get_ports rst]
set_input_delay -clock [get_clocks VIRTUAL_clk_65Mhz_clk_wiz] -min -add_delay 0.600 [get_ports rst]
set_input_delay -clock [get_clocks VIRTUAL_clk_65Mhz_clk_wiz] -max -add_delay 0.800 [get_ports rst]
set_input_delay -clock [get_clocks VIRTUAL_clk_65Mhz_clk_wiz] -min -add_delay 0.600 [get_ports rx]
set_input_delay -clock [get_clocks VIRTUAL_clk_65Mhz_clk_wiz] -max -add_delay 0.800 [get_ports rx]

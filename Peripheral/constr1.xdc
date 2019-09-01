create_clock -name clk -period 20.400 [get_ports {clk}]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN U17 [get_ports {reset}]
set_property IOSTANDARD LVCMOS33 [get_ports {reset}]

# =================================================
# Nexys A7-50T - Minimal constraints for hex display
# Based on Digilent Nexys-A7-50T-Master.xdc
# =================================================

# -----------------------------------------------
# Slide switches SW3..SW0
# -----------------------------------------------
set_property PACKAGE_PIN J15 [get_ports {sw[0]}] ; # SW0
set_property PACKAGE_PIN L16 [get_ports {sw[1]}] ; # SW1
set_property PACKAGE_PIN M13 [get_ports {sw[2]}] ; # SW2
set_property PACKAGE_PIN R15 [get_ports {sw[3]}] ; # SW3
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

# -----------------------------------------------
# Seven-segment cathodes CA..CG (active-low)
# seg[6] = a, seg[5] = b, ... seg[0] = g
# (Adjust bit order if needed to match your design)
# -----------------------------------------------
set_property PACKAGE_PIN T10  [get_ports {seg[6]}] ; # CA
set_property PACKAGE_PIN R10  [get_ports {seg[5]}] ; # CB
set_property PACKAGE_PIN K16  [get_ports {seg[4]}] ; # CC
set_property PACKAGE_PIN K13  [get_ports {seg[3]}] ; # CD
set_property PACKAGE_PIN P15  [get_ports {seg[2]}] ; # CE
set_property PACKAGE_PIN T11  [get_ports {seg[1]}] ; # CF
set_property PACKAGE_PIN L18  [get_ports {seg[0]}] ; # CG
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

# -----------------------------------------------
# Seven-segment anodes AN7..AN0 (active-low)
# Only AN0 is used in this lab
# -----------------------------------------------
set_property PACKAGE_PIN J17 [get_ports {an[0]}] ; # AN0
set_property PACKAGE_PIN J18 [get_ports {an[1]}] ; # AN1
set_property PACKAGE_PIN T9 [get_ports {an[2]}] ; # AN2
set_property PACKAGE_PIN J14 [get_ports {an[3]}] ; # AN3
set_property PACKAGE_PIN P14 [get_ports {an[4]}] ; # AN4
set_property PACKAGE_PIN T14 [get_ports {an[5]}] ; # AN5
set_property PACKAGE_PIN K2 [get_ports {an[6]}] ; # AN6
set_property PACKAGE_PIN U13 [get_ports {an[7]}] ; # AN7
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

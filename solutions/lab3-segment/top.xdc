# =================================================
# Nexys A7-50T - Minimal constraints for hex display
# Based on Digilent Nexys-A7-50T-Master.xdc
# =================================================

# -----------------------------------------------
# Slide switches SW3..SW0
# -----------------------------------------------
set_property PACKAGE_PIN V17 [get_ports {sw[0]}] ; # SW0
set_property PACKAGE_PIN V16 [get_ports {sw[1]}] ; # SW1
set_property PACKAGE_PIN W16 [get_ports {sw[2]}] ; # SW2
set_property PACKAGE_PIN W17 [get_ports {sw[3]}] ; # SW3
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

# -----------------------------------------------
# Seven-segment cathodes CA..CG (active-low)
# seg[6] = a, seg[5] = b, ... seg[0] = g
# (Adjust bit order if needed to match your design)
# -----------------------------------------------
set_property PACKAGE_PIN W7  [get_ports {seg[6]}] ; # CA
set_property PACKAGE_PIN W6  [get_ports {seg[5]}] ; # CB
set_property PACKAGE_PIN U8  [get_ports {seg[4]}] ; # CC
set_property PACKAGE_PIN V8  [get_ports {seg[3]}] ; # CD
set_property PACKAGE_PIN U5  [get_ports {seg[2]}] ; # CE
set_property PACKAGE_PIN V5  [get_ports {seg[1]}] ; # CF
set_property PACKAGE_PIN U7  [get_ports {seg[0]}] ; # CG
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

# -----------------------------------------------
# Seven-segment anodes AN7..AN0 (active-low)
# Only AN0 is used in this lab
# -----------------------------------------------
set_property PACKAGE_PIN U2 [get_ports {an[0]}] ; # AN0
set_property PACKAGE_PIN U4 [get_ports {an[1]}] ; # AN1
set_property PACKAGE_PIN V4 [get_ports {an[2]}] ; # AN2
set_property PACKAGE_PIN W4 [get_ports {an[3]}] ; # AN3
set_property PACKAGE_PIN U1 [get_ports {an[4]}] ; # AN4
set_property PACKAGE_PIN U3 [get_ports {an[5]}] ; # AN5
set_property PACKAGE_PIN V2 [get_ports {an[6]}] ; # AN6
set_property PACKAGE_PIN W2 [get_ports {an[7]}] ; # AN7
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

# ======================================================
# OSS CAD Suite: https://github.com/YosysHQ/oss-cad-suite-build
#   - verilator (Verilog/SystemVerilog simulator)
#   - iverilog (Verilog compilation system)
#   - GTK Wave (wave viewer)
#   - Surfer (waveform viewer)
#   - Yosys (RTL synthesis with extensive Verilog 2005 support)
#   - Amaranth (Python toolbox for building complex digital hardware)
#   - nextpnr (portable FPGA place and route tool)
#   - openFPGALoader (universal utility for programming FPGA)
#   - icesprog (iCESugar FPGA board programmer)
#   - ...
# ======================================================

TOP = blink

# Synthesizable file(s)
SRC = blink.v

# Testbench file(s)
TB  = blink_tb.v


# Default target
all: sim

# Lint (static code analysis), compile, and run simulation
sim: lint
	iverilog -Wall -g2012 -o sim.vvp $(SRC) $(TB)
	vvp sim.vvp

lint:
	verilator --lint-only -Wno-fatal $(SRC) $(TB)

# Synthesis
top.json: $(SRC)
	yosys -q -p "synth_ice40 -top $(TOP) -json top.json" $(SRC)

# Place & Route
top.asc: top.json icebreaker.pcf
	nextpnr-ice40 \
		--up5k \
		--package sg48 \
		--json top.json \
		--pcf icebreaker.pcf \
		--asc top.asc \
#		--report timing.rpt

# nextpnr-ice40 -r ... --timing-allow-fail --detailed-timing-report --quiet --log pnr.log

# Bitstream generation
top.bin: top.asc
	icepack top.asc top.bin

# Build + Flash
compile: top.bin

download: top.bin
	openFPGALoader -b ice40_generic -f top.bin

# Schematics
schematic: rtl_schematic.pdf gate_schematic.pdf

# RTL schematic
rtl_schematic.pdf: $(SRC)
	yosys -p "read_verilog $(SRC); hierarchy; show -format pdf -prefix rtl_schematic"

# Gate-level schematic (after synthesis)
gate_schematic.pdf: top.json
	yosys -p "read_json top.json; show -format pdf -prefix gate_schematic"

# Clean generated files
clean:
	rm -f *.vvp *.vcd top.json top.asc top.bin timing.rpt \
		*.dot gate_schematic.pdf rtl_schematic.pdf

.PHONY: all sim lint compile download clean

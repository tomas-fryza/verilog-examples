# ===============================================
# Simple Makefile for Icarus Verilog + GTKWave
# ===============================================

# Simulator and tools
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Files
TOP      = gates_tb
VCD      = gates.vcd
SRCS     = gates.v gates_tb.v

# Default target
all: sim

# Compile and run simulation
sim: $(SRCS)
	$(IVERILOG) -g2012 -o sim $(SRCS)
	$(VVP) sim

# Open waveform
wave: sim
	$(GTKWAVE) $(VCD)

# Clean generated files
clean:
	rm -f sim $(VCD)

# Help
help:
	@echo "make        - compile, run, and open GTKWave"
	@echo "make sim    - compile and run"
	@echo "make wave   - compile, run, and view waves"
	@echo "make clean  - remove generated files"

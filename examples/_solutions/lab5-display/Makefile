# ===============================================
# Simple Makefile for Icarus Verilog + GTKWave
# ===============================================

# Simulator and tools
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Files
TOP      = display_driver_tb
VCD      = display_driver.vcd
SRCS     = display_driver.v display_driver_tb.v clk_en.v counter.v bin2seg.v

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

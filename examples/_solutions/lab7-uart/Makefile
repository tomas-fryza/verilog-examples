# ===============================================
# Simple Makefile for Icarus Verilog + GTKWave
# ===============================================

# Simulator and tools
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Files
TOP      = uart_tx_tb
VCD      = uart_tx.vcd

SRCS = \
	uart_tx.v \
	uart_tx_tb.v

# Default target
all: sim

# Compile and run simulation
sim: $(SRCS)
	$(IVERILOG) -g2012 -s $(TOP) -o sim $(SRCS)
	$(VVP) sim

# Open waveform viewer
wave: sim
	$(GTKWAVE) $(VCD)

# Clean generated files
clean:
	rm -f sim $(VCD)

# Help
help:
	@echo "make        - compile and run simulation"
	@echo "make wave   - open GTKWave"
	@echo "make clean  - remove generated files"

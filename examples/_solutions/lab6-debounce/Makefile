# ======================================================
# Makefile for Verilator (lint) + Icarus (simulation)
# ======================================================

# Files
SRCS = \
	debounce.v \
	debounce_tb.v \
	clk_en.v

# Lint (static code analysis), compile, and run simulation
all:
	verilator --lint-only -Wno-fatal $(SRCS)
	iverilog -Wall -g2012 -o sim.vvp $(SRCS)
	vvp sim.vvp

# Clean generated files
clean:
	rm -f *.vvp *.vcd

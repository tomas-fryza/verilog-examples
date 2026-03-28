# ======================================================
# Makefile for Verilator (lint) + Icarus (simulation)
# ======================================================

# Lint (static code analysis), compile, and run simulation
all:
	verilator --lint-only -Wno-fatal *.v
	iverilog -Wall -g2012 -o sim.vvp *.v
	vvp sim.vvp

# Clean generated files
clean:
	rm -f *.vvp *.vcd

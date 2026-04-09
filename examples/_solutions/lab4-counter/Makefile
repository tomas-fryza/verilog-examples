# ======================================================
# Makefile for Verilator (lint) + Icarus (simulation)
# ======================================================

# Files
SRCS = \
	counter.v \
	counter_tb.v
# SRCS = \
# 	clk_en.v \
# 	clk_en_tb.v

# Lint (static code analysis), compile, and run simulation
all:
	verilator --lint-only -Wno-fatal $(SRCS)
	iverilog -Wall -g2012 -o sim.vvp $(SRCS)
	vvp sim.vvp

# Clean generated files
clean:
	rm -f *.vvp *.vcd

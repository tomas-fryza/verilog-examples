# ======================================================
# Makefile for Verilator (lint) + Icarus (simulation)
# ======================================================

# Files
SRCS = \
	uart_tx.v \
	uart_tx_tb.v

# Lint (static code analysis), compile, and run simulation
all:
	verilator --lint-only -Wno-fatal $(SRCS)
	iverilog -Wall -g2012 -o sim.vvp $(SRCS)
	vvp sim.vvp

# Clean generated files
clean:
	rm -f *.vvp *.vcd

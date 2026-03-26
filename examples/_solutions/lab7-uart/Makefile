# ===============================================
# Makefile for Verilog (Verilator + Icarus)
# ===============================================

# Tools
IVERILOG  = iverilog
VVP       = vvp
VERILATOR = verilator

# Top test
TOP = uart_tx_tb

# Output files
SIM_OUT = sim.vvp
PASS    = test.pass
VCD     = dump.vcd

# Sources
SRCS = \
	uart_tx.v \
	uart_tx_tb.v

# ===============================================
# Default target
# ===============================================
all: $(PASS)

# ===============================================
# Lint + Compile + Simulate
# ===============================================
$(PASS): $(SRCS)
	@echo "== Linting with Verilator =="
	$(VERILATOR) --lint-only -Wno-fatal $^

	@echo "== Compiling with Icarus =="
	$(IVERILOG) -Wall -g2012 -o $(SIM_OUT) $^

	@echo "== Running simulation =="
	($(VVP) $(SIM_OUT) -fst > $@.log && touch $@) || (cat $@.log && false)

# ===============================================
# Clean
# ===============================================
clean:
	rm -f *.vvp *.vcd *.fst *.pass *.log

# ===============================================
# Help
# ===============================================
help:
	@echo "make        - run lint + simulation"
	@echo "make clean  - remove generated files"

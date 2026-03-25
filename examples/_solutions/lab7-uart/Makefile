# ===============================================
# Makefile for Verilog (Verilator + Icarus + GTKWave)
# ===============================================

# Tools
IVERILOG  = iverilog
VVP       = vvp
VERILATOR = verilator
GTKWAVE   = gtkwave

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
# Waveform viewer
# ===============================================
wave: $(PASS)
	$(GTKWAVE) $(VCD)

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
	@echo "make wave   - open waveform viewer"
	@echo "make clean  - remove generated files"

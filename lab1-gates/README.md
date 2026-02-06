# Laboratory 1: Basic Logic Gates

## Objectives

The goal of this laboratory is to introduce the **Verilog hardware description language** and the **basic digital design workflow**. Students will learn how to describe simple **combinational logic** in Verilog, simulate the design, and analyze its behavior using waveforms.

After completing this lab, students will be able to:

- understand the structure of a Verilog module,
- describe basic logic gates using Verilog operators,
- write and run a simple **testbench**,
- simulate a design and inspect waveforms using **GTKWave** or Vivado.

## Assignment

Design a Verilog module that implements the following logic functions:

- 2-input **AND** gate,
- 2-input **OR** gate,
- 2-input **XOR** gate.

The module has two single-bit inputs and three single-bit outputs.

## Design Requirements

- Use **combinational logic only**.
- Use **continuous assignments** (`assign`).
- Do **not** use clocks or sequential logic.
- The design must be synthesizable.

## Provided Verilog Template (Design)

Create a file named **`gates.v`** and use the following template:

```verilog
// =================================================
// Basic logic gates
// =================================================

module gates (
    input  wire a,     // First input

    // TODO: Complete input / output ports

    output wire y_xor  // XOR gate output
);

    // ---------------------------------------------
    // TODO: Implement logic gates using assign
    // ---------------------------------------------
    // assign y_and = ...
    // assign y_or  = ...
    // assign y_xor = ...

endmodule
```

## Provided Verilog Template (Testbench)

Create a file named **`gates_tb.v`** and use the following template to verify your design by simulation.

```verilog
`timescale 1ns/1ps

// =================================================
// Testbench for basic logic gates
// =================================================

module gates_tb;

    // ---------------------------------------------
    // Testbench internal signals
    // reg  = driven by testbench
    // wire = driven by DUT outputs
    // ---------------------------------------------
    reg  a;
    reg  b;
    wire y_and;
    wire y_or;
    wire y_xor;

    // ---------------------------------------------
    // Instantiate Device Under Test (DUT)
    // ---------------------------------------------
    gates dut (
        .a     (a),
        .b     (b),
        .y_and (y_and),
        .y_or  (y_or),
        .y_xor (y_xor)
    );

    // ---------------------------------------------
    // Stimulus process
    // ---------------------------------------------
    initial begin
        // Waveform dump for GTKWave
        $dumpfile("gates.vcd");
        $dumpvars(0, gates_tb);

        // TODO: Apply all input combinations
        a = 0; b = 0; #10;

        $finish;
    end

endmodule
```

## Using the Makefile in VS Code (not Vivado)

A **`Makefile`** is provided to simplify the simulation workflow. Instead of typing long commands manually, common tasks are executed using short `make` commands.

1. Copy/paste the [`Makefile`](../solutions/lab1-gates/Makefile) to your project folder.
2. Open the integrated terminal (**View → Terminal**).
3. Run commands from the terminal:

   - `make` -- compiles and runs the simulation  
   - `make wave` -- opens the waveform in GTKWave  
   - `make clean` -- removes generated files  

## Expected Results

After a successful simulation, the outputs must follow the truth tables of the basic logic gates:

| a | b | AND | OR | XOR |
|---|---|-----|----|-----|
| 0 | 0 |  0  | 0  |  0  |
| 0 | 1 |  0  | 1  |  1  |
| 1 | 0 |  0  | 1  |  1  |
| 1 | 1 |  1  | 1  |  0  |

The GTKWave waveform should show that:
- inputs `a` and `b` change over time,
- outputs update immediately after input changes,
- no clock signal is present.

## Common Mistakes and Troubleshooting

- **Simulation does not start**
  - Check file names and module names.
  - Ensure the testbench module has no ports.

- **No waveform file generated**
  - Verify that `$dumpfile` and `$dumpvars` are present in the testbench.
  - Make sure the simulation reaches `$finish`.

- **Outputs are always `0` or `X`**
  - Check that `assign` statements are correctly written.
  - Ensure all signals are declared with correct directions and types.

- **GTKWave shows nothing**
  - Confirm the correct `.vcd` file is opened.
  - Reload signals in GTKWave if needed.

## Optional Extensions

For students who finish early:

- Add a **NAND** or **NOR** gate.
- Modify the testbench to print results to the console using `$display`, such as:

  ```verilog
  $display("[%0t] %b %b | %b %b %b", $time, b, a, y_and, y_or, y_xor);
  ```

- Use deMorgan laws and replace individual gates with Boolean expressions.

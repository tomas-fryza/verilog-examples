// Run in Terminal (Linux, macOS):
// $ iverilog -o sim gates.v gates_tb.v && vvp sim && gtkwave gates.vcd
//
// Windows:
// $ iverilog -o sim gates.v gates_tb.v ; vvp sim ; gtkwave gates.vcd
//
// 1. Make sure waveform dumping is in the testbench
// 2. Compile your design + testbench: iverilog ...
// 3. Run the simulation create the waveform file: vvp sim

// Time unit = 1 ns / Time precision = 1 ps
`timescale 1ns/1ps

module gates_tb;

    // ---------------------------------------------
    // Testbench internal signals
    // Must be `reg`, so we can assign values
    // ---------------------------------------------
    reg a, b;
    wire y_and, y_or, y_xor;

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
    // Applies test vectors to DUT inputs over time
    // ---------------------------------------------
    initial begin
        // Waveform dump
        $dumpfile("gates.vcd");

        // $dumpvars(level, list_of_modules_or_signals);
        //   * level -- integer controlling hierarchy depth; 0 means everything in this module and all sub-modules recursively
        //   * list_of_modules_or_signals -- top-level module or individual signals
        $dumpvars(0, gates_tb);

        // Console header
        $display("Time(ps)   b a | AND OR  XOR");
        $display("---------------+-------------");

        // Test vectors
        // Set both `a`, `b`, then wait 10 time units
        b = 0; a = 0; #10;
    
        // `%0t` prints a time value without any leading spaces
        // `%b` prints a value in binary 
        // `%h` prints a value in hexadecimal
        // `%d` in decimal
        $display("[%0t]    %b %b |  %b   %b   %b", $time, b, a, y_and, y_or, y_xor);
    
        b = 0; a = 1; #10;
        $display("[%0t]    %b %b |  %b   %b   %b", $time, b, a, y_and, y_or, y_xor);

        b = 1; a = 0; #10;
        $display("[%0t]    %b %b |  %b   %b   %b", $time, b, a, y_and, y_or, y_xor);

        b = 1; a = 1; #10;
        $display("[%0t]    %b %b |  %b   %b   %b", $time, b, a, y_and, y_or, y_xor);

        $display("---------------------------");
        $display("Simulation finished.");

        $finish;
    end

endmodule

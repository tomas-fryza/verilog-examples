// -----------------------------------------------------------
// Run in Terminal (Linux, macOS):
// $ iverilog -o sim gates.v gates_tb.v && vvp sim && gtkwave gates.vcd
//
// Windows:
// $ iverilog -o sim.vvp gates.v gates_tb.v ; vvp sim.vvp ; gtkwave gates.vcd
//
// 1. Make sure waveform dumping is in the testbench
// 2. Compile your design + testbench: iverilog ...
// 3. Run the simulation create the waveform file: vvp sim.vvp
// -----------------------------------------------------------

// Time unit = 1 ns / Time precision = 1 ps
`timescale 1ns/1ps

module gates_tb (
    // Testbench module has no ports
);

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
        .a    (a),
        .b    (b),
        .y_and(y_and),
        .y_or (y_or),
        .y_xor(y_xor)
    );

    // ---------------------------------------------
    // Testbench stimulus
    // Applies test vectors to DUT inputs over time
    // ---------------------------------------------
    initial begin
        // Set both `a`, `b`, then wait 10 time units
        b = 0; a = 0; #10;
        b = 0; a = 1; #10
        b = 1; a = 0; #10;
        b = 1; a = 1; #10

        $display("\nSimulation finished\n");
        $finish;
    end

    initial begin
        // Waveform dump for GTKWave
        $dumpfile("gates.vcd");

        // $dumpvars(level, list_of_modules_or_signals);
        //   * level -- integer controlling hierarchy depth; 0 means everything in this module and all sub-modules recursively
        //   * list_of_modules_or_signals -- top-level module or individual signals
        $dumpvars(0, gates_tb);

        // Console header
        $display("\nStarting simulation...\n");
        $display("Time  b a | AND OR XOR");
        $display("----------+-----------");

        // Use the monitor task to automaticaly display any change
        $monitor("%4d  %b %b |  %b  %b  %b", $time, b, a, y_and, y_or, y_xor);

        // `%b` prints a value in binary 
        // `%h` prints a value in hexadecimal
        // `%d` in decimal
    end
endmodule

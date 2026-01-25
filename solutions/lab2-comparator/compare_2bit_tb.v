// Time unit = 1 ns / Time precision = 1 ps
`timescale 1ns/1ps

// =================================================
// Testbench for 2-bit binary comparator
// =================================================

module compare_2bit_tb;

    // ---------------------------------------------
    // Testbench internal signals
    // Must be `reg`, so we can assign values
    // ---------------------------------------------
    reg [1:0] b;  // DUT input b
    reg [1:0] a;  // DUT input a
    wire      b_gt;
    wire      b_a_eq;
    wire      a_gt;

    // ---------------------------------------------
    // Instantiate Device Under Test (DUT)
    // ---------------------------------------------
    compare_2bit dut (
        .b      (b),
        .a      (a),
        .b_gt   (b_gt),
        .b_a_eq (b_a_eq),
        .a_gt   (a_gt)
    );

    integer i;  // Integer in Verilog is typically 32-bit signed
    integer j;

    // ---------------------------------------------
    // Stimulus process
    // Applies test vectors to DUT inputs over time
    // ---------------------------------------------
    initial begin
        // Waveform dump for GTKWave
        $dumpfile("compare_2bit.vcd");
        $dumpvars(0, compare_2bit_tb);

        // Console header
        $display("Time  b  a | b>a b=a b<a");
        $display("-----------+--------------");

        // -----------------------------------------
        // Exhaustive test of all combinations
        // -----------------------------------------
        for (i = 0; i < 4; i = i+1) begin
            for (j = 0; j < 4; j = j+1) begin
                b = i[1:0];  // Take only the lowest 2 bits of i
                a = j[1:0];
                #10;

                $display("%4t  %0d  %0d |  %b   %b    %b",
                         $time, b, a, b_gt, b_a_eq, a_gt);
            end
        end

        $display("---------------------------");
        $display("Simulation finished.");

        $finish;
    end

endmodule

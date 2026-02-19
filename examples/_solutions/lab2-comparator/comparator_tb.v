// Time unit = 1 ns / Time precision = 1 ps
`timescale 1ns/1ps

// =================================================
// Testbench for 2-bit binary comparator
// =================================================

module comparator_tb ();

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
    comparator dut (
        .b      (b),
        .a      (a),
        .b_gt   (b_gt),
        .b_a_eq (b_a_eq),
        .a_gt   (a_gt)
    );

    integer i, j;  // Integer in Verilog is typically 32-bit signed
    integer errors = 0;

    reg exp_b_gt;
    reg exp_b_a_eq;
    reg exp_a_gt;

    // ---------------------------------------------
    // Stimulus process
    // Applies test vectors to DUT inputs over time
    // ---------------------------------------------
    initial begin
        // Waveform dump for GTKWave
        $dumpfile("comparator.vcd");
        $dumpvars(0, comparator_tb);

        // Console header
        $display("\nStarting simulation...\n");
        $display("Time   b  a | b>a b=a b<a");
        $display("------------+------------");

        // Use the monitor task to automaticaly display any change
        $monitor("%3d   %b %b |  %b   %b   %b", $time, b, a, b_gt, b_a_eq, a_gt);

        // -----------------------------------------
        // Exhaustive test of all combinations
        // -----------------------------------------
        for (i = 0; i < 4; i = i+1) begin
            for (j = 0; j < 4; j = j+1) begin
                b = i[1:0];  // Take only the lowest 2 bits of i
                a = j[1:0];
                #10;

                // -----------------------------
                // Compute expected values
                // -----------------------------
                exp_b_gt   = (b > a);
                exp_b_a_eq = (b == a);
                exp_a_gt   = (a > b);

                // -----------------------------
                // Compare with DUT outputs
                // -----------------------------
                if (b_gt !== exp_b_gt ||
                    b_a_eq !== exp_b_a_eq ||
                    a_gt !== exp_a_gt) begin

                    $display("[Error] a=%0d b=%0d | DUT=%b%b%b EXPECTED=%b%b%b",
                         a, b,
                         b_gt, b_a_eq, a_gt,
                         exp_b_gt, exp_b_a_eq, exp_a_gt);
                    
                    errors += 1;
                end
            end
        end

        if (errors == 0)
            $display("\nAll tests PASSED\n");
        else
            $display("\nTest FAILED with %0d errors\n", errors);

        $finish;
    end

endmodule

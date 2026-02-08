// Time unit = 1 ns / Time precision = 1 ps
`timescale 1ns/1ps

// =================================================
// Testbench for 4-bit to 7-segment decoder
// =================================================

module bin2seg_tb;

    // ---------------------------------------------
    // Testbench internal signals
    // Must be `reg`, so we can assign values
    // ---------------------------------------------
    reg  [3:0] bin;  // DUT input: 4-bit value
    wire [6:0] seg;  // DUT output: {a,b,c,d,e,f,g}, active-low

    // ---------------------------------------------
    // Instantiate Device Under Test (DUT)
    // ---------------------------------------------
    bin2seg dut (
        .bin   (bin),
        .seg   (seg)
    );

    integer i;  // Loop variable

    // ---------------------------------------------
    // Stimulus process
    // Applies test vectors to DUT inputs over time
    // ---------------------------------------------
    initial begin
        // Waveform dump for GTKWave
        $dumpfile("bin2seg.vcd");
        $dumpvars(0, bin2seg_tb);

        // Console header
        $display("Time  bin  | seg (abcdefg, active-low)");
        $display("-----------+--------------------------");

        // -----------------------------------------
        // Enable display and test 0..F
        // -----------------------------------------
        for (i = 0; i < 16; i = i+1) begin
            bin = i[3:0];   // Apply hex value; use only lowest 4 bits of i
            #10;

            $display("%4t    %h  | %b", $time, bin, seg);
        end

        $display("------------+--------------------------");
        $display("Simulation finished.");

        $finish;
    end

endmodule

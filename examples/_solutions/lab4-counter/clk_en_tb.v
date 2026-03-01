// Time unit = 1 ns / Time precision = 1 ps
`timescale 1ns/1ps

// =================================================
// Testbench for clock enable generator
// =================================================

module clk_en_tb ();

    // ---------------------------------------------
    // Testbench internal signals and parameter
    // Must be `reg`, so we can assign values
    // ---------------------------------------------
    parameter MAX = 12;  // Change only this value to modify counting
    reg  clk;
    reg  rst;
    wire ce;

    // ---------------------------------------------
    // Instantiate Device Under Test (DUT)
    // ---------------------------------------------
    // clk_en -- module name
    // #() -- parameter override block
    // .MAX (MAX) -- named parameter mapping
    // dut -- instance name of this module
    // .clk (clk) -- connect/map module port clk to testbench signal clk
    clk_en #(
        .MAX (MAX)
    ) dut (
        .clk (clk),
        .rst (rst),
        .ce  (ce)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;
    // `always` defines a process that runs indefinitely during
    // simulation. This block repeats forever.

    // ---------------------------------------------
    // Stimulus process
    // Applies test vectors to DUT inputs over time
    // ---------------------------------------------
    initial begin
        // Waveform dump for GTKWave
        $dumpfile("counter.vcd");
        $dumpvars(0, clk_en_tb);

        // Use the monitor task to automaticaly display any change
        $monitor("[%3d] clk=%b rst=%b ce=%b  cnt=%d",
            $time, clk, rst, ce,
            clk_en_tb.dut.sig_cnt);  // <--- hierarchical path
        
        // Initialize signals
        clk = 0;
        rst = 1;

        // Hold reset for a few clock cycles
        #20;
        rst = 0;

        // Let it run for several pulses
        #200;

        rst = 1;
        #20;
        rst = 0;
        #200;

        $finish;
    end

endmodule

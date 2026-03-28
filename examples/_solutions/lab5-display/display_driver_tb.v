`timescale 1ns/1ps

module display_driver_tb ();

    // ---------------------------------------------------------
    // Testbench signals
    // ---------------------------------------------------------
    reg        clk;
    reg        rst;
    reg  [7:0] data;
    wire [6:0] seg;
    wire [1:0] anode;

    // ---------------------------------------------------------
    // Instantiate DUT (Device Under Test)
    // ---------------------------------------------------------
    display_driver dut (
        .i_clk   (clk),
        .i_rst   (rst),
        .i_data  (data),
        .o_seg   (seg),
        .o_anode (anode)
    );

    // ---------------------------------------------------------
    // Clock generator (100 MHz -> 10 ns period)
    // ---------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ---------------------------------------------------------
    // Stimulus
    // ---------------------------------------------------------
    initial begin
        // Initialize signals
        rst  = 1;
        data = 8'h00;

        // Hold reset for a few cycles
        #50;
        rst = 0;

        // Apply test value 0x18
        data = 8'h18;
        #2000;

        // Apply test value 0x19
        data = 8'h19;
        #2000;

        // Apply test value 0x20
        data = 8'h20;
        #2000;

        // End simulation
        $display("\nSimulation finished\n");
        $finish;
    end

    // ---------------------------------------------------------
    // VCD waveform dump for GTKWave
    // ---------------------------------------------------------
    initial begin
        $dumpfile("display_driver.vcd");
        $dumpvars(0, display_driver_tb);
    end

    // ---------------------------------------------------------
    // Monitor signals
    // ---------------------------------------------------------
    initial begin
        $display("   Time  rst data anode seg");
        $monitor("%7t   %b   %h   %b   %b",
                  $time, rst, data, anode, seg);
    end

endmodule

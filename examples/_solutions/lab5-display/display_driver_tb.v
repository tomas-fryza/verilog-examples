`timescale 1ns/1ps

module display_driver_tb ();

    // Testbench signals
    reg  clk;
    reg  rst;
    reg  [7:0] data;
    wire [6:0] seg;
    wire [1:0] anode;

    // Instantiate Device Under Test (DUT)
    display_driver dut (
        .clk  (clk),
        .rst  (rst),
        .data (data),
        .seg  (seg),
        .anode(anode)
    );

    // Clock generation: 10ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Testbench stimulus
    initial begin
        // Initialize
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

        // Finish simulation
        $display("\nSimulation finished\n");
        $finish;
    end

    // Monitor outputs
    initial begin
        $display("   Time  rst data anode seg");
        $monitor("%7t   %b   %h   %b   %b",
                  $time, rst, data, anode, seg);
    end

    // VCD waveform dump for GTKWave
    initial begin
        $dumpfile("display_driver.vcd");
        $dumpvars(0, display_driver_tb);
    end

endmodule

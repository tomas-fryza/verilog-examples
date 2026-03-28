`timescale 1ns/1ps

module debounce_tb ();

    //------------------------------------------------------------
    // Testbench signals
    //------------------------------------------------------------
    reg clk;
    reg rst;
    reg btn_in;

    wire btn_state;
    wire btn_press;

    //------------------------------------------------------------
    // DUT (Device Under Test)
    //------------------------------------------------------------
    debounce dut (
        .clk       (clk),
        .rst       (rst),
        .btn_in    (btn_in),
        .btn_state (btn_state),
        .btn_press (btn_press)
    );

    //------------------------------------------------------------
    // Clock generation (10 ns period = 100 MHz)
    //------------------------------------------------------------
    always #5 clk = ~clk;

    //------------------------------------------------------------
    // Stimulus
    //------------------------------------------------------------
    initial begin
        // Init
        clk    = 0;
        rst    = 1;
        btn_in = 0;

        $display("\nStarting simulation...\n");
        $display("Reset phase");
        #50;
        rst = 0;

        #20;
        $display("Simulate bouncing (fast toggling)");
        btn_in = 1; #30;
        btn_in = 0; #20;
        btn_in = 1; #40;
        btn_in = 0; #30;
        btn_in = 1;  // Finally stable HIGH
        #300;

        $display("Simulate button on release");
        btn_in = 0; #30;
        btn_in = 1; #20;
        btn_in = 0; #40;
        btn_in = 1; #30;
        btn_in = 0;  // Finally stable LOW
        #300;

        //--------------------------------------------------------
        // End simulation
        //--------------------------------------------------------
        $display("\nSimulation finished\n");
        $finish;
    end

    // ---------------------------------------------------------
    // VCD waveform dump for GTKWave
    // ---------------------------------------------------------
    initial begin
        $dumpfile("debounce.vcd");
        $dumpvars(0, debounce_tb);
    end

endmodule

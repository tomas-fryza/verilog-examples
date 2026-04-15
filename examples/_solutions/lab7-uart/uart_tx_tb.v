`timescale 1ns/1ps

module uart_tx_tb ();

    // Testbench signals
    reg  clk;
    reg  rst;
    reg  start;
    reg  [7:0] data;
    wire tx;
    wire busy;

    // Instantiate Device Under Test (DUT)
    uart_tx dut (
        .clk  (clk),
        .rst  (rst),
        .start(start),
        .data (data),
        .tx   (tx),
        .busy (busy)
    );

    // Clock generation: 10 ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Testbench stimulus
    initial begin
        // Initialize
        rst   = 1'b1;
        data  = 8'd0;
        start = 1'b0;

        $display("\nStarting simulation...\n");
        $display("Reset generation");
        #50;
        rst = 1'b0;

        //-------------------------------------------------
        $display("Send first byte: 0x44");
        data  = 8'h44;
        start = 1'b1;
        #10;
        start = 1'b0;
        #10;
    
        wait (busy == 0);
        #100;
    
        //-------------------------------------------------
        $display("Send next byte: 0x45");
        data  = 8'h45;
        start = 1'b1;
        #10;
        start = 1'b0;
        #10;
    
        wait (busy == 0);
        #100;
    
        //-------------------------------------------------
        $display("Send next byte: 0x31");
        data  = 8'h31;
        start = 1'b1;
        #10;
        start = 1'b0;
        #10;
    
        wait (busy == 0);
        #100;
    
        // Finish simulation
        $display("\nSimulation finished\n");
        $finish;
    end

    // VCD waveform dump for GTKWave
    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);
    end

endmodule

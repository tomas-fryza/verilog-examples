`timescale 1ns/1ps

module uart_tx_tb ();

    //-------------------------------------------------
    // Testbench signals
    //-------------------------------------------------
    reg       clk;
    reg       rst;
    reg       tx_start;
    reg [7:0] tx_data;
    wire      tx;
    wire      tx_busy;

    //-------------------------------------------------
    // Instantiate DUT
    //-------------------------------------------------
    uart_tx dut (
        .clk     (clk),
        .rst     (rst),
        .tx_start(tx_start),
        .tx_data (tx_data),
        .tx      (tx),
        .tx_busy (tx_busy)
    );

    //-------------------------------------------------
    // Clock generation (10 ns period = 100 MHz)
    //-------------------------------------------------
    always #5 clk = ~clk;

    //-------------------------------------------------
    // Stimulus
    //-------------------------------------------------
    initial begin
        // Initialization
        clk       = 1'b0;
        rst       = 1'b1;
        tx_data   = 8'd0;
        tx_start  = 1'b0;

        $display("\nStarting simulation...\n");
        $display("Reset generation");
        #50;
        rst = 1'b0;
        #20;

        //-------------------------------------------------
        $display("Send first byte: 0x44");
        tx_data  = 8'h44;
        tx_start = 1'b1;
        #10;
        tx_start = 1'b0;
        #10;
    
        wait (tx_busy == 0);
        #100;
    
        //-------------------------------------------------
        $display("Send next byte: 0x45");
        tx_data  = 8'h45;
        tx_start = 1'b1;
        #10;
        tx_start = 1'b0;
        #10;
    
        wait (tx_busy == 0);
        #100;
    
        //-------------------------------------------------
        $display("Send next byte: 0x31");
        tx_data  = 8'h31;
        tx_start = 1'b1;
        #10;
        tx_start = 1'b0;
        #10;
    
        wait (tx_busy == 0);
        #100;
    
        //-------------------------------------------------
        $display("\nSimulation finished\n");
        $finish;
    end

    // ---------------------------------------------------------
    // VCD waveform dump for GTKWave
    // ---------------------------------------------------------
    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, uart_tx_tb);
    end

endmodule

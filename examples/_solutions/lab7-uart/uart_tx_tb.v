`timescale 1ns/1ps

module uart_tx_tb ();

    //-------------------------------------------------
    // Testbench signals
    //-------------------------------------------------
    reg        clk;
    reg        rst;
    reg [7:0]  data;
    reg        tx_start;
    wire       tx;
    wire       tx_complete;

    //-------------------------------------------------
    // Instantiate DUT
    //-------------------------------------------------
    uart_tx dut (
        .clk        (clk),
        .rst        (rst),
        .data       (data),
        .tx_start   (tx_start),
        .tx         (tx),
        .tx_complete(tx_complete)
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
        data      = 8'd0;
        tx_start  = 1'b0;

        $display("\nStarting simulation...\n");
        $display("Reset generation");
        #50;
        rst = 1'b0;
        #20;

        //-------------------------------------------------
        $display("Send first byte: 0x44");
        data     = 8'h44;
        tx_start = 1'b1;
        #10;
        tx_start = 1'b0;

        wait (tx_complete == 1'b1);
        #100;

        //-------------------------------------------------
        $display("Send next byte: 0x45");
        data     = 8'h45;
        tx_start = 1'b1;
        #10;
        tx_start = 1'b0;

        wait (tx_complete == 1'b1);
        #100;

        //-------------------------------------------------
        $display("Send next byte: 0x31");
        data     = 8'h31;
        tx_start = 1'b1;
        #10;
        tx_start = 1'b0;

        wait (tx_complete == 1'b1);
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

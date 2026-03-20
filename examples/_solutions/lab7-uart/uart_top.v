module uart_top (
    input  wire        clk,
    input  wire        btnu,
    input  wire [7:0]  sw,
    input  wire        btnd,
    output wire        uart_rxd_out,
    output wire        led16_b,
    output wire        led17_g
);

    //-------------------------------------------------
    // Debounce instance
    //-------------------------------------------------
    wire sig_tx_en;
    debounce debounce_inst (
        .clk       (clk),
        .rst       (btnu),
        .btn_in    (btnd),
        .btn_state (led16_b),
        .btn_press (sig_tx_en)
    );

    //-------------------------------------------------
    // UART TX instance
    //-------------------------------------------------
    uart_tx uart_tx_inst (
        .clk         (clk),
        .rst         (btnu),
        .data        (sw),
        .tx_start    (sig_tx_en),
        .tx          (uart_rxd_out),
        .tx_complete (led17_g)
    );

endmodule

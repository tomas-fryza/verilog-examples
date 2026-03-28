`timescale 1ns/1ps

module debounce_counter_top (
    input  wire clk,
    input  wire btnu,
    input  wire btnd,
    output wire [7:0] led,
    output wire led16_b
);

    //------------------------------------------------------------
    // Internal signals
    //------------------------------------------------------------
    wire sig_cnt_en;

    //------------------------------------------------------------
    // Debounce instance
    //------------------------------------------------------------
    debounce debounce_inst (
        .clk       (clk),
        .rst       (btnu),
        .btn_in    (btnd),
        .btn_state (led16_b),
        .btn_press (sig_cnt_en)
    );

    //------------------------------------------------------------
    // Counter instance
    //------------------------------------------------------------
    counter #(
        .N(8)
    ) counter_inst (
        .i_clk (clk),
        .i_rst (btnu),
        .i_en  (sig_cnt_en),
        .i_cnt (led)
    );

endmodule

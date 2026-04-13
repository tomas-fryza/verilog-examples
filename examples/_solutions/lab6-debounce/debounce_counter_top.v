`timescale 1ns/1ps

module debounce_counter_top (
    input  wire clk,
    input  wire btnu,
    input  wire btnd,
    output wire [7:0] led,
    output wire led16_b
);

    // Debounce instance
    wire sig_cnt_en;
    debounce debounce_inst (
        .clk  (clk),
        .rst  (btnu),
        .pin  (btnd),
        .state(led16_b),
        .press(cnt_en)
    );

    // 8-bit counter
    counter #(
        .N(8)
    ) counter_inst (
        .clk(clk),
        .rst(btnu),
        .en (cnt_en),
        .cnt(led)
    );

endmodule

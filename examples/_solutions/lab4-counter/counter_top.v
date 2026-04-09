`timescale 1ns/1ps

module counter_top (
    input  wire clk,        // Main clock
    input  wire btnu,       // Synchronous reset
    output wire [15:0] led  // 16-bit counter value
);

    // ---------------------------------------------------------
    // Clock enable for 10 ms
    // ---------------------------------------------------------
    wire en_10ms;
    clk_en #(
        .MAX(1_000_000)
    ) enable_inst (
        .clk(clk),
        .rst(btnu),
        .ce (en_10ms)
    );

    // ---------------------------------------------------------
    // 16-bit binary counter
    // ---------------------------------------------------------
    counter #(
        .N(16)
    ) counter_inst (
        .clk(clk),
        .rst(btnu),
        .en (en_10ms),
        .cnt(led)
    );

endmodule

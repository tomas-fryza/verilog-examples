// -----------------------------------------------------------
//! @brief Two-digit 7-segment display driver (multiplexed)
//! @version 2.1
//! @copyright (c) 2020-2026 Tomas Fryza, MIT license
//!
//! This module implements a multiplexed driver for a
//! two-digit 7-segment display. It alternates between
//! two hexadecimal digits.
//
// Notes:
// - Active-low segments and anodes
// - Multiplexing frequency must be high enough to avoid flicker
// - Uses external modules: clk_en, counter, bin2seg
// -----------------------------------------------------------

`timescale 1ns/1ps

module display_driver (
    input  wire       i_clk,   //! Main clock
    input  wire       i_rst,   //! High-active synchronous reset
    input  wire [7:0] i_data,  //! Two hexadecimal digits
    output wire [6:0] o_seg,   //! {a,b,c,d,e,f,g} active-low
    output reg  [1:0] o_anode  //! Seven-segment anodes AN1..AN0 (active-low)
);

    // Internal signals
    wire       w_en;
    wire       w_digit;
    wire [3:0] w_bin;

    // ---------------------------------------------------------
    // Refresh timing
    // ---------------------------------------------------------
    clk_en #(
        .MAX (8)  // Adjust for flicker-free multiplexing
                  // For simulation: 8
    ) clock_inst (   // For implementation: 80_000_000
        .i_clk (i_clk),
        .i_rst (i_rst),
        .o_ce  (w_en)
    );

    counter #(
        .N (1)
    ) counter_inst (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .i_en  (w_en),
        .o_cnt (w_digit)
    );

    // ---------------------------------------------------------
    // Digit select multiplexer
    // ---------------------------------------------------------
    // w_digit = 0 -> right digit  (i_data[3:0])
    // w_digit = 1 -> left digit   (i_data[7:4])
    assign w_bin = (w_digit == 1'b0) ? i_data[3:0] : i_data[7:4];

    // ---------------------------------------------------------
    // 7-segment decoder
    // ---------------------------------------------------------
    bin2seg decoder_inst (
        .i_bin (w_bin),
        .o_seg (o_seg)
    );

    // ---------------------------------------------------------
    // Anode select (active-low)
    // ---------------------------------------------------------
    always @(*) begin
        o_anode = 2'b11;          // All digits off (active-low)
        o_anode[w_digit] = 1'b0;  // Enable selected digit
    end

endmodule

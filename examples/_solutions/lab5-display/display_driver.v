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
    input  wire clk,         //! Main clock
    input  wire rst,         //! High-active synchronous reset
    input  wire [7:0] data,  //! Two hexadecimal digits
    output wire [6:0] seg,   //! {a,b,c,d,e,f,g} active-low
    output reg  [1:0] anode  //! Anodes AN1..AN0 (active-low)
);

    // ---------------------------------------------------------
    // Refresh timing
    // ---------------------------------------------------------
    wire cnt_en;
    clk_en #(
        .MAX(8)      // Adjust for flicker-free multiplexing
                     // For simulation: 8
    ) enable_inst (  // For implementation: 8_000_000
        .clk(clk),
        .rst(rst),
        .ce (cnt_en)
    );

    wire digit_sel;
    counter #(
        .N(1)
    ) counter_inst (
        .clk(clk),
        .rst(rst),
        .en (cnt_en),
        .cnt(digit_sel)
    );

    // ---------------------------------------------------------
    // Digit select multiplexer
    // ---------------------------------------------------------
    wire [3:0] digit_val;
    // digit_sel = 0 -> right digit (data[3:0])
    // digit_sel = 1 -> left digit  (data[7:4])
    assign digit_val = (digit_sel == 1'b0) ? data[3:0] : data[7:4];

    // ---------------------------------------------------------
    // 7-segment decoder
    // ---------------------------------------------------------
    bin2seg decoder_inst (
        .bin(digit_val),
        .seg(seg)
    );

    // ---------------------------------------------------------
    // Anode select (active-low)
    // ---------------------------------------------------------
    always @(*) begin
        anode = 2'b11;            // All digits off (active-low)
        anode[digit_sel] = 1'b0;  // Enable selected digit
    end

endmodule

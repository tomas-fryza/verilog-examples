// =================================================
//! @brief Top-level module for Nexys A7
//! @version 2.1
//! @copyright (c) 2018-2026 Tomas Fryza, MIT license
//!
//! Demonstrates 4-bit to 7-segment decoder. Only one digit is used.
//
// Uses:
//   SW[3:0]  -> binary input
//   CA..CG   -> segment outputs (active-low)
//   DP       -> decimal point (active-low, not used)
//   AN[0]    -> digit enable (active-low)
// =================================================

module segment_top (
    input  wire [3:0] sw,   //! Slide switches SW3..SW0
    output wire [6:0] seg,  //! Seven-segment cathodes CA..CG (active-low)
    output wire       dp,   //! Seven-segment decimal point (active-low, not used)
    output wire [7:0] an    //! Seven-segment anodes AN7..AN0 (active-low)
);

    // ---------------------------------------------
    //! Instantiate 7-segment decoder
    //! (Prefix `u_` means unit or instance.)
    // ---------------------------------------------
    bin2seg u_bin2seg (
        .bin (sw),
        .seg (seg)
    );

    // Turn off decimal point (inactive = '1')
    assign dp = 1;

    // Enable AN0 only (active-low)
    assign an = 8'b1111_1110;

endmodule

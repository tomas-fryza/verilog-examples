// =================================================
// Top-level module for Nexys A7
// Demonstrates 4-bit to 7-segment decoder
//
// Uses:
//   SW[3:0]  -> binary input
//   CA..CG   -> segment outputs (active-low)
//   AN[0]    -> digit enable (active-low)
//
// Only one digit is used.
// =================================================

module top (
    input  wire [3:0] sw,   // Slide switches SW3..SW0
    output wire [6:0] seg,  // Seven-segment cathodes CA..CG (active-low)
    output wire [7:0] an    // Seven-segment anodes AN7..AN0 (active-low)
);

    // ---------------------------------------------
    // Enable only one 7-segment digit
    // Nexys A7 uses active-low anodes
    // ---------------------------------------------
    assign an = 8'b1111_1110;  // Enable AN0 only (active-low)

    // ---------------------------------------------
    // Instantiate 7-segment decoder
    // (Prefix `u_` means unit or instance.)
    // ---------------------------------------------
    bin2seg u_bin2seg (
        .bin (sw),
        .seg (seg)
    );

endmodule

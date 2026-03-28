`timescale 1ns/1ps

module display_top (
    input  wire        clk,   // Main clock
    input  wire        btnu,  // Synchronous reset
    input  wire [7:0]  sw,    // Input data
    output wire [6:0]  seg,   // Seven-segment cathodes CA..CG (active-low)
    output wire [7:0]  an     // Seven-segment anodes AN7..AN0 (active-low)
    output wire        dp,    // Decimal point
);

    // ---------------------------------------------------------
    // Display driver instance
    // ---------------------------------------------------------
    display_driver u_driver (
        .i_clk   (clk),
        .i_rst   (btnu),
        .i_data  (sw),
        .o_seg   (seg),
        .o_anode (an[1:0])
    );

    // Turn off unused digit positions
    assign an[7:2] = 6'b11_1111;

    // Turn off decimal point (active-low → 1 = off)
    assign dp = 1'b1;

endmodule

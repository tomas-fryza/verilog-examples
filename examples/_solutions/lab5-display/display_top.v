`timescale 1ns/1ps

module display_top (
    input  wire clk,         // Main clock
    input  wire btnu,        // Synchronous reset
    input  wire [7:0]  sw,   // Input data
    output wire [6:0]  seg,  // Seven-segment cathodes CA..CG (active-low)
    output wire [7:0]  an,   // Seven-segment anodes AN7..AN0 (active-low)
    output wire dp           // Decimal point
);

    // Display driver instance
    display_driver driver_inst (
        .clk  (clk),
        .rst  (btnu),
        .data (sw),
        .seg  (seg),
        .anode(an[1:0])
    );

    // Disable other digits and decimal points
    assign an[7:2] = 6'b11_1111;
    assign dp = 1'b1;

endmodule

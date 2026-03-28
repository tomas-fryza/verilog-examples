// -----------------------------------------------------------
//! @brief Simple RGB LED blinker
//! @version 1.1
//! @copyright (c) 2026 Tomas Fryza, MIT license
//!
//! A 25-bit counter divides the input clock to generate
//! visible blinking on the onboard RGB LED.
//
//  See also:
//    https://github.com/damdoy/ice40_ultraplus_examples/blob/master/leds/leds.v
//    https://www.youtube.com/watch?v=FcFbFTbngrw
//
//  Usage:
//    Simulation                : make sim
//    Synthesis + Place & Route : make compile
//    Program FPGA              : make download
//    Generate PDF schematics   : make schematic
//    Clean build files         : make clean
// -----------------------------------------------------------

`timescale 1 ns/1 ps

module blink (
    input wire clk,  // 12 MHz input clock (iCEBreaker onboard oscillator)
    output wire ledr,
    output wire ledg,
    output wire rgb_b);

    reg [24:0] counter = 0;

    always @ (posedge clk)
    begin
        counter <= counter + 1'b1;
    end

    assign ledr = counter[24];
    assign ledg = counter[23];
    assign rgb_b = counter[22];

endmodule  // blink

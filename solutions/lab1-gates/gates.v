// =================================================
// Basic logic gates (AND, OR, XOR)
// Version 2.0
// (c) 2019-2026 Tomas Fryza, MIT license
//
// This module implements three basic combinational
// logic functions for two single-bit input signals
// A and B.
//
// Outputs:
//   y_and = A AND B
//   y_or  = A OR  B
//   y_xor = A XOR B
// =================================================

module gates (
    // Inputs: two single-bit logic signals
    input  wire a,  // First input (1-bit)
    input  wire b,  // Second input (1-bit)

    // Outputs: one-bit signals representing each gate
    output wire y_and,  // Output of 2-input AND gate
    output wire y_or,   // Output of 2-input OR gate
    output wire y_xor   // Output of 2-input XOR gate
);

    // ---------------------------------------------
    // Combinational logic using continuous assignment
    // The outputs change immediately when inputs
    // A or B change (combinational behavior).
    // ---------------------------------------------
    assign y_and = a & b;  // AND operation
    assign y_or  = a | b;  // OR operation
    assign y_xor = a ^ b;  // XOR operation

endmodule

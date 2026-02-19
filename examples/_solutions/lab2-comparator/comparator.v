// =================================================
//! @brief 2-bit binary comparator
//! @version 2.1
//! @copyright (c) 2020-2026 Tomas Fryza, MIT license
//!
//! A digital or binary comparator compares digital
//! signals A and B and produces outputs depending
//! on the condition of those inputs.
//
// Outputs:
//   b_gt   = 1 when b > a
//   b_a_eq = 1 when b == a
//   a_gt   = 1 when b < a
// =================================================

module comparator (
    input  wire [1:0] b,       //! Input bus b[1:0]
    input  wire [1:0] a,       //! Input bus a[1:0]
    output wire       b_gt,    //! Output is 1 when b > a
    output wire       b_a_eq,  //! Output is 1 when b == a
    output wire       a_gt     //! Output is 1 when b < a
);

    // ---------------------------------------------
    // Method 1: Behavioral (recommended for design)
    // ---------------------------------------------
    // assign b_gt   = (b > a);
    assign b_a_eq = (b == a);
    assign a_gt   = (b < a);

    // ---------------------------------------------
    // Method 2: Gate-level implementation (for learning only)
    // This logic is derived from the truth table for
    // a 2-bit magnitude comparator.
    // ---------------------------------------------
    assign b_gt =
          (b[1] & ~a[1]) |
          (b[0] & ~a[1] & ~a[0]) |
          (b[1] &  b[0] & ~a[0]);

endmodule

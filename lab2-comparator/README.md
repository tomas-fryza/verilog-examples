# Laboratory 2: 2-Bit Binary Comparator  

### Objectives

After completing this lab, students should be able to:

- Work with multi-bit signals (`[1:0]`)
- Use relational operators (`>`, `<`, `==`)
- Write structured testbenches
- Analyze digital waveforms

### Background

*Digital* or *Binary comparator* compares the digital signals A, B presented at input terminal and produce outputs depending upon the condition of those inputs.

![Binary comparator](images/two-bit-comparator.png)

Complete the truth table for 2-bit *Identity comparator* (B equals A), and two *Magnitude comparators* (B is greater than A, A is greater than B). Note that, such a digital device has four inputs and three outputs/functions but only **one output** should be HIGH at a time:

   - `b_gt`: Output is `1` when `b > a`
   - `b_a_eq`: Output is `1` when `b == a`
   - `a_gt`: Output is `1` when `b < a`

   | **Dec. equivalent** | **B[1:0]** | **A[1:0]** | **B is greater than A** | **B equals A** | **A is greater than B** |
   | :-: | :-: | :-: | :-: | :-: | :-: |
   |  0 | 0 0 | 0 0 | 0 | 1 | 0 |
   |  1 | 0 0 | 0 1 | 0 | 0 | 1 |
   |  2 | 0 0 | 1 0 | 0 | 0 | 1 |
   |  3 | 0 0 | 1 1 | 0 | 0 | 1 |
   |  4 | 0 1 | 0 0 |  | 0 |  |
   |  5 | 0 1 | 0 1 |  | 1 |  |
   |  6 | 0 1 | 1 0 |  | 0 |  |
   |  7 | 0 1 | 1 1 |  | 0 |  |
   |  8 | 1 0 | 0 0 |  | 0 |  |
   |  9 | 1 0 | 0 1 |  | 0 |  |
   | 10 | 1 0 | 1 0 |  | 1 |  |
   | 11 | 1 0 | 1 1 |  | 0 |  |
   | 12 | 1 1 | 0 0 |  | 0 |  |
   | 13 | 1 1 | 0 1 |  | 0 |  |
   | 14 | 1 1 | 1 0 |  | 0 |  |
   | 15 | 1 1 | 1 1 |  | 1 |  |

## 1. Task

Design a Verilog module that implements a combinational 2-bit comparator. The module shall have two 2-bit inputs `a[1:0]`, `b[1:0]` and three single-bit outputs `a_gt`, `b_a_eq`, `a_gt`.

   - Use **continuous assignments (`assign`)**
   - Do NOT use `always` blocks for this version
   - Use relational operators (`>`, `<`, `==`)
   - The design shall use combinational logic only (no clocks, latches, or flip-flops)
   - Verify the desing using a testbench that checks all possible input combinations

## 2. Provided Templates

Create a file named **`compare_2bit.v`** and use the following template:

```verilog
// =================================================
// 2-bit binary comparator
// =================================================

module compare_2bit (
    input  wire [1:0] b,

    // TODO: Complete input/output ports

    output wire       a_gt
);

    // ---------------------------------------------
    // Method 1: Behavioral (recommended for design)
    // ---------------------------------------------
    assign b_gt   = (b > a);
    assign b_a_eq = (b == a);
    assign a_gt   = (b < a);

    // ---------------------------------------------
    // Method 2: Gate-level implementation (for learning only)
    // This logic is derived from the truth table for
    // a 2-bit magnitude comparator.
    // ---------------------------------------------

endmodule
```

Create a file named **`compare_2bit_tb.v`** and use the following template to verify all 16 input combinations.

```verilog
`timescale 1ns/1ps

module compare_2bit_tb;

    reg [1:0] b;
    reg [1:0] a;
    wire      b_gt;
    wire      b_a_eq;
    wire      a_gt;

    compare_2bit dut (
        .b(b),
        .a(a),
        .b_gt(b_gt),
        .b_a_eq(b_a_eq),
        .a_gt(a_gt)
    );

    integer i, j;

    initial begin

        $dumpfile("compare_2bit.vcd");
        $dumpvars(0, compare_2bit_tb);

        $display("Time  b  a | b>a b=a b<a");
        $display("-------------------------");

        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                b = i[1:0];
                a = j[1:0];
                #10;

                $display("%4t  %0d  %0d |  %b   %b    %b",
                         $time, b, a, b_gt, b_a_eq, a_gt);
            end
        end

        $finish;
    end

endmodule
```
















## Simulation

Compile and run:

```bash
iverilog -g2012 -o sim compare_2bit.v compare_2bit_tb.v
vvp sim
gtkwave compare_2bit.vcd
```

## Expected Results

- Exactly one of the three outputs must be HIGH.
- Waveform must show correct transitions.
- Simulation time should increase in 10 ns steps.

## Optional Tasks

1. Implement the comparator using gate-level logic instead of relational operators.
2. Add an assertion that checks only one output is HIGH.
3. Modify the design for a 4-bit comparator.

## Questions

1. Why are testbench inputs declared as `reg`?
2. Why are comparator outputs declared as `wire`?
3. What is the difference between:
   - `assign b_gt = (b > a);`
   - Implementing logic manually using `&`, `|`, `~`?
4. Why is this design considered combinational logic?
5. What happens if you forget `#10` in the loop?

# Laboratory 2: 2-Bit Binary Comparator  

### Learning Objectives

After completing this lab, students should be able to:

- Work with multi-bit signals (`[1:0]`)
- Use relational operators (`>`, `<`, `==`)
- Write structured testbenches
- Analyze digital waveforms

## Background

A **binary comparator** compares two binary numbers and determines their relationship.

For two 2-bit inputs:

```
a = a1 a0
b = b1 b0
```

The comparator generates three outputs:

- `b_gt`   → 1 when `b > a`
- `b_a_eq` → 1 when `b == a`
- `a_gt`   → 1 when `b < a`

Only **one output** should be HIGH at a time.

Example:

| b  | a  | b_gt | b_a_eq | a_gt |
|----|----|------|--------|------|
| 00 | 00 | 0    | 1      | 0    |
| 01 | 00 | 1    | 0      | 0    |
| 01 | 10 | 0    | 0      | 1    |

## Design Requirements

Create file: `compare_2bit.v`

Implement a combinational 2-bit comparator.

### Module template

```verilog
// =================================================
// 2-bit binary comparator
// =================================================

module compare_2bit (
    input  wire [1:0] b,
    input  wire [1:0] a,
    output wire       b_gt,
    output wire       b_a_eq,
    output wire       a_gt
);

    // Implement logic here using assign statements

endmodule
```

### Implementation Rules

- Use **continuous assignments (`assign`)**
- Do NOT use `always` blocks for this version
- Use relational operators (`>`, `<`, `==`)

## Testbench Requirements

Create file: `compare_2bit_tb.v`

The testbench must:

- Apply all 16 input combinations
- Use nested `for` loops
- Generate a VCD waveform file
- Print formatted console output

### Testbench template

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

## Questions

1. Why are testbench inputs declared as `reg`?
2. Why are comparator outputs declared as `wire`?
3. What is the difference between:
   - `assign b_gt = (b > a);`
   - Implementing logic manually using `&`, `|`, `~`?
4. Why is this design considered combinational logic?
5. What happens if you forget `#10` in the loop?

## Optional Tasks

1. Implement the comparator using gate-level logic instead of relational operators.
2. Add an assertion that checks only one output is HIGH.
3. Modify the design for a 4-bit comparator.

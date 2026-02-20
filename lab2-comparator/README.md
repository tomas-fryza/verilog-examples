# Laboratory 2: Binary comparator  

* [Task 1: Logic function minimization](#task1)
* [Task 2: 2-bit binary comparator](#task2)
* [Task 3: Checking simulation values](#task3)
* [Optional tasks](#tasks)
* [Questions](#questions)

### Objectives

After completing this lab, students should be able to:

* Use truth table, K-map, SoP/PoS forms of logic functions
* Work with multi-bit signals
* Use relational operators (`>`, `<`, `==`)
* Use simple checking for testing

### Background

*[Karnaugh Maps](https://learnabout-electronics.org/Digital/dig24.php) (or K-maps)* offer a graphical method of reducing a digital circuit to its minimum number of gates. The map is a simple table containing `1`s and `0`s that can express a truth table or complex Boolean expression describing the operation of a digital circuit.

*Digital* or *Binary comparator* compares the digital signals A, B presented at input terminal and produce outputs depending upon the condition of those inputs.

   ![Binary comparator](images/two-bit-comparator.png)

<a name="task1"></a>

## Task 1: Logic function minimization

1. Complete the truth table for 2-bit *Identity comparator* (B equals A), and two *Magnitude comparators* (B is greater than A, A is greater than B). Note that, such a digital device has four inputs and three outputs/functions but only **one output** should be HIGH at a time:

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

2. According to truth table, create K-maps for all functions.

   ![2-bit comparator Karnaugh maps](images/k-maps.png)

3. Use K-maps to create simplified SoP and PoS forms of "B greater than A" function.

<a name="task2"></a>

## Task 2: 2-bit binary comparator

Design a circuit that implements a **2-bit binary comparator**. The comparator shall compare two 2-bit unsigned inputs `a` and `b` and generate three mutually exclusive outputs `b_gt`, `b_a_eq`, `a_gt`.

   - Use 2-bit input busses `[1:0] a`, `[1:0] b`
   - Use **combinational logic only**
   - Use **continuous assignments** (`assign`)
   - Do not use clocks or sequential logic
   - The design must be synthesizable
   - Only **one output may be HIGH at a time** (one-hot behavior)
   - All 16 input combinations must be verified by simulation

1. Run Vivado and create a new project:

   1. Project name: `comparator`
   2. Project location: your working folder, such as `Documents`
   3. Project type: **RTL Project**
   4. Create a new VHDL source file: `comparator`
   5. Do not add any constraints now
   6. Choose a default board: `Nexys A7-50T`
   7. Click **Finish** to create the project
   8. Define I/O ports of new module:

      * Port name: `a`, Direction: `input`, Bus: `check`, MSB: `1`, LSB: `0`
      * `b`, `input`, Bus: `check`, MSB: `1`, LSB: `0`
      * `b_gt`, `output`
      * `b_a_eq`, `output`
      * `a_gt`, `output`

2. Open a file **`comparator.v`** and complete the following template:

   ```verilog
   // =================================================
   // 2-bit binary comparator
   // =================================================

   module comparator (
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

3. Add a new simulation file named **`comparator_tb.v`**, complete the provided template, and verify your design by simulation.

   ```verilog
   `timescale 1ns/1ps

   module comparator_tb ();

       // ---------------------------------------------
       // Testbench internal signals
       // Must be `reg`, so we can assign values
       // ---------------------------------------------
       reg [1:0] b;  // DUT input b
       reg [1:0] a;  // DUT input a
       wire      b_gt;
       wire      b_a_eq;
       wire      a_gt;

       // ---------------------------------------------
       // Instantiate Device Under Test (DUT)
       // ---------------------------------------------
       comparator dut (
           .b      (b),
           .a      (a),
           .b_gt   (b_gt),
           .b_a_eq (b_a_eq),
           .a_gt   (a_gt)
       );

       integer i, j;  // Integer in Verilog is typically 32-bit signed

       // ---------------------------------------------
       // Stimulus process
       // Applies test vectors to DUT inputs over time
       // ---------------------------------------------
       initial begin
           // Exhaustive testing
           for (i = 0; i < 4; i = i + 1) begin
               for (j = 0; j < 4; j = j + 1) begin
                   b = i[1:0];  // Take only the lowest 2 bits of i
                   a = j[1:0];
                   #10;
               end
           end

           $finish;
       end
   endmodule
   ```

4. Use `$display` and `$monitor` to print information to the console. The system task `$display` prints a message once at the moment it is executed. It is typically used to print headers, error messages, intermediate debug information, or a final PASS/FAIL summary. In contrast, `$monitor` continuously observes the listed signals and automatically prints their values whenever any of them change during simulation. This makes `$monitor` useful for tracking signal activity over time without manually inserting multiple print statements.

   ```verilog
   ...
   // ---------------------------------------------
   // Stimulus process
   // Applies test vectors to DUT inputs over time
   // ---------------------------------------------
   initial begin
       $display("\nStarting simulation...\n");
       $display("Time   b  a | b>a b=a b<a");
       $display("------------+------------");

       // Use the monitor task to automaticaly display any change
       $monitor("%3d   %b %b |  %b   %b   %b",
           $time, b, a, b_gt, b_a_eq, a_gt);

       // Exhaustive testing
   ...
   ```

5. In `module`, use method 2 and implement `b_gt` using minimized Boolean equation in SoP or PoS logic at gate-level. Simulate it. Compare waveform results with behavioral version.

   > **Note:** The behavioral implementation is synthesizable and preferred in real designs because it is clearer, scalable, and less error-prone than manual Boolean equations.

<a name="task3"></a>

## Task 3: Checking simulation values

Relying only on waveform inspection is not sufficient. Modern digital design requires **self-checking verification**, where the testbench evaluates whether the Design Under Test (DUT) behaves as expected. There are three levels of testing quality:

   * Manual checking (bad). Inputs are applied and the waveform is visually inspected.

   * Hardcoded expected values (better). Expected outputs are manually written for each test case.

   * Computed expected model (best). The testbench computes expected results automatically and compares them with DUT outputs.

1. In this task, you will implement a self-checking testbench using **monitors** and **checkers**. The monitor is useful for tracking signal behavior during simulation, but it does not verify correctness. Therefore, your testbench must also include checking logic that compares DUT outputs with expected values and reports mismatches.

   ```verilog
       ...
       integer i, j;  // Integer in Verilog is typically 32-bit signed
       integer errors = 0;

       reg exp_b_gt;
       reg exp_b_a_eq;
       reg exp_a_gt;

       // ---------------------------------------------
       // Stimulus process
       // Applies test vectors to DUT inputs over time
       // ---------------------------------------------
       initial begin
           $display("\nStarting simulation...\n");
           $display("Time   b  a | b>a b=a b<a");
           $display("------------+------------");

           // Use the monitor task to automaticaly display any change
           $monitor("%3d   %b %b |  %b   %b   %b",
               $time, b, a, b_gt, b_a_eq, a_gt);

           // Exhaustive testing
           for (i = 0; i < 4; i = i+1) begin
               for (j = 0; j < 4; j = j+1) begin
                   b = i[1:0];  // Take only the lowest 2 bits of i
                   a = j[1:0];
                   #10;

                   // Compute expected values
                   exp_b_gt   = (b > a);
                   exp_b_a_eq = (b == a);
                   exp_a_gt   = (a > b);

                   // Compare with DUT outputs
                   if (b_gt !== exp_b_gt ||
                       b_a_eq !== exp_b_a_eq ||
                       a_gt !== exp_a_gt) begin

                       $display("[Error] a=%0d b=%0d | DUT=%b%b%b EXPECTED=%b%b%b",
                           a, b,
                           b_gt, b_a_eq, a_gt,
                           exp_b_gt, exp_b_a_eq, exp_a_gt);
                        
                       errors = errors + 1;
                   end
               end
           end

           // Final result
           if (errors == 0)
               $display("\nAll tests PASSED\n");
           else
               $display("\nTest FAILED with %0d errors\n", errors);

           $finish;
       end
   endmodule
   ```

   > **Note:** In Verilog testbenches, the operators `===` (case equality) and `!==` (case inequality) should be used when comparing signals. Unlike `==` and `!=`, which perform logical comparisons, `===` and `!==` compare every bit explicitly, including unknown (`X`) and high-impedance (`Z`) values. This guarantees reliable mismatch detection and prevents hidden simulation errors.

2. Use **Flow > Open Elaborated design** and see the schematic after RTL analysis.

<a name="tasks"></a>

## Optional tasks

1. Extend comparator to 4-bit (scalability).

2. Design a [*Prime number detector*](https://link.springer.com/chapter/10.1007/978-3-030-10552-5_1) that takes in values from 0 to 15.

   ![prime detector](images/digital-design-flow_prime.png)

3. The simulation can be done without Vivado. Just add the following lines to the testbench:

   ```verilog
   // Waveform dump for GTKWave
   $dumpfile("comparator.vcd");
   $dumpvars(0, comparator_tb);
   ```
   
   and use Icarus Verilog and GTKWave tools from command line to simulate your desing.
   
   ```bash
   $ iverilog -g2012 -o sim comparator.v comparator_tb.v
   $ vvp sim
   $ gtkwave comparator.vcd
   ```

<a name="questions"></a>

## Questions

1. What is the advantage of using K-maps instead of directly writing SoP expressions?

2. Why is using relational operators preferred over manual Boolean equations?

3. Why must only one comparator output be high at a time?

4. How many input combinations must be tested for a 2-bit comparator?

5. What happens if you forget `#10` in the loop?

6. Why is a self-checking testbench better than manually writing expected output values?

7. What is the difference between using `$monitor` and `$display` system tasks?

# Laboratory 4: Binary counter

* [Task 1: Binary counter](#task1)
* [Task 2: Clock enable](#task2)
* [Task 3: Top-level design and FPGA implementation](#task3)
* [Optional tasks](#tasks)
* [Questions](#questions)

### Objectives

After completing this laboratory, students will be able to:

* Use a clock enable signal to drive slower logic without creating new clock domains
* Use Verilog parameters to make designs flexible and reusable
* Implement synchronous processes with a clock and reset signals
* Understand the operation of binary counters and how N-bit outputs represent sequential counts

### Background

A binary **N-bit counter** is a digital circuit with **N output bits** representing the current count value. It counts sequentially from `0` to `2^N-1` and then wraps around back to `0`. When the reset signal is asserted, the counter is cleared and starts again from `0`.

Many digital circuits include an **enable** (clock enable) input. This signal controls whether the counter is allowed to increment. When the clock enable signal is active (typically high), the counter updates its value on each clock edge and counts normally. When the clock enable signal is inactive (typically low), the counter holds its current value and does not increment.

![simple counter](images/waveform_counter.png)

---

<a name="task1"></a>

## Task 1: Binary counter

1. Run Vivado, create a new RTL project named `counter`, and create a Verilog design source file named `counter` for Nexys A7-50T FPGA board. Use the following I/O ports and implement a 4-bit binary counter:

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `clk` | input | `wire` | Main clock |
   | `rst` | input | `wire` | High-active synchronous reset |
   | `en`  | input | `wire` | Clock enable |
   | `cnt` | output | `reg [3:0]` | Counter value |

2. A **parameter** in Verilog allows the designer to configure a module at instantiation time, making the design flexible and reusable. The same module can therefore be used with different parameter values without modifying its internal implementation.

   A parameter behaves similarly to a constant:
      * Its value is defined when the module is instantiated.
      * It cannot be changed during simulation.
      * It is typically used to define sizes, limits, or timing parameters.

   In the following example, the parameter `N` defines the width of the generated binary counter. The module can be extended with such a parameter as follows:

   ```verilog
   module counter #(
       // "#()" after a module name introduces a parameter list
       parameter N = 4  // Number of bits for the counter
   )(
       input  wire clk,         // Main clock
       input  wire rst,         // High-active synchronous reset
       input  wire en,          // Clock enable
       output reg  [N-1:0] cnt  // Counter value
   );
   ```

3. Use a Verilog **sequential always block** `always @(posedge clk) begin ... end` to describe the internal behavior of the module. This block is triggered only on the **positive (rising) edge** of the clock signal. Therefore, the described logic is **synchronous with the clock**, meaning that all signal updates occur only when the clock rises.

   ```verilog
   ...
       always @(posedge clk) begin
           if (rst) begin
               cnt <= 0;  // Reset counter; non-blocking assignment (<=)
           end
           else if (en) begin
               cnt <= cnt + 1'b1;  // Increment counter when enabled
           end
       end

   endmodule
   ```

   > **Note:** Verilog suppors **blocking** and **non-blocking** assignments. Blocking assignments (`=`) execute immediately and in order, while non-blocking assignments (`<=`) update at the end of the time step, which correctly models how flip-flops update simultaneously in hardware.

4. Create a new Verilog simulation file named `counter_tb`, complete the provided template, test the functionality of the `rst` and `en` signals, and try several values of `N`.

   A module parameter allows the designer to **configure the internal properties of a module during instantiation**. When a module is instantiated, its parameters can be overridden using the `#(...)` syntax placed between the module name and the instance name.

   ```verilog
   `timescale 1ns/1ps

   module counter_tb ();

       // Local parameter value is fixed inside the module
       localparam N = 5;  // Change only this value to scale the counter

       // Testbench signals
       reg  clk;
       reg  rst;
       reg  en;
       wire [N-1:0] cnt;

       // Instantiate Device Under Test (DUT)
       counter #(
           .N(N)
       ) dut (
           .clk(clk),
           .rst(rst),
           .en (en),
           .cnt(cnt)
       );

       // Clock generation: 10 ns period (100 MHz)
       initial clk = 0;
       always #5 clk = ~clk;
       // `always` defines a process that runs indefinitely during
       // simulation. This block repeats forever.

       // Testbench stimulus
       initial begin
           // Initialize
           rst = 0;
           en  = 1;

           // TODO: Reset generation
    
           // TODO: Clock enable/disable sequence
 
           // Finish simulation
           $display("\nSimulation finished\n");
           $finish;
       end

   endmodule
   ```

   > **Note:** For any vector, you can change the numeric display format in the simulation viewer. To do this, right-click the vector name and select **Radix > Unsigned Decimal** from the context menu. You can also change the vector color using **Signal Color**.
   > 
   > ![Change radix](images/vivado_radix.png)

5. In Vivado, use **Flow > RTL Analysis > Open Elaborated design** and see the **Schematic** after RTL analysis. Note that RTL (Register Transfer Level) represents digital circuit at the abstract level.

6. Use **Flow > Synthesis > Run Synthesis** and then see the schematic at the gate level.

---

<a name="task2"></a>

## Task 2: Clock enable

To drive other logic in the design that requires a slower operation, it is better to generate a **clock enable signal** (see figure bellow) instead of creating a new clock domain using clock dividers. Creating additional clock domains may cause timing issues or clock domain crossing (CDC) problems such as metastability, data loss, and data incoherency.

![Clock enable](images/waveform_clock-enable.png)

1. Calculate how many clock cycles of a 100&nbsp;MHz clock (period 10&nbsp;ns) correspond to the following time intervals. Express each result in decimal, binary, and hexadecimal forms. What is the minimum number of bits required for each counter?

   | **Time interval** | **Clock cycles (decimal)** | **Binary** | **Hexadecimal** | **Required bits** |
   | :-: | :-: | :-: | :-: | :-: |
   | 2&nbsp;ms   | 200_000     | `18'b11_0000_1101_0100_0000`  | `18'h3_0d40` | 18 |
   | 4&nbsp;ms   | 400_000     | `19'b110_0001_1010_1000_0000` | `19'h6_1a80` | 19 |
   | 8&nbsp;ms   |             |  |  |  |
   | 10&nbsp;ms  |             |  |  |  |
   | 250&nbsp;ms | 25_000_000  | `25'b1_0111_1101_0111_1000_0100_0000`   | `25'h17d_7840` | 25 |
   | 500&nbsp;ms |             |  |  |  |
   | 1&nbsp;sec  | 100_000_000 | `27'b101_1111_0101_1110_0001_0000_0000` | `27'h5f5_e100` | 27 |

2. In your project, create a new Verilog design source file named `clk_en`, and implement a clock enable circuit which generates one-clock-cycle positive pulse every `MAX` clock periods.

3. Copy the [design](https://raw.githubusercontent.com/tomas-fryza/verilog-examples/refs/heads/main/examples/_solutions/lab4-counter/clk_en.v) into your `clk_en.v` file.

4. (Optionaly) Create a new Verilog simulation source file named `clk_en_tb`, copy the [testbench](https://raw.githubusercontent.com/tomas-fryza/verilog-examples/refs/heads/main/examples/_solutions/lab4-counter/clk_en_tb.v), and test several `MAX` values.

   > **Note:** To select which testbench to simulate, right-click to the testbench file name and choose `Set as Top`.
   >
   > ![Set as Top](images/vivado_set-top.png)

---

<a name="task3"></a>

## Task 3: Top-level design and FPGA implementation

Choose one of the following variants, implement a counter on the Nexys A7 board, and display the counter value on the LEDs (variant 1) or 7-segment display (variant 2).

### Variant 1: Counter and LEDs

1. In your project, create a new Verilog design source file named `counter_top`. Define I/O ports as follows.

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `clk`  | input  | `wire` | Main clock |
   | `btnu` | input  | `wire` | Synchronous reset |
   | `led`  | output | `wire [7:0]` | 8-bit counter value |

2. Use module instantiation of `clk_en` and `counter`, and complete the top-level module according to the following schematic and template.

   ![top level ver1](images/top-level_ver1.png)

   ```verilog
   `timescale 1ns/1ps

   module counter_top (
       input  wire clk,       // Main clock

       // TODO: Complete input/output ports

       output wire [7:0] led  // 8-bit counter value
   );

       // ---------------------------------------------------------
       // Clock enable for 10 ms
       // ---------------------------------------------------------
       wire en_10ms;
       clk_en #(
           .MAX(1_000_000)
       ) enable_inst (
           .clk(clk),
           .rst(btnu),
           .ce (en_10ms)
       );

       // ---------------------------------------------------------
       // 8-bit binary counter
       // ---------------------------------------------------------
       counter #(
           .N(8)
       ) counter_inst (

           // TODO: Complete instantiation of `counter`

       );

   endmodule
   ```

3. Complete all **TODO** items in the module.

4. Create a new constraints file `nexys` (XDC file) and copy relevant pin assignments from the [Nexys A7-50T](../examples/nexys.xdc) constraint file.

5. Implement your design to Nexys A7 board:

   1. Click **Generate Bitstream** (the process is time consuming and may take some time).
   2. Open **Hardware Manager**.
   3. Select **Open Target > Auto Connect** (make sure Nexys A7 board is connected and switched on).
   4. Click **Program device** and select the generated file `YOUR-PROJECT-FOLDER/counter.runs/impl_1/counter_top.bit`.

5. Use **IMPLEMENTATION > Open Implemented Design > Schematic** to see the generated structure.

### Variant 2: Counter and 7-segment display

1. In your project, create a new Verilog design source file named `counter_top`. Define I/O ports as follows.

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `clk`  | input  | `wire` | Main clock |
   | `btnu` | input  | `wire` | Synchronous reset |
   | `seg`  | output | `wire [6:0]` | Seven-segment cathodes CA..CG (active-low) |
   | `dp`   | output | `wire` | Seven-segment decimal point (active-low, not used) |
   | `an`   | output | `wire [7:0]` | Seven-segment anodes AN7..AN0 (active-low) |

2. In your project, add the design source file `bin2seg.v` from the previous lab and check the "Copy sources into project".

   ![vivado_copy-sources](images/vivado_copy-sources.png)

3. Use instantiation of modules `clk_en`, `counter`, and `bin2seg`, and define the top-level module as follows.

   ![top level ver2](images/top-level_ver2.png)

   ```verilog
   module counter_top (
       input  wire clk,      // Main clock

       // TODO: Complete input/output ports

       output wire [7:0] an  // Seven-segment anodes AN7..AN0 (active-low)
   );

       // Internal signals

       // ---------------------------------------------------------
       // Clock enable for 250 ms
       // ---------------------------------------------------------
       wire en_250ms;
       clk_en #(
           .MAX(25_000_000)
       ) enable_inst (
           .clk(clk),
           .rst(btnu),
           .ce (en_250ms)
       );

       // ---------------------------------------------------------
       // 4-bit binary counter
       // ---------------------------------------------------------
       wire [3:0] cnt;
       counter #(
           .N(4)
       ) counter_inst (

           // TODO: Complete instantiation of `counter`

       );

       // ---------------------------------------------------------
       // Binary to 7-segment decoder
       // ---------------------------------------------------------
       bin2seg decoder_inst (
           .bin(cnt),
           .seg(seg)
       );

       assign dp = // TODO: Turn off decimal point (inactive = '1')
       assign an = // TODO: Enable AN0 only (active-low)

   endmodule
   ```

4. Complete all **TODO** items in the module.

5. Create a new constraints file `nexys` (XDC file) and copy relevant pin assignments from the [Nexys A7-50T](../examples/nexys.xdc) constraint file.

6. Implement your design to Nexys A7 board:

   1. Click **Generate Bitstream** (the process is time consuming and may take some time).
   2. Open **Hardware Manager**.
   3. Select **Open Target > Auto Connect** (make sure Nexys A7 board is connected and switched on).
   4. Click **Program device** and select the generated file `YOUR-PROJECT-FOLDER/counter.runs/impl_1/counter_top.bit`.

7. Use **IMPLEMENTATION > Open Implemented Design > Schematic** to see the generated structure.

---

<a name="tasks"></a>

## Optional tasks

1. Combine two independent counters:
   * 4-bit counter with a 250 ms time base
   * 10-bit counter with a 10 ms time base

      ![top level](images/top-level_ver3.png)

2. Create a new module `counter_bcd` implementing BCD counter.

3. Create a new module `up_down_counter` implementing bi-directional (up/down) binary counter.

---

<a name="questions"></a>

## Questions

1. What is the purpose of the `en` (clock enable) signal in the counter, and what happens when it is `0`?

2. How many bits are required in a counter to generate a pulse every 10 ms on a 100 MHz clock?

3. What is the role of the parameter `N` in the counter module?

4. Why is the sequential process written as `always @(posedge clk)` instead of `always @(clk)`?

5. What is the purpose of the `#(...)` syntax when instantiating the counter module in the testbench?

6. What is the maximum value that an N-bit binary counter can represent? Explain why.

7. If the clock frequency were changed from 100 MHz to 50 MHz, how would the `MAX` value in the `clk_en` module need to change to keep the same 10 ms enable pulse?

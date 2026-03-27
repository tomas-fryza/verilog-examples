# Verilog basic syntax reference (Introductory level)

This reference guide covers the fundamental syntax and structure of Verilog, the Hardware Description Language (HDL) most commonly used in introductory digital design courses.

---

## 1. Basic Module Structure
The **module** is the fundamental building block in Verilog. Think of it as a "black box" with inputs and outputs.

```verilog
module module_name (
    input  wire a,  // Input port
    input  wire b,
    output wire y   // Output port
);
    // Logic goes here

endmodule  // Every module must end with endmodule
```

---

## 2. Data Types
Verilog has two primary data types representing physical hardware connections.

| Type | Assignment Method | Hardware Analogy |
| :--- | :--- | :--- |
| **wire** | `assign` statements | A physical wire; cannot "hold" a value without a driver. |
| **reg** | Inside `always` blocks | A variable that holds its value. 

> **Note:** A `reg` does not always result in a physical register in synthesized hardware (it can sometimes represent combinational logic), but it is required for any signal assigned within a procedural block.

---

## 3. Logic Values and Constants
Verilog uses a four-value logic system to accurately model hardware behavior.

* `0`: Logic low, ground, or "false"
* `1`: Logic high, VCC, or "true"
* `x`: Unknown (Usually a simulation error or uninitialized state)
* `z`: High impedance (disconnected/tri-stated)

### Constant Literals
Constants are defined using the syntax: `<size>'<radix><value>`

* `4'b1010`: A 4-bit binary number (10 in decimal).
* `8'hff`: An 8-bit hexadecimal number (255 in decimal).
* `16'd100`: A 16-bit decimal number.

### Arithmetic & Logical
* **Arithmetic:** `+`, `-`, `*`, `/`, `%`
* **Bitwise:** `&` (AND), `|` (OR), `^` (XOR), `~` (NOT)
* **Logical:** `&&` (AND), `||` (OR), `!` (NOT) — *Used for true/false expressions.*
* **Relational:** `==`, `!=`, `<`, `>`, `<=`, `>=`

### Concatenation and Replication
* **Concatenation `{ }`:** Combines smaller buses into a larger one. 
    * `{4'b1100, 4'b0011}` results in `8'b11000011`.
* **Replication `{n{m}}`:** Repeats a value $n$ times.
    * `{4{1'b1}}` results in `4'b1111`.

---

## 4. Assignment Types
Understanding the difference between these two is the most critical part of learning Verilog.

### Continuous Assignment (`assign`)
Used for **Combinational Logic**. The right-hand side is "driven" onto the left-hand side wire continuously. Drives `wire` types.

```verilog
assign out = a & b;  // Logical AND gate
```

### Procedural Assignment (`always` blocks)
Used for both combinational and sequential (clocked) logic. Signals on the left-hand side (targets) must be of type `reg`.

* **Combinational:** `always @(*)` triggers on any input change.
* **Sequential:** `always @(posedge clk)` triggers only on the rising edge of the clock.

---

## 5. Combinational `always` Blocks
A combinational `always` block describes logic where the output changes immediately (after a small propagation delay) based on the inputs. 

### Key Characteristics:
* **Sensitivity List:** Use `always @(*)` to automatically include all signals read in the block.
* **Assignment Type:** Use **Blocking** assignments (`=`).
* **Hardware Result:** This synthesizes into logic gates (AND, OR, MUX), not flip-flops.

```verilog
// Example: A 2-to-1 Multiplexer
module mux2to1 (
    input wire a,
    input wire b,
    input wire sel,
    output reg y      // Must be 'reg' because it's in an always block
);
    always @(*) begin
        if (sel)
            y = b;    // Blocking assignment
        else
            y = a;
    end
endmodule
```

---

## 6. Sequential `always` Blocks
A sequential block describes logic that only updates at specific moments, usually triggered by a clock edge.

### Key Characteristics:
* **Sensitivity List:** Use `always @(posedge clk)` for rising-edge triggered logic.
* **Assignment Type:** Use **Non-Blocking** assignments (`<=`).
* **Hardware Result:** This synthesizes into Flip-Flops (Registers).

```verilog
// Example: A simple D-Flip-Flop
module d_flip_flop (
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;       // Non-blocking assignment
    end
endmodule
```

---

## 7. Procedural Blocks: If-Else and Case
These can only be used inside `always` blocks.

### If-Else
```verilog
always @(*) begin
    if (sel)
        y = a;
    else
        y = b;
end
```

```verilog
always @(*) begin
    if (sel) begin
        y = a;
        status = 1'b1; // Second statement
    end else begin
        y = b;
        status = 1'b0; // Second statement
    end
end
```

Note, `begin` and `end` is mandatory for **multiple statements**. For **single statement** they are optional but many engineers use them anyway for clarity.

```verilog
// Single statement
if (enable)
    data_out <= data_in;

// Multiple statements
if (enable) begin
    data_out <= data_in;
    ready    <= 1'b1;
end
```

### Case Statement
Useful for Multiplexers (MUX) or State Machines.

```verilog
always @(*) begin
    case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        default: y = 1'b0;
    endcase
end
```

Using a `default` statement in Verilog isn't just a coding "safety net"—it's a critical tool for hardware synthesis and preventing one of the most common bugs in digital design: the **unintentional latch**.

---

## 8. Blocking vs. Non-Blocking Assignments
This governs how values are updated inside `always` blocks.

* **Blocking (`=`):** Used for **Combinational** logic. Assignments happen sequentially (like software).
* **Non-Blocking (`<=`):** Used for **Sequential** logic. All assignments happen simultaneously on the clock edge.

> **Golden Rule:** > * Use `=` inside `always @(*)`
> * Use `<=` inside `always @(posedge clk)`

Building on the syntax reference, here is a breakdown of how to implement combinational and sequential logic using `always` blocks, specifically focusing on the behavior of a **synchronous reset**.

---

## 9. Synchronous vs. Asynchronous Reset
The **reset** signal brings the system to a known initial state. In modern digital design, a **Synchronous Reset** is often preferred for its stability.

### Synchronous Reset
The reset is only sampled on the **rising edge of the clock**. If the reset signal transitions between clock edges, nothing happens until the next `posedge clk`.

| Feature | Synchronous Reset | Asynchronous Reset |
| :--- | :--- | :--- |
| **Sensitivity List** | `always @(posedge clk)` | `always @(posedge clk or posedge rst)` |
| **Logic Type** | Clock-dependent | Immediate (Clock-independent) |
| **Advantage** | Filters out "glitches" on the reset line. | Works even if the clock is dead. |

### Verilog Example: 4-bit Counter with Synchronous Reset
```verilog
module counter_sync_reset (
    input wire clk,
    input wire reset, // Synchronous reset
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            // This happens ONLY on the clock edge if reset is high
            count <= 4'b0000;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule
```

---

## 10. Finite State Machines (FSM)
An FSM is a mathematical model of computation used to design sequential logic. It consists of a fixed number of **states**, transitions between those states, and actions.

### Moore vs. Mealy Machines
There are two primary types of FSMs used in Verilog:

| Feature | Moore Machine | Mealy Machine |
| :--- | :--- | :--- |
| **Output Depends On** | Only the **Current State**. | The **Current State** AND the **Inputs**. |
| **Hardware** | Usually safer; outputs are synchronized. | Can be faster; reacts immediately to inputs. |
| **Complexity** | Often requires more states. | Often requires fewer states. |

### The "Three-Block" Coding Style
For clean, synthesizable Verilog, it is best practice to separate an FSM into three distinct procedural blocks.

1.  **State Register (Sequential):** Updates the current state on the clock edge.
2.  **Next State Logic (Combinational):** Determines what the next state should be based on current state and inputs.
3.  **Output Logic (Combinational or Sequential):** Determines the output values.

### FSM Implementation Example
Below is a template for a simple **Moore FSM** that detects a specific sequence or controls a process.

#### Step 1: State Enumeration
Use `localparam` to give your states descriptive names. This makes the code readable.
```verilog
localparam S_IDLE  = 2'b00,
           S_START = 2'b01,
           S_WAIT  = 2'b10,
           S_DONE  = 2'b11;

reg [1:0] current_state, next_state;
```

#### Step 2: The Three Blocks
```verilog
// BLOCK 1: State Register (Sequential)
always @(posedge clk) begin
    if (reset)
        current_state <= S_IDLE;
    else
        current_state <= next_state;
end

// BLOCK 2: Next State Logic (Combinational)
always @(*) begin
    case (current_state)
        S_IDLE: begin
            if (go_signal) next_state = S_START;
            else           next_state = S_IDLE;
        end
        S_START: next_state = S_WAIT;
        S_WAIT:  begin
            if (timer_done) next_state = S_DONE;
            else            next_state = S_WAIT;
        end
        S_DONE:  next_state = S_IDLE;
        default: next_state = S_IDLE; // Safety net
    endcase
end

// BLOCK 3: Output Logic (Combinational - Moore Style)
always @(*) begin
    case (current_state)
        S_IDLE:  done_led = 1'b0;
        S_START: done_led = 1'b0;
        S_WAIT:  done_led = 1'b0;
        S_DONE:  done_led = 1'b1; // Output only high in this state
        default: done_led = 1'b0;
    endcase
end
```

### Common FSM Pitfalls
* **Missing `default` in Case:** If you don't cover every possible state or input combination, Verilog might infer a **Latch**, which can cause unpredictable timing issues.
* **Incomplete Sensitivity List:** Always use `always @(*)` for your combinational blocks to ensure the state transitions happen as soon as an input changes.
* **Mixing Logic:** Avoid putting your "Next State" logic inside the "State Register" block. Keeping them separate makes debugging significantly easier.

> **Final Note:** When designing an FSM, always draw your **State Transition Diagram** on paper first. Coding is much easier once you visualize the bubbles and arrows!

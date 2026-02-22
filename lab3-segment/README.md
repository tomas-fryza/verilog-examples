# Laboratory 3: Seven-segment display decoder

* [Task 1: Seven-segment display decoder](#task1)
* [Task 2: Structural modeling and instantiation](#task2)
* [Task 3: Top-level design and FPGA implementation](#task3)
* [Optional tasks](#tasks)
* [Questions](#questions)

### Objectives

After completing this laboratory, students will be able to:

* Use 7-segment display
* Use Verilog processes
* Understand the structural modeling and instantiation in Verilog
* Implement design to real hardware

### Background

The Binary to 7-Segment Decoder converts 4-bit binary data to 7-bit control signals which can be displayed on 7-segment display. A display consists of 7 LED segments to display the decimal digits `0` to `9` and letters `A` to `F`.

Note that, there are other types of segment displays, such as 9-, 14- or 16-segment.

   ![other displays](images/7-segment.png) &nbsp; &nbsp; &nbsp; &nbsp;
   ![other displays](images/9-segment.png) &nbsp; &nbsp; &nbsp; &nbsp;
   ![other displays](images/14-segment.png) &nbsp; &nbsp; &nbsp; &nbsp;
   ![other displays](images/16-segment.png)

The Nexys A7 board provides two four-digit common anode seven-segment LED displays (configured to behave like a single eight-digit display). See [schematic](https://github.com/tomas-fryza/verilog-examples/blob/master/docs/nexys-a7-sch.pdf) or [reference manual](https://reference.digilentinc.com/reference/programmable-logic/nexys-a7/reference-manual) of the Nexys A7 board and find out the connection of 7-segment displays and push-buttons. What is the difference between NPN and PNP type of BJT (Bipolar Junction Transistor).

   ![nexys A7 led and segment](images/nexys-a7_leds-display.png)

<a name="task1"></a>

## Task 1: Seven-segment display decoder

1. Complete the decoder truth table for a **common anode** (active low) 7-segment display.

   ![https://lastminuteengineers.com/seven-segment-arduino-tutorial/](images/7-Segment-Display-Number-Formation-Segment-Contol.png)

   | **Symbol** | **bin** | **a** | **b** | **c** | **d** | **e** | **f** | **g** |
   | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
   | `0` | 0000 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
   | `1` | 0001 | 1 | 0 | 0 | 1 | 1 | 1 | 1 |
   | `2` |      |   |   |   |   |   |   |   |
   | `3` |      |   |   |   |   |   |   |   |
   | `4` |      |   |   |   |   |   |   |   |
   | `5` |      |   |   |   |   |   |   |   |
   | `6` |      |   |   |   |   |   |   |   |
   | `7` | 0111 | 0 | 0 | 0 | 1 | 1 | 1 | 1 |
   | `8` | 1000 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
   | `9` |      |   |   |   |   |   |   |   |
   | `A` |      |   |   |   |   |   |   |   |
   | `b` |      |   |   |   |   |   |   |   |
   | `C` |      |   |   |   |   |   |   |   |
   | `d` |      |   |   |   |   |   |   |   |
   | `E` | 1110 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
   | `F` | 1111 | 0 | 1 | 1 | 1 | 0 | 0 | 0 |

2. Run Vivado, create a new RTL project named `segment` with a Verilog source file `bin2seg`. Use the following I/O ports:

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `bin` | input | `xxxxx` | 4-bit hexadecimal input |
   | `seg` | output | `xxxxx` | {a,b,c,d,e,f,g} active-low outputs |


   TBD


4. Create a Verilog simulation file named `bin2seg_tb`, complete the provided template, and verify the functionality of your decoder.


   TBD


5. Use **Flow > Open Elaborated design** and see the schematic after RTL analysis. Note that RTL (Register Transfer Level) represents digital circuit at the abstract level.

<a name="task2"></a>

## Task 2: Structural modeling and instantiation


TBD


<a name="task3"></a>

## Task 3: Top-level design and FPGA implementation

In this task, you will integrate your `bin2seg` decoder into a **top-level entity** and implement the design on the **Nexys A7 FPGA board**. The 4-bit input value will be provided by slide switches, and the decoded output will drive one digit of the onboard 7-segment display.

1. Create a new Verilog design source named `segment_top`.
2. Define the following I/O ports:

   | **Port name** | **Direction** | **Type** | **Description** |
   | :-: | :-: | :-- | :-- |
   | `sw`  | input  | `xxx` | Slide switch inputs |
   | `seg` | output | `xxx` | Seven-segment cathodes CA..CG (active-low) |
   | `dp` | output | `xxx` | Decimal point (active-low) |
   | `an` | output | `xxx` | Digit enable anodes AN7..AN0 (active-low) |

3. Use component instantiation to connect `bin2seg` and define the top-level architecture.

   ![Top level, 1-digit](images/top-level_1-digit.png)

   > **Note:** In Vivado, individual templates can be found in **Flow Navigator** or in the menu **Tools > Language Templates**. Search for `component declaration` and `component instantiation`.


   TBD


   Only one digit must be enabled. All other digits must remain disabled to prevent multiple digits from lighting simultaneously.

4. A **constraint** is a rule that dictates a placement or timing restriction for the implementation. Constraints are not VHDL, and the syntax of constraints files differ between FPGA vendors.

   * __Physical constraints__ limit the placement of a signal or instance within the FPGA. The most common physical constraints are pin assignments. They tell the P&R (Place & Route) tool to which physical FPGA pins the top-level entity signals shall be mapped.

   * __Timing constraints__ set boundaries for the propagation time from one logic element to another. The most common timing constraint is the clock constraint. We need to specify the clock frequency so that the P&R tool knows how much time it has to work with between clock edges.

   In this design, only physical constraints are required.

5. Create a new constraints file `nexys` (XDC file).

6. Copy relevant pin assignments from the [Nexys A7-50T](../examples/_solutions/nexys.xdc) constraint file or use the following minimal constrains:

   ```xdc
   set_property PACKAGE_PIN J15 [get_ports {sw[0]}]
   set_property PACKAGE_PIN L16 [get_ports {sw[1]}]
   set_property PACKAGE_PIN M13 [get_ports {sw[2]}]
   set_property PACKAGE_PIN R15 [get_ports {sw[3]}]
   set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

   set_property PACKAGE_PIN T10 [get_ports {seg[6]}] ; # CA
   set_property PACKAGE_PIN R10 [get_ports {seg[5]}] ; # CB
   set_property PACKAGE_PIN K16 [get_ports {seg[4]}] ; # CC
   set_property PACKAGE_PIN K13 [get_ports {seg[3]}] ; # CD
   set_property PACKAGE_PIN P15 [get_ports {seg[2]}] ; # CE
   set_property PACKAGE_PIN T11 [get_ports {seg[1]}] ; # CF
   set_property PACKAGE_PIN L18 [get_ports {seg[0]}] ; # CG
   set_property PACKAGE_PIN H15 [get_ports {dp}]
   set_property IOSTANDARD LVCMOS33 [get_ports {seg[*] dp}]

   set_property PACKAGE_PIN J17 [get_ports {an[0]}]
   set_property PACKAGE_PIN J18 [get_ports {an[1]}]
   set_property PACKAGE_PIN T9  [get_ports {an[2]}]
   set_property PACKAGE_PIN J14 [get_ports {an[3]}]
   set_property PACKAGE_PIN P14 [get_ports {an[4]}]
   set_property PACKAGE_PIN T14 [get_ports {an[5]}]
   set_property PACKAGE_PIN K2  [get_ports {an[6]}]
   set_property PACKAGE_PIN U13 [get_ports {an[7]}]
   set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]
   ```

7. Implement your design to Nexys A7 board:

   1. Click **Generate Bitstream** (the process is time consuming and may take some time).
   2. Open **Hardware Manager**.
   3. Select **Open Target > Auto Connect** (make sure Nexys A7 board is connected and switched on).
   4. Click **Program device** and select the generated file `YOUR-PROJECT-FOLDER/segment.runs/impl_1/segment_top.bit`.

8. Test the functionality of the seven-segment display decoder by toggling the switches and observing the display.

9. Use **IMPLEMENTATION > Open Implemented Design > Schematic** to see the generated structure.

<a name="tasks"></a>

## Optional tasks

1. Display input `bin` value on LEDs.

2. Use 8 slide switches to extend the one-digit 7-segment decoder to drive a two-digit display. When the button `btnd` is pressed, the display should switch between the two digits and only one digit should be active at a time.

   ![Top level, 2-digit](images/top-level_2-digit.png)


   TBD


<a name="questions"></a>

## Questions

1. What is the difference between a common anode and a common cathode 7-segment display?



4. What is the purpose of a top-level entity in an FPGA design?



6. Why must only one digit (`an`) be enabled at a time on the Nexys A7 display?

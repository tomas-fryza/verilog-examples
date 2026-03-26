# Verilog projects 2026

The projects are designed for groups of **2–4 students** with a total time allocation of **10 hours** (5 lab sessions of 2 hours each).

## 1. Project rules

- **Group Work:**  
  Work on your assigned topic within your computer exercise group. No switching groups is allowed.

- **Attendance & Weekly Checks:**  
  Attendance is mandatory. Weekly graded progress checks will take place.

- **Grading & Git Repositories:**  
  Points will be awarded or deducted weekly based on your project repository updates (GitHub, GitLab, Bitbucket, etc.), including:
  - Public repository creation
  - Top-level schematic
  - Defined inputs/outputs, constraints
  - Description and simulation of new moduless
  - Complete Vivado project
  - Verilog coding style
  - README, poster, demo video, and responses to questions

  > Goal: Avoid last-minute uploads of high-quality code that students don’t understand.

- **Use of Components:**  
  Use the standard lab components: `bin2seg`, `counter`, `clk_en`, `debouncer`, `display_driver`, etc.

- **Short Demo Video:**  
  Demonstrate that your project works correctly and explain key design aspects in 1–3 minutes (short and focused) video.

- **Project Defense / Poster Session:**  
  Public poster sessions during the last week of the semester (dates announced separately). Poster must be at least A3 size.

- **Team Points:**  
  By default, all team members receive the same points. Teams may propose a different distribution if a member did little or no work.

- **Points & Passing:**
  - Maximum points: **10**
  - Minimum points required to pass: **5**

### Proposed schedule (5x 2 hours)

- **Lab 1: Architecture.** Block diagram design, role assignment, Git initialization, `.xdc` file preparation.

- **Lab 2: Unit Design.** Development of individual modules, testbench simulation, Git updates.

- **Lab 3: Integration.** Merging modules into the Top-level entity, synthesis, and initial HW testing, Git updates.

- **Lab 4: Tuning.** Debugging, code optimization, and Git documentation.

- **Lab 5: Defense.** Completion, video demonstration of the functional device, poster presentation, and code review.

### Documentation requirements (README.md)

Each project repository must include:
*   **Problem Description:** Brief overview of the project content in Czech, Slovak, or English.
*   **Block Diagram:** Graphical representation of module hierarchy and signal flows.
*   **Git Flow:** Commit history demonstrating the activity of team members.
*   **Simulations:** Screenshots from the Vivado simulator (Waveforms) proving new module functionality.
*   **Resource Report:** A table of resource utilization (LUTs, FFs) after synthesis.
*   **Vivado Project:** A complete Vivado 2025.2 project.
*   **Other Outputs:** A3 poster, link to short video, list of used references and tools.

---

## 2. Project summary table (2025/26)

| Project | Students | Verilog | Time | Peripherals (Nexys A7) | Required Module(s) |
| :--- | :---: | :---: | :---: | :--- | :--- |
| **1. PWM Breathing LED** | 2 | 2 | 2 | 16x LED, 1x Switch | Counter |
| **2. Digital Stopwatch (Lap)** | 2–3 | 3 | 3 | 8x 7-seg, Buttons | Counter, Debouncer |
| **3. Digital Safe** | 2–3 | 3 | 4 | Switches, 7-seg, Buttons | Debouncer |
| **4. 7-segment Snake** | 3–4 | 4 | 5 | 8x 7-seg, Buttons | Debouncer, Counter |
| **5. Alarm Clock** | 2–3 | 3 | 4 | 7-seg, Buttons, Buzzer | Debouncer |
| **6. Ultrasound HS-SR04** | 2–3 | 3 | 4 | HS-SR04 (Pmod), 7-seg | Counter, Debouncer |

*Difficulty Rating: 0 = lowest, 5 = highest.*

---

## 3. Detailed project descriptions

### 3.1. PWM Breathing LED
Create a module that smoothly changes LED brightness by generating a triangle waveform for the PWM duty cycle, simulating “inhale” and “exhale.”

### 3.2. Digital Stopwatch (Lap)
Measure time to hundredths of a second and display current and lap times on 7-segment displays, using a clock divider and registers to store laps.

### 3.3. Digital Safe / Combination Lock
Implement a 4-digit code entry system with visual feedback. Store entered codes in registers and compare to the preset combination to indicate success or failure.

### 3.4. 7-segment Snake
Implement a snake game on 7-segment displays. Track snake position and length, generate food randomly, and update the score as the snake grows.

### 3.5. Alarm Clock
Build a 24-hour clock with alarm functionality. Keep time using counters and indicate current time and alarm status on 7-segment displays.

### 3.6. Ultrasound HS-SR04
Measure distances using an ultrasonic sensor and display results on 7-segment displays. Trigger the sensor, measure echo duration, and calculate distance.

---

## 4. Help

* Use hierarchical design, ie. instances, top-level, several files, etc.

* LATCHes indicate errors. Always verify in the **Report after synthesis**.

* Use the TclConsole command `reset_project` before committing to Git.

* Be careful with external connections. Pmod voltage levels are 0--3.3 V!

* Always simulate new components before using them. Rough guideline: 20% of time writing the design, 80% writing testbenches, simulating, verifying.

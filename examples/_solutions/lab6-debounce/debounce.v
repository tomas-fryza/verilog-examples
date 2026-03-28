// -----------------------------------------------------------
//! @brief Button debouncer
//! @version 2.1
//! @copyright (c) 2023-2026 Tomas Fryza, MIT license
//!
//! This module implements a debouncer for mechanical push-buttons
//! using a sampling technique with a shift register. The circuit
//! provides a stable debounced output and generates a one-clock-cycle
//! pulse when a button press is detected.
//
// Notes:
// - Synchronous design (rising edge of clk)
// - High-active synchronous reset
// - Input synchronization using two flip-flops
// - Debouncing via shift register and sampling
// - Configurable debounce time via clock enable
// - One-clock pulse output for button press
// -----------------------------------------------------------

`timescale 1ns/1ps

module debounce (
    input  wire clk,
    input  wire rst,
    input  wire btn_in,      // Noisy button input

    output wire btn_state,   // Debounced level
    output wire btn_press    // 1-clock press pulse
    // output wire btn_release
);

    //------------------------------------------------------------
    // Constants (internal)
    //------------------------------------------------------------
    localparam C_SHIFT_LEN = 4;
    localparam C_MAX       = 2;  // Sampling period
                                 // 2 for simulation
                                 // 200_000 (2 ms) for implementation !!!

    //------------------------------------------------------------
    // Internal signals
    //------------------------------------------------------------
    wire ce_sample;

    reg sync0, sync1;
    reg [C_SHIFT_LEN-1:0] shift_reg;
    reg debounced;
    reg delayed;

    //------------------------------------------------------------
    // Clock enable instance
    //------------------------------------------------------------
    clk_en #(
        .MAX (C_MAX)
    ) clock_inst (
        .i_clk (clk),
        .i_rst (rst),
        .o_ce  (ce_sample)
    );

    //------------------------------------------------------------
    // Debounce logic
    //------------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            sync0     <= 0;
            sync1     <= 0;
            shift_reg <= 0;
            debounced <= 0;
            delayed   <= 0;
        end else begin
            // Synchronizer
            sync0 <= btn_in;
            sync1 <= sync0;

            // Sampling
            if (ce_sample) begin
                shift_reg <= {shift_reg[C_SHIFT_LEN-2:0], sync1};

                if (&shift_reg)
                    debounced <= 1;
                else if (~|shift_reg)
                    debounced <= 0;
            end

            // Delay for edge detection
            delayed <= debounced;
        end
    end

    //------------------------------------------------------------
    // Outputs
    //------------------------------------------------------------
    assign btn_state = debounced;
    assign btn_press = debounced & ~delayed;

    // assign btn_release = ~debounced & delayed;

endmodule

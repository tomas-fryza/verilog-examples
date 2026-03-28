// -----------------------------------------------------------
//! @brief UART transmitter (8N1, FSM-based)
//! @version 1.3
//! @copyright (c) 2025-2026 Tomas Fryza, MIT license
//!
//! This module implements a UART (Universal Asynchronous Receiver/
//! Transmitter) transmitter using a Finite State Machine (FSM).
//! The design operates in standard 8N1 mode (8 data bits, no
//! parity, 1 stop bit) and transmits data asynchronously with
//! a configurable baud rate.
//
// Notes:
// - Synchronous design (rising edge of clk)
// - High-active synchronous reset
// - Baud rate generated using clock counter
//
// See also:
//   https://nandland.com/uart-serial-port-module/
// -----------------------------------------------------------

`timescale 1ns/1ps

module uart_tx (
    input  wire clk,            //! System clock
    input  wire rst,            //! Active-high reset
    input  wire tx_start,       //! Start transmission
    input  wire [7:0] tx_data,  //! Data to transmit
    output reg  tx,             //! UART Tx line
    output reg  tx_busy         //! Transmission in progress
);

    //-------------------------------------------------
    // FSM states
    //-------------------------------------------------
    localparam IDLE               = 2'd0;
    localparam TRANSMIT_START_BIT = 2'd1;
    localparam TRANSMIT_DATA      = 2'd2;
    localparam TRANSMIT_STOP_BIT  = 2'd3;

    reg [1:0] current_state = IDLE;

    //-------------------------------------------------
    // Internal constants
    //-------------------------------------------------
    localparam CLK_FREQ = 100_000_000;  // 100 MHz
    localparam BAUDRATE = 9600;
    localparam MAX = 2;  // 2 for simulation
                                 // CLK_FREQ / BAUDRATE for implementation

    //-------------------------------------------------
    // Internal registers
    //-------------------------------------------------
    localparam CNT_WIDTH = $clog2(MAX);
    reg [CNT_WIDTH-1:0] baud_count;
    reg [7:0] shift_reg;
    reg [2:0] current_bit_index;

    //-------------------------------------------------
    // FSM
    //-------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            current_state     <= IDLE;
            tx                <= 1'b1;
            tx_busy           <= 1'b0;
            shift_reg         <= 8'd0;
            current_bit_index <= 3'd0;
            baud_count        <= 0;

        end else begin

            case (current_state)

                //-------------------------------------------------
                // IDLE
                //-------------------------------------------------
                IDLE: begin
                    tx      <= 1'b1;
                    tx_busy <= 1'b0;

                    if (tx_start) begin
                        shift_reg          <= tx_data;
                        current_bit_index  <= 3'd0;
                        baud_count         <= 0;
                        current_state      <= TRANSMIT_START_BIT;
                    end
                end

                //-------------------------------------------------
                // START BIT
                //-------------------------------------------------
                TRANSMIT_START_BIT: begin
                    tx      <= 1'b0;
                    tx_busy <= 1'b1;

                    if (baud_count == (MAX - 1)) begin
                        baud_count    <= 0;
                        current_state <= TRANSMIT_DATA;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end

                //-------------------------------------------------
                // DATA BITS
                //-------------------------------------------------
                TRANSMIT_DATA: begin
                    tx      <= shift_reg[0];
                    tx_busy <= 1'b1;

                    if (baud_count == (MAX - 1)) begin
                        // shift_reg <= {1'b0, shift_reg[7:1]};
                        shift_reg <= shift_reg >> 1;

                        if (current_bit_index == 3'd7) begin
                            current_state <= TRANSMIT_STOP_BIT;
                        end else begin
                            current_bit_index <= current_bit_index + 1;
                        end

                        baud_count <= 0;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end

                //-------------------------------------------------
                // STOP BIT
                //-------------------------------------------------
                TRANSMIT_STOP_BIT: begin
                    tx      <= 1'b1;
                    tx_busy <= 1'b1;

                    if (baud_count == (MAX - 1)) begin
                        current_state <= IDLE;
                        baud_count    <= 0;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end

                //-------------------------------------------------
                default: begin
                    current_state <= IDLE;
                end

            endcase
        end
    end

endmodule

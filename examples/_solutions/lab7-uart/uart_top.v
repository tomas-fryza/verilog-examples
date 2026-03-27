// Use Serial monitor, such as:
// https://hhdsoftware.com/online-serial-port-monitor

`timescale 1ns / 1ps

module uart_top (
    input  wire clk,
    input  wire btnu,
    input  wire [7:0] sw,
    input  wire btnd,
    output wire uart_txd,
    output wire led17_g
  );

  //-------------------------------------------------
  // Debounce instance
  //-------------------------------------------------
  wire sig_tx_en;
  debounce debounce_inst (
             .clk      (clk),
             .rst      (btnu),
             .btn_in   (btnd),
             .btn_state(),  // Unconnected output; will be high impedance (Z)
             .btn_press(sig_tx_en)
           );

  //-------------------------------------------------
  // UART TX instance
  //-------------------------------------------------
  uart_tx uart_tx_inst (
            .clk         (clk),
            .rst         (btnu),
            .data        (sw),
            .tx_start    (sig_tx_en),
            .tx          (uart_txd),
            .tx_complete (led17_g)
          );

endmodule

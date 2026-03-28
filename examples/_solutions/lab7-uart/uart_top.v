// Use Serial monitor, such as:
// https://hhdsoftware.com/online-serial-port-monitor

`timescale 1ns / 1ps

module uart_top (
    input  wire clk,
    input  wire btnu,
    input  wire btnd,
    input  wire [7:0] sw,
    output wire tx,
    output wire led17_g
  );

  //-------------------------------------------------
  // Debounce instance
  //-------------------------------------------------
  wire tx_en;
  debounce debounce_inst (
             .clk      (clk),
             .rst      (btnu),
             .btn_in   (btnd),
             .btn_state(),  // Unconnected output; will be high impedance (Z)
             .btn_press(tx_en)
           );

  //-------------------------------------------------
  // UART TX instance
  //-------------------------------------------------
  uart_tx uart_tx_inst (
            .clk     (clk),
            .rst     (btnu),
            .tx_start(tx_en),
            .tx_data (sw),
            .tx      (tx),
            .tx_busy (led17_g)
          );

endmodule

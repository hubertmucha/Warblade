// File: keypad_main.v
// Author: NP
// Main module for keypad matrix 4x4.

`timescale 1 ns / 1 ps

module keypad_main(
  input wire clk,
  input wire [2:0] columns,
  input wire rst,

  output wire [3:0] rows,
  output wire [7:0] sseg_ca,
  output wire [3:0] sseg_an,
  output wire [7:0] key_press
);

  wire pclk;
  clk_div_fs my_clk_div_fs(
    .clk(clk),
    .clk_out(pclk)
  );

  wire [7:0] pressed_key;
  wire [3:0] rows_o;
  keypad_4x4_sm my_keypad(
    .pclk(pclk),
    .rst(rst),
    .columns(columns),
    .pressed_key(pressed_key),
    .rows(rows_o)
  );

  wire [7:0] sseg_ca_o;
  wire [3:0] sseg_an_o;

  key_sseg my_key_sseg(
    .pclk(pclk),
    .rst(rst),
    .key(pressed_key),
    .sseg_ca(sseg_ca_o),
    .sseg_an(sseg_an_o)
  );

  assign rows = rows_o;
  assign sseg_ca = sseg_ca_o;
  assign sseg_an = sseg_an_o;
  assign key_press = pressed_key;

endmodule
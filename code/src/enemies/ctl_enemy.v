// File: draw_rect_ctl.v
// This module draw a rectangle shot the ckround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

// TODO ADD sycn-reset

module ctl_enemy
    #( parameter
        N = 1 // number of enemy
    )(
    input wire pclk,
    input wire rst,

    input wire [10:0] x_in,
    input wire [10:0] y_in,

    output reg [10:0] x_out,
    output reg [10:0] y_out
);

    always @(posedge pclk) begin
        x_out <= x_in + (N*70);
        y_out <= x_in + 100; // cahnge to y from main generator
    end
endmodule

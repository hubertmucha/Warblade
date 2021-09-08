// File: ctl_enemy.v
// Author: Hubert Mucha
// This module generate x and y for one enemy.

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
        x_out <= x_in + (N*100);
        y_out <= y_in; 
    end
endmodule

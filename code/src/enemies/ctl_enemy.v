// File: ctl_enemy.v
// Author: HM
// This module generate x and y for one enemy.

`timescale 1 ns / 1 ps

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
        if(rst) begin
          x_out <= 11'b0;
          y_out <= 11'b0;
        end
        else begin
          x_out <= x_in + (N*100);
          y_out <= y_in; 
        end
    end
endmodule

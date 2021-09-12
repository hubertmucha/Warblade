// File: key_control.v
// Author: NPL
// This module is translates pressed keypads to controls inputs.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module key_control
#(
  parameter LEFT_KEY   = 8'b00000111,               // 7 key
  parameter RIGHT_KEY  = 8'b00001000,               // 8 key
  parameter SHOOT_KEY  = 8'b00000011                // 3 key
)
(
  input wire pclk,
  input wire rst,
  input wire [7:0] pressed_key,
  output reg left,
  output reg right,
  output reg shoot
);

  reg left_nxt, right_nxt, shoot_nxt;

  always @(posedge pclk) begin
    if(rst) begin
      left <= 1'b0;
      right <= 1'b0;
      shoot <= 1'b0;
    end
    else begin
      left <= left_nxt;
      right <= right_nxt;
      shoot <= shoot_nxt;
    end
  end

  always @* begin
    case(pressed_key)
      LEFT_KEY: begin
        left_nxt = 1'b1;
        right_nxt = 1'b0;
        shoot_nxt = 1'b0;
      end
      RIGHT_KEY: begin
        left_nxt = 1'b0;
        right_nxt = 1'b1;
        shoot_nxt = 1'b0;
      end
      SHOOT_KEY: begin
        left_nxt = 1'b0;
        right_nxt = 1'b0;
        shoot_nxt = 1'b1;
      end
      default: begin
        left_nxt = 1'b0;
        right_nxt = 1'b0;
        shoot_nxt = 1'b0;
      end
    endcase
  end
endmodule

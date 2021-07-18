// File: draw_rect_ctl_tb.v
// This module generate the backround for vga

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_ctl_tb (
  input wire pclk,
  input wire rst, 

  output reg mouse_left,
  output reg [11:0] mouse_xpos,
  output reg [11:0] mouse_ypos
  );

  reg mouse_left_nxt;
  reg [11:0] mouse_xpos_nxt = 0, mouse_ypos_nxt = 0;
  reg [40:0] counter = 0, counter_nxt = 0;

  always @(posedge pclk) begin
      if (rst) begin
        mouse_left_nxt <= 0;
        mouse_xpos_nxt <= 0;
        mouse_ypos_nxt <= 0;
        counter <= 0;
      end
      else begin
        mouse_left  <= mouse_left_nxt;
        mouse_xpos  <= mouse_xpos_nxt;
        mouse_ypos  <= mouse_ypos_nxt;
        counter     <= counter_nxt; 
      end
    end

  always @* begin
      if(counter == 0) begin
        mouse_left_nxt = 0;                           // left up 
        mouse_xpos_nxt = 0;                           // set at (0, 0) position
        mouse_ypos_nxt = 0;                           // reset values to default
      end
      if(counter < 500) begin
        mouse_xpos_nxt = mouse_xpos + 1;              // increasing x_pos
      end
      if(counter == 500) begin
        mouse_left_nxt = 1;                           // left down 
      end
      else begin
        mouse_left_nxt = mouse_left;
      end
      counter_nxt = counter + 1;  
  end

endmodule

    
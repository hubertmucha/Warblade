// File: draw_enemy.v
// Author: Hubert Mucha
// This module is drawing enemy

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

 module draw_enemy(
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire [10:0] xpos,
    input wire [10:0] ypos,
    input wire on,

    input wire [10:0] vcount_in,                      // input vertical count
    input wire vsync_in,                              // input vertical sync
    input wire vblnk_in,                              // input vertical blink
    input wire [10:0] hcount_in,                      // input horizontal count
    input wire hsync_in,                              // input horizontal sync
    input wire hblnk_in,                              // input horizontal blink
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel,

    output reg [10:0] vcount_out,                     // output vertical count
    output reg vsync_out,                             // output vertical sync
    output reg vblnk_out,                             // output vertical blink
    output reg [10:0] hcount_out,                     // output horizontal count
    output reg hsync_out,                             // output horizontal sync
    output reg hblnk_out,                             // output horizontal blink
    output reg [11:0] rgb_out
  );

  reg [11:0] rgb_out_nxt = 12'b0;
  reg [11:0] pixel_addr_nxt = 12'b0;
  reg [5:0] x_addr, y_addr, x_addr_nxt, y_addr_nxt;


  localparam WIDTH_RECT   = 50;                     
  localparam HEIGHT_RECT  = 50;
  localparam [11:0] RGB_RECT    = 12'h8_f_8;


  // This is a simple rectangle pattern generator.
  always @(posedge pclk) begin
    if(rst) begin
      hsync_out  <= 1'b0;
      vsync_out  <= 1'b0;
      hblnk_out  <= 1'b0;
      vblnk_out  <= 1'b0;

      hcount_out <= 11'b0;
      vcount_out <= 11'b0;

      rgb_out    <= 12'h0_0_0;
    end
    else begin
      // Just pass these through.
      hsync_out <= hsync_in;
      vsync_out <= vsync_in;

      hblnk_out <= hblnk_in;
      vblnk_out <= vblnk_in;

      hcount_out <= hcount_in;
      vcount_out <= vcount_in;

      rgb_out    <= rgb_out_nxt;
      
      x_addr <= x_addr_nxt;
      y_addr <= y_addr_nxt;
    end
  end
  // rectangle generator
  always @* begin
    if (vblnk_in || hblnk_in) begin
          rgb_out_nxt = 12'h0_0_0;
    end
    else begin
      if (hcount_in >= xpos && hcount_in <= xpos + WIDTH_RECT && vcount_in >= ypos && vcount_in <= ypos + HEIGHT_RECT && on) 
        rgb_out_nxt = RGB_RECT; 
      else 
        rgb_out_nxt = rgb_in;  
    end
      y_addr_nxt = vcount_in[5:0] - ypos[5:0];
      x_addr_nxt = hcount_in[5:0] - xpos[5:0];
  end
endmodule

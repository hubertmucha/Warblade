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
    output reg [11:0] rgb_out,
    output reg [11:0] pixel_addr
  );

  reg [11:0] rgb_out_nxt = 12'b0;
  reg [11:0] pixel_addr_nxt = 12'b0;
  reg [5:0] x_addr, y_addr, x_addr_nxt, y_addr_nxt;


  localparam WIDTH_RECT   = 64;                     
  localparam HEIGHT_RECT  = 64;
  localparam [11:0] RGB_RECT    = 12'h8_f_8;
  localparam [11:0] TRANSPARENT_COLOR = 12'hf_f_f;

  // This module delays signals by one clk
  wire [10:0] vcount_out_1, hcount_out_1; 
  wire vsync_out_1, hsync_out_1;
  wire vblnk_out_1, hblnk_out_1;
  wire [11:0] rgb_out_1;

  dff_image my_dff_image_1
  (
    .pclk(pclk),
    .rst(rst),

    .vcount_in(vcount_in),
    .vsync_in(vsync_in),
    .vblnk_in(vblnk_in),
    .hcount_in(hcount_in),
    .hsync_in(hsync_in),
    .hblnk_in(hblnk_in),
    .rgb_in(rgb_in),

    .vcount_out(vcount_out_1),
    .vsync_out(vsync_out_1),
    .vblnk_out(vblnk_out_1),
    .hcount_out(hcount_out_1),
    .hsync_out(hsync_out_1),
    .hblnk_out(hblnk_out_1),
    .rgb_out(rgb_out_1)
  );

  // This module delays signals by one clk
  wire [10:0] vcount_out_2, hcount_out_2; 
  wire vsync_out_2, hsync_out_2;
  wire vblnk_out_2, hblnk_out_2;
  wire [11:0] rgb_out_2;

  dff_image my_dff_image_2
  (
    .pclk(pclk),
    .rst(rst),

    .vcount_in(vcount_out_1),
    .vsync_in(vsync_out_1),
    .vblnk_in(vblnk_out_1),
    .hcount_in(hcount_out_1),
    .hsync_in(hsync_out_1),
    .hblnk_in(hblnk_out_1),
    .rgb_in(rgb_out_1),

    .vcount_out(vcount_out_2),
    .vsync_out(vsync_out_2),
    .vblnk_out(vblnk_out_2),
    .hcount_out(hcount_out_2),
    .hsync_out(hsync_out_2),
    .hblnk_out(hblnk_out_2),
    .rgb_out(rgb_out_2)
  );


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
      pixel_addr <= 12'b0;
    end
    else begin
      // Just pass these through.
      hsync_out <= hsync_out_2;
      vsync_out <= vsync_out_2;

      hblnk_out <= hblnk_out_2;
      vblnk_out <= vblnk_out_2;

      hcount_out <= hcount_out_2;
      vcount_out <= vcount_out_2;

      rgb_out    <= rgb_out_nxt;
      
      x_addr <= x_addr_nxt;
      y_addr <= y_addr_nxt;

      pixel_addr <= pixel_addr_nxt;
    end
  end
  // rectangle generator
  always @* begin
    if (vblnk_out_2|| hblnk_out_2) begin
          rgb_out_nxt = 12'h0_0_0;
    end
    else begin
      if (hcount_out_2 >= xpos && hcount_out_2 <= xpos + WIDTH_RECT && vcount_out_2 >= ypos && vcount_out_2 <= ypos + HEIGHT_RECT && on) begin 
          if (rgb_pixel != TRANSPARENT_COLOR) begin
            rgb_out_nxt = rgb_pixel;
            //rgb_out_nxt = 12'hf_0_0;
          end
          else begin
            rgb_out_nxt =  rgb_out_2; 
            //rgb_out_nxt =  12'h0_f_0; 
          end
      end
      else begin
            rgb_out_nxt = rgb_out_2; 
      end 
    end
      y_addr_nxt = vcount_in[5:0] - ypos[5:0];
      x_addr_nxt = hcount_in[5:0] - xpos[5:0];
      pixel_addr_nxt = {y_addr[5:0], x_addr[5:0]};
  end
endmodule

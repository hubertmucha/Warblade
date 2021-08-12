// File: draw_react.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

 module draw_missile_en(
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire [11:0] xpos,
    input wire [11:0] ypos,
    input wire on,

    input wire [10:0] vcount_in,                      // input vertical count
    input wire vsync_in,                              // input vertical sync
    input wire vblnk_in,                              // input vertical blink
    input wire [10:0] hcount_in,                      // input horizontal count
    input wire hsync_in,                              // input horizontal sync
    input wire hblnk_in,                              // input horizontal blink
    input wire [11:0] rgb_in,

    output reg [10:0] vcount_out,                     // output vertical count
    output reg vsync_out,                             // output vertical sync
    output reg vblnk_out,                             // output vertical blink
    output reg [10:0] hcount_out,                     // output horizontal count
    output reg hsync_out,                             // output horizontal sync
    output reg hblnk_out,                             // output horizontal blink
    output reg [11:0] rgb_out

  );

  localparam X = 30;
  localparam WIDTH_RECT   = 5;           
  localparam HEIGHT_RECT  = 20;
  localparam COLOR        = 12'hf_4_4;

  // (47/2) - (5/2) = 23,5 - 2,5 = 21 px
  localparam X_MISSILE_OFFSET = 21; //half of ship widht minus widt of half of missile widht

  reg [11:0] vcount_nxt, hcount_nxt; 
  reg vsync_nxt, hsync_nxt;
  reg vblnk_nxt, hblnk_nxt;
  reg [11:0] rgb_nxt;

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
      hsync_out <= hsync_nxt;
      vsync_out <= vsync_nxt;

      hblnk_out <= hblnk_nxt;
      vblnk_out <= vblnk_nxt;

      hcount_out <= hcount_nxt;
      vcount_out <= vcount_nxt;

      rgb_out <= rgb_nxt;
    end
  end
  // rectangle generator
  always @* begin

    hsync_nxt  = hsync_in;
    vsync_nxt  = vsync_in;
    hblnk_nxt  = hblnk_in;
    vblnk_nxt  = vblnk_in;
    hcount_nxt = hcount_in;
    vcount_nxt = vcount_in;

    if (vblnk_in || hblnk_in) begin
          rgb_nxt = 12'h0_0_0;
    end
    else begin
      if (hcount_in >= xpos + X_MISSILE_OFFSET && hcount_in <= xpos + WIDTH_RECT + X_MISSILE_OFFSET && vcount_in >= ypos && vcount_in <= ypos + HEIGHT_RECT && on) 
        rgb_nxt = COLOR; 
      else 
        rgb_nxt = rgb_in;  
    end
  end
endmodule

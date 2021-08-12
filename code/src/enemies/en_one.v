// File: draw_react.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

 module en_one
    #( parameter
        N   = 1 // number of enemy
    )
    (
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire [10:0] vcount_in,                      // input vertical count
    input wire vsync_in,                              // input vertic al sync
    input wire vblnk_in,                              // input vertical blink
    input wire [10:0] hcount_in,                      // input horizontal count
    input wire hsync_in,                              // input horizontal sync
    input wire hblnk_in,                              // input horizontal blink
    input wire [11:0] rgb_in,

    input wire [10:0] xpos_missile,
    input wire [10:0] ypos_missile,
    input wire on_missle,

    output wire [10:0] vcount_out,                     // output vertical count
    output wire vsync_out,                             // output vertical sync
    output wire vblnk_out,                             // output vertical blink
    output wire [10:0] hcount_out,                     // output horizontal count
    output wire hsync_out,                             // output horizontal sync
    output wire hblnk_out,                             // output horizontal blink
    output wire [11:0] rgb_out
  );

  wire [10:0] vcount_o, hcount_o;
  wire vsync_o, hsync_o;
  wire vblnk_o, hblnk_o;
  wire [11:0] rgb_o;


    wire [10:0] xpos, ypos;
    wire shoot;
    wire on;

    ctl_enemy #(.N(N)) ctl_en(
    .pclk(pclk),
    .rst(rst),

    .xpos_out(xpos),
    .ypos_out(ypos),
    .shot(shoot) // to the clt_shooting module in the future
    );

    detec_col #(.N(1)) detec_colision(
    .pclk(pclk),
    .rst(rst),

    .xpos_missile(xpos_missile),
    .ypos_missile(ypos_missile),
    .on_missile(on_missle),

    .xpos_enemy(xpos),
    .ypos_enemy(ypos),
    .on_out(on)
    );

    draw_enemy draw_en(
    .pclk(pclk),
    .rst(rst),

    .xpos(xpos),
    .ypos(ypos),
    .on(on),

    //input
    .vcount_in(vcount_in),
    .vsync_in(vsync_in),
    .vblnk_in(vblnk_in),
    .hcount_in(hcount_in),
    .hsync_in(hsync_in),
    .hblnk_in(hblnk_in),
    .rgb_in(rgb_in),

    //output
    .vcount_out(vcount_o),
    .vsync_out(vsync_o),
    .vblnk_out(vblnk_o),
    .hcount_out(hcount_o),
    .hsync_out(hsync_o),
    .hblnk_out(hblnk_o),
    .rgb_out(rgb_o)
  );

  assign vcount_out = vcount_o;
  assign vsync_out  = vsync_o;
  assign vblnk_out  = vblnk_o;
  assign hcount_out = hcount_o;
  assign hsync_out  = hsync_o;
  assign hblnk_out  = hblnk_o;
  assign rgb_out    = rgb_o;
endmodule

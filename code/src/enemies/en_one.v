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

    input wire [3:0] level,

    output wire [10:0] en_x_missile,
    output wire [10:0] en_y_missile,

    output wire [10:0] vcount_out,                     // output vertical count
    output wire vsync_out,                             // output vertical sync
    output wire vblnk_out,                             // output vertical blink
    output wire [10:0] hcount_out,                     // output horizontal count
    output wire hsync_out,                             // output horizontal sync
    output wire hblnk_out,                             // output horizontal blink
    output wire [11:0] rgb_out,
    output wire lives
  );

  wire [10:0] vcount_o, hcount_o;
  wire vsync_o, hsync_o;
  wire vblnk_o, hblnk_o;
  wire [11:0] rgb_o;


    wire [10:0] xpos, ypos;
    wire shoot;
    wire on;

    wire [11:0] a;

    addres_gen gen(
    .pclk(pclk),
    .rst(rst),
    .level(4'd1),
    .addr(a)

    );

    ctl_enemy #(.N(N)) ctl_en(
    .pclk(pclk),
    .rst(rst),
    .addr(a),

    .x_out(xpos),
    .y_out(ypos)
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

    //from draw enemy to draw enemy missile
    wire [10:0] vcount_1, hcount_1;
    wire vsync_1, hsync_1;
    wire vblnk_1, hblnk_1;
    wire [11:0] rgb_1;

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
    .vcount_out(vcount_1),
    .vsync_out(vsync_1),
    .vblnk_out(vblnk_1),
    .hcount_out(hcount_1),
    .hsync_out(hsync_1),
    .hblnk_out(hblnk_1),
    .rgb_out(rgb_1)
  );

  wire [11:0] ypos_ctl_missle, xpos_ctl_missle;
  wire on_ctl_missle;

  ctl_missile_en missle_ctl(
    .pclk(pclk),
    .rst(rst),
    .missle_button(1),
    .xpos_in(xpos),
    .ypos_in(ypos),
    .enemy_lives(on),

    .ypos_out(ypos_ctl_missle),
    .xpos_out(xpos_ctl_missle),
    .on_out(on_ctl_missle)
  );


  draw_missile_en draw_enemy_missile(
    .pclk(pclk),
    .rst(rst),

    .xpos(xpos_ctl_missle),
    .ypos(ypos_ctl_missle),
    .on(on_ctl_missle),

    //input
    .vcount_in(vcount_1),
    .vsync_in(vsync_1),
    .vblnk_in(vblnk_1),
    .hcount_in(hcount_1),
    .hsync_in(hsync_1),
    .hblnk_in(hblnk_1),
    .rgb_in(rgb_1),

    //output
    .vcount_out(vcount_o),  //all is module outputs
    .vsync_out(vsync_o),  //all is module outputs
    .vblnk_out(vblnk_o),  //all is module outputs
    .hcount_out(hcount_o),  //all is module outputs
    .hsync_out(hsync_o),  //all is module outputs
    .hblnk_out(hblnk_o),  //all is module outputs
    .rgb_out(rgb_o)  //all is module outputs
  );


  assign vcount_out = vcount_o;
  assign vsync_out  = vsync_o;
  assign vblnk_out  = vblnk_o;
  assign hcount_out = hcount_o;
  assign hsync_out  = hsync_o;
  assign hblnk_out  = hblnk_o;
  assign rgb_out    = rgb_o;
  assign lives      = on;
  assign en_x_missile = xpos_ctl_missle;
  assign en_y_missile = ypos_ctl_missle;
endmodule

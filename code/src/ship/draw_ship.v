`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

 module draw_ship(
    input wire pclk,
    input wire rst,                                 

    input wire left,
    input wire right,

    input wire missile_button,

    input wire hblnk_in,
    input wire [10:0] hcount_in,   
    input wire hsync_in,

    input wire [10:0] vcount_in,                    
    input wire vsync_in,                            
    input wire vblnk_in,
    
    input wire [11:0] rgb_in,

    // enemies missiles
    input wire [10:0] en_x_missile1,
    input wire [10:0] en_y_missile1,                           
    input wire [10:0] en_x_missile2,
    input wire [10:0] en_y_missile2,                           
    input wire [10:0] en_x_missile3,
    input wire [10:0] en_y_missile3,                           

    output wire [10:0] vcount_out,                     
    output wire vsync_out,                          
    output wire vblnk_out,                             
    output wire [10:0] hcount_out,                     
    output wire hsync_out,                            
    output wire hblnk_out,                             
    output wire [11:0] rgb_out,

    // output wire [10:0] xpos_ship,
    output wire [10:0] xpos_missile,
    output wire [10:0] ypos_missile,
    output wire on_missle
  );


  wire [10:0] xpos_ctl;
  position_rect_ctl my_position_rect_ctl(
    //inputs
    .pclk(pclk),
    .rst(rst),
    .left(left),
    .right(right),
    //outputs
    .xpos_out(xpos_ctl)
  );

  wire is_ship_dead;
  detect_collision my_detect_collision(
    // inputs 
    .pclk(pclk),
    .rst(rst),
    .ship_X(xpos_ctl),
    .enBullet_X_1(en_x_missile1),
    .enBullet_Y_1(en_y_missile1),
    .enBullet_X_2(en_x_missile2),
    .enBullet_Y_2(en_y_missile2),
    .enBullet_X_3(en_x_missile3),
    .enBullet_Y_3(en_y_missile3),
    //output
    .is_ship_dead(is_ship_dead)
  );

  wire ship_dead_locked;
  locked_signal my_locked_signal(
    .pclk(pclk),
    .rst(rst),
    .locked(is_ship_dead),
    .unlocked(),
    .locked_out(ship_dead_locked)
  );

  // Instantiate the draw_react module, which is
  // the module you are designing for this lab.
  wire [10:0] vcount_r, hcount_r;
  wire vsync_r, hsync_r;
  wire vblnk_r, hblnk_r;
  wire [11:0] rgb_r;
  wire [11:0] rgb_pixel, pixel_addr;
  wire [10:0] vcount_rm, hcount_rm;
  wire vsync_rm, hsync_rm;
  wire vblnk_rm, hblnk_rm;
  wire [11:0] rgb_rm;



  draw_react my_draw_react(
    .pclk(pclk),
    .rst(rst),

    // input x, y position of the rect from position_rect_ctl module
    .xpos(xpos_ctl),
    // .ypos(680),
    .dead_ship(ship_dead_locked),

    //input
    .vcount_in(vcount_in),
    .vsync_in(vsync_in),
    .vblnk_in(vblnk_in),
    .hcount_in(hcount_in),
    .hsync_in(hsync_in),
    .hblnk_in(hblnk_in),
    .rgb_in(rgb_in),
    .rgb_pixel(rgb_pixel),

    //output
    .vcount_out(vcount_rm),
    .vsync_out(vsync_rm),
    .vblnk_out(vblnk_rm),
    .hcount_out(hcount_rm),
    .hsync_out(hsync_rm),
    .hblnk_out(hblnk_rm),
    .rgb_out(rgb_rm),
    .pixel_addr(pixel_addr)
  );

  image_rom my_image_rom(
    .clk(pclk),
    .address(pixel_addr),
    .rgb(rgb_pixel)
  );

  wire [10:0] ypos_ctl_missle, xpos_ctl_missle;
  wire on_ctl_missle;

  missle_ctl my_missle_ctl(
    .pclk(pclk),
    .rst(rst),
    .missle_button(missile_button),
    .xpos_in(xpos_ctl),
    .ship_dead(ship_dead_locked),

    .ypos_out(ypos_ctl_missle),
    .xpos_out(xpos_ctl_missle),
    .on_out(on_ctl_missle)
  );


  wire [10:0] vcount_o, hcount_o;
  wire vsync_o, hsync_o;
  wire vblnk_o, hblnk_o;
  wire [11:0] rgb_o;

  draw_missile my_draw_missile(
    .pclk(pclk),
    .rst(rst),

    .xpos(xpos_ctl_missle),
    .ypos(ypos_ctl_missle),
    .on(on_ctl_missle),

    //input
    .vcount_in(vcount_rm),
    .vsync_in(vsync_rm),
    .vblnk_in(vblnk_rm),
    .hcount_in(hcount_rm),
    .hsync_in(hsync_rm),
    .hblnk_in(hblnk_rm),
    .rgb_in(rgb_rm),

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
  // assign xpos_ship  = xpos_ctl;
  assign xpos_missile = xpos_ctl_missle;
  assign ypos_missile = ypos_ctl_missle;
  assign on_missle   = on_ctl_missle;

  endmodule
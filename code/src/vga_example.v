// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  input wire clk,
  input wire rst,                         // U17 button - reset <-- look to vga_example.xdc
  input wire right,                       // T17 button
  input wire left,                        // W19 button
  input wire missle_button,               // T18 button 
  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  output wire pclk_mirror,

  inout wire ps2_clk,
  inout wire ps2_data
  );
   
  wire pclk;
  wire locked;
  
  clk_wiz_0 my_clk_wiz_0(
      .clk(clk),
      .clk65Mhz(pclk),
      .clk100Mhz(),
      .locked(locked),
      .reset(rst)
  );

  // Mirrors pclk on a pin for use by the testbench;
  // not functionally required for this design to work.

  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );

  // lock_reset 
  wire rst_out;

  lock_reset my_lock_reset(
    .lowest_freq_clk(pclk),
    .locked(locked),
    .rst_out(rst_out)
  );
  
  // Instantiate the vga_timing module, which is
  // the module you are designing for this lab.

  wire [10:0] vcount, hcount;
  wire vsync, hsync;
  wire vblnk, hblnk;

  vga_timing my_timing (
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),

    .pclk(pclk),
    .rst(rst_out)
  );

  // Instantiate the draw_background module, which is
  // the module you are designing for this lab.

  wire [10:0] vcount_b, hcount_b;
  wire vsync_b, hsync_b;
  wire vblnk_b, hblnk_b;
  wire [11:0] rgb_b;

  draw_background my_draw_background(
    .pclk(pclk),
    .rst(rst_out),

    //input
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),

    //output
    .vcount_out(vcount_b),
    .vsync_out(vsync_b),
    .vblnk_out(vblnk_b),
    .hcount_out(hcount_b),
    .hsync_out(hsync_b),
    .hblnk_out(hblnk_b),
    .rgb_out(rgb_b)
  );
  
  // dff delay controls signals
  wire left_d, right_d;
  delay #(.WIDTH(2), .CLK_DEL(2)) my_delay_controls(
    .clk(pclk),
    .rst(rst_out),
    .din({left, right}),
    .dout({left_d, right_d})
  );


  wire [11:0] xpos_ctl;
  position_rect_ctl my_position_rect_ctl(
    //inputs
    .pclk(pclk),
    .rst(rst_out),
    .left(left_d),
    .right(right_d),
    //outputs
    .xpos_out(xpos_ctl)
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
    .rst(rst_out),

    // input x, y position of the rect from position_rect_ctl module
    .xpos(xpos_ctl),
    // .ypos(680),

    //input
    .vcount_in(vcount_b),
    .vsync_in(vsync_b),
    .vblnk_in(vblnk_b),
    .hcount_in(hcount_b),
    .hsync_in(hsync_b),
    .hblnk_in(hblnk_b),
    .rgb_in(rgb_b),
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

  // Instantiate the image_rom module, which is
  // the module you are using for this lab.

  image_rom my_image_rom(
    .clk(pclk),
    .address(pixel_addr),
    .rgb(rgb_pixel)
  );

  wire [11:0] ypos_ctl_missle, xpos_ctl_missle;
  wire on_missle;
  missle_ctl my_missle_ctl(
    .pclk(pclk),
    .rst(rst_out),
    .missle_button(missle_button),
    .xpos_in(xpos_ctl),

    .ypos_out(ypos_ctl_missle),
    .xpos_out(xpos_ctl_missle),
    .on_out(on_missle)
  );

  draw_missile my_draw_missile(
    .pclk(pclk),
    .rst(rst_out),

    .xpos(xpos_ctl_missle),
    .ypos(ypos_ctl_missle),
    .on(on_missle),

    //input
    .vcount_in(vcount_rm),
    .vsync_in(vsync_rm),
    .vblnk_in(vblnk_rm),
    .hcount_in(hcount_rm),
    .hsync_in(hsync_rm),
    .hblnk_in(hblnk_rm),
    .rgb_in(rgb_rm),

    //output
    .vcount_out(vcount_r),
    .vsync_out(vsync_r),
    .vblnk_out(vblnk_r),
    .hcount_out(hcount_r),
    .hsync_out(hsync_r),
    .hblnk_out(hblnk_r),
    .rgb_out(rgb_r)

  );

  // Instantiate the draw_rect_char module, which is
  // the module you are using for this lab.

  wire [10:0] vcount_ch, hcount_ch;
  wire [11:0] rgb_ch;
  wire vsync_ch, hsync_ch;
  wire vblnk_ch, hblnk_ch;
  wire [7:0] char_pixels;
  wire [7:0] char_xy;
  wire [3:0] char_line;

  draw_rect_char my_draw_rect_char(
    .rst(rst),
    .pclk(pclk),
    .rgb_in(rgb_r),
    .char_pixels(char_pixels),

    .hcount_in(hcount_r),
    .vcount_in(vcount_r),
    .hblnk_in(hblnk_r),
    .vblnk_in(vblnk_r),    
    .hsync_in(hsync_r),
    .vsync_in(vsync_r),
    
    .hcount_out(hcount_ch),
    .vcount_out(vcount_ch),
    .hblnk_out(hblnk_ch),
    .vblnk_out(vblnk_ch),
    .hsync_out(hsync_ch),
    .vsync_out(vsync_ch),

    .rgb_out(rgb_ch),
    .char_xy(char_xy),
    .char_line(char_line)
  );

  
  // Instantiate the char_rom_16x16 module, which is
  // the module you are using for this lab.

  wire [6:0] char_code; 

  char_rom_16x16 my_char_rom_16x16(
    .level(3),
    .char_xy(char_xy),
    .char_code(char_code)
  );

  // Instantiate the font_rom module, which is
  // the module you are using for this lab.

  font_rom my_font_rom(
    .clk(pclk),
    .addr({char_code, char_line}),
    .char_line_pixels(char_pixels)
  );

    // Just pass these through.
    assign hs = hsync_ch;
    assign vs = vsync_ch;
    assign r  = rgb_ch[11:8];
    assign g  = rgb_ch[7:4];
    assign b  = rgb_ch[3:0];
    
endmodule

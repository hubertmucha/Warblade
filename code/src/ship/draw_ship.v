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

    input wire [10:0] en_x_missile4,
    input wire [10:0] en_y_missile4,

    input wire [10:0] en_x_missile5,
    input wire [10:0] en_y_missile5,                           

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
    output wire on_missle,

    output wire ship_down
  );


  wire [10:0] xpos_ctl;
  wire is_ship_dead;
  position_rect_ctl my_position_rect_ctl(
    //inputs
    .pclk(pclk),
    .rst(rst),
    .left(left),
    .right(right),
    .dead_s(is_ship_dead),
    //outputs
    .xpos_out(xpos_ctl)
  );


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

    .enBullet_X_4(en_x_missile4),
    .enBullet_Y_4(en_y_missile4),

    .enBullet_X_5(en_x_missile5),
    .enBullet_Y_5(en_y_missile5),
    //output
    .is_ship_dead(is_ship_dead)
  );

  wire ship_dead_locked;
  locked_signal my_locked_signal(
    .pclk(pclk),
    .rst(rst),
    .locked(is_ship_dead),
    .unlocked(unlocked_dead),
    .locked_out(ship_dead_locked)
  );

  // Instantiate the draw_react module, which is
  // the module you are designing for this lab.
  wire [10:0] vcount_r, hcount_r;
  wire vsync_r, hsync_r;
  wire vblnk_r, hblnk_r;
  wire [11:0] rgb_r;
  wire [11:0] rgb_pixel;
  wire [13:0] pixel_addr;
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

	wire [3:0] dead_count;

  signal_counter my_dead_counter(
		.pclk(pclk),
		.rst(rst),
		.signal(is_ship_dead),

		.signal_counter(dead_count)
  );

	wire unlocked_dead;

	unlocked my_dead_unlocked(
		.pclk(pclk),
		.rst(rst),
		.signal_counter(dead_count),

		.unlocked_signal(unlocked_dead)
	);

  wire [10:0] vcount_dl_1, hcount_dl_1;
  wire vsync_dl_1, hsync_dl_1;
  wire vblnk_dl_1, hblnk_dl_1;
  wire [11:0] rgb_dl_1;
  wire [3:0] dead_count_dl_1;

  draw_live #(
    .N(1),
    .XPOS(30),
    .YPOS(50),
    .WIDTH_RECT(30),
    .HEIGHT_RECT(31),
    .RGB_RECT(12'hf_0_0)
  ) my_draw_live_1(
    .pclk(pclk),
    .rst(rst),
    .dead_count(dead_count),

    .vcount_in(vcount_o),
    .vsync_in(vsync_o),
    .vblnk_in(vblnk_o),
    .hcount_in(hcount_o),
    .hsync_in(hsync_o),
    .hblnk_in(hblnk_o),
    .rgb_in(rgb_o),
    .rgb_pixel(rgb_pixel_heart),

    .dead_count_out(dead_count_dl_1),
    .vcount_out(vcount_dl_1),
    .vsync_out(vsync_dl_1),
    .vblnk_out(vblnk_dl_1),
    .hcount_out(hcount_dl_1),
    .hsync_out(hsync_dl_1),
    .hblnk_out(hblnk_dl_1),
    .rgb_out(rgb_dl_1),
    .pixel_addr(pixel_addr_heart)
  );

  wire [11:0] pixel_addr_heart;
  wire [11:0] rgb_pixel_heart;
  heart_rom my_heart_rom(
    .clk(pclk),
    .address(pixel_addr_heart),
    .rgb(rgb_pixel_heart)
  );

  
  wire [10:0] vcount_dl_2, hcount_dl_2;
  wire vsync_dl_2, hsync_dl_2;
  wire vblnk_dl_2, hblnk_dl_2;
  wire [11:0] rgb_dl_2;
  wire [3:0] dead_count_dl_2;

  draw_live #(
    .N(2),
    .XPOS(30),
    .YPOS(100),
    .WIDTH_RECT(32),
    .HEIGHT_RECT(32),
    .RGB_RECT(12'hf_0_0)
  ) my_draw_live_2(
    .pclk(pclk),
    .rst(rst),
    .dead_count(dead_count_dl_1),

    .vcount_in(vcount_dl_1),
    .vsync_in(vsync_dl_1),
    .vblnk_in(vblnk_dl_1),
    .hcount_in(hcount_dl_1),
    .hsync_in(hsync_dl_1),
    .hblnk_in(hblnk_dl_1),
    .rgb_in(rgb_dl_1),
    .rgb_pixel(),

    .dead_count_out(dead_count_dl_2),
    .vcount_out(vcount_dl_2),
    .vsync_out(vsync_dl_2),
    .vblnk_out(vblnk_dl_2),
    .hcount_out(hcount_dl_2),
    .hsync_out(hsync_dl_2),
    .hblnk_out(hblnk_dl_2),
    .rgb_out(rgb_dl_2),
    .pixel_addr()
  );

  wire [10:0] vcount_dl_3, hcount_dl_3;
  wire vsync_dl_3, hsync_dl_3;
  wire vblnk_dl_3, hblnk_dl_3;
  wire [11:0] rgb_dl_3;
  wire [3:0] dead_count_dl_3;

  draw_live #(
    .N(3),
    .XPOS(30),
    .YPOS(150),
    .WIDTH_RECT(32),
    .HEIGHT_RECT(32),
    .RGB_RECT(12'hf_0_0)
  ) my_draw_live_3(
    .pclk(pclk),
    .rst(rst),
    .dead_count(dead_count_dl_2),

    .vcount_in(vcount_dl_2),
    .vsync_in(vsync_dl_2),
    .vblnk_in(vblnk_dl_2),
    .hcount_in(hcount_dl_2),
    .hsync_in(hsync_dl_2),
    .hblnk_in(hblnk_dl_2),
    .rgb_in(rgb_dl_2),
    .rgb_pixel(),

    .dead_count_out(dead_count_dl_3),
    .vcount_out(vcount_dl_3),
    .vsync_out(vsync_dl_3),
    .vblnk_out(vblnk_dl_3),
    .hcount_out(hcount_dl_3),
    .hsync_out(hsync_dl_3),
    .hblnk_out(hblnk_dl_3),
    .rgb_out(rgb_dl_3),
    .pixel_addr()
  );

  assign vcount_out = vcount_dl_3;
  assign vsync_out  = vsync_dl_3;
  assign vblnk_out  = vblnk_dl_3;
  assign hcount_out = hcount_dl_3;
  assign hsync_out  = hsync_dl_3;
  assign hblnk_out  = hblnk_dl_3;
  assign rgb_out    = rgb_dl_3;

  // assign xpos_ship  = xpos_ctl;
  assign xpos_missile = xpos_ctl_missle;
  assign ypos_missile = ypos_ctl_missle;
  assign on_missle   = on_ctl_missle;
  assign ship_down   = is_ship_dead;

  endmodule
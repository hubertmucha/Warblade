// File: main.v
// Author: HM & NP

// This is a top module for Warblade project

`timescale 1 ns / 1 ps

module main (
  input wire clk,
  input wire rst,                         // U17 button - reset <-- look to vga_example.xdc
  input wire right,                       // T17 button
  input wire left,                        // W19 button
  input wire missle_button,               // T18 button
  input wire rx, 
  input wire [2:0] columns,

  output tx,
  output wire [3:0] rows,
  output wire [7:0] sseg_ca,
  output wire [3:0] sseg_an,


  output wire vs,
  output wire hs,
  output wire [3:0] r,
  output wire [3:0] g,
  output wire [3:0] b,
  output wire pclk_mirror
  );
   
  wire pclk;
  wire locked;
  wire clk100Mhz;
  
  clk_wiz_0 my_clk_wiz_0(
      .clk(clk),
      .clk65Mhz(pclk),
      .clk100Mhz(clk100Mhz),
      .locked(locked),
      .reset(rst)
  );

  wire [7:0] key_uart;
  wire [7:0] key_press;
  uart uart(
    // inputs
    .clk(clk100Mhz),
    .reset(rst),
    .rd_uart(1'b0),
    .wr_uart(1'b0),
    .rx(rx),
    .w_data(key_press),

    // outputs
    // .tx_full(),
    // .rx_empty(),
    .tx(tx),
    .r_data(key_uart)
  );

  wire [3:0] rows_k;
  wire [7:0] sseg_ca_k;
  wire [3:0] sseg_an_k;

  keypad_main keypad(
    .clk(pclk),
    .columns(columns),
    .rows(rows_k),
    .sseg_ca(sseg_ca_k),
    .sseg_an(sseg_an_k),
    .key_press(key_press)
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

  wire [10:0] vga_vcount, vga_hcount;
  wire vga_vsync, vga_hsync;
  wire vga_vblnk, vga_hblnk;

  vga_timing my_timing (
    .vcount(vga_vcount),
    .vsync(vga_vsync),
    .vblnk(vga_vblnk),
    .hcount(vga_hcount),
    .hsync(vga_hsync),
    .hblnk(vga_hblnk),

    .pclk(pclk),
    .rst(rst_out)
  );

  wire [10:0] vga_vcount_b, vga_hcount_b;
  wire vga_vsync_b, vga_hsync_b;
  wire vga_vblnk_b, vga_hblnk_b;
  wire [11:0] vga_rgb_b;

  wire [10:0] vga_vcount_r, vga_hcount_r;
  wire vga_vsync_r, vga_hsync_r;
  wire vga_vblnk_r, vga_hblnk_r;
  wire [11:0] vga_rgb_r;

  wire [3:0] level_fb;
  wire [3:0] level_fb_draw_background;

  draw_background my_draw_background(
    .pclk(pclk),
    .rst(rst_out),

    //input
    .vcount_in(vga_vcount),
    .vsync_in(vga_vsync),
    .vblnk_in(vga_vblnk),
    .hcount_in(vga_hcount),
    .hsync_in(vga_hsync),
    .hblnk_in(vga_hblnk),

    .level(level_fb_draw_background),

    //output
    .vcount_out(vga_vcount_b),
    .vsync_out(vga_vsync_b),
    .vblnk_out(vga_vblnk_b),
    .hcount_out(vga_hcount_b),
    .hsync_out(vga_hsync_b),
    .hblnk_out(vga_hblnk_b),
    .rgb_out(vga_rgb_b)
  );
  
  // dff delay controls signals
  wire left_d, right_d;
  delay #(.WIDTH(2), .CLK_DEL(2)) my_delay_controls(
    .clk(pclk),
    .rst(rst_out),
    .din({left, right}),
    .dout({left_d, right_d})
  );

  wire kc_left_control_1, kc_right_control_1, kc_shoot_control_1;
  key_control key_control_1(
    .pclk(pclk),
    .rst(rst),
    .pressed_key(key_press),
    .left(kc_left_control_1),
    .right(kc_right_control_1),
    .shoot(kc_shoot_control_1)
  );

  wire kc_left_control_2, kc_right_control_2, kc_shoot_control_2;
  key_control key_control_2(
    .pclk(pclk),
    .rst(rst),
    .pressed_key(key_uart),
    .left(kc_left_control_2),
    .right(kc_right_control_2),
    .shoot(kc_shoot_control_2)
  );

  wire [54:0] en_x_missile_group;  
  wire [54:0] en_y_missile_group;  
  
  wire [10:0] d2s_xpos_missile_1, d2s_ypos_missile_1;
  wire [10:0] d2s_xpos_missile_2, d2s_ypos_missile_2;

  wire [10:0] vga_vcount_1_to_2, vga_hcount_1_to_2;
  wire vga_vsync_1_to_2, vga_hsync_1_to_2;
  wire vga_vblnk_1_to_2, vga_hblnk_1_to_2;
  wire [11:0] vga_rgb_1_to_2;

  wire [3:0] d2t_dead_count_1;
  wire [3:0] d2t_dead_count_2;

  draw_ship #(.XPOS_LIVES(20), .N(1), .RESET_X_POS(2)) my_draw_ship_1(
    .pclk(pclk),                                  
    .rst(rst_out),                                   
    .left(kc_left_control_1),
    .right(kc_right_control_1),
    .missile_button(kc_shoot_control_1),
    .hblnk_in(vga_hblnk_b),
    .hcount_in(vga_hcount_b),
    .hsync_in(vga_hsync_b),
    .vcount_in(vga_vcount_b),            
    .vsync_in(vga_vsync_b),                            
    .vblnk_in(vga_vblnk_b),
    .rgb_in(vga_rgb_b),

    .en_x_missile1(en_x_missile_group[10:0]),
    .en_y_missile1(en_y_missile_group[10:0]),

    .en_x_missile2(en_x_missile_group[21:11]),
    .en_y_missile2(en_y_missile_group[21:11]),

    .en_x_missile3(en_x_missile_group[32:22]),
    .en_y_missile3(en_y_missile_group[32:22]),

    .en_x_missile4(en_x_missile_group[43:33]),
    .en_y_missile4(en_y_missile_group[43:33]),

    .en_x_missile5(en_x_missile_group[54:44]),
    .en_y_missile5(en_y_missile_group[54:44]),             

    .vcount_out(vga_vcount_1_to_2),                     
    .vsync_out(vga_vsync_1_to_2),                          
    .vblnk_out(vga_vblnk_1_to_2),                             
    .hcount_out(vga_hcount_1_to_2),                     
    .hsync_out(vga_hsync_1_to_2),                            
    .hblnk_out(vga_hblnk_1_to_2),                             
    .rgb_out(vga_rgb_1_to_2),
    
    .xpos_missile(d2s_xpos_missile_1),
    .ypos_missile(d2s_ypos_missile_1),
    .dead_count_out(d2t_dead_count_1)
  );


    draw_ship  #(.XPOS_LIVES(970), .N(2), .RESET_X_POS(940)) my_draw_ship_2(
    .pclk(pclk),                                  
    .rst(rst_out),                                   
    .left(kc_left_control_2),
    .right(kc_right_control_2),
    .missile_button(kc_shoot_control_2),
    .hblnk_in(vga_hblnk_1_to_2),
    .hcount_in(vga_hcount_1_to_2),
    .hsync_in(vga_hsync_1_to_2),
    .vcount_in(vga_vcount_1_to_2),            
    .vsync_in(vga_vsync_1_to_2),                            
    .vblnk_in(vga_vblnk_1_to_2),
    .rgb_in(vga_rgb_1_to_2),

    .en_x_missile1(en_x_missile_group[10:0]),
    .en_y_missile1(en_y_missile_group[10:0]),

    .en_x_missile2(en_x_missile_group[21:11]),
    .en_y_missile2(en_y_missile_group[21:11]),

    .en_x_missile3(en_x_missile_group[32:22]),
    .en_y_missile3(en_y_missile_group[32:22]),

    .en_x_missile4(en_x_missile_group[43:33]),
    .en_y_missile4(en_y_missile_group[43:33]),

    .en_x_missile5(en_x_missile_group[54:44]),
    .en_y_missile5(en_y_missile_group[54:44]),                   

    .vcount_out(vga_vcount_r),                     
    .vsync_out(vga_vsync_r),                          
    .vblnk_out(vga_vblnk_r),                             
    .hcount_out(vga_hcount_r),                     
    .hsync_out(vga_hsync_r),                            
    .hblnk_out(vga_hblnk_r),                             
    .rgb_out(vga_rgb_r),
    
    .xpos_missile(d2s_xpos_missile_2),
    .ypos_missile(d2s_ypos_missile_2),
    .dead_count_out(d2t_dead_count_2)
  );

  wire vga_vsync_o, vga_hsync_o;
  wire [11:0] vga_rgb_o;

  wire [10:0] vga_vcount_s, vga_hcount_s;
  wire vga_vsync_s, vga_hsync_s;
  wire vga_vblnk_s, vga_hblnk_s;
  wire [11:0] vga_rgb_s;

  wire [3:0] level_nxt;


  wire level_change_nxt;
  wire level_change_fb;



  enemies my_enemies(
    .pclk(pclk),                                  
    .rst(rst_out),                                   
    .hblnk_in(vga_hblnk_r),
    .hcount_in(vga_hcount_r),
    .hsync_in(vga_hsync_r),
    .vcount_in(vga_vcount_r),            
    .vsync_in(vga_vsync_r),                            
    .vblnk_in(vga_vblnk_r),
    .rgb_in(vga_rgb_r),

    .level_in(level_fb),
    .level_change(level_change_fb),

    .xpos_missile_1(d2s_xpos_missile_1),
    .ypos_missile_1(d2s_ypos_missile_1),

    .xpos_missile_2(d2s_xpos_missile_2),
    .ypos_missile_2(d2s_ypos_missile_2),                      

    .vcount_out(vga_vcount_s),                     
    .vsync_out(vga_vsync_s),                          
    .vblnk_out(vga_vblnk_s),                             
    .hcount_out(vga_hcount_s),                     
    .hsync_out(vga_hsync_s),                            
    .hblnk_out(vga_hblnk_s),                             
    .rgb_out(vga_rgb_s),

    .en_x_missile_group(en_x_missile_group),
    .en_y_missile_group(en_y_missile_group),

    .level_out(level_nxt),              // output form level.v
    .level_change_out(level_change_nxt) // output form level.v
  );

  // 11  9 14

  delay #(.WIDTH(4), .CLK_DEL(12)) delay_fb_loop_level(
    .clk(pclk),
    .rst(rst_out),
    .din({level_nxt}),
    .dout({level_fb})
  );

  delay #(.WIDTH(4), .CLK_DEL(10)) delay_fb_loop_level_bg( 
    .clk(pclk),
    .rst(rst_out),
    .din({level_nxt}),
    .dout({level_fb_draw_background})
  );

  delay #(.WIDTH(1), .CLK_DEL(15)) delay_fb_loop_level_change(
    .clk(pclk),
    .rst(rst_out),
    .din({level_change_nxt}),
    .dout({level_change_fb})
  );


  textbox my_text_box(
    .pclk(pclk),                                  
    .rst(rst_out),
    .level(level_nxt),                                   

    .hblnk_in(vga_hblnk_s),
    .hcount_in(vga_hcount_s),
    .hsync_in(vga_hsync_s),
    .vcount_in(vga_vcount_s),            
    .vsync_in(vga_vsync_s),                            
    .vblnk_in(vga_vblnk_s),
    .rgb_in(vga_rgb_s),

    .dead_count_1(d2t_dead_count_1),
    .dead_count_2(d2t_dead_count_2),                           
                 
    .vsync_out(vga_vsync_o),                                             
    .hsync_out(vga_hsync_o),                                                     
    .rgb_out(vga_rgb_o)
  );


    // Just pass these through.
    assign hs = vga_hsync_o;
    assign vs = vga_vsync_o;
    assign r  = vga_rgb_o[11:8];
    assign g  = vga_rgb_o[7:4];
    assign b  = vga_rgb_o[3:0];
    assign rows = rows_k;
    assign sseg_ca = sseg_ca_k;
    assign sseg_an = sseg_an_k;
    
endmodule

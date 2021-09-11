// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module main (
  input wire clk,
  input wire rst,                         // U17 button - reset <-- look to vga_example.xdc
  input wire right,                       // T17 button
  input wire left,                        // W19 button
  input wire missle_button,               // T18 button 

  input wire [2:0] columns,
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
  
  clk_wiz_0 my_clk_wiz_0(
      .clk(clk),
      .clk65Mhz(pclk),
      .clk100Mhz(),
      .locked(locked),
      .reset(rst)
  );

  wire [3:0] rows_k;
  wire [7:0] sseg_ca_k;
  wire [3:0] sseg_an_k;
  wire [7:0] key_press;

  keypad_main my_keypad_main(
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

  wire [10:0] vcount_r, hcount_r;
  wire vsync_r, hsync_r;
  wire vblnk_r, hblnk_r;
  wire [11:0] rgb_r;

  wire [3:0] level_fb;
  wire [3:0] level_fb_draw_background;

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

    .level(level_fb_draw_background),

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

  wire left_control, right_control, shoot_control;
  key_control key_control_1(
    .pclk(pclk),
    .rst(rst),
    .pressed_key(key_press),
    .left(left_control),
    .right(right_control),
    .shoot(shoot_control)
  );

  wire [10:0] en1_x_missile, en1_y_missile;
  wire [10:0] en2_x_missile, en2_y_missile;
  wire [10:0] en3_x_missile, en3_y_missile;  
  wire [10:0] en4_x_missile, en4_y_missile;  
  wire [10:0] en5_x_missile, en5_y_missile;  
  
  wire [10:0] xpos_missile_1, ypos_missile_1;
  wire [10:0] xpos_missile_2, ypos_missile_2;

  wire [10:0] vcount_1_to_2, hcount_1_to_2;
  wire vsync_1_to_2, hsync_1_to_2;
  wire vblnk_1_to_2, hblnk_1_to_2;
  wire [11:0] rgb_1_to_2;

  draw_ship #(.XPOS_LIVES(20), .N(1), .RESET_X_POS(2)) my_draw_ship_1(
    .pclk(pclk),                                  
    .rst(rst_out),                                   
    .left(left_control),
    .right(right_control),
    .missile_button(shoot_control),
    .hblnk_in(hblnk_b),
    .hcount_in(hcount_b),
    .hsync_in(hsync_b),
    .vcount_in(vcount_b),            
    .vsync_in(vsync_b),                            
    .vblnk_in(vblnk_b),
    .rgb_in(rgb_b),

    .en_x_missile1(en1_x_missile),
    .en_y_missile1(en1_y_missile),

    .en_x_missile2(en2_x_missile),
    .en_y_missile2(en2_y_missile),

    .en_x_missile3(en3_x_missile),
    .en_y_missile3(en3_y_missile),

    .en_x_missile4(en4_x_missile),
    .en_y_missile4(en4_y_missile),  

    .en_x_missile5(en5_x_missile),
    .en_y_missile5(en5_y_missile),                           

    .vcount_out(vcount_1_to_2),                     
    .vsync_out(vsync_1_to_2),                          
    .vblnk_out(vblnk_1_to_2),                             
    .hcount_out(hcount_1_to_2),                     
    .hsync_out(hsync_1_to_2),                            
    .hblnk_out(hblnk_1_to_2),                             
    .rgb_out(rgb_1_to_2),
    
    .xpos_missile(xpos_missile_1),
    .ypos_missile(ypos_missile_1)
  );


    draw_ship  #(.XPOS_LIVES(970), .N(2), .RESET_X_POS(940)) my_draw_ship_2(
    .pclk(pclk),                                  
    .rst(rst_out),                                   
    .left(left_d),
    .right(right_d),
    .missile_button(missle_button),
    .hblnk_in(hblnk_1_to_2),
    .hcount_in(hcount_1_to_2),
    .hsync_in(hsync_1_to_2),
    .vcount_in(vcount_1_to_2),            
    .vsync_in(vsync_1_to_2),                            
    .vblnk_in(vblnk_1_to_2),
    .rgb_in(rgb_1_to_2),

    .en_x_missile1(en1_x_missile),
    .en_y_missile1(en1_y_missile),

    .en_x_missile2(en2_x_missile),
    .en_y_missile2(en2_y_missile),

    .en_x_missile3(en3_x_missile),
    .en_y_missile3(en3_y_missile),

    .en_x_missile4(en4_x_missile),
    .en_y_missile4(en4_y_missile),  

    .en_x_missile5(en5_x_missile),
    .en_y_missile5(en5_y_missile),                           

    .vcount_out(vcount_r),                     
    .vsync_out(vsync_r),                          
    .vblnk_out(vblnk_r),                             
    .hcount_out(hcount_r),                     
    .hsync_out(hsync_r),                            
    .hblnk_out(hblnk_r),                             
    .rgb_out(rgb_r),
    
    .xpos_missile(xpos_missile_2),
    .ypos_missile(ypos_missile_2)
  );

  wire vsync_o, hsync_o;
  wire [11:0] rgb_o;

  wire [10:0] vcount_s, hcount_s;
  wire vsync_s, hsync_s;
  wire vblnk_s, hblnk_s;
  wire [11:0] rgb_s;

  wire [3:0] level_nxt;


  wire level_change_nxt;
  wire level_change_fb;

  enemies my_enemies(
    .pclk(pclk),                                  
    .rst(rst_out),                                   
    .hblnk_in(hblnk_r),
    .hcount_in(hcount_r),
    .hsync_in(hsync_r),
    .vcount_in(vcount_r),            
    .vsync_in(vsync_r),                            
    .vblnk_in(vblnk_r),
    .rgb_in(rgb_r),

    .level_in(level_fb),
    .level_change(level_change_fb),

    .xpos_missile_1(xpos_missile_1),
    .ypos_missile_1(ypos_missile_1),

    .xpos_missile_2(xpos_missile_2),
    .ypos_missile_2(ypos_missile_2),                      

    .vcount_out(vcount_s),                     
    .vsync_out(vsync_s),                          
    .vblnk_out(vblnk_s),                             
    .hcount_out(hcount_s),                     
    .hsync_out(hsync_s),                            
    .hblnk_out(hblnk_s),                             
    .rgb_out(rgb_s),

    .en1_x_missile(en1_x_missile),
    .en1_y_missile(en1_y_missile),
    .en2_x_missile(en2_x_missile),
    .en2_y_missile(en2_y_missile),
    .en3_x_missile(en3_x_missile),
    .en3_y_missile(en3_y_missile),

    .en4_x_missile(en4_x_missile),
    .en4_y_missile(en4_y_missile),

    .en5_x_missile(en5_x_missile),
    .en5_y_missile(en5_y_missile),

    .level_out(level_nxt),              // output form level.v
    .level_change_out(level_change_nxt) // output form level.v
  );

  // 7 9 14

  delay #(.WIDTH(4), .CLK_DEL(11)) delay_fb_loop_level(
    .clk(pclk),
    .rst(rst_out),
    .din({level_nxt}),
    .dout({level_fb})
  );

  delay #(.WIDTH(4), .CLK_DEL(9)) delay_fb_loop_level_bg( 
    .clk(pclk),
    .rst(rst_out),
    .din({level_nxt}),
    .dout({level_fb_draw_background})
  );

  delay #(.WIDTH(1), .CLK_DEL(14)) delay_fb_loop_level_change(
    .clk(pclk),
    .rst(rst_out),
    .din({level_change_nxt}),
    .dout({level_change_fb})
  );


  textbox my_text_box(
    .pclk(pclk),                                  
    .rst(rst_out),
    .level(level_nxt),                                   

    .hblnk_in(hblnk_s),
    .hcount_in(hcount_s),
    .hsync_in(hsync_s),
    .vcount_in(vcount_s),            
    .vsync_in(vsync_s),                            
    .vblnk_in(vblnk_s),
    .rgb_in(rgb_s),                           
                 
    .vsync_out(vsync_o),                                             
    .hsync_out(hsync_o),                                                     
    .rgb_out(rgb_o)
  );


    // Just pass these through.
    assign hs = hsync_o;
    assign vs = vsync_o;
    assign r  = rgb_o[11:8];
    assign g  = rgb_o[7:4];
    assign b  = rgb_o[3:0];
    assign rows = rows_k;
    assign sseg_ca = sseg_ca_k;
    assign sseg_an = sseg_an_k;
    
endmodule

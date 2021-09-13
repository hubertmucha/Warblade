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

  // Instantiate the draw_background module, which is
  // the module you are designing for this lab.

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

  wire [10:0] en1_x_missile, en1_y_missile;
  wire [10:0] en2_x_missile, en2_y_missile;
  wire [10:0] en3_x_missile, en3_y_missile;  
  wire [10:0] en4_x_missile, en4_y_missile;  
  wire [10:0] en5_x_missile, en5_y_missile;  
  
  wire [10:0] xpos_missile_1, ypos_missile_1;
  wire [10:0] xpos_missile_2, ypos_missile_2;

  wire [10:0] vga_vcount_1_to_2, vga_hcount_1_to_2;
  wire vga_vsync_1_to_2, vga_hsync_1_to_2;
  wire vga_vblnk_1_to_2, vga_hblnk_1_to_2;
  wire [11:0] vga_rgb_1_to_2;

  wire [3:0] dead_count_1;
  wire [3:0] dead_count_2;

  draw_ship #(.XPOS_LIVES(20), .N(1), .RESET_X_POS(2)) my_draw_ship_1(
    .pclk(pclk),                                  
    .rst(rst_out),                                   
    .left(0),
    .right(0),
    .missile_button(missle_button),
    .hblnk_in(vga_hblnk_b),
    .hcount_in(vga_hcount_b),
    .hsync_in(vga_hsync_b),
    .vcount_in(vga_vcount_b),            
    .vsync_in(vga_vsync_b),                            
    .vblnk_in(vga_vblnk_b),
    .rgb_in(vga_rgb_b),

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

    .vcount_out(vga_vcount_1_to_2),                     
    .vsync_out(vga_vsync_1_to_2),                          
    .vblnk_out(vga_vblnk_1_to_2),                             
    .hcount_out(vga_hcount_1_to_2),                     
    .hsync_out(vga_hsync_1_to_2),                            
    .hblnk_out(vga_hblnk_1_to_2),                             
    .rgb_out(vga_rgb_1_to_2),
    
    .xpos_missile(xpos_missile_1),
    .ypos_missile(ypos_missile_1),
    .dead_count_out(dead_count_1)
  );


    draw_ship  #(.XPOS_LIVES(970), .N(2), .RESET_X_POS(940)) my_draw_ship_2(
    .pclk(pclk),                                  
    .rst(rst_out),                                   
    .left(left_d),
    .right(right_d),
    .missile_button(missle_button),
    .hblnk_in(vga_hblnk_1_to_2),
    .hcount_in(vga_hcount_1_to_2),
    .hsync_in(vga_hsync_1_to_2),
    .vcount_in(vga_vcount_1_to_2),            
    .vsync_in(vga_vsync_1_to_2),                            
    .vblnk_in(vga_vblnk_1_to_2),
    .rgb_in(vga_rgb_1_to_2),

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

    .vcount_out(vga_vcount_r),                     
    .vsync_out(vga_vsync_r),                          
    .vblnk_out(vga_vblnk_r),                             
    .hcount_out(vga_hcount_r),                     
    .hsync_out(vga_hsync_r),                            
    .hblnk_out(vga_hblnk_r),                             
    .rgb_out(vga_rgb_r),
    
    .xpos_missile(xpos_missile_2),
    .ypos_missile(ypos_missile_2),
    .dead_count_out(dead_count_2)
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

    .xpos_missile_1(xpos_missile_1),
    .ypos_missile_1(ypos_missile_1),

    .xpos_missile_2(xpos_missile_2),
    .ypos_missile_2(ypos_missile_2),                      

    .vcount_out(vga_vcount_s),                     
    .vsync_out(vga_vsync_s),                          
    .vblnk_out(vga_vblnk_s),                             
    .hcount_out(vga_hcount_s),                     
    .hsync_out(vga_hsync_s),                            
    .hblnk_out(vga_hblnk_s),                             
    .rgb_out(vga_rgb_s),

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

    .dead_count_1(3), // TODO: change to dead_count_1
    .dead_count_2(dead_count_2),                           
                 
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
    
endmodule

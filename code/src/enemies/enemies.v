 module enemies(
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire [10:0] xpos_missile,
    input wire [10:0] ypos_missile,
    input wire on_missle,

    input wire [10:0] vcount_in,                      // input vertical count
    input wire vsync_in,                              // input vertical sync
    input wire vblnk_in,                              // input vertical blink
    input wire [10:0] hcount_in,                      // input horizontal count
    input wire hsync_in,                              // input horizontal sync
    input wire hblnk_in,                              // input horizontal blink
    input wire [11:0] rgb_in,

    input wire [3:0] level_in,
    input wire level_change,

    output wire [10:0] vcount_out,                     // output vertical count
    output wire vsync_out,                             // output vertical sync
    output wire vblnk_out,                             // output vertical blink
    output wire [10:0] hcount_out,                     // output horizontal count
    output wire hsync_out,                             // output horizontal sync
    output wire hblnk_out,                             // output horizontal blink
    output wire [11:0] rgb_out,

    output wire [10:0] en1_x_missile,
    output wire [10:0] en1_y_missile,
    output wire [10:0] en2_x_missile,
    output wire [10:0] en2_y_missile,
    output wire [10:0] en3_x_missile,
    output wire [10:0] en3_y_missile,
    output wire [3:0] level_out,
    output wire level_change_out
  );

  wire [3:0] level_nxt;
  wire level_change_out_nxt; 

  // life controls
  wire lives_1, lives_2, lives_3, lives_4, lives_5;

  wire [10:0] x_missile_1, y_missile_1;
  wire [10:0] x_missile_2, y_missile_2;
  wire [10:0] x_missile_3, y_missile_3;
  wire [10:0] x_missile_4, y_missile_4;
  wire [10:0] x_missile_5, y_missile_5;

  // from 1 to 2
  wire [10:0] vcount_1, hcount_1;
  wire vsync_1, hsync_1;
  wire vblnk_1, hblnk_1;
  wire [11:0] rgb_1;

  // from 2 to 3
  wire [10:0] vcount_2, hcount_2;
  wire vsync_2, hsync_2;
  wire vblnk_2, hblnk_2;
  wire [11:0] rgb_2;

  // from 3 to 4
  wire [10:0] vcount_3, hcount_3;
  wire vsync_3, hsync_3;
  wire vblnk_3, hblnk_3;
  wire [11:0] rgb_3;

  // from 4 to 5
  wire [10:0] vcount_4, hcount_4;
  wire vsync_4, hsync_4;
  wire vblnk_4, hblnk_4;
  wire [11:0] rgb_4;

  // from 5 to output
  wire [10:0] vcount_o, hcount_o;
  wire vsync_o, hsync_o;
  wire vblnk_o, hblnk_o;
  wire [11:0] rgb_o;

  wire [10:0] x_main;
  wire [10:0] y_main;

  // one x and y generetor from file 
    main_gen gene (
    .pclk(pclk),
    .rst(rst),
    //inputs
    .level(level_in),
    // outputs
    .x_out(x_main),
    .y_out(y_main)
    );

    en_one #(.N(1)) enemy_1(
    .pclk(pclk),
    .rst(rst),

    //input
    .vcount_in(vcount_in),
    .vsync_in(vsync_in),
    .vblnk_in(vblnk_in),
    .hcount_in(hcount_in),
    .hsync_in(hsync_in),
    .hblnk_in(hblnk_in),
    .rgb_in(rgb_in),
    .x_in(x_main),
    .y_in(y_main),
    .level_change(level_change),

    //output
    .vcount_out(vcount_1),
    .vsync_out(vsync_1),
    .vblnk_out(vblnk_1),
    .hcount_out(hcount_1),
    .hsync_out(hsync_1),
    .hblnk_out(hblnk_1),
    .rgb_out(rgb_1),

    // inputs: to detecion colision with missile
    .xpos_missile(xpos_missile),
    .ypos_missile(ypos_missile),
    .on_missle(on_missle),

    // outputs: to detect_collision
    .en_x_missile(x_missile_1),
    .en_y_missile(y_missile_1),   

    // output: to calculate level
    .lives(lives_1)
  );

  en_one #(.N(2)) enemy_2(
    .pclk(pclk),
    .rst(rst),

    //input
    .vcount_in(vcount_1),
    .vsync_in(vsync_1),
    .vblnk_in(vblnk_1),
    .hcount_in(hcount_1),
    .hsync_in(hsync_1),
    .hblnk_in(hblnk_1),
    .rgb_in(rgb_1),
    .x_in(x_main),
    .y_in(y_main),
    .level_change(level_change),

    //output
    .vcount_out(vcount_2),
    .vsync_out(vsync_2),
    .vblnk_out(vblnk_2),
    .hcount_out(hcount_2),
    .hsync_out(hsync_2),
    .hblnk_out(hblnk_2),
    .rgb_out(rgb_2),

    // to detecion colision with missile
    .xpos_missile(xpos_missile),
    .ypos_missile(ypos_missile),
    .on_missle(on_missle),

    // outputs: to detect_collision
    .en_x_missile(x_missile_2),
    .en_y_missile(y_missile_2),   

    // to calculate level
    .lives(lives_2)
  );
  
  en_one #(.N(3)) enemy_3(
    .pclk(pclk),
    .rst(rst),

    //input
    .vcount_in(vcount_2),
    .vsync_in(vsync_2),
    .vblnk_in(vblnk_2),
    .hcount_in(hcount_2),
    .hsync_in(hsync_2),
    .hblnk_in(hblnk_2),
    .rgb_in(rgb_2),
    .x_in(x_main),
    .y_in(y_main),
    .level_change(level_change),

    //output
    .vcount_out(vcount_3),
    .vsync_out(vsync_3),
    .vblnk_out(vblnk_3),
    .hcount_out(hcount_3),
    .hsync_out(hsync_3),
    .hblnk_out(hblnk_3),
    .rgb_out(rgb_3),

    // to detecion colision with missile
    .xpos_missile(xpos_missile),
    .ypos_missile(ypos_missile),
    .on_missle(on_missle),

    // outputs: to detect_collision
    .en_x_missile(x_missile_3),
    .en_y_missile(y_missile_3),   

    // to calculate level
    .lives(lives_3)
  );

  en_one #(.N(4)) enemy_4(
    .pclk(pclk),
    .rst(rst),

    //input
    .vcount_in(vcount_3),
    .vsync_in(vsync_3),
    .vblnk_in(vblnk_3),
    .hcount_in(hcount_3),
    .hsync_in(hsync_3),
    .hblnk_in(hblnk_3),
    .rgb_in(rgb_3),
    .x_in(x_main),
    .y_in(y_main),
    .level_change(level_change),

    //output
    .vcount_out(vcount_4),
    .vsync_out(vsync_4),
    .vblnk_out(vblnk_4),
    .hcount_out(hcount_4),
    .hsync_out(hsync_4),
    .hblnk_out(hblnk_4),
    .rgb_out(rgb_4),

    // to detecion colision with missile
    .xpos_missile(xpos_missile),
    .ypos_missile(ypos_missile),
    .on_missle(on_missle),

    // outputs: to detect_collision
    .en_x_missile(x_missile_4),
    .en_y_missile(y_missile_4),   

    // to calculate level
    .lives(lives_4)
  );

    en_one #(.N(5)) enemy_5(
    .pclk(pclk),
    .rst(rst),

    //input
    .vcount_in(vcount_4),
    .vsync_in(vsync_4),
    .vblnk_in(vblnk_4),
    .hcount_in(hcount_4),
    .hsync_in(hsync_4),
    .hblnk_in(hblnk_4),
    .rgb_in(rgb_4),
    .x_in(x_main),
    .y_in(y_main),
    .level_change(level_change),
    
    //output
    .vcount_out(vcount_o),
    .vsync_out(vsync_o),
    .vblnk_out(vblnk_o),
    .hcount_out(hcount_o),
    .hsync_out(hsync_o),
    .hblnk_out(hblnk_o),
    .rgb_out(rgb_o),

    // to detecion colision with missile
    .xpos_missile(xpos_missile),
    .ypos_missile(ypos_missile),
    .on_missle(on_missle),

    // outputs: to detect_collision
    .en_x_missile(x_missile_5),
    .en_y_missile(y_missile_5),   

    // to calculate level
    .lives(lives_5)
  );

  level my_level(
    .pclk(pclk),
    .rst(rst),

    //input
    .lives_1(lives_1),
    .lives_2(lives_2),
    .lives_3(lives_3),
    .lives_4(lives_4),
    .lives_5(lives_5),

    //output
    .level(level_nxt),
    .level_up_out(level_change_out_nxt)

  );
  

  assign vcount_out = vcount_o;
  assign vsync_out  = vsync_o;
  assign vblnk_out  = vblnk_o;
  assign hcount_out = hcount_o;
  assign hsync_out  = hsync_o;
  assign hblnk_out  = hblnk_o;
  assign rgb_out    = rgb_o;
  assign level_out  = level_nxt;
  assign level_change_out  = level_change_out_nxt;

  assign en1_x_missile = x_missile_1;
  assign en1_y_missile = y_missile_1;
  assign en2_x_missile = x_missile_2;
  assign en2_y_missile = y_missile_2;
  assign en3_x_missile = x_missile_3;
  assign en3_y_missile = y_missile_3;

  endmodule
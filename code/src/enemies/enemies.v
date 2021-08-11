 module enemies(
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire [10:0] vcount_in,                      // input vertical count
    input wire vsync_in,                              // input vertical sync
    input wire vblnk_in,                              // input vertical blink
    input wire [10:0] hcount_in,                      // input horizontal count
    input wire hsync_in,                              // input horizontal sync
    input wire hblnk_in,                              // input horizontal blink
    input wire [11:0] rgb_in,

    output wire [10:0] vcount_out,                     // output vertical count
    output wire vsync_out,                             // output vertical sync
    output wire vblnk_out,                             // output vertical blink
    output wire [10:0] hcount_out,                     // output horizontal count
    output wire hsync_out,                             // output horizontal sync
    output wire hblnk_out,                             // output horizontal blink
    output wire [11:0] rgb_out
  );

  // from input to 1
  wire [10:0] vcount_1, hcount_1;
  wire vsync_1, hsync_1;
  wire vblnk_1, hblnk_1;
  wire [11:0] rgb_1;

  // from 1 to 2
  wire [10:0] vcount_2, hcount_2;
  wire vsync_2, hsync_2;
  wire vblnk_2, hblnk_2;
  wire [11:0] rgb_2;

  // from 2 to output
  wire [10:0] vcount_o, hcount_o;
  wire vsync_o, hsync_o;
  wire vblnk_o, hblnk_o;
  wire [11:0] rgb_o;


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

    //output
    .vcount_out(vcount_1),
    .vsync_out(vsync_1),
    .vblnk_out(vblnk_1),
    .hcount_out(hcount_1),
    .hsync_out(hsync_1),
    .hblnk_out(hblnk_1),
    .rgb_out(rgb_1)
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

    //output
    .vcount_out(vcount_2),
    .vsync_out(vsync_2),
    .vblnk_out(vblnk_2),
    .hcount_out(hcount_2),
    .hsync_out(hsync_2),
    .hblnk_out(hblnk_2),
    .rgb_out(rgb_2)
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
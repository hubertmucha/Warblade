 module textbox(
    input wire pclk,
    input wire rst,                                 

    input wire hblnk_in,
    input wire [10:0] hcount_in,   
    input wire hsync_in,

    input wire [3:0] level,

    input wire [10:0] vcount_in,                    
    input wire vsync_in,                            
    input wire vblnk_in,

    input wire [3:0] dead_count_1,                   
    input wire [3:0] dead_count_2,  
    
    input wire [11:0] rgb_in,                            
                  
    output wire vsync_out,                                   
    output wire hsync_out,                                                   
    output wire [11:0] rgb_out
  );

  wire [10:0] vcount_ch, hcount_ch;
  wire [11:0] rgb_ch;
  wire vsync_ch, hsync_ch;
  wire vblnk_ch, hblnk_ch;
  wire [7:0] char_pixels;
  wire [7:0] char_xy;
  wire [3:0] char_line;

  wire [10:0] vcount_2, hcount_2;
  wire [11:0] rgb_2;
  wire vsync_2, hsync_2;
  wire vblnk_2, hblnk_2;
  wire [7:0] char_pixels_2;
  wire [7:0] char_xy_2;
  wire [3:0] char_line_2;

  draw_rect_char my_draw_rect_char(
    .rst(rst),
    .pclk(pclk),
    .rgb_in(rgb_in),
    .char_pixels(char_pixels),

    .hcount_in(hcount_in),
    .vcount_in(vcount_in),
    .hblnk_in(hblnk_in),
    .vblnk_in(vblnk_in),    
    .hsync_in(hsync_in),
    .vsync_in(vsync_in),
    
    .hcount_out(hcount_2),
    .vcount_out(vcount_2),
    .hblnk_out(hblnk_2),
    .vblnk_out(vblnk_2),
    .hsync_out(hsync_2),
    .vsync_out(vsync_2),
    .rgb_out(rgb_2),
    
    .char_xy(char_xy),
    .char_line(char_line)
  );

  wire [6:0] char_code; 

  char_rom_16x16 my_char_rom_16x16(
    .level(level),
    .char_xy(char_xy),
    .char_code(char_code)
  );

  font_rom my_font_rom(
    .clk(pclk),
    .addr({char_code, char_line}),
    .char_line_pixels(char_pixels)
  );

  draw_rect_game_over my_draw_rect_game_over(
  .rst(rst),
  .pclk(pclk),
  .rgb_in(rgb_2),  
  .char_pixels(char_pixels_2),

  .hcount_in(hcount_2),
  .vcount_in(vcount_2),
  .hblnk_in(hblnk_2),
  .vblnk_in(vblnk_2),    
  .hsync_in(hsync_2),
  .vsync_in(vsync_2),
  .dead_count_1(dead_count_1),
  .dead_count_2(dead_count_2),
  
  .hcount_out(hcount_ch),
  .vcount_out(vcount_ch),
  .hblnk_out(hblnk_ch),
  .vblnk_out(vblnk_ch),
  .hsync_out(hsync_ch),
  .vsync_out(vsync_ch),

  .rgb_out(rgb_ch),
  .char_xy(char_xy_2),
  .char_line(char_line_2)
  );

  wire [6:0] char_code_2; 

  char_rom_game_over my_char_rom_game_over(
    .char_xy(char_xy_2),
    .char_code(char_code_2)
  );

  font_rom my_font_rom_game_over(
    .clk(pclk),
    .addr({char_code_2, char_line_2}),
    .char_line_pixels(char_pixels_2)
  );

    assign vsync_out = vsync_ch;
    assign hsync_out = hsync_ch;
    assign rgb_out = rgb_ch;

  endmodule
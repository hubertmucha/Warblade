 module textbox(
    input wire pclk,
    input wire rst,                                 

    input wire hblnk_in,
    input wire [10:0] hcount_in,   
    input wire hsync_in,

    input wire [10:0] vcount_in,                    
    input wire vsync_in,                            
    input wire vblnk_in,
    
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

    assign vsync_out = vsync_ch;
    assign hsync_out = hsync_ch;
    assign rgb_out = rgb_ch;

  endmodule
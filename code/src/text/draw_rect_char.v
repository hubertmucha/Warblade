// File: draw_rect_char.v
// Author: HM

`timescale 1 ns / 1 ps

module draw_rect_char (
  input wire pclk,                                  // Peripheral Clock
  input wire rst,                                   // Synchrous reset
  input wire [10:0] vcount_in,                      // input vertical count
  input wire vsync_in,                              // input vertical sync
  input wire vblnk_in,                              // input vertical blink
  input wire [10:0] hcount_in,                      // input horizontal count
  input wire hsync_in,                              // input horizontal sync
  input wire hblnk_in,                              // input horizontal blink
  input wire [11:0] rgb_in,     
  input wire [7:0] char_pixels,                   

  output reg [10:0] vcount_out,                     // output vertical count
  output reg vsync_out,                             // output vertical sync
  output reg vblnk_out,                             // output vertical blink
  output reg [10:0] hcount_out,                     // output horizontal count
  output reg hsync_out,                             // output horizontal sync
  output reg hblnk_out,                             // output horizontal blink

  output reg [11:0] rgb_out,
  output wire [7:0] char_xy,
  output wire [3:0] char_line
);

  localparam  PIXEL_BIT_NUMBERS = 4'b1000;
  localparam  BLACK = 12'h0_0_0;
  localparam  BG = 12'h1_1_5;
  localparam  COLOR  = 12'h8_f_8;

  localparam RECT_LENGTH = 20;
  localparam RECT_WIDTH = 128; 
  localparam Y_START = 30;
  localparam X_START = 483; 


  wire hsync_nxt, vsync_nxt;
  wire hblnk_nxt, vblnk_nxt;
  wire [10:0] hcount_nxt, vcount_nxt;
  wire [10:0] hcount_text, vcount_text;

  reg [11:0] rgb_nxt;

  
  delay #(.WIDTH(26), .CLK_DEL(1)) my_delay_h_v(
    .clk(pclk),
    .rst(rst),
    .din({hsync_in, vsync_in, hcount_in, vcount_in, hblnk_in, vblnk_in}),
    .dout({hsync_nxt, vsync_nxt, hcount_nxt, vcount_nxt, hblnk_nxt, vblnk_nxt})
  );

    // This is a simple test pattern generator.
  always @(posedge pclk) begin
    if(rst) begin
      hsync_out  <= 1'b0;
      vsync_out  <= 1'b0;

      hcount_out <= 11'b0;
      vcount_out <= 11'b0;
      
      hblnk_out  <= 1'b0;
      vblnk_out  <= 1'b0;

      rgb_out    <= 12'b0;
    end
    else begin
      // Just pass these through.
      hsync_out <= hsync_nxt;
      vsync_out <= vsync_nxt;

      hcount_out <= hcount_nxt;
      vcount_out <= vcount_nxt;

      hblnk_out <= hblnk_nxt;
      vblnk_out <= vblnk_nxt;

      rgb_out   <= rgb_nxt;
    end
  end
 
  always @(*) begin
     if (vblnk_in || hblnk_in) rgb_nxt = BLACK; 
     else begin
       if(vcount_in < RECT_LENGTH + Y_START && vcount_in >= Y_START && hcount_in < RECT_WIDTH + X_START && hcount_in >= X_START) begin
         if(char_pixels[PIXEL_BIT_NUMBERS - hcount_text[2:0]])
           rgb_nxt = COLOR;
         else
           rgb_nxt = BG;
       end
       else begin
         rgb_nxt = rgb_in;
       end
     end
  end

  assign char_addr = {hcount_text[9:3], hcount_text[3:0]};

  assign char_xy = {vcount_text[7:4], hcount_text[6:3]};
  assign char_line = vcount_text[3:0];
  assign vcount_text = vcount_in - Y_START;
  assign hcount_text = hcount_in - X_START;
    
endmodule
// File: vga_background.v
// Author: HM

`timescale 1 ns / 1 ps

 module draw_background (
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire [10:0] vcount_in,                      // input vertical count
    input wire vsync_in,                              // input vertical sync
    input wire vblnk_in,                              // input vertical blink
    input wire [10:0] hcount_in,                      // input horizontal count
    input wire hsync_in,                              // input horizontal sync
    input wire hblnk_in,                              // input horizontal blink

    input wire [3:0] level,

    output reg [10:0] vcount_out,                     // output vertical count
    output reg vsync_out,                             // output vertical sync
    output reg vblnk_out,                             // output vertical blink
    output reg [10:0] hcount_out,                     // output horizontal count
    output reg hsync_out,                             // output horizontal sync
    output reg hblnk_out,                             // output horizontal blink
    output reg [11:0] rgb_out
  );

  reg [11:0] rgb_out_nxt;


  // http://neildowning.com/HEX_to_RGB_color_converter.php to pick colors

  // INFO :main color also shold be chenged in draw_rect_char.v in BG

  localparam BG_MAIN = 12'h1_1_5;

  // color panel for 1 LV
  localparam BG_MAIN_SH_1 = 12'h1_1_8;
  localparam BG_SIDES_STRIP_1 = 12'h0_9_6;
  localparam BG_SIDES_STRIP_SH_1 = 12'h0_6_4;

  // color panel for 2 LV

  localparam BG_MAIN_SH_2 = 12'h0_4_6;
  localparam BG_SIDES_STRIP_2 = 12'ha_7_0;
  localparam BG_SIDES_STRIP_SH_2 = 12'ha_9_0;

  // color panel for 2 LV

  localparam BG_MAIN_SH_3 = 12'h2_0_3;
  localparam BG_SIDES_STRIP_3 = 12'h6_0_9;
  localparam BG_SIDES_STRIP_SH_3 = 12'ha_0_f;

  // This is a simple test pattern generator.
  always @(posedge pclk) begin
    if(rst) begin
      hsync_out  <= 1'b0;
      vsync_out  <= 1'b0;
      hcount_out <= 11'b0;
      vcount_out <= 11'b0;
      rgb_out    <= 12'b0;

      // 2 warnings
      hblnk_out  <= 1'b0;
      vblnk_out  <= 1'b0;

    end
    else begin
      // Just pass these through.
      hsync_out <= hsync_in;
      vsync_out <= vsync_in;

      hblnk_out <= hblnk_in;
      vblnk_out <= vblnk_in;

      hcount_out <= hcount_in;
      vcount_out <= vcount_in;

      rgb_out <= rgb_out_nxt;      
    end
  end

  always@* begin
    if(level == 1) begin
      // During blanking, make it it black.
      if (vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0; 
      else begin
        //side strips
        if ((hcount_in >= 0 && hcount_in < 76)) rgb_out_nxt <= BG_SIDES_STRIP_1;
        else if ((hcount_in >= 948 && hcount_in < 1024)) rgb_out_nxt <= BG_SIDES_STRIP_1;
        //side strips shadows
        else if ((hcount_in >= 76 && hcount_in < 80)) rgb_out_nxt <= BG_SIDES_STRIP_SH_1;
        else if ((hcount_in >= 944 && hcount_in < 948)) rgb_out_nxt <= BG_SIDES_STRIP_SH_1;
        //main shadows
        else if ((hcount_in >= 80 && hcount_in < 84)) rgb_out_nxt <= BG_MAIN_SH_1;
        else if ((hcount_in >= 940 && hcount_in < 944)) rgb_out_nxt <= BG_MAIN_SH_1;
        //main
        else rgb_out_nxt = BG_MAIN;
      end
    end
    else if(level == 2) begin
      // During blanking, make it it black.
      if (vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0; 
      else begin
        //side strips
        if ((hcount_in >= 0 && hcount_in < 76)) rgb_out_nxt <= BG_SIDES_STRIP_2;
        else if ((hcount_in >= 948 && hcount_in < 1024)) rgb_out_nxt <= BG_SIDES_STRIP_2;
        //side strips shadows
        else if ((hcount_in >= 76 && hcount_in < 80)) rgb_out_nxt <= BG_SIDES_STRIP_SH_2;
        else if ((hcount_in >= 944 && hcount_in < 948)) rgb_out_nxt <= BG_SIDES_STRIP_SH_2;
        //main shadows
        else if ((hcount_in >= 80 && hcount_in < 84)) rgb_out_nxt <= BG_MAIN_SH_2;
        else if ((hcount_in >= 940 && hcount_in < 944)) rgb_out_nxt <= BG_MAIN_SH_2;
        //main
        else rgb_out_nxt = BG_MAIN;
      end
    end
    else if(level == 3) begin
      // During blanking, make it it black.
      if (vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0; 
      else begin
        //side strips
        if ((hcount_in >= 0 && hcount_in < 76)) rgb_out_nxt <= BG_SIDES_STRIP_3;
        else if ((hcount_in >= 948 && hcount_in < 1024)) rgb_out_nxt <= BG_SIDES_STRIP_3;
        //side strips shadows
        else if ((hcount_in >= 76 && hcount_in < 80)) rgb_out_nxt <= BG_SIDES_STRIP_SH_3;
        else if ((hcount_in >= 944 && hcount_in < 948)) rgb_out_nxt <= BG_SIDES_STRIP_SH_3;
        //main shadows
        else if ((hcount_in >= 80 && hcount_in < 84)) rgb_out_nxt <= BG_MAIN_SH_3;
        else if ((hcount_in >= 940 && hcount_in < 944)) rgb_out_nxt <= BG_MAIN_SH_3;
        //main
        else rgb_out_nxt = BG_MAIN;
      end
    end
  end

endmodule


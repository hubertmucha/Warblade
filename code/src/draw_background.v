// File: vga_background.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

 module draw_background (
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire [10:0] vcount_in,                      // input vertical count
    input wire vsync_in,                              // input vertical sync
    input wire vblnk_in,                              // input vertical blink
    input wire [10:0] hcount_in,                      // input horizontal count
    input wire hsync_in,                              // input horizontal sync
    input wire hblnk_in,                              // input horizontal blink

    output reg [10:0] vcount_out,                     // output vertical count
    output reg vsync_out,                             // output vertical sync
    output reg vblnk_out,                             // output vertical blink
    output reg [10:0] hcount_out,                     // output horizontal count
    output reg hsync_out,                             // output horizontal sync
    output reg hblnk_out,                             // output horizontal blink
    output reg [11:0] rgb_out
  );

  reg [11:0] rgb_out_nxt;

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
    // During blanking, make it it black.
    if (vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0; 
    else begin
      // Active display, top edge, make a yellow line.
      if (vcount_in == 0) rgb_out_nxt = 12'hf_f_0;
      // Active display, bottom edge, make a red line.
      else if (vcount_in == 599) rgb_out_nxt = 12'hf_0_0;
      // Active display, left edge, make a green line.
      else if (hcount_in == 0) rgb_out_nxt = 12'h0_f_0;
      // Active display, right edge, make a blue line.
      else if (hcount_in == 799) rgb_out_nxt = 12'h0_0_f;
      // Active display, interior, fill with gray.
      
      // N letter display
      else if ((hcount_out < 150 && hcount_in >= 70 && vcount_in <= 500 && vcount_in >= 100)) rgb_out_nxt = 12'h0_8_f;
      else if ((hcount_in < 390 && hcount_in >= 310 && vcount_in <= 500 && vcount_in >= 100)) rgb_out_nxt = 12'h0_8_f;
      else if ((hcount_in < 310 && hcount_in >= 150 && (100*vcount_in+4225)/175 <= hcount_in &&  hcount_in <= (100*vcount_in+16225)/175)) rgb_out_nxt = 12'h0_8_f;
            
      // P letter display
      else if ((hcount_in < 570 && hcount_in >= 490 && vcount_in <= 500 && vcount_in >= 100)) rgb_out_nxt = 12'h0_8_f;
      else if ((hcount_in < 730 && hcount_in >= 570 && vcount_in <= 180 && vcount_in >= 100)) rgb_out_nxt = 12'h0_8_f;
      else if ((hcount_in < 730 && hcount_in >= 570 && vcount_in <= 340 && vcount_in >= 260)) rgb_out_nxt = 12'h0_8_f;
      else if ((hcount_in < 730 && hcount_in >= 650 && vcount_in <= 260 && vcount_in >= 180)) rgb_out_nxt = 12'h0_8_f;
      
      // You will replace this with your own test.
      else rgb_out_nxt = 12'h8_8_8;    
    end
  end

endmodule


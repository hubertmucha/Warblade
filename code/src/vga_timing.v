// File: vga_timing.v
// Author: HM & NP

`timescale 1 ns / 1 ps

 module vga_timing (
  output reg [10:0] vcount,                             // vertical count
  output reg vsync,                                     // vertical sync
  output reg vblnk,                                     // vertical blink
  output reg [10:0] hcount,                             // horizontal count
  output reg hsync,                                     // horizontal sync
  output reg hblnk,                                     // horizontal blink

  input wire pclk,                                      // Peripheral Clock
  input wire rst                                        // Synchrous reset
  );
  
  reg [10:0] vcount_nxt;
  reg [10:0] hcount_nxt;
  reg vsync_nxt;
  reg hsync_nxt;
  reg vblnk_nxt;
  reg hblnk_nxt;
  
  // Parameters
//   localparam HOR_TOTAL_TIME   = 1056;
//   localparam HOR_BLANK_START  = 800;
//   localparam HOR_BLANK_TIME   = 256;
//   localparam HOR_SYNC_START   = 840;
//   localparam HOR_SYNC_TIME    = 128;
  
//   localparam VER_TOTAL_TIME   = 628;
//   localparam VER_BLANK_START  = 600;
//   localparam VER_BLANK_TIME   = 28;
//   localparam VER_SYNC_START   = 601;
//   localparam VER_SYNC_TIME    = 4;


  localparam HOR_TOTAL_TIME   = 1344;
  localparam HOR_BLANK_START  = 1024;
  localparam HOR_BLANK_TIME   = 320;
  localparam HOR_SYNC_START   = 1048;
  localparam HOR_SYNC_TIME    = 136;
  
  localparam VER_TOTAL_TIME   = 806;
  localparam VER_BLANK_START  = 768;
  localparam VER_BLANK_TIME   = 38;
  localparam VER_SYNC_START   = 771;
  localparam VER_SYNC_TIME    = 6;
 

 
  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.
 
//  uncomment for tesbench!!!  
//   initial begin
//     vcount = 11'b0;
//     hcount = 11'b0;
//   end
  
  // next counters logic
always@(posedge pclk) begin
    if(rst) begin
        hcount <= 1'b0;
        vcount <= 1'b0;
        hsync  <= 1'b0;
        vsync  <= 1'b0;
        hblnk  <= 11'b0;
        vblnk  <= 11'b0;
    end
    else begin
        hcount <= hcount_nxt;
        vcount <= vcount_nxt;
        hsync  <= hsync_nxt;
        vsync  <= vsync_nxt;
        hblnk  <= hblnk_nxt;
        vblnk  <= vblnk_nxt;       
    end
end

// next horizontal counter
always@* begin
    if (hcount == HOR_TOTAL_TIME-1)                             
        hcount_nxt = 0;                            // reset horizontal counter
    else 
        hcount_nxt = hcount + 1;                      // keep counting until 1055
    end    

// next vertical counter
always@* begin
    if(hcount == HOR_TOTAL_TIME-1) begin
        if(vcount == VER_TOTAL_TIME-1)
            vcount_nxt = 0;                         // reset vertical counter
        else 
            vcount_nxt = vcount + 1;                  // keep counting until 627
        end
    else
        vcount_nxt = vcount;
    end

  // vsync next and hsync next 
always@* begin
    if(hcount == HOR_TOTAL_TIME-1) begin
        if(vcount >= VER_SYNC_START-1 && vcount < VER_SYNC_START+VER_SYNC_TIME-1)
            vsync_nxt = 1;
        else
            vsync_nxt = 0;
        end
    else
        vsync_nxt = vsync;        
            
    if(hcount >= HOR_SYNC_START-1 && hcount < HOR_SYNC_START+HOR_SYNC_TIME-1)
            hsync_nxt = 1;
        else
            hsync_nxt = 0;
    end       

  // blinking next
always@* begin
    if(hcount == HOR_TOTAL_TIME-1) begin
        if(vcount >= VER_BLANK_START-1 && vcount < VER_TOTAL_TIME-1)
            vblnk_nxt = 1;
        else
            vblnk_nxt = 0;        
        end
    else
        vblnk_nxt = vblnk;
    
    if(hcount >= HOR_BLANK_START-1 && hcount < HOR_TOTAL_TIME-1)
        hblnk_nxt = 1;
    else 
        hblnk_nxt = 0; 
    end   
endmodule

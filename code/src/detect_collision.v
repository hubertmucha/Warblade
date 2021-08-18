// File: vga_background.v
// Author: Natalia Pluta
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

	input wire ship_X,
	input wire ship_Y,
    input wire enBullet_X,
	input wire enBullet_Y,
	
	output wire is_ship_display
  );

  localparam X_WIDTH = 10;
  reg is_ship_display_nxt;

  // This is a simple test pattern generator.
  always @(posedge pclk) begin
    if(rst) begin
      is_ship_display  <= 1'b1;
    end
    else begin
      // Just pass these through.
      is_ship_display <= is_ship_display_nxt;    
    end
  end

  always@* begin
	if(enBullet_X >= (ship_X - X_WIDTH) && enBullet_X <= (ship_X + X_WIDTH) && enBullet_Y == ship_Y)
		is_ship_display_nxt = 1'b0;
	else
		is_ship_display_nxt = is_ship_display;
  end

endmodule

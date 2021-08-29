// File: vga_background.v
// Author: Natalia Pluta
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

 module detect_collision (
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

	input wire [10:0] ship_X,
	// input wire [10:0] ship_Y,
  input wire [10:0] enBullet_X_1,
	input wire [10:0] enBullet_Y_1,
  input wire [10:0] enBullet_X_2,
	input wire [10:0] enBullet_Y_2,
  input wire [10:0] enBullet_X_3,
	input wire [10:0] enBullet_Y_3,
	
	output reg is_ship_display
  );

  localparam Y_SHIP = 680;
  localparam HALF_SHIP_WIDTH = 24;
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
	if(enBullet_X_1 >= (ship_X - HALF_SHIP_WIDTH) && enBullet_X_1 <= (ship_X + HALF_SHIP_WIDTH) && enBullet_Y_1 == Y_SHIP)
		is_ship_display_nxt = 1'b0;
	else if(enBullet_X_2 >= (ship_X - HALF_SHIP_WIDTH) && enBullet_X_2 <= (ship_X + HALF_SHIP_WIDTH) && enBullet_Y_2 == Y_SHIP)
		is_ship_display_nxt = 1'b0;
	else if(enBullet_X_3 >= (ship_X - HALF_SHIP_WIDTH) && enBullet_X_3 <= (ship_X + HALF_SHIP_WIDTH) && enBullet_Y_3 == Y_SHIP)
		is_ship_display_nxt = 1'b0;
	else
		is_ship_display_nxt = is_ship_display;
  end

endmodule


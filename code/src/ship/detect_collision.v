// File: detect_collision.v
// Author: Natalia Pluta
// This module is detecting collison ship with enemy missile and turn him off

`timescale 1 ns / 1 ps

 module detect_collision (
  input wire pclk,                                  // Peripheral Clock
  input wire rst,                                   // Synchrous reset

	input wire [10:0] ship_X,
  input wire [10:0] enBullet_X_1,
	input wire [10:0] enBullet_Y_1,

  input wire [10:0] enBullet_X_2,
	input wire [10:0] enBullet_Y_2,

  input wire [10:0] enBullet_X_3,
	input wire [10:0] enBullet_Y_3,
	
  input wire [10:0] enBullet_X_4,
	input wire [10:0] enBullet_Y_4,
	
  input wire [10:0] enBullet_X_5,
	input wire [10:0] enBullet_Y_5,
	
	output reg is_ship_dead
  );

  localparam Y_SHIP = 680;
  localparam HALF_SHIP_WIDTH = 24;

  reg is_ship_dead_nxt;
  localparam SHIP_ALIVE = 1'b0;
  localparam SHIP_SHOOT_DOWN = 1'b1;

  // This is a simple test pattern generator.
  always @(posedge pclk) begin
    if(rst) begin
      is_ship_dead <= SHIP_ALIVE;
    end
    else begin
      // Just pass these through.
      is_ship_dead <= is_ship_dead_nxt;    
    end
  end

  // TODO: y <- enBullet should can shoot down ship on his all height.
  always@* begin
	if(enBullet_X_1 >= (ship_X - HALF_SHIP_WIDTH) && enBullet_X_1 <= (ship_X + HALF_SHIP_WIDTH) && enBullet_Y_1 == Y_SHIP)
		is_ship_dead_nxt = SHIP_SHOOT_DOWN;
	else if(enBullet_X_2 >= (ship_X - HALF_SHIP_WIDTH) && enBullet_X_2 <= (ship_X + HALF_SHIP_WIDTH) && enBullet_Y_2 == Y_SHIP)
		is_ship_dead_nxt = SHIP_SHOOT_DOWN;
	else if(enBullet_X_3 >= (ship_X - HALF_SHIP_WIDTH) && enBullet_X_3 <= (ship_X + HALF_SHIP_WIDTH) && enBullet_Y_3 == Y_SHIP)
		is_ship_dead_nxt = SHIP_SHOOT_DOWN;
	else if(enBullet_X_4 >= (ship_X - HALF_SHIP_WIDTH) && enBullet_X_4 <= (ship_X + HALF_SHIP_WIDTH) && enBullet_Y_4 == Y_SHIP)
		is_ship_dead_nxt = SHIP_SHOOT_DOWN;
	else if(enBullet_X_5 >= (ship_X - HALF_SHIP_WIDTH) && enBullet_X_5 <= (ship_X + HALF_SHIP_WIDTH) && enBullet_Y_5 == Y_SHIP)
		is_ship_dead_nxt = SHIP_SHOOT_DOWN;
	else
		is_ship_dead_nxt = SHIP_ALIVE;
  end

endmodule


// File: game_over.v
// Author: HM

`timescale 1 ns / 1 ps

module game_over
(
  input wire pclk,
  input wire rst,
  input wire [3:0] dead_counter_1,
  input wire [3:0] dead_counter_2,
  output reg game_over
);

  localparam N = 2;
  reg game_over_nxt;

  always @(posedge pclk) begin
    if(rst) begin
      game_over <= 1'b0;
    end
    else begin
      game_over <= game_over_nxt;
    end
  end

  always @* begin
    if (dead_counter_1 >= N && dead_counter_2 >= N) begin
      game_over_nxt = 1'b1;
    end
    else begin
      game_over_nxt = 1'b0;
    end
  end
endmodule
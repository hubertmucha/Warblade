// File: unlocked.v
// Author: Natalia Pluta
// Date: 4.09.2021r.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module unlocked(
  input wire pclk,
  input wire rst,
  input wire [3:0] signal_counter,

  output reg unlocked_signal
);

localparam N = 3;
reg unlocked_signal_nxt; 

always @(posedge pclk) begin
  if(rst) begin
    unlocked_signal <= 1'b0;
  end
  else begin
    unlocked_signal <= unlocked_signal_nxt;
  end
end

always @* begin
  if(signal_counter < N) begin
    unlocked_signal_nxt = 1'b1;
  end
  else begin
    unlocked_signal_nxt = 1'b0;
  end
end

endmodule
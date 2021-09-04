// File: signal_counter.v
// Author: Natalia Pluta
// Date: 3.09.2021r.
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module signal_counter(
  input wire pclk,
  input wire rst,
  input wire signal,

  output reg [3:0] signal_counter
);

reg [3:0] signal_counter_nxt; 

always @(posedge pclk) begin
  if(rst) begin
    signal_counter <= 4'b0;
  end
  else begin
    signal_counter <= signal_counter_nxt;
  end
end

always @(posedge signal) begin
  signal_counter_nxt = signal_counter + 1;
end

endmodule
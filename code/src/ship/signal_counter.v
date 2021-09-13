// File: signal_counter.v
// Author: NP
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

localparam IDLE = 2'b00;
localparam INCREMENT = 2'b01;
localparam SIGNAL_ON = 2'b10;

reg [3:0] signal_counter_nxt;
reg [1:0] state, next_state; 

always @(posedge pclk) begin
  if(rst) begin
    signal_counter <= 4'b0;
    state <= IDLE;
  end
  else begin
    signal_counter <= signal_counter_nxt;
    state <= next_state;
  end
end

// ---------------------------------------
// next state logic
always @(state or signal) begin
  case(state)
    IDLE: begin
      if(signal) begin
        next_state <= INCREMENT;
      end
      else begin
        next_state <= IDLE;
      end
    end
    INCREMENT: begin
      next_state <= SIGNAL_ON;
    end
    SIGNAL_ON: begin
      if(signal) begin
        next_state <= SIGNAL_ON;
      end
      else begin
        next_state <= IDLE;
      end
    end
  endcase
end

  // ---------------------------------------
  // output logic direct output definitions
  always @* begin
    case(state)
      IDLE: begin
        signal_counter_nxt = signal_counter;
      end
      INCREMENT: begin
        signal_counter_nxt = signal_counter + 1;
      end
      SIGNAL_ON: begin
        signal_counter_nxt = signal_counter;
      end
    endcase
  end

endmodule
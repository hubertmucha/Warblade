// File: lock_signal.v 
// Author: NPL
// Date: 29.08.2021r.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// This module is locking signal !locked. Signal is being locked untill rst or unlocked.

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module locked_signal (    
  input wire pclk,
  input wire rst,                                
  input wire locked,
  input wire unlocked,

  output reg locked_out                                     
);
  
  reg locked_out_nxt;
  reg [1:0] state, next_state;

  localparam IDLE = 2'b00;
  localparam LOCKED_STATE = 2'b01;

  always @(posedge pclk) begin
    if(rst) begin
      locked_out <= 1'b0;
      state <= IDLE;
    end
    else begin
      locked_out <= locked_out_nxt;
      state <= next_state;
    end
  end

  // ---------------------------------------
  // next state logic
  always @(state or locked or unlocked) begin
    case(state)
      IDLE: begin
          next_state = locked ? LOCKED_STATE : IDLE;
      end
      LOCKED_STATE: begin
        next_state = unlocked ? IDLE : LOCKED_STATE;
      end
    endcase
  end

  // ---------------------------------------
  // output logic direct output definitions
  always @* begin
    case(state)
      IDLE: begin
        locked_out_nxt <= 1'b0;
      end
      LOCKED_STATE: begin
        locked_out_nxt <= 1'b1;
      end
    endcase
  end

endmodule
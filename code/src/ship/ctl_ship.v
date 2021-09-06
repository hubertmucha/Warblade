// File: ctl_ship.v
// Author: HEHE
// This module is genereating xpos_out by calculating inputs form keyboard

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module position_rect_ctl (
    input wire pclk,
    input wire rst,

    input wire left,
    input wire right,

    output reg [10:0] xpos_out
);
  localparam IDLE = 2'b00;
  localparam LEFT = 2'b01;
  localparam RIGHT = 2'b10;

  localparam WIDTH_RECT   = 48;                    
  localparam HEIGHT_RECT  = 64;
  localparam COUNTER_LIMIT = 30000;
  localparam DISPLAY_WIDTH_MIN = 80;
  localparam DISPLAY_WIDTH_MAX = 944 - WIDTH_RECT;

  reg [1:0] state, next_state;
  reg [10:0] xpos_nxt;
  reg [20:0] refresh_counter, refresh_counter_nxt;


// ---------------------------------------
// state register
  always @(posedge pclk) begin
    if(rst) begin
      state <= IDLE;
      xpos_out <= 512;
      refresh_counter <= 21'b0;
    end
    else begin
      state <= next_state;
      xpos_out <= xpos_nxt;
      refresh_counter <= refresh_counter_nxt;
    end
  end

// ---------------------------------------
// next state logic
  always @(state or left or right) begin
    case(state)
      IDLE: begin
        if(left)
          next_state = LEFT;
        else if(right)
          next_state = RIGHT;
        else
          next_state = IDLE;
      end
      LEFT: next_state = left ? LEFT : IDLE;
      RIGHT: next_state = right ? RIGHT : IDLE; 
      default:
        next_state = IDLE;
    endcase
  end

// ---------------------------------------
// output logic direct output definitions
  always @* begin
    case (state)
      IDLE: begin
        refresh_counter_nxt = refresh_counter;
        xpos_nxt = xpos_out;
      end

      LEFT: begin
        if(refresh_counter == COUNTER_LIMIT) begin
          refresh_counter_nxt = 0;
          if(xpos_out > DISPLAY_WIDTH_MIN) begin
            xpos_nxt = xpos_out - 1;
          end
          else begin
            xpos_nxt = DISPLAY_WIDTH_MIN;
          end
        end
        else begin
          refresh_counter_nxt = refresh_counter + 1;
          xpos_nxt = xpos_out;
        end
      end
      
        RIGHT: begin
        if(refresh_counter == COUNTER_LIMIT) begin
          refresh_counter_nxt = 0;
          if(xpos_out < DISPLAY_WIDTH_MAX) begin
            xpos_nxt = xpos_out + 1;   
          end
          else begin
            xpos_nxt = DISPLAY_WIDTH_MAX;
          end
        end
        else begin
          refresh_counter_nxt = refresh_counter + 1;
          xpos_nxt = xpos_out;
        end
      end

      default: begin
        xpos_nxt = xpos_out;
        refresh_counter_nxt = refresh_counter;
      end
    endcase
  end
endmodule
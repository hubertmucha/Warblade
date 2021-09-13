// File: ctl_ship.v
// Author: NP
// This module is genereating xpos_out by calculating inputs form keyboard

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module position_rect_ctl
    #( parameter
        RESET_X_POS = 0
    )(
    input wire pclk,
    input wire rst,

    input wire dead_s,
    input wire left,
    input wire right,

    output reg [10:0] xpos_out
);
  localparam IDLE = 3'b000;
  localparam LEFT = 3'b001;
  localparam RIGHT = 3'b010;
  localparam DEAD = 3'b011;
  localparam START_POSITION = 3'b100;

  localparam WIDTH_RECT   = 83;         // TODO: change to param            
  localparam HEIGHT_RECT  = 64;
  localparam COUNTER_LIMIT = 30000;
  localparam DISPLAY_WIDTH_MIN = 80;
  localparam DISPLAY_WIDTH_MAX = 944 - WIDTH_RECT;

  reg [2:0] state, next_state;
  reg [10:0] xpos_nxt;
  reg [20:0] refresh_counter, refresh_counter_nxt;


// ---------------------------------------
// state register
  always @(posedge pclk) begin
    if(rst) begin
      state <= IDLE;
      xpos_out <= RESET_X_POS;
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
  always @(state or left or right or dead_s) begin
    case(state)
      IDLE: begin
        if(dead_s)
          next_state = DEAD;
        else if(left)
          next_state = LEFT;
        else if(right)
          next_state = RIGHT;
        else
          next_state = IDLE;
      end
      LEFT: next_state = left ? LEFT : IDLE;
      RIGHT: next_state = right ? RIGHT : IDLE;
      DEAD: next_state = START_POSITION;
      START_POSITION: next_state = IDLE; 
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
      
    DEAD: begin
      xpos_nxt = 0;
      refresh_counter_nxt = refresh_counter;
    end

    START_POSITION: begin
      xpos_nxt = RESET_X_POS;
      refresh_counter_nxt = refresh_counter;
    end

      default: begin
        xpos_nxt = xpos_out;
        refresh_counter_nxt = refresh_counter;
      end
    endcase
  end
endmodule
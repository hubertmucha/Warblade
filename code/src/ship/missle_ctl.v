// File: missle_ctl.v
// This module draw a rectangle on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module missle_ctl (
    input wire pclk,
    input wire rst,
    input wire [11:0] xpos_in,
    input wire missle_button,
    
    output reg [11:0] ypos_out,
    output reg [11:0] xpos_out,
    output reg on_out
);
  localparam IDLE = 2'b00;
  localparam SHOOT = 2'b01;
  localparam MISSLE_FLY = 2'b10;

  localparam WIDTH_RECT   = 48;                    
  localparam HEIGHT_RECT  = 64;
  localparam COUNTER_LIMIT = 90000;         
  localparam MISSLE_HEIGHT_MIN = 80;                   // TODO: change height of minimum (up limit) ypos of missle 
  localparam MISSLE_HEIGHT_MAX = 768 - HEIGHT_RECT;

  reg on_out_nxt;
  reg [1:0] state, next_state;
  reg [11:0] ypos_nxt, xpos_nxt;
  reg [20:0] refresh_counter, refresh_counter_nxt;


// ---------------------------------------
// state register
  always @(posedge pclk) begin
    if(rst) begin
      state <= IDLE;
      ypos_out  <= MISSLE_HEIGHT_MAX;
      refresh_counter <= 21'b0;
      on_out <= 0;
      xpos_out <= 0;                              // TODO: change to the middle of a screen   
    end
    else begin
    state <= next_state;
    ypos_out <= ypos_nxt;
    xpos_out <= xpos_nxt;
    refresh_counter <= refresh_counter_nxt;
    on_out <= on_out_nxt;      
    end
  end

// ---------------------------------------
// next state logic
  always @(state or missle_button) begin
    case(state)
      IDLE: next_state = missle_button ? SHOOT : IDLE;
      SHOOT: next_state = MISSLE_FLY;
      MISSLE_FLY: begin
        if(ypos_out <= MISSLE_HEIGHT_MIN) begin
          next_state = IDLE;
        end
        else begin
          next_state = MISSLE_FLY;
        end
      end
      default:
        next_state = IDLE;
    endcase
  end

// ---------------------------------------
// output logic direct output definitions
  always @* begin
    case(state)
      MISSLE_FLY:
        begin
          on_out_nxt = 1; 
          xpos_nxt = xpos_out;
          if(refresh_counter == COUNTER_LIMIT) begin
            refresh_counter_nxt = 0;
            ypos_nxt = ypos_out - 1;
          end
          else begin
            refresh_counter_nxt = refresh_counter + 1;
            ypos_nxt = ypos_out;
          end 
        end

      SHOOT:
        begin
          on_out_nxt = 1;
          ypos_nxt = MISSLE_HEIGHT_MAX;
          xpos_nxt = xpos_in;  
          refresh_counter_nxt = refresh_counter;
        end

      IDLE:
        begin
          xpos_nxt = xpos_out;
          on_out_nxt = 0; 
          ypos_nxt = MISSLE_HEIGHT_MAX;
          refresh_counter_nxt = refresh_counter;
        end

      default:        
        begin
          xpos_nxt = xpos_out;
          on_out_nxt = on_out; 
          ypos_nxt = ypos_out;
          refresh_counter_nxt = refresh_counter;
        end
      endcase
  end

endmodule


      

// File: ctl_missile_en.v
// Author: HM
// This module generate x, y and on for missile for one enemy

`timescale 1 ns / 1 ps

module ctl_missile_en (
    input wire pclk,
    input wire rst,
    input wire [10:0] xpos_in,
    input wire [10:0] ypos_in,
    input wire missle_button,
    input wire enemy_lives,

    output reg [10:0] ypos_out,
    output reg [10:0] xpos_out,
    output reg on_out
);
  localparam IDLE = 2'b00;
  localparam SHOOT = 2'b01;
  localparam MISSLE_FLY = 2'b10;


  localparam START_OFFSET = 10;
  localparam WIDTH_RECT   = 48;                    
  localparam HEIGHT_RECT  = 64;
  localparam COUNTER_LIMIT = 90000;         
  localparam MISSLE_HEIGHT_MIN = 80;                   
  localparam MISSLE_HEIGHT_MAX = 768;

  reg on_out_nxt;
  reg [1:0] state, next_state;
  reg [10:0] ypos_nxt, xpos_nxt;
  reg [20:0] refresh_counter, refresh_counter_nxt;


// ---------------------------------------
// state register
  always @(posedge pclk) begin
    if(rst) begin
      state <= IDLE;
      ypos_out  <= ypos_in;             
      refresh_counter <= 21'b0;
      on_out <= 0;
      xpos_out <= 0;                                
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
  always @(state or missle_button or enemy_lives or ypos_out) begin
    case(state)
      IDLE:begin
              if (missle_button && enemy_lives) begin
                  next_state = SHOOT;
              end
              else begin
                  next_state = IDLE;
              end
            end
      SHOOT: next_state = MISSLE_FLY;
      MISSLE_FLY: begin
        if(ypos_out >= MISSLE_HEIGHT_MAX) begin
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
          xpos_nxt = xpos_out;
          on_out_nxt = 1; 
          if(refresh_counter == COUNTER_LIMIT) begin
            refresh_counter_nxt = 0;
            ypos_nxt = ypos_out + 1;
          end
          else begin
            refresh_counter_nxt = refresh_counter + 1;
            ypos_nxt = ypos_out;
          end 
        end

      SHOOT:
        begin
          on_out_nxt = 1;
          ypos_nxt = ypos_in;       
          refresh_counter_nxt = refresh_counter;
          xpos_nxt = xpos_in;  
        end

      IDLE:
        begin
          on_out_nxt = 0; 
          ypos_nxt = ypos_in;
          refresh_counter_nxt = refresh_counter;
          xpos_nxt = xpos_out;
        end

      default:        
        begin
          on_out_nxt = on_out; 
          ypos_nxt = ypos_out;
          refresh_counter_nxt = refresh_counter;
          xpos_nxt = xpos_out;
        end
      endcase
  end

endmodule
// File: draw_rect_ctl.v
// This module draw a rectangle on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module draw_rect_ctl (
    input wire pclk,
    input wire rst,

    input wire mouse_left,
    input wire [11:0] mouse_xpos,
    input wire [11:0] mouse_ypos,

    output reg [11:0] xpos,
    output reg [11:0] ypos
);
  localparam IDLE = 2'b00;
  localparam RESET = 2'b01;
  localparam LEFT_DOWN = 2'b10;
  localparam LEFT_UP = 2'b11;

  localparam DISPLAY_HEIGHT = 600;
  localparam WIDTH_RECT   = 48;                    
  localparam HEIGHT_RECT  = 64;
  localparam CLK = 40000000;            // freq_clk = 40MHz 
  localparam REFRESH_RATE = 60;         // Screen refreshing = 60Hz
  localparam COUNTER = (CLK/REFRESH_RATE);
  localparam ACCELERATION_NOMINATOR = 981;
  localparam ACCELERATION_DENOMINATOR = 100; 

  reg [1:0] state, next_state;
  reg [11:0] xpos_nxt, ypos_nxt;
  reg [11:0] ypos_tmp, ypos_tmp_nxt;
  reg [11:0] ypos_zero, ypos_zero_nxt; 

           

  reg [40:0] time_elapsed, time_elapsed_nxt;         // falling time 
  reg [20:0] refresh_counter, refresh_counter_nxt;


// ---------------------------------------
// state register

  always @(posedge pclk) begin
    state <= next_state;
    xpos  <= xpos_nxt;
    ypos  <= ypos_nxt;
    ypos_tmp <= ypos_tmp_nxt;

    refresh_counter <= refresh_counter_nxt;
    time_elapsed <= time_elapsed_nxt; 
    ypos_zero <= ypos_zero_nxt;
  end

// ---------------------------------------
// next state logic
  always @(state or rst or mouse_left) begin
    case(state)
      IDLE:
        begin
          if(rst) begin
            next_state = RESET;
          end
          else begin
            if(mouse_left)
              next_state = LEFT_DOWN;
            else begin
              next_state = IDLE;
            end
          end
        end
      LEFT_DOWN: next_state = mouse_left ? LEFT_DOWN : LEFT_UP;
      LEFT_UP: next_state = IDLE;
      RESET: next_state = rst ? RESET : IDLE;
      default:
        next_state = IDLE;
    endcase
  end

  always @* begin
    case(state)
      RESET:
        begin
          xpos_nxt = 12'b0;
          ypos_nxt = 12'b0;
          ypos_tmp_nxt = 12'b0;
          ypos_zero_nxt = 12'b0;
          time_elapsed_nxt = 8'b0;
        end

      LEFT_DOWN:
        begin
          xpos_nxt = mouse_xpos;
          ypos_zero_nxt = ypos_zero;
          if(refresh_counter == COUNTER) begin
            refresh_counter_nxt = 0;
            time_elapsed_nxt = time_elapsed + 1;
            if(ypos_tmp < DISPLAY_HEIGHT - HEIGHT_RECT - 1) begin
              // position is counted with the acceleration equal to 981/100 pixel per s^2
              ypos_tmp_nxt = ypos_zero + (((time_elapsed*time_elapsed)*(ACCELERATION_NOMINATOR/ACCELERATION_DENOMINATOR))/(2*REFRESH_RATE*REFRESH_RATE));
              ypos_nxt = ypos_tmp;
            end
            else begin
              ypos_nxt = DISPLAY_HEIGHT - HEIGHT_RECT - 1;
              ypos_tmp_nxt = DISPLAY_HEIGHT - HEIGHT_RECT - 1;
            end
          end
          else begin
            refresh_counter_nxt = refresh_counter + 1;
            ypos_tmp_nxt = ypos_tmp;
            ypos_nxt = ypos_tmp;
          end 
        end

      LEFT_UP:
        begin
          ypos_zero_nxt = mouse_ypos;
          time_elapsed_nxt = 0;
          ypos_tmp_nxt = mouse_ypos; 
          xpos_nxt = mouse_xpos;
          ypos_nxt = mouse_ypos;
        end

      IDLE:
        begin
          ypos_zero_nxt = mouse_ypos;
          ypos_tmp_nxt = mouse_ypos; 
          xpos_nxt = mouse_xpos;
          ypos_nxt = mouse_ypos;
        end

      default:        
        begin
          ypos_zero_nxt = mouse_ypos;
          ypos_tmp_nxt = mouse_ypos; 
          xpos_nxt = mouse_xpos;
          ypos_nxt = mouse_ypos;
        end

      endcase
  end

endmodule


      


// File: level.v
// Author: HM

module level(
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire lives_1, 
    input wire lives_2, 
    input wire lives_3,
    input wire lives_4,
    input wire lives_5,

    output reg [3:0] level,
    output reg level_up_out
  );

    localparam IDLE = 2'b00;
    localparam LEVEL_UP = 2'b01;
    localparam RESET = 2'b10;
    localparam HOLD = 2'b11;

    localparam COUNTER_LIMIT = 100000000;
      
    reg [1:0] state, state_nxt;

    reg [3:0] level_nxt = 1;
    //reg [3:0] level_nxt_machine = 1;

    reg level_up_out_nxt;
    reg [32:0] refresh_counter, refresh_counter_nxt = 0;

// ---------------------------------------
// state register
  always @(posedge pclk) begin
    if(rst) begin
        state <= IDLE;
        level <= 1;
        level_up_out <= 0;
        refresh_counter <= 0;      
    end
    else begin
        state <= state_nxt;
        level <= level_nxt;
        level_up_out <= level_up_out_nxt;
        refresh_counter <= refresh_counter_nxt;
    end
  end

// ---------------------------------------
// next state logic
  always @(lives_1 or lives_2 or lives_3 or lives_4 or lives_5 or state or refresh_counter) begin
    case(state)
      IDLE: begin
                //refresh_counter_nxt = refresh_counter;
                if( (!lives_1) && (!lives_2) && (!lives_3) && (!lives_4) && (!lives_5)) begin
                //if((!lives_5)) begin // for developing purpose
                    state_nxt = LEVEL_UP;
                end
                else begin
                    state_nxt = IDLE;
                end
                refresh_counter_nxt = 0;
            end
      LEVEL_UP: begin
            refresh_counter_nxt = 0;
            state_nxt = HOLD;
       end
      HOLD: begin
          if(refresh_counter >= COUNTER_LIMIT) begin
            refresh_counter_nxt = 0;
            state_nxt = RESET;
          end
          else begin
            refresh_counter_nxt = refresh_counter + 1;
            state_nxt = HOLD;
            end
       end
      RESET: begin
          if(refresh_counter >= 100) begin
            refresh_counter_nxt = 0;
            state_nxt = IDLE;
          end
          else begin
            refresh_counter_nxt = refresh_counter + 1;
            state_nxt = RESET;
          end
       end
      default: begin
        state_nxt = IDLE;
        refresh_counter_nxt = refresh_counter;
      end  

    endcase
  end

// ---------------------------------------
// output logic direct output definitions
  always @(*) begin
    case(state)
        IDLE: begin
            level_nxt = level; 
            level_up_out_nxt = 0;
        end
        LEVEL_UP: begin
            level_nxt = level + 1;
            level_up_out_nxt = 0;
        end
        HOLD: begin
            level_nxt = level;
            level_up_out_nxt = 1;
        end
        RESET: begin
            level_nxt = level;
            level_up_out_nxt = 1;
        end
        default: begin
            level_nxt = level; 
            level_up_out_nxt = 0;
        end  
      endcase
  end
endmodule
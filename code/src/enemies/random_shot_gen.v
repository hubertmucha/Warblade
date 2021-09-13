// File: random_shoot_gen.v
// Author: HM

`timescale 1 ns / 1 ps

module random_shoot_gen
(
    input wire pclk,
    input wire rst,

    output reg on
);

    // same like enemy/draw_enemy.v remeber to change 
    localparam COUNTER_LIMIT = 3000;           
    //localparam COUNTER_LIMIT = 1000000;       // for test purpose    

    // sates of machine
    localparam IDLE = 2'b00;
    localparam SHOT = 2'b01;
    localparam WAIT = 2'b10;

    reg [1:0] state = 0;
    reg [1:0] state_nxt = 0; // mact form ON sattehine star
    reg on_nxt = 0;
    reg [25:0] counter = 0;
    reg [25:0] counter_nxt = 0;

    reg [25:0] s_time = 0;
    reg [25:0] s_time_nxt = 0; 

    reg [6:0] rd = 0;
    reg [6:0] rd_nxt = 0; 

// ---------------------------------------
// state register

  always @(posedge pclk) begin
      state <= state_nxt;
      on <= on_nxt;
      counter <= counter_nxt;
      rd <= $urandom%20;
      s_time <= s_time_nxt;
  end

// ---------------------------------------
// next state logic
  always @(state or counter or s_time) begin
    case(state)
      IDLE:begin
        if(counter >= COUNTER_LIMIT) begin
            state_nxt = SHOT;
            counter_nxt = 0;
        end
        else begin
            state_nxt = IDLE;
            counter_nxt = counter + 1;
        end
      end
      SHOT:begin
        counter_nxt = 0;
        if (rd > 1)begin
          state_nxt = WAIT;
        end
        else begin
          state_nxt = IDLE;
        end   
      end
      WAIT:begin // to provide enaught widht on on signal
        if(s_time >= 20) begin
            state_nxt = IDLE;
            s_time_nxt = 0;
        end
        else begin
            state_nxt = WAIT;
            s_time_nxt = s_time + 1;
        end  
      end
    endcase
  end

  always @* begin
    case(state)
      IDLE:
        begin
            on_nxt = 0;
        end
      SHOT:
        begin
            on_nxt = 0;
        end
      WAIT:
        begin
            on_nxt = 1;
        end
    endcase
  end
endmodule

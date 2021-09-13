// File: detec_col.v
// Author: HM
// This module is detecting colision enemy with ship missile and turns off enemy
// drawing when he die

module detec_col
    #( parameter
        N = 1 // number of enemy
    )(
    input wire pclk,
    input wire rst,

    input wire [10:0] xpos_missile_1,
    input wire [10:0] ypos_missile_1,
 
    input wire [10:0] xpos_missile_2,
    input wire [10:0] ypos_missile_2,
            
    input wire level_change,

    input wire [10:0] xpos_enemy,
    input wire [10:0] ypos_enemy,

    output reg on_out 
);

    // same like enemy/draw_enemy.v remeber to change 
    localparam HALF_WIDTH_ENEMY = 25; // 50/2 = 25           
    localparam HEIGHT_ENEMY  = 50;

    // sates of machine
    localparam ON = 1'b0;
    localparam OFF = 1'b1;

    reg state, state_nxt = 0; // machine start form ON satte
    reg on_nxt = 1;

// ---------------------------------------
// state register

  always @(posedge pclk) begin
    state  <= state_nxt;
    on_out <= on_nxt;
  end

// ---------------------------------------
// next state logic
  always @(state or rst or level_change or xpos_enemy or ypos_enemy or xpos_missile_1 or ypos_missile_1 or xpos_missile_2 or ypos_missile_2 ) begin
    case(state)
      ON:
        begin
            if(rst) begin
                state_nxt = ON;
            end
            else begin
                // && xpos_missile >= xpos_enemy + WIDTH_ENEMY
                if( (xpos_enemy - HALF_WIDTH_ENEMY <= xpos_missile_1 && xpos_missile_1 <= xpos_enemy + HALF_WIDTH_ENEMY && ypos_missile_1 <= ypos_enemy + HEIGHT_ENEMY && ypos_missile_1 >= ypos_enemy)
                || (xpos_enemy - HALF_WIDTH_ENEMY <= xpos_missile_2 && xpos_missile_2 <= xpos_enemy + HALF_WIDTH_ENEMY && ypos_missile_2 <= ypos_enemy + HEIGHT_ENEMY && ypos_missile_2 >= ypos_enemy)
                ) begin
                    state_nxt = OFF;
                end
                else begin
                    state_nxt = ON;
                end
            end
        end
      OFF:
        begin
            if(rst || level_change) begin
                state_nxt = ON;
            end
            else begin
                state_nxt = OFF;
            end
        end
    endcase
  end

  always @* begin
    case(state)
      ON:
        begin
            on_nxt = 1;
        end
      OFF:
        begin
            on_nxt = 0;
        end
    endcase
  end

endmodule

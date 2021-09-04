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
    localparam END = 2'b10;
    //localparam CONTER = 10000;
      
    reg [1:0] state, state_nxt;

    reg [3:0] level_nxt = 1;
    reg [3:0] level_nxt_machine = 1;

    reg level_up_out_nxt;

// ---------------------------------------
// state register
  always @(posedge pclk) begin
    if(rst) begin
        state <= IDLE;
        level <= 1;
        level_up_out <= 0;      
    end
    else begin
        state <= state_nxt;
        level <= level_nxt;
        level_up_out <= level_up_out_nxt;
    end
  end

// ---------------------------------------
// next state logic
  always @(lives_1 or lives_2 or lives_3 or lives_4 or lives_5) begin
    case(state)
      IDLE: begin
                if( (!lives_1) && (!lives_2) && (!lives_3) && (!lives_4) && (!lives_5)) begin
                //if((!lives_5)) begin // for developing purpose
                    state_nxt = LEVEL_UP;
                end
                else begin
                    state_nxt = IDLE;
                end
            end
      LEVEL_UP: begin
           state_nxt = END;
       end
      END: begin
           state_nxt = END;
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
            level_nxt_machine = level + 1;
        end
        LEVEL_UP: begin
            level_nxt = level_nxt_machine;
            level_up_out_nxt = 1;
        end
        END: begin
            level_nxt = level;
            level_up_out_nxt = 0;
        end  
      endcase
  end

endmodule
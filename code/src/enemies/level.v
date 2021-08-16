 module level(
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire lives_1, 
    input wire lives_2, 
    input wire lives_3,

    output reg [3:0] level,
    output reg level_change
  );

    localparam IDLE = 2'b00;
    localparam LEVEL_UP = 2'b01;
      
    reg [1:0] state, state_nxt;

    reg [3:0] level_nxt = 1;
    reg level_change_nxt;

// ---------------------------------------
// state register
  always @(posedge pclk) begin
    if(rst) begin
        state <= IDLE;
        level <= 1;
        level_change <= 0;      
    end
    else begin
        state <= state_nxt;
        level <= level_nxt;
        level_change <= level_change_nxt;
    end
  end

// ---------------------------------------
// next state logic
  always @(state) begin
    case(state)
      IDLE: begin
                if( (!lives_1) && (!lives_1) && (!lives_1)) begin
                    state_nxt = LEVEL_UP;
                end
                else begin
                    state_nxt = IDLE;
                end
            end
       LEVEL_UP: begin
           state_nxt = IDLE;
       end 

    endcase
  end

// ---------------------------------------
// output logic direct output definitions
  always @* begin
    case(state)
        IDLE: begin
            level_change_nxt = 0;
        end
        LEVEL_UP: begin
            level_change_nxt = 1;
            level_nxt = level + 1;
        end 
      endcase
  end

endmodule
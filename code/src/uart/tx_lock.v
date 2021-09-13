// File: tx_lock.v
// Author: NP

`timescale 1 ns / 1 ps

module tx_lock(
  input wire pclk,
  input wire [7:0] data_in,
  output reg tx_start,
  output reg [7:0] data_out
);

  localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam LOCKED = 2'b10;

  localparam COUNTER_LIMIT = 28700;           // 28646
  reg [7:0] temp_data;
  reg [1:0] state, next_state;
  reg [14:0] counter, next_counter;

  always @(posedge pclk) begin
    state <= next_state;
    counter <= next_counter;
    data_out <= temp_data;
  end

  always @(state or counter) begin
    case(state)
      IDLE: begin
        next_state = START;
      end
      START: begin
        next_state = LOCKED;
      end
      LOCKED: begin
        if(counter > COUNTER_LIMIT) begin
          next_state = IDLE;
        end
        else begin 
          next_state = LOCKED;
        end
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

  always @* begin
    next_counter = counter;             // TODO: rozwiazanie infering latcha
    temp_data = data_out;
    case(state)
      IDLE: begin
        tx_start = 1'b0;
        next_counter = 15'b0;
      end
      START: begin
        tx_start = 1'b1;
        temp_data = data_in;
        next_counter = 15'b0;
      end
      LOCKED: begin
        tx_start = 1'b0;
        next_counter = counter + 1;
      end
      default: begin
        tx_start = 1'b0;
      end
    endcase
  end

endmodule
  
// File: keypad_4x4_sm.v
// Author: Natalia Pluta
// This module is FSM for keypad.

`timescale 1 ns / 1 ps

module keypad_4x4_sm(
    input wire pclk,
    // input wire rst,
    input wire [2:0] columns,

    output reg [7:0] pressed_key,
    output reg [3:0] rows
);

  localparam IDLE = 3'b000;
  localparam STATE_ROW0 = 3'b001;
  localparam STATE_ROW1 = 3'b010;
  localparam STATE_ROW2 = 3'b011;
  localparam STATE_ROW3 = 3'b100;

  localparam COL0 = 3'b110;
  localparam COL1 = 3'b101;
  localparam COL2 = 3'b011;

  reg [2:0] state, next_state;
  reg [3:0] rows_nxt;
  reg [7:0] pressed_key_nxt;

// ---------------------------------------
// state register
  always @(posedge pclk) begin
    state <= next_state;
    rows <= rows_nxt;
    pressed_key <= pressed_key_nxt;
    // if(rst) begin
    //   state <= IDLE; 

    // end
    // else begin
    //   state <= next_state;
    //   rows <= rows_nxt;
    // end
  end

// ---------------------------------------
// next state logic
  always @(state or columns) begin
    case(state)
      IDLE: begin
        next_state = STATE_ROW0;
      end
      STATE_ROW0: begin
        next_state = STATE_ROW1;
      end
      STATE_ROW1: begin
        next_state = STATE_ROW2;
      end
      STATE_ROW2: begin
        next_state = STATE_ROW3;
      end
      STATE_ROW3: begin
        next_state = STATE_ROW0;
      end
    endcase
  end

// ---------------------------------------
// output logic direct output definitions
  always @* begin
    case(state)
      STATE_ROW0: begin
        rows_nxt = 4'b1101;
        if(columns == COL0) begin
          pressed_key_nxt <= 8'b00000001;             // 1
        end
        else if(columns == COL1) begin
          pressed_key_nxt <= 8'b00000010;             // 2
        end
        else if(columns == COL2) begin
          pressed_key_nxt <= 8'b00000011;             // 3
        end
        else begin
          pressed_key_nxt <= 8'b11111111;             // wrong value
        end
      end
      STATE_ROW1: begin
        rows_nxt = 4'b1011;
        if(columns == COL0) begin
          pressed_key_nxt <= 8'b00000100;             // 4
        end
        else if(columns == COL1) begin
          pressed_key_nxt <= 8'b00000101;             // 5
        end
        else if(columns == COL2) begin
          pressed_key_nxt <= 8'b00000110;             // 6
        end
        else begin
          pressed_key_nxt <= 8'b11111111;             // wrong value
        end
      end
      STATE_ROW2: begin
        rows_nxt = 4'b0111;
        if(columns == COL0) begin
          pressed_key_nxt <= 8'b00000111;             // 7
        end
        else if(columns == COL1) begin
          pressed_key_nxt <= 8'b00001000;             // 8
        end
        else if(columns == COL2) begin
          pressed_key_nxt <= 8'b00001001;             // 9
        end
        else begin
          pressed_key_nxt <= 8'b11111111;             // wrong value
        end
      end
      STATE_ROW3: begin
        rows_nxt = 4'b1110;
        if(columns == COL0) begin
          pressed_key_nxt <= 8'b00001010;             // *
        end
        else if(columns == COL1) begin
          pressed_key_nxt <= 8'b00000000;             // 0
        end
        else if(columns == COL2) begin
          pressed_key_nxt <= 8'b00001011;             // #
        end
        else begin
          pressed_key_nxt <= 8'b11111111;             // wrong value
        end
      end
      default: begin
        rows_nxt = 4'b1101;
        pressed_key_nxt <= 8'b11111111;
      end
    endcase
  end

endmodule
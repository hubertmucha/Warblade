// File: key_sseg.v
// Author: NP
// This module is displaying pressed key on sseg display.

`timescale 1 ns / 1 ps

module key_sseg(
  input wire pclk,
  input wire rst,
  input wire [7:0] key,
  output reg [7:0] sseg_ca,          // segments (active LOW)
  output reg [3:0] sseg_an           // anode enable (active LOW)
);

localparam [7:0] SSEG_0 = 8'b11000000;
localparam [7:0] SSEG_1 = 8'b11111001;
localparam [7:0] SSEG_2 = 8'b10100100;
localparam [7:0] SSEG_3 = 8'b10110000;
localparam [7:0] SSEG_4 = 8'b10011001;
localparam [7:0] SSEG_5 = 8'b10010010;
localparam [7:0] SSEG_6 = 8'b10000010;
localparam [7:0] SSEG_7 = 8'b11111000;
localparam [7:0] SSEG_8 = 8'b10000000;
localparam [7:0] SSEG_9 = 8'b10010000;
localparam [7:0] SSEG_A = 8'b10001000;
localparam [7:0] SSEG_B = 8'b10000011;

reg [7:0] sseg_ca_nxt;
reg [3:0] sseg_an_nxt;

always @(posedge pclk) begin
  if(rst) begin
    sseg_ca <= 8'b1;
    sseg_an <= 4'b1;
  end
  else begin
    sseg_ca <= sseg_ca_nxt;
    sseg_an <= sseg_an_nxt;
  end
end

always @* begin
  sseg_an_nxt = 4'b1110;

  case(key)
    8'b00000000: begin
      sseg_ca_nxt = SSEG_0;
    end
    8'b00000001: begin
      sseg_ca_nxt = SSEG_1;
    end
    8'b00000010: begin
      sseg_ca_nxt = SSEG_2;
    end
    8'b00000011: begin
      sseg_ca_nxt = SSEG_3;
    end
    8'b00000100: begin
      sseg_ca_nxt = SSEG_4;
    end
    8'b00000101: begin
      sseg_ca_nxt = SSEG_5;
    end
    8'b00000110: begin
      sseg_ca_nxt = SSEG_6;
    end
    8'b00000111: begin
      sseg_ca_nxt = SSEG_7;
    end
    8'b00001000: begin
      sseg_ca_nxt = SSEG_8;
    end
    8'b00001001: begin
      sseg_ca_nxt = SSEG_9;
    end
    8'b00001010: begin
      sseg_ca_nxt = SSEG_A;
    end
    8'b00001011: begin
      sseg_ca_nxt = SSEG_B;
    end
    default: begin
      sseg_ca_nxt = 8'b11111111;
    end
  endcase
end

endmodule
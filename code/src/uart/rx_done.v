// File: rx_done.v
// Author: NP

`timescale 1 ns / 1 ps
// TODO: add reset synch
module rx_done(
    input wire pclk,
    input wire [7:0] r_data,
    input wire rx_done,
    output reg [7:0] r_data_out
);

reg [7:0] r_data_temp;

always @(posedge pclk) begin
    r_data_out <= r_data_temp;
end


always @* begin
    if(rx_done) begin
        r_data_temp = r_data;
    end
    else begin
        r_data_temp = r_data_out;
    end
end

endmodule
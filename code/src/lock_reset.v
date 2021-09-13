// File: lock_reset.v 
// Author: NP

`timescale 1 ns / 1 ps

module lock_reset (    
    input wire lowest_freq_clk,                                
    input wire locked,                                     
    output reg rst_out                                     
);
    always @(posedge lowest_freq_clk) begin
        if(!locked) begin
            rst_out <= 1'b1;
        end
        else begin
            rst_out <= 1'b0;
        end
    end

endmodule
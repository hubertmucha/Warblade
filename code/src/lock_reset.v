// File: lock_reset.v 

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module lock_reset (    
    input wire lowest_freq_clk,                                
    input wire locked,                                     
    output reg rst_out                                     
);

    always @(negedge locked or negedge lowest_freq_clk) begin
        if(!locked) begin
            rst_out <= 1'b1;
        end
        else begin
            rst_out <= 1'b0;
        end
    end

endmodule
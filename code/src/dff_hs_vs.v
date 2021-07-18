// File: dff_hs_vs.v - data flip flop module

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module dff_hs_vs (
    input wire pclk,                                  // Peripheral Clock
    input wire rst,                                   // Synchrous reset

    input wire hs_in,
    input wire vs_in,

    output reg hs_out,
    output reg vs_out
);

    always @(posedge pclk) begin
        if(rst) begin
            hs_out <= 12'b0;
            vs_out <= 12'b0;
        end
        else begin
            hs_out <= hs_in;
            vs_out <= vs_in;
        end        
    end  
endmodule
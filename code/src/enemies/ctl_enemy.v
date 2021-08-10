// File: draw_rect_ctl.v
// This module draw a rectangle on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module ctl_enemy
    #( parameter
        N   = 1 // number of enemy
    ) (
    input wire pclk,
    input wire rst,

    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out,
    output reg on // is enemy visible ?
);


    localparam COUNTER_LIMIT = 5000000;
 
    reg [11:0] rom [0:120];
    reg [11:0] address, address_nxt;
    reg [20:0] refresh_counter, refresh_counter_nxt;
    reg [11:0] xpos_nxt, ypos_nxt;
    reg on_nxt;

    
    initial $readmemh("x.mem", rom);
    
    always @(posedge pclk) begin
        xpos_out <= rom[2];
        ypos_out <= 300;
        on       <= on_nxt;
        address  <= address_nxt;
        refresh_counter <= refresh_counter_nxt;
    end
    always @* begin
        if(refresh_counter == COUNTER_LIMIT) begin
            if(address > 120)begin
                address_nxt = 0;
            end
            else begin
                address_nxt = address + 1;
            end
            on_nxt   = 1;
            refresh_counter_nxt = 0;
            end
        else begin
            refresh_counter_nxt = refresh_counter + 1;
        end
    end
endmodule



      


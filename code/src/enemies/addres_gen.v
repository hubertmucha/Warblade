// File: draw_rect_ctl.v
// This module draw a rectangle shot the ckround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

// TODO ADD sycn-reset

module addres_gen(
    input wire pclk,
    input wire rst,
    input wire [3:0] level,
    output reg [11:0] address_out
);

    localparam COUNTER_LIMIT = 1000000;
    //localparam COUNTER_LIMIT = 30000;
    localparam LEVEL_SCALER = 150;
    
    reg [20:0] refresh_counter = 0, refresh_counter_nxt = 0;
    reg [11:0] address_nxt = 0;

    always @(posedge pclk) begin
        // if (rst) begin
        //     address_out <= (LEVEL_SCALER*(level-1));
        //     address_nxt <= (LEVEL_SCALER*(level-1));
        //     refresh_counter <= 0;
        //     refresh_counter_nxt <= 0;
        // end
        // else begin      
        address_out <= address_nxt;
        refresh_counter <= refresh_counter_nxt;
        //end
    end

    // + (LEVEL_SCALER*(level-1))
    //   (LEVEL_SCALER*(level)) - 1
    always @* begin
        if(refresh_counter == COUNTER_LIMIT) begin
            if(address_out >= (LEVEL_SCALER*(level)) - 1) begin 
                address_nxt = (LEVEL_SCALER*(level-1));
            end
            else begin
                address_nxt =  address_nxt + 1 ;
            end
            refresh_counter_nxt = 0;
            end
        else begin
            refresh_counter_nxt = refresh_counter + 1;
        end
    end
endmodule

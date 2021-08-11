// File: draw_rect_ctl.v
// This module draw a rectangle on the backround.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

// TODO ADD sycn-reset

module ctl_enemy
    #( parameter
        N = 1 // number of enemy
    )(
    input wire pclk,
    input wire rst,

    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out,
    output reg on // is enemy visible ?
);


    //localparam COUNTER_LIMIT = 1000; // for simulation purpose
    localparam COUNTER_LIMIT = 1000000;
 
    reg [11:0] rom_x [0:151];
    reg [11:0] rom_y [0:151];
    reg [11:0] address, address_nxt = 0;
    reg [20:0] refresh_counter, refresh_counter_nxt = 0;
    reg [11:0] xpos_nxt, ypos_nxt = 0;
    reg on_nxt;

    if (N == 1) begin
        initial $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en1_x.txt", rom_x);
        //initial $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en1_y.txt", rom_y);
    end
    else if (N == 2) begin
        initial $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en2_x.txt", rom_x);
        //initial $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en2_y.txt", rom_y);
    end
    else if (N == 3) begin
        initial $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en3_x.txt", rom_x);
        //initial $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en2_y.txt", rom_y);
    end
    
    always @(posedge pclk) begin
        xpos_out <= rom_x[address_nxt];
        ypos_out <= 200;
        on       <= on_nxt;
        address  <= address_nxt;
        refresh_counter <= refresh_counter_nxt;
    end
    always @* begin
        if(refresh_counter == COUNTER_LIMIT) begin
            if(address >= 150)begin
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



      


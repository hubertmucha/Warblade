// File: main_gen.v
// Author: Hubert Mucha
// This module is genereating x and y for all enemies based on current level

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

module main_gen (
    input wire pclk,
    input wire rst,
    input wire [3:0] level,

    output reg [11:0] addr,
    output reg [10:0] x_out,
    output reg [10:0] y_out

);

    //localparam COUNTER_LIMIT = 1000; // for simulation purpose
    localparam COUNTER_LIMIT = 1000000;
    localparam LEVEL_SCALER = 150;
    localparam LEVEL = 1; // TODO: change in the future to input parameter
 
    reg [11:0] address, address_nxt = 0;
    reg [20:0] refresh_counter, refresh_counter_nxt = 0;

    reg [11:0] rom_x [0:460];
    reg [11:0] rom_y [0:460];

    initial begin  
        $readmemb("E:/warblade/v3/Warblade/code/src/enemies/data/x.txt", rom_x);
        $readmemb("E:/warblade/v3/Warblade/code/src/enemies/data/y.txt", rom_y);
    end


    always @(posedge pclk) begin
        if (rst) begin
            addr <= 0;
            refresh_counter <= 0;
            x_out <= 0;
            y_out <= 0;
        end
        else begin
            addr <= address_nxt;
            refresh_counter <= refresh_counter_nxt;
            x_out <= rom_x[address_nxt];
            y_out <= 100;
        end
    end

    always @* begin
        if(refresh_counter == COUNTER_LIMIT) begin
            if(addr >= (LEVEL_SCALER*level) - 1)begin
                address_nxt = (LEVEL_SCALER*(level-1));
            end
            else begin
                address_nxt = addr + 1;
            end
                refresh_counter_nxt = 0;
            end
        else begin
                refresh_counter_nxt = refresh_counter + 1;
        end
    end
endmodule



      


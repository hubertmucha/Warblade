// File: main_gen.v
// Author: HM

`timescale 1 ns / 1 ps

module main_gen (
    input wire pclk,
    input wire rst,
    input wire [3:0] level,

    output reg [10:0] x_out,
    output reg [10:0] y_out

);

    //localparam COUNTER_LIMIT = 1000; // for simulation purpose
    localparam COUNTER_LIMIT = 1000000;
    localparam LEVEL_SCALER = 150;
    localparam LEVEL = 1; 
 
    reg [11:0] address, address_nxt = 0;
    reg [20:0] refresh_counter, refresh_counter_nxt = 0;

    reg [10:0] rom_x [0:460];
    reg [10:0] rom_y [0:460];

    initial begin  
        $readmemb("/data/x.txt", rom_x);
        $readmemb("/data/y.txt", rom_y);
    end


    always @(posedge pclk) begin
        if (rst) begin
            address <= 0;
            refresh_counter <= 0;
            x_out <= 0;
            y_out <= 0;
        end
        else begin
            address <= address_nxt;
            refresh_counter <= refresh_counter_nxt;
            x_out <= rom_x[address_nxt];
            y_out <= 100;
        end
    end

    always @* begin
        address_nxt = address;
        refresh_counter_nxt = refresh_counter;
        if(refresh_counter == COUNTER_LIMIT) begin
            if(address >= (LEVEL_SCALER*level) - 1) begin
                address_nxt = (LEVEL_SCALER*(level-1));
            end
            else begin
                address_nxt = address + 1;
            end
                refresh_counter_nxt = 0;
            end
        else begin
                refresh_counter_nxt = refresh_counter + 1;
        end
    end
endmodule



      


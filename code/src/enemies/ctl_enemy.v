// File: draw_rect_ctl.v
// This module draw a rectangle shot the ckround.

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
    input wire [11:0] addr,
    output reg [11:0] x_out,
    output reg [11:0] y_out
);

    reg [11:0] rom_x [0:301];
    reg [11:0] rom_y [0:301];

    if (N == 1) begin
        initial begin  
            $readmemb("C:/studia/MTM/MTM-4/UEC2/projekt/code/src/enemies/data/en1_x.txt", rom_x);
            $readmemb("C:/studia/MTM/MTM-4/UEC2/projekt/code/src/enemies/data/en1_y.txt", rom_y);
            // $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en1_x.txt", rom_x);
            // $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en1_y.txt", rom_y);
        end
    end
    else if (N == 2) begin
        initial begin  
            $readmemb("C:/studia/MTM/MTM-4/UEC2/projekt/code/src/enemies/data/en2_x.txt", rom_x);
            $readmemb("C:/studia/MTM/MTM-4/UEC2/projekt/code/src/enemies/data/en2_y.txt", rom_y);
            // $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en2_x.txt", rom_x);
            // $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en2_y.txt", rom_y);
        end
    end
    else if (N == 3) begin
        initial begin  
            $readmemb("C:/studia/MTM/MTM-4/UEC2/projekt/code/src/enemies/data/en2_x.txt", rom_x);
            $readmemb("C:/studia/MTM/MTM-4/UEC2/projekt/code/src/enemies/data/en3_y.txt", rom_y);
            // $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en2_x.txt", rom_x);
            // $readmemb("E:/warblade/v2/Warblade/code/src/enemies/data/en3_y.txt", rom_y);
        end
    end

    always @(posedge pclk) begin
        x_out <= rom_x[addr];
        y_out <= N*100;
    end
endmodule

// File: enemies.v
// Author: HM & NP
 
module enemy_rom(
    input wire clk ,
    input wire [11:0] address,  // address = {addry[6:0], addrx[6:0]}
    output reg [11:0] rgb
);

reg [11:0] rom [0:4095];

initial begin
    $readmemh("/data/enemy.data", rom);
end

always @(posedge clk)
    rgb <= rom[address];

endmodule

// This is the ROM for the 'live29x31.png' image.
// The image size is 29 x 31 pixels.
// The input 'address' is a 10-bit number, composed of the concatenated
// 5-bit y and 5-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)
module heart_rom (
    input wire clk ,
    input wire [9:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
);


reg [10:0] rom [0:1023];

initial $readmemh("heart_rom.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule

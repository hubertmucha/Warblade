// This is the ROM for the 'AGH48x64.png' image.
// The image size is 48 x 64 pixels.
// The input 'address' is a 12-bit number, composed of the concatenated
// 6-bit y and 6-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)
module image_rom (
    input wire clk ,
    input wire [13:0] address,  // address = {addry[6:0], addrx[6:0]}
    output reg [11:0] rgb
);


reg [15:0] rom [0:16383];

initial $readmemh("image_rom.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule

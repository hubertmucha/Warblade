// File: image_rom.v
// Author: HM & NP

// This is the ROM for the 'AGH48x64.png' image.
// The image size is 48 x 64 pixels.
// The input 'address' is a 12-bit number, composed of the concatenated
// 6-bit y and 6-bit x pixel coordinates.
// The output 'rgb' is 12-bit number with concatenated
// red, green and blue color values (4-bit each)

module image_rom
    #( parameter
        N = 1
    )(
    input wire clk ,
    input wire [13:0] address,  // address = {addry[6:0], addrx[6:0]}
    output reg [11:0] rgb
);


reg [11:0] rom [0:16383];

initial begin
    if (N==1) begin
        $readmemh("/data/ship_1_rom.data", rom);
    end
    else begin
        $readmemh("/data/ship_2_rom.data", rom);
    end
end

always @(posedge clk) begin
    rgb <= rom[address];
    end

endmodule

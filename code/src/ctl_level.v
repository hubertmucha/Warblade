// will be controling level 

module ctl_level(
    input wire pclk,
    input wire rst,
    
    input wire [4:0] in_lv,

    output wire next_level, // inform when is new level to reset enemies
    output wire [4:0] level 
);

assign level = in_lv;

endmodule

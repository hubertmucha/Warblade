`timescale 1 ns / 1 ps

module image_rom_test;
    reg pclk; 

    reg [11:0] address_t, address_t_nxt;
    wire [11:0] rgb_t;

    localparam MAX_ADDRESS = 4096;

    image_rom my_image_rom(
      .clk(pclk),
      .address(address_t),
      .rgb(rgb_t)
    );

  always @(posedge pclk) begin
    address_t <= address_t_nxt;
  end

  always @* begin
    if(address_t == 4096)
      address_t_nxt = 0;
  end 

  // Describe a process that generates a clock
  // signal. The clock is 40 MHz.
  always
  begin
    pclk = 1'b0;
    #13;                                    // 13n+12n = 25ns --> f = 1/(25*10-9) = 40MHz
    pclk = 1'b1;
    #12;                                                                    
  end

endmodule



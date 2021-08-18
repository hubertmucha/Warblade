
`timescale 1 ns / 1 ps

module add_gen_test;

  reg pclk;
  reg rst;

  wire [11:0] address;
  wire on;
  
  addres_gen addr_generator(
    .pclk(pclk),
    .rst(rst),
    .level(2),
    .address_out(address)
  );



  initial               // reset implementation
  begin
    rst = 0;
    #200;
    rst = 1;
    #50;
    rst = 0;
    #5000;
    rst = 1;
    #50;
    rst = 0;
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
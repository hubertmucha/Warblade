
`timescale 1 ns / 1 ps

module random_gen_test;

  reg pclk;
  reg rst;

  wire on;
  
  random_shoot_gen random_shoot_gen(
    .pclk(pclk),
    .rst(rst),
    .on(on)
  );

  initial
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

  always
  begin
    pclk = 1'b0;
    #13;                                
    pclk = 1'b1;
    #12;                                                                    
  end
  
endmodule
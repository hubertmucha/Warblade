
`timescale 1 ns / 1 ps

module ctl_enemy_test;

  reg pclk;
  reg rst;

  wire [11:0] xpos;
  wire [11:0] ypos;
  wire on;
  
  ctl_enemy ctl_en (
    .pclk(pclk),
    .rst(rst),

    .xpos_out(xpos),
    .ypos_out(ypos),
    .on(on)
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
// File: draw_rect_ctl_test.v
// This is a top level testbench for the
// draw_rect_ctl design.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

module draw_rect_ctl_test;

  reg pclk;
  reg rst;

  wire mouse_left;
  wire [11:0] mouse_xpos; 
  wire [11:0] mouse_ypos;

  wire [11:0] xpos_out_ctl;
  wire [11:0] ypos_out_ctl;
  
  draw_rect_ctl_tb my_draw_rect_ctl_tb (
    .pclk(pclk),
    .rst(rst),

    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos)
  );

  draw_rect_ctl my_draw_rect_ctl (
    .pclk(pclk),
    .rst(rst),

    .mouse_left(mouse_left),
    .mouse_xpos(mouse_xpos),
    .mouse_ypos(mouse_ypos),

    .xpos(xpos_out_ctl),
    .ypos(ypos_out_ctl)
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
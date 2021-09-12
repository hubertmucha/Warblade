//Listing 8.2 - Modified buff - 2 outputs data - one current, one previous
module flag_buf
   #(parameter W = 8) // # buffer bits
   (
    input wire clk, reset,
    input wire clr_flag, set_flag,
    input wire [W-1:0] din,
    output wire flag,
    output wire [W-1:0] dout_curr,
    output wire [W-1:0] dout_prev
   );

   // signal declaration
   reg [W-1:0] buf_reg, buf_next;                           // for current
   reg [W-1:0] buf_prev_reg, buf_prev_next;                 // for previous
   reg flag_reg, flag_next;


   // body
   // FF & register
   always @(posedge clk, posedge reset)
      if (reset)
         begin
            buf_reg <= 0;
            buf_prev_reg <= 0; 
            flag_reg <= 1'b0;
         end
      else
         begin
            buf_reg <= buf_next;
            buf_prev_reg <= buf_prev_next;
            flag_reg <= flag_next;
         end

   // next-state logic
   always @*
   begin
      buf_next = buf_reg;
      buf_prev_next = buf_prev_reg;
      flag_next = flag_reg;
      if (set_flag)
         begin
            buf_next = din;
            buf_prev_next = buf_reg; 
            flag_next = 1'b1;
         end
      else if (clr_flag)
         flag_next = 1'b0;
   end
   // output logic
   assign dout_curr = buf_reg;
   assign dout_prev = buf_prev_reg;
   assign flag = flag_reg;

endmodule
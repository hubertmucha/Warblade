// File: char_rom_16x16.v
// Author: HM

`timescale 1 ns / 1 ps

module char_rom_16x16 (
  input wire [3:0] level,
  input wire [7:0] char_xy,
  output reg [6:0] char_code
);

  always @* begin
    case(char_xy)
      8'h00: char_code = 7'h4c; //L
      8'h01: char_code = 7'h65; //e
      8'h02: char_code = 7'h76; //v
      8'h03: char_code = 7'h65; //e
      8'h04: char_code = 7'h6c; //l
      8'h05: char_code = 7'h20; // space
      8'h06: char_code = 7'h20; // space 
      8'h07:
        begin
          if (level == 1) begin
            char_code = 7'h31; 
          end
          else if( level == 2) begin
            char_code = 7'h32;  
          end
          else if( level == 3) begin
            char_code = 7'h33;  
          end
          else if( level == 4) begin
            char_code = 7'h34;  
          end
          else if( level == 5) begin
            char_code = 7'h35;  
          end
          else if( level == 6) begin
            char_code = 7'h36;  
          end
          else if( level == 7) begin
            char_code = 7'h37;  
          end
          else if( level == 8) begin
            char_code = 7'h38;  
          end
          else if( level == 9) begin
            char_code = 7'h39;  
          end
        end 
      8'h08: char_code = 7'h20; //
      8'h09: char_code = 7'h20; //
      8'h0a: char_code = 7'h20; //
      8'h0b: char_code = 7'h20; //
      8'h0c: char_code = 7'h20; //
      8'h0d: char_code = 7'h20; //
      8'h0e: char_code = 7'h20; //
      8'h0f: char_code = 7'h20; //
      8'h10: char_code = 7'h00; //
      8'h11: char_code = 7'h20; //
      8'h12: char_code = 7'h20; //
      8'h13: char_code = 7'h20; //
      8'h14: char_code = 7'h20; //
      8'h15: char_code = 7'h20; //
      8'h16: char_code = 7'h20; //
      8'h17: char_code = 7'h20; //
      8'h18: char_code = 7'h20; //
      8'h19: char_code = 7'h20; //
      8'h1a: char_code = 7'h20; //
      8'h1b: char_code = 7'h20; //
      8'h1c: char_code = 7'h20; //
      8'h1d: char_code = 7'h20; //
      8'h1e: char_code = 7'h20; //
      8'h1f: char_code = 7'h20; //
      8'h20: char_code = 7'h20; //
      8'h21: char_code = 7'h20; //
      8'h22: char_code = 7'h20; //
      8'h23: char_code = 7'h20; //
      8'h24: char_code = 7'h20; //
      8'h25: char_code = 7'h20; //
      8'h26: char_code = 7'h20; //
      8'h27: char_code = 7'h20; //
      8'h28: char_code = 7'h20; //
      8'h29: char_code = 7'h20; //
      8'h2a: char_code = 7'h20; //
      8'h2b: char_code = 7'h20; //
      8'h2c: char_code = 7'h20; //
      8'h2d: char_code = 7'h20; //
      8'h2e: char_code = 7'h20; //
      8'h2f: char_code = 7'h20; //
      8'h30: char_code = 7'h20; //
      8'h31: char_code = 7'h20; //
      8'h32: char_code = 7'h20; //
      8'h33: char_code = 7'h20; //
      8'h34: char_code = 7'h20; // 
      8'h35: char_code = 7'h20; //
      8'h36: char_code = 7'h20; //
      8'h37: char_code = 7'h20; //
      8'h38: char_code = 7'h20; //
      8'h39: char_code = 7'h20; //
      8'h3a: char_code = 7'h20; //
      8'h3b: char_code = 7'h20; //
      8'h3c: char_code = 7'h20; //
      8'h3d: char_code = 7'h20; //
      8'h3e: char_code = 7'h20; //
      8'h3f: char_code = 7'h20; //
      8'h40: char_code = 7'h20; //
      8'h41: char_code = 7'h20; //
      8'h42: char_code = 7'h20; //
      8'h43: char_code = 7'h20; //
      8'h44: char_code = 7'h20; //
      8'h45: char_code = 7'h20; //
      8'h46: char_code = 7'h20; //
      8'h47: char_code = 7'h20; //
      8'h48: char_code = 7'h20; //
      8'h49: char_code = 7'h20; //
      8'h4a: char_code = 7'h20; //
      8'h4b: char_code = 7'h20; //
      8'h4c: char_code = 7'h20; //
      8'h4d: char_code = 7'h20; //
      8'h4e: char_code = 7'h20; //
      8'h4f: char_code = 7'h20; //
      8'h50: char_code = 7'h20; //
      8'h51: char_code = 7'h20; //
      8'h52: char_code = 7'h20; //
      8'h53: char_code = 7'h20; //
      8'h54: char_code = 7'h20; //
      8'h55: char_code = 7'h20; //
      8'h56: char_code = 7'h20; //
      8'h57: char_code = 7'h20; //
      8'h58: char_code = 7'h20; //
      8'h59: char_code = 7'h20; //
      8'h5a: char_code = 7'h20; //
      8'h5b: char_code = 7'h20; //
      8'h5c: char_code = 7'h20; //
      8'h5d: char_code = 7'h20; //
      8'h5e: char_code = 7'h20; //
      8'h5f: char_code = 7'h20; //
      8'h60: char_code = 7'h20; //
      8'h61: char_code = 7'h20; //
      8'h62: char_code = 7'h20; //
      8'h63: char_code = 7'h20; //
      8'h64: char_code = 7'h20; //
      8'h65: char_code = 7'h20; //
      8'h66: char_code = 7'h20; //
      8'h67: char_code = 7'h20; //
      8'h68: char_code = 7'h20; //
      8'h69: char_code = 7'h20; //
      8'h6a: char_code = 7'h20; //
      8'h6b: char_code = 7'h20; //
      8'h6c: char_code = 7'h20; // 
      8'h6d: char_code = 7'h20; //
      8'h6e: char_code = 7'h20; //
      8'h6f: char_code = 7'h20; //
      8'h70: char_code = 7'h20; //
      8'h71: char_code = 7'h20; //
      8'h72: char_code = 7'h20; //
      8'h73: char_code = 7'h20; //
      8'h74: char_code = 7'h20; //
      8'h75: char_code = 7'h20; //
      8'h76: char_code = 7'h20; //
      8'h77: char_code = 7'h20; //
      8'h78: char_code = 7'h20; //
      8'h79: char_code = 7'h20; //
      8'h7a: char_code = 7'h20; //
      8'h7b: char_code = 7'h20; //
      8'h7c: char_code = 7'h20; //
      8'h7d: char_code = 7'h20; //
      8'h7e: char_code = 7'h20; //
      8'h7f: char_code = 7'h20; //
      8'h80: char_code = 7'h20; //
      8'h81: char_code = 7'h20; //
      8'h82: char_code = 7'h20; //
      8'h83: char_code = 7'h20; //
      8'h84: char_code = 7'h20; //
      8'h85: char_code = 7'h20; //
      8'h86: char_code = 7'h20; //
      8'h87: char_code = 7'h20; //
      8'h88: char_code = 7'h20; //
      8'h89: char_code = 7'h20; //
      8'h8a: char_code = 7'h20; //
      8'h8b: char_code = 7'h20; //
      8'h8c: char_code = 7'h20; //
      8'h8d: char_code = 7'h20; //
      8'h8e: char_code = 7'h20; //
      8'h8f: char_code = 7'h20; //
      8'h90: char_code = 7'h20; //
      8'h91: char_code = 7'h20; //
      8'h92: char_code = 7'h20; //
      8'h93: char_code = 7'h20; //
      8'h94: char_code = 7'h20; //
      8'h95: char_code = 7'h20; //
      8'h96: char_code = 7'h20; //
      8'h97: char_code = 7'h20; //
      8'h98: char_code = 7'h20; //
      8'h99: char_code = 7'h20; //
      8'h9a: char_code = 7'h20; //
      8'h9b: char_code = 7'h20; //
      8'h9c: char_code = 7'h20; //
      8'h9d: char_code = 7'h20; //
      8'h9e: char_code = 7'h20; //
      8'h9f: char_code = 7'h20; //
      8'ha0: char_code = 7'h20; //
      8'ha1: char_code = 7'h20; //
      8'ha2: char_code = 7'h20; //
      8'ha3: char_code = 7'h20; //
      8'ha4: char_code = 7'h20; //
      8'ha5: char_code = 7'h20; //
      8'ha6: char_code = 7'h20; //
      8'ha7: char_code = 7'h20; //
      8'ha8: char_code = 7'h20; //
      8'ha9: char_code = 7'h20; //
      8'haa: char_code = 7'h20; //
      8'hab: char_code = 7'h20; // 
      8'hac: char_code = 7'h20; //
      8'had: char_code = 7'h20; //
      8'hae: char_code = 7'h20; //
      8'haf: char_code = 7'h20; //
      8'hb0: char_code = 7'h20; //
      8'hb1: char_code = 7'h20; //
      8'hb2: char_code = 7'h20; //
      8'hb3: char_code = 7'h20; //
      8'hb4: char_code = 7'h20; //
      8'hb5: char_code = 7'h20; //
      8'hb6: char_code = 7'h20; //
      8'hb7: char_code = 7'h20; //
      8'hb8: char_code = 7'h20; //
      8'hb9: char_code = 7'h20; //
      8'hba: char_code = 7'h20; //
      8'hbb: char_code = 7'h20; //
      8'hbc: char_code = 7'h20; //
      8'hbd: char_code = 7'h20; //
      8'hbe: char_code = 7'h20; //
      8'hbf: char_code = 7'h20; //
      8'hc0: char_code = 7'h20; //
      8'hc1: char_code = 7'h20; //
      8'hc2: char_code = 7'h20; //
      8'hc3: char_code = 7'h20; //
      8'hc4: char_code = 7'h20; //
      8'hc5: char_code = 7'h20; //
      8'hc6: char_code = 7'h20; //
      8'hc7: char_code = 7'h20; //
      8'hc8: char_code = 7'h20; //
      8'hc9: char_code = 7'h20; //
      8'hca: char_code = 7'h20; //
      8'hcb: char_code = 7'h20; //
      8'hcc: char_code = 7'h20; //
      8'hcd: char_code = 7'h20; //
      8'hce: char_code = 7'h20; //
      8'hcf: char_code = 7'h20; //
      8'hd0: char_code = 7'h20; //
      8'hd1: char_code = 7'h20; //
      8'hd2: char_code = 7'h20; //
      8'hd3: char_code = 7'h20; //
      8'hd4: char_code = 7'h20; //
      8'hd5: char_code = 7'h20; //
      8'hd6: char_code = 7'h20; //
      8'hd7: char_code = 7'h20; //
      8'hd8: char_code = 7'h20; //
      8'hd9: char_code = 7'h20; //
      8'hda: char_code = 7'h20; //
      8'hdb: char_code = 7'h20; //
      8'hdc: char_code = 7'h20; //
      8'hdd: char_code = 7'h20; //
      8'hde: char_code = 7'h20; //
      8'hdf: char_code = 7'h20; //
      8'he0: char_code = 7'h20; //
      8'he1: char_code = 7'h20; //
      8'he2: char_code = 7'h20; //
      8'he3: char_code = 7'h20; //
      8'he4: char_code = 7'h20; //
      8'he5: char_code = 7'h20; //
      8'he6: char_code = 7'h20; //
      8'he7: char_code = 7'h20; //
      8'he8: char_code = 7'h20; //
      8'he9: char_code = 7'h20; //
      8'hea: char_code = 7'h20; //
      8'heb: char_code = 7'h20; //
      8'hec: char_code = 7'h20; //
      8'hed: char_code = 7'h20; //
      8'hee: char_code = 7'h20; //
      8'hef: char_code = 7'h20; //
      8'hf0: char_code = 7'h20; // 
      8'hf1: char_code = 7'h20; //
      8'hf2: char_code = 7'h20; //
      8'hf3: char_code = 7'h20; //
      8'hf4: char_code = 7'h20; //
      8'hf5: char_code = 7'h20; //
      8'hf6: char_code = 7'h20; //
      8'hf7: char_code = 7'h20; //
      8'hf8: char_code = 7'h20; //
      8'hf9: char_code = 7'h20; //
      8'hfa: char_code = 7'h20; //
      8'hfb: char_code = 7'h20; //
      8'hfc: char_code = 7'h20; //
      8'hfd: char_code = 7'h20; //
      8'hfe: char_code = 7'h20; //
      8'hff: char_code = 7'h20; //
      default: char_code = 7'h20; //
    endcase
  end
endmodule

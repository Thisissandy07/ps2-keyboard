module key_decoder(
  input wire clk,
  input wire reset,
  input wire [7:0] scan_code,
  input wire scan_valid,

  output reg [7:0] key_ascii,
  output reg key_released,
  output reg key_valid
);
  reg release_pending;
  reg shift_l;
  reg shift_r;
  reg caps_lock;
 

  wire shift_pressed = shift_l | shift_r;

function [7:0] decode_ascii;
    input [7:0] code;
    input shift;
    input caps;
    begin
        case (code)
           8'h1C: decode_ascii = (shift ^ caps) ? "A" : "a";
            8'h32: decode_ascii = (shift ^ caps) ? "B" : "b";
            8'h21: decode_ascii = (shift ^ caps) ? "C" : "c";
            8'h23: decode_ascii = (shift ^ caps) ? "D" : "d";
            8'h24: decode_ascii = (shift ^ caps) ? "E" : "e";
            8'h2B: decode_ascii = (shift ^ caps) ? "F" : "f";
            8'h34: decode_ascii = (shift ^ caps) ? "G" : "g";
            8'h33: decode_ascii = (shift ^ caps) ? "H" : "h";
            8'h43: decode_ascii = (shift ^ caps) ? "I" : "i";
            8'h3B: decode_ascii = (shift ^ caps) ? "J" : "j";
            8'h42: decode_ascii = (shift ^ caps) ? "K" : "k";
            8'h4B: decode_ascii = (shift ^ caps) ? "L" : "l";
            8'h3A: decode_ascii = (shift ^ caps) ? "M" : "m";
            8'h31: decode_ascii = (shift ^ caps) ? "N" : "n";
            8'h44: decode_ascii = (shift ^ caps) ? "O" : "o";
            8'h4D: decode_ascii = (shift ^ caps) ? "P" : "p";
            8'h15: decode_ascii = (shift ^ caps) ? "Q" : "q";
            8'h2D: decode_ascii = (shift ^ caps) ? "R" : "r";
            8'h1B: decode_ascii = (shift ^ caps) ? "S" : "s";
            8'h2C: decode_ascii = (shift ^ caps) ? "T" : "t";
            8'h3C: decode_ascii = (shift ^ caps) ? "U" : "u";
            8'h2A: decode_ascii = (shift ^ caps) ? "V" : "v";
            8'h1D: decode_ascii = (shift ^ caps) ? "W" : "w";
            8'h22: decode_ascii = (shift ^ caps) ? "X" : "x";
            8'h35: decode_ascii = (shift ^ caps) ? "Y" : "y";
            8'h1A: decode_ascii = (shift ^ caps) ? "Z" : "z";

            8'h45: decode_ascii = shift ? ")" : "0";
            8'h16: decode_ascii = shift ? "!" : "1";
            8'h1E: decode_ascii = shift ? "@" : "2";
            8'h26: decode_ascii = shift ? "#" : "3";
            8'h25: decode_ascii = shift ? "$" : "4";
            8'h2E: decode_ascii = shift ? "%" : "5";
            8'h36: decode_ascii = shift ? "^" : "6";
            8'h3D: decode_ascii = shift ? "&" : "7";
            8'h3E: decode_ascii = shift ? "*" : "8";
            8'h46: decode_ascii = shift ? "(" : "9";

            8'h29: decode_ascii = " ";
            8'h5A: decode_ascii = 8'h0D; // Enter: carriage return

            default: decode_ascii = 8'd0;
        endcase
    end
endfunction
  always @(posedge clk) begin
    if(reset) begin
      release_pending <= 1'b0;
      key_ascii <= 8'd0;
      key_released <= 1'b0;
      key_valid <= 1'b0;
      shift_l <= 1'b0;
      shift_r <= 1'b0;
      caps_lock <= 1'b0;
    end
    else begin
      key_valid <= 1'b0;
      if(scan_valid) begin
        if(scan_code == 8'hF0) begin
          release_pending <= 1'b1;
        end else if (scan_code == 8'h12) begin        
          shift_l <= ~release_pending;            
          release_pending <= 1'b0;
        end
        else if (scan_code == 8'h59) begin        
          shift_r <= ~release_pending;            
          release_pending <= 1'b0;
        end else if(scan_code == 8'h58) begin 
          if(!release_pending)
            caps_lock <= ~caps_lock;
          release_pending <= 1'b0;
        end else begin
      if (decode_ascii(scan_code, shift_pressed, caps_lock) != 8'd0) begin
        key_ascii <= decode_ascii(scan_code, shift_pressed, caps_lock);
        key_released <= release_pending;
        key_valid <= 1'b1;
      end

      release_pending <= 1'b0;
    end
  end
  end
  end
endmodule

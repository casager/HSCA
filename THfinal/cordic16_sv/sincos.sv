module sincos (sin, cos, addr, load, clock, inv, outY, modeSel);
   
   input logic[3:0]   addr;   
   input logic	 inv, load, clock;
   input logic modeSel;
   
   output logic[15:0] sin;
   output logic[15:0] cos;
   output logic outY;
   
   logic [15:0] 	 constX, constY, inregX, outregX, inregY;
   logic [15:0]	 outregY, outshX, outshY, outshXb, outshYb;
   logic 	 coutX, coutY, invb, invc;
   
   mux2 #(16) muxX(constX, 16'b0010_0110_1101_1101, 16'b0010_0000_0000_0000, modeSel);
   mux2 #(16) muxY(constY, 16'b0000_0000_0000_0000, 16'b0010_0000_0000_0000, modeSel);

   // assign 	 constX=16'b0010_0110_1101_1101; //represents 1/K value USE THIS
   // assign    constY=16'b0000_0000_0000_0000;

   // assign 	 constX=16'b0010_0000_0000_0000; //represents vector value
   // assign    constY=16'b0010_0000_0000_0000;

   mux2 #(1)mux1(invc, inv, 1'b0, load); //first sigma value is 0 
   // mux21 mux1 (invc, inv, 1'b0, load);   
   
   mux2 #(16) mux21x2 (outregX, cos, constX, load);
   // mux21x16 mux21x2 (outregX, cos, constX, load);
   shall log1 (outshX, outregX, addr);
   assign outshXb = outshX ^ {16{invc}};
   // xor16 cmp1 (outshXb, outshX, invc);
   assign inregX = outregX + outshYb + {15'b0000_0000_0000_000, invc};
   // rca16 cpa1 (inregX, coutX, outregX, outshYb, invc);
   flop #(16) reg1 (cos, inregX, clock);
   // reg16 reg1 (cos, inregX, clock);   
   
   mux2 #(16) mux21x3 (outregY, sin, constY, load);
   shall log2 (outshY, outregY, addr);
   assign outshYb = outshY ^ {16{~invc}};
   //xor16 cmp2 (outshYb, outshY, ~invc);
   assign inregY = outregY + outshXb + {15'b0000_0000_0000_000, ~invc};
   //rca16 cpa2 (inregY, coutY, outregY, outshXb, ~invc);
   flop #(16) reg2 (sin, inregY, clock);
   assign outY = cos[15]; //changed this to be from outY since it has pos inv sign (flipped on schem.)
   // reg16 reg2 (sin, inregY, clock);   
   
endmodule // sincos


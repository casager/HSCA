module angle (outreg, load, endangle, clock, data);

   input logic[15:0]  endangle;
   input logic	 load, clock;
   input logic[15:0]  data;

   output logic[15:0] outreg;
   
   logic [15:0] 	 inreg, currentangle, subadd;
   logic 	 cout, negoutreg;

   mux2 #(16) mux1(inreg, outreg, endangle, load);
   // mux2 #(16) mux2(inreg, 16'h0000, 16'h0000, load);
   //mux21x16 mux1 (inreg, outreg, endangle, load);

   assign subadd = data ^ {16{~inreg[15]}};
   // assign subadd = data;
   
   //xor16 cmp1 (subadd, data, ~inreg[15]);

   assign currentangle = subadd + inreg + {15'b0000_0000_0000_000, ~inreg[15]}; //USE THIS

   //rca16 cpa1 (currentangle, cout, subadd, inreg, ~inreg[15]);
   
   flop #(16) reg1(outreg, currentangle, clock);
   //reg16 reg1 (outreg, currentangle, clock);

   
endmodule

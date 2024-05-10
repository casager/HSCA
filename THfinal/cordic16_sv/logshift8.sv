module logshift8 (dataout, a, sh);

   input logic[15:0]  a;
   input logic	 sh;
   
   output logic[15:0] dataout;
   
   mux2 #(1) m1 (dataout[0], a[0], a[8], sh);
   mux2 #(1) m2 (dataout[1], a[1], a[9], sh);
   mux2 #(1) m3 (dataout[2], a[2], a[10], sh);
   mux2 #(1) m4 (dataout[3], a[3], a[11], sh);
   mux2 #(1) m5 (dataout[4], a[4], a[12], sh);
   mux2 #(1) m6 (dataout[5], a[5], a[13], sh);
   mux2 #(1) m7 (dataout[6], a[6], a[14], sh);
   mux2 #(1) m8 (dataout[7], a[7], a[15], sh);
   mux2 #(1) m9 (dataout[8], a[8], a[15], sh);
   mux2 #(1) m10 (dataout[9], a[9], a[15], sh);
   mux2 #(1) m11 (dataout[10], a[10], a[15], sh);
   mux2 #(1) m12 (dataout[11], a[11], a[15], sh);
   mux2 #(1) m13 (dataout[12], a[12], a[15], sh);
   mux2 #(1) m14 (dataout[13], a[13], a[15], sh);		
   mux2 #(1) m15 (dataout[14], a[14], a[15], sh);
   mux2 #(1) m16 (dataout[15], a[15], a[15], sh);

endmodule // logshift8

module shall (dataout, a, sh);

   input logic[15:0]  a;
   input logic[3:0]   sh;   
   output logic[15:0] dataout;
   
   logic [15:0] 	 l1,l2,l4;
   
   logshift1 lev1 (l1, a, sh[0]);
   logshift2 lev2 (l2, l1, sh[1]);
   logshift4 lev3 (l4, l2, sh[2]);
   logshift8 lev4 (dataout, l4, sh[3]);
   
endmodule // shall

module cordic16 (sin, cos, data, currentangle, endangle, addr, load, clock, modeSel);

   input logic [15:0]  endangle;
   input logic	 clock;
   input logic[3:0] 	 addr;
   input logic	 load;
   input logic modeSel;

   output logic [15:0] sin, cos;
   output logic [15:0] data, currentangle;

   logic outY;

   mux2 #(1) invMux(invMuxOut, currentangle[15], outY, modeSel);
   angle angle1 (currentangle, load, endangle, clock, data);
   sincos sincos1 (sin, cos, addr, load, clock, invMuxOut, outY, modeSel);
   rom mem (data, addr);  //USE THIS
   
endmodule // cordic

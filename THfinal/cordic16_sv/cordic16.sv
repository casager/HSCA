module cordic16 (sin, cos, data, currentangle, endangle, addr, load, clock);

   input logic [15:0]  endangle;
   input logic	 clock;
   input logic[3:0] 	 addr;
   input logic	 load;

   output logic [15:0] sin, cos;
   output logic [15:0] data, currentangle;

   angle angle1 (currentangle, load, endangle, clock, data);
   sincos sincos1 (sin, cos, addr, load, clock, currentangle[15]);
   rom mem (data, addr);  //USE THIS
   
endmodule // cordic

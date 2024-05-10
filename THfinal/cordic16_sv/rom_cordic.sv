module rom (data, address);

   input logic[3:0]   address;
   
   output logic[15:0] data;

   reg [15:0] 	 memory[0:15];

   initial
     begin
	$readmemh("./cordic.dat", memory); //change this (cordic.dat) works
     end
   
   assign data = memory[address];

endmodule // rom

module stimulus ();

   logic  clock;
   logic  reset_b;
   
   logic  [2:0] Out;
   
   integer handle3;
   integer desc3;
   
   // Instantiate DUT
   gray_code dut (Out, reset_b, clock);

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clock = 1'b1;
	forever #5 clock = ~clock;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("test.out");
	// Tells when to finish simulation
	#500 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "%b || %b", 
		     reset_b, Out);
     end   
   
   initial 
     begin      
	#0  reset_b = 1'b0;
	#12 reset_b = 1'b1;	
     end

endmodule // gray_code_tb
module stimulus ();

   logic  clock;
   logic  reset_b;
   logic  In;
   
   logic  [2:0] Out;
   
   integer handle3;
   integer desc3;
   
   // Instantiate DUT
   gray_input dut (Out, reset_b, clock, In);

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
	#5 $fdisplay(desc3, "%b %b|| %b", 
		     reset_b, In, Out);
     end   
   
   initial 
     begin      
	#0  reset_b = 1'b0;
	#12 reset_b = 1'b1;
    #0 In = 1;
    #10 In = 1;
    #10 In = 1;
    #10 In = 1;
    #10 In = 0;
    #10 In = 1;
    #10 In = 1;
    #10 In = 1;
    #10 In = 0; 
    #10 In = 1;
    #10 In = 1;       
     end

endmodule // gray_input_tb
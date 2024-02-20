module stimulus ();

   logic  clock;
   logic  a;
   logic  b;
   logic  reset_b;
   
   logic  Out;
   
   integer handle3;
   integer desc3;
   
   // Instantiate DUT
   FSM dut (Out, reset_b, clock, a, b);

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
	#5 $fdisplay(desc3, "%b %b %b || %b", 
		     reset_b, a, b, Out);
     end   
   
   initial 
     begin      
	#0  reset_b = 1'b0;
	#12 reset_b = 1'b1;	
	#0  a = 1'b0;
    #10 a = 1'b1;
	#10 b = 1'b0;
    #10 a = 1'b1;
    #10 b = 1'b1;
	#10 a = 1'b1;
    #0  b = 1'b1;
    #10 a = 1'b0;
     end

endmodule // FSM_tb
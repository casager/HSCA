`timescale 1ns/1ps
module stimulus;

   logic [15:0] a;   
   logic [11:0] b;   
   logic [27:0] z;

   logic [27:0] z_correct;
   
   logic 	clk;
   logic [27:0] errors;
   logic [27:0] vectornum;      
   
   integer 	 handle3;
   integer 	 i;  
   integer   j;
   integer 	 y_integer;   
   integer 	 sum; 

   // Instantiate the Device Under Test
   CSAM1612 dut (z, a, b);

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   // Define the output file
   initial
     begin
	handle3 = $fopen("CSAM1612.out");
	vectornum = 0;
	errors = 0;		
     end

   // Test vector 
   initial
     begin
	// Number of tests
	for (j=0; j < 32; j=j+1)
	  begin
	     // Put vectors before beginning of clk
	     @(posedge clk)
	       begin
		  // allows better output of randomized signals
		  assert(std::randomize(a));
		  assert(std::randomize(b));
	       end
	     @(negedge clk)
	       begin
		  //z_correct = (a)*(b);
		  z_correct = $signed(a)*$signed(b); //creates 2c multiplication
		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		  if (z_correct != z)
		    begin
		       errors = errors + 1;
		       $display("%h %h || %h %h", 
				a, b, z, z_correct);
		    end		       
		  #0 $fdisplay(handle3, "%h %h || %h %h %b", 
			       a, b, z, z_correct, (z == z_correct));
	       end // @(negedge clk)		  
	  end // for (i=0; i < 32; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus

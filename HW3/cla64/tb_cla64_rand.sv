`timescale 1ns/1ps
module stimulus;

   logic [63:0] a;   
   logic [63:0] b;  
   logic [63:0] z;

   //logic [127:0] z_correct;

   logic 	clk;
   logic [31:0] errors;
   logic [31:0] vectornum;      
   
   integer 	 handle3;
   integer 	 i;  
   integer   j;
   integer 	 y_integer;   
   integer 	 sum; 

   // Instantiate the Device Under Test
   cla64 dut (a, b, c, z);

   // 10 ns clock 
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   // Define the output file
   initial
     begin
	handle3 = $fopen("cla64.out");
	vectornum = 0;
	errors = 0;		
     end

   // Test vector 
   initial
     begin
	// Number of tests
	for (j=0; j < 64; j=j+1)
	  begin
	     // Put vectors before beginning of clk
	     @(posedge clk)
	       begin
		  // allows better output of randomized signals
        //   a = 64'h264ea0b28d3d0772; 
        //   b = 64'hff19f530a3c56e10;
        //   c = 64'h0000000000000005;
		  assert(std::randomize(a));
		  assert(std::randomize(b));
		  assert(std::randomize(c));  
          
        //   assert(std::randomize(as));
		//   assert(std::randomize(bs));
		//   assert(std::randomize(cs));  
	       end
	     @(negedge clk)
	       begin
		 // z_correct = a*b+{64'h0, c};

		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		//   if (z_correct != z || zs_correct != zs)
		//     begin
		//        errors = errors + 1;
		//        $display("%h %h %h || %h %h", 
		// 		a, b, c, z, z_correct);
		//     end		       
		  #0 $fdisplay(handle3, "%h %h %h || %h %h %b", 
			       a, b, c, z, z_correct, (z == z_correct));
	       end // @(negedge clk)		  
	  end // for (i=0; i < 16; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus
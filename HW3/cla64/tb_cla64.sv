module stimulus ();

   logic  clock;
   logic  reset_b;

   logic [63:0] a,b,sum;
   logic cin;

   
   integer handle3;
   integer desc3;
   
   // Instantiate DUT
   cla64 dut (a, b, cin, sum);

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clock = 1'b1;
	forever #5 clock = ~clock;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("cla64.out");
	// Tells when to finish simulation
	#500 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(handle3, "%h %h || %b || %h", a, b, cin, sum);
     end   
   
   initial 
     begin 
    //  #5   cin = 1'b0;
    //  #0   a = 64'h000000000000A0A0; 
    //  #0   b = 64'h0000000000000A0A;

    //  #10  a = 64'hA0A0A0A0A0A0A0A0; 
    //  #0   b = 64'h0A0A0A0A0A0A0A0A;
     #5   cin = 1'b0;
     #0   a = 64'h000000000000FFFF; 
     #0   b = 64'h0000000000000001;


     


     end

endmodule // tb_cla64
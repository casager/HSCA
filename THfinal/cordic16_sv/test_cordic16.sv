//
// File name : test.v
// Title     : test
// project   : ECE 429/530
// Library   : test
// Author(s) : James E. Stine, Jr.
// Purpose   : definition of modules for testbench 
// notes :   
//
// Copyright Illinois Institute of Technology
//

// Top level stimulus module

module stimulus;

   logic [15:0]  endangle;
   logic [3:0]   addr;   
   logic 	       load;
   logic         clock;
   logic 	       Clk;   
   logic [15:0] sin, cos;
   logic [15:0] data, currentangle;
   logic modeSel;
   
   integer     handle3;
   integer     desc3;   
   
   cordic16 dut (sin, cos, data, currentangle,
		 endangle, addr, load, clock, modeSel);
   
   initial 
     begin	
	Clk = 1'b1;
	forever #5 Clk = ~Clk;
     end

   initial
     begin
	handle3 = $fopen("cordic16.out");
	#800 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "%b %h %d || %h %b %b || %b %h %d || %b %h %d || %h %h", 
		     endangle, endangle, endangle, addr, clock, load, sin, sin, sin, cos, cos, cos, data, currentangle);
     end

   initial
     begin
	#0  clock = 1'b0;	
	#0  addr = 4'b0000;	
	// #0  endangle = 16'h2500; //ex: angle = 0.578125 
	// #0  endangle = 16'h2a72; //angle = 38 deg = 0.663225
	// #0  endangle = 16'h4541; //angle = 62 deg =1.0821
	#0  endangle = 16'h54e5; //angle = 76 deg =1.32645
	// #0  endangle = 16'h0000;
	// #0 endangle = 16'h2a72;
	#0 modeSel = 1'b0;
	#0  load = 1'b1;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b0001;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b0010;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b0011;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b0100;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b0101;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b0110;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b0111;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b1000;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b1001;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b1010;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b1011;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b1100;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b1101;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;
	
	#0  addr = 4'b1110;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	#0  addr = 4'b1111;
	#0  load = 1'b0;
	#20 clock = 1'b1;
	#20 clock = 1'b0;

	
	
     end


endmodule // stimulus






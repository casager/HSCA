// testbench
`timescale 1ps/1ps
module tb ();

   logic [63:0] op1;		
   logic [2:0] 	rm;		
   logic 	op_type;	
   logic 	P;   		
   logic 	OvEn;		
   logic 	UnEn;   	

   logic 	start;
   logic 	reset;

   logic [63:0] AS_Result;	
   logic [4:0]  Flags;   	
   logic 	 Denorm;   	
   logic 	 done;

   logic         clk;
   logic [63:0]  yexpected;
   logic [63:0]  vectornum, errors;    // bookkeeping variables
   logic [135:0] testvectors[50000:0]; // array of testvectors
   logic [7:0] 	 flags_expected;

   integer 	handle3;
   integer 	desc3;   
   
   // instantiate device under test
   fpdiv dut (done, AS_Result, Flags, Denorm, op1, 64'h0, rm, op_type, P, OvEn, UnEn,
	      start, reset, clk);

   initial 
     begin	
	clk = 1'b1;
	forever #333 clk = ~clk;
     end
   
   
   initial
     begin
	handle3 = $fopen("f64_sqrt_rnm.out");
	$readmemh("f64_sqrt_rnm.tv", testvectors);
	vectornum = 0; errors = 0;
	start = 1'b0;
	// reset
	reset = 1; #27; reset = 0;
     end

   initial
     begin
	desc3 = handle3;	
	#0  op_type = 1'b1;
	#0  P = 1'b0;
	#0  rm = 3'b100;
	#0  OvEn = 1'b0;
	#0  UnEn = 1'b0;
     end

   always @(posedge clk)
     begin
	if (~reset)
	  begin
	     #0; {op1, yexpected, flags_expected} = testvectors[vectornum];
	     //#0 op1 = 64'h4059_4000_0000_0000;
	     #50 start = 1'b1;
	     repeat (2)
	       @(posedge clk);
	     // deassert start after 2 cycles
	     start = 1'b0;	
	     repeat (15)
	       @(posedge clk);
	     $fdisplay(desc3, "%h_%h_%b_%b | %h_%b", op1, AS_Result, Flags, Denorm, yexpected, (AS_Result==yexpected));
	     vectornum = vectornum + 1;
	     if ((testvectors[vectornum] === 136'bx)) begin
		$display("Simulation succeeded");
		$stop;
	     end	     	     	     
	  end // if (~reset)
	$display("%d vectors processed", vectornum);	
     end // always @ (posedge clk)
   
endmodule // tb

`timescale 1ps/1ps
`timescale 1ps/1ps
module tb;

   logic [52:0]   d, n;
   logic [2:0] 	  sel_muxa, sel_muxb;
   logic 	  sel_muxr;   
   logic 	  load_rega, load_regb, load_regc, load_regd;
   logic 	  load_regr, load_regs;
   logic 	  P;
   logic 	  op_type;
   logic 	  exp_odd;   
   logic 	  reset;
   
   logic [63:0]   q1, qp1, qm1;
   logic [63:0]   q0, qp0, qm0;   
   logic [63:0]   rega_out, regb_out, regc_out, regd_out;
   logic [127:0]  regr_out;

   logic 	  start;
   logic 	  error;
   logic 	  done;
   
   logic 	  clk;
   integer 	  handle3;
   integer 	  desc3;   
   
   divconv dut (q1, qm1, qp1, q0, qm0, qp0,
		rega_out, regb_out, regc_out, regd_out,
		regr_out, d, n, sel_muxa, sel_muxb, sel_muxr, reset, clk, 
		load_rega, load_regb, load_regc, load_regd, load_regr, 
		load_regs, P, op_type, exp_odd);

   fsm control (done, load_rega, load_regb, load_regc, 
		load_regd, load_regr, load_regs,
		sel_muxa, sel_muxb, sel_muxr, 
		clk, reset, start, error, op_type);   
   
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	handle3 = $fopen("divconv.out");
	#2700 $finish;		
     end

   initial
     begin
	#0  start = 1'b0;
	#0  P = 1'b1;
	#0  op_type = 1'b0;
	#0  exp_odd = 1'b0;
	
	//#0  n = 53'h1C_0000_0000_0000; // 1.75
	//#0  d = 53'h1E_0000_0000_0000; // 1.875
	#0  n = {32'h9F9d_b240, 21'h0}; // 1.65
	#0  d = {32'hd333_3340, 21'h0}; // 1.247	
	#0  reset = 1'b1;	

	#20 reset = 1'b0;	
	#20 start = 1'b1;
	#40 start = 1'b0;
	

     end


endmodule // tb






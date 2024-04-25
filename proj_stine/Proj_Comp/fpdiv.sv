`timescale 1ps/1ps
module fpdiv (done, AS_Result, Flags, Denorm, op1, op2, rm, op_type, P, OvEn, UnEn,
	      start, reset, clk);

   input logic  [63:0]  op1;		// 1st input logic operand (A)
   input logic  [63:0]  op2;		// 2nd input logic logic operand (B)
   input logic  [2:0] 	rm;		// Rounding mode - specify values 
   input logic 	      op_type;	// Function opcode
   input logic 	      P;   		// Result Precision (0 for double, 1 for single)
   input logic 	      OvEn;		// Overflow trap enabled
   input logic 	      UnEn;   	// Underflow trap enabled

   input logic 	      start;
   input logic 	      reset;
   input logic 	      clk;   

   output logic [63:0] AS_Result;	// Result of operation
   output logic [4:0]  Flags;   	// IEEE exception flags 
   output logic	     Denorm;   	// Denorm on input logic or output
   output logic        done;

   supply1 	  vdd;
   supply0 	  vss;   

   logic [63:0] 	 Float1; 
   logic [63:0] 	 Float2;
   logic [63:0] 	 IntValue;
   
   logic [12:0] 	 exp1, exp2, expF;
   logic [12:0] 	 exp_diff, bias;
   logic [13:0] 	 exp_sqrt;
   logic [12:0] 	 exp_s;
   logic [12:0] 	 exp_c;
   
   logic [10:0] 	 exponent, exp_pre;
   logic [63:0] 	 Result;   
   logic [52:0] 	 mantissaA;
   logic [52:0] 	 mantissaB; 
   logic [63:0] 	 sum, sum_tc, sum_corr, sum_norm;
   
   logic [5:0] 	 align_shift;
   logic [5:0] 	 norm_shift;
   logic [2:0] 	 sel_inv;
   logic		       op1_Norm, op2_Norm;
   logic		       opA_Norm, opB_Norm;
   logic		       Invalid;
   logic 	       DenormIn, DenormIO;
   logic [4:0] 	 FlagsIn;   	
   logic 	       exp_gt63;
   logic 	       Sticky_out;
   logic 	       signResult, sign_corr;
   logic           corr_sign;
   logic 	       zeroB;         
   logic 	       convert;
   logic           swap;
   logic           sub;
   
   logic [63:0] 	 q1, qm1, qp1, q0, qm0, qp0;
   logic [63:0] 	 rega_out, regb_out, regc_out, regd_out;
   logic [127:0]   regr_out;
   logic [2:0] 	 sel_muxa, sel_muxb;
   logic 	       sel_muxr;   
   logic 	       load_rega, load_regb, load_regc, load_regd, load_regr;

   logic 	       donev, sel_muxrv, sel_muxsv;
   logic [1:0] 	 sel_muxav, sel_muxbv;   
   logic 	       load_regav, load_regbv, load_regcv;
   logic 	       load_regrv, load_regsv;
   
   // Convert the input logic operands to their appropriate forms based on 
   // the orignal operands, the op_type , and their precision P. 
   // Single precision input logics are converted to double precision 
   // and the sign of the first operand is set appropratiately based on
   // if the operation is absolute value or negation. 
   convert_inputs conv1 (Float1, Float2, op1, op2, op_type, P);

   // Test for exceptions and return the "Invalid Operation" and
   // "Denormalized" input logic Flags. The "sel_inv" is used in
   // the third pipeline stage to select the result. Also, op1_Norm
   // and op2_Norm are one if op1 and op2 are not zero or denormalized.
   // sub is one if the effective operation is subtaction. 
   exception exc1 (sel_inv, Invalid, DenormIn, op1_Norm, op2_Norm, 
		   Float1, Float2, op_type);

   // Determine Sign/Mantissa
   assign signResult = ((Float1[63]^Float2[63])&~op_type) | Float1[63]&op_type;
   assign mantissaA = {vdd, Float1[51:0]};
   assign mantissaB = {vdd, Float2[51:0]};
   // Perform Exponent Subtraction - expA - expB + Bias   
   assign exp1 = {2'b0, Float1[62:52]};
   assign exp2 = {2'b0, Float2[62:52]};
   // bias : DP = 2^{11-1}-1 = 1023
   assign bias = {3'h0, 10'h3FF};
   // Divide exponent
   csa #(13) csa1 (exp1, ~exp2, bias, exp_s, exp_c);
   exp_add explogic1 (exp_cout1, {open, exp_diff}, 
		      {vss, exp_s}, {vss, exp_c}, 1'b1);
   // Sqrt exponent (check if exponent is odd)
   assign exp_odd = Float1[52] ? vss : vdd;
   exp_add explogic2 (exp_cout2, exp_sqrt, 
		      {vss, exp1}, {4'h0, 10'h3ff}, exp_odd);
   // Choose correct exponent
   assign expF = op_type ? exp_sqrt[13:1] : exp_diff;   

   // Main Goldschmidt/Division Routine
   divconv goldy (q1, qm1, qp1, q0, qm0, qp0, 
		  rega_out, regb_out, regc_out, regd_out,
		  regr_out, mantissaB, mantissaA, 
		  sel_muxa, sel_muxb, sel_muxr, 
		  reset, clk,
		  load_rega, load_regb, load_regc, load_regd,
		  load_regr, load_regs, P, op_type, exp_odd);

   // FSM : control divider
   fsm control (done, load_rega, load_regb, load_regc, load_regd, 
		load_regr, load_regs, sel_muxa, sel_muxb, sel_muxr, 
		clk, reset, start, error, op_type);
   
   // Round the mantissa to a 52-bit value, with the leading one
   // removed. The rounding units also handles special cases and 
   // set the exception flags.
   rounder round1 (Result, DenormIO, FlagsIn, 
		   rm, P, OvEn, UnEn, expF, 
   		   sel_inv, Invalid, DenormIn, signResult, 
		   q1, qm1, qp1, q0, qm0, qp0, regr_out);

   // Store the final result and the exception flags in registers.
   flopenr #(64) rega (clk, reset, done, Result, AS_Result);
   flopenr #(1) regb (clk, reset, done, DenormIO, Denorm);   
   flopenr #(5) regc (clk, reset, done, FlagsIn, Flags);   
   
endmodule // fpadd

//
// Brent-Kung Prefix Adder 
//   (yes, it is 14 bits as my generator is broken for 13 bits :( 
//    assume, synthesizer will delete stuff not needed )
//
module exp_add (cout, sum, a, b, cin);
   
   input logic [13:0] a, b;
   input logic 	cin;
   
   output [13:0] sum;
   output 	 cout;

   logic [14:0] 	 p,g;
   logic [13:0] 	 c;

   // pre-computation
   assign p={a^b,1'b0};
   assign g={a&b, cin};

   // prefix tree
   brent_kung prefix_tree(c, p[13:0], g[13:0]);

   // post-computation
   assign sum=p[14:1]^c;
   assign cout=g[14]|(p[14]&c[13]);

endmodule // exp_add

module brent_kung (c, p, g);
   
   input logic [13:0] p;
   input logic [13:0] g;
   output [14:1] c;

   // parallel-prefix, Brent-Kung

   // Stage 1: Generates G/P pairs that span 1 bits
   grey b_1_0 (G_1_0, {g[1],g[0]}, p[1]);
   black b_3_2 (G_3_2, P_3_2, {g[3],g[2]}, {p[3],p[2]});
   black b_5_4 (G_5_4, P_5_4, {g[5],g[4]}, {p[5],p[4]});
   black b_7_6 (G_7_6, P_7_6, {g[7],g[6]}, {p[7],p[6]});
   black b_9_8 (G_9_8, P_9_8, {g[9],g[8]}, {p[9],p[8]});
   black b_11_10 (G_11_10, P_11_10, {g[11],g[10]}, {p[11],p[10]});
   black b_13_12 (G_13_12, P_13_12, {g[13],g[12]}, {p[13],p[12]});

   // Stage 2: Generates G/P pairs that span 2 bits
   grey g_3_0 (G_3_0, {G_3_2,G_1_0}, P_3_2);
   black b_7_4 (G_7_4, P_7_4, {G_7_6,G_5_4}, {P_7_6,P_5_4});
   black b_11_8 (G_11_8, P_11_8, {G_11_10,G_9_8}, {P_11_10,P_9_8});

   // Stage 3: Generates G/P pairs that span 4 bits
   grey g_7_0 (G_7_0, {G_7_4,G_3_0}, P_7_4);

   // Stage 4: Generates G/P pairs that span 8 bits

   // Stage 5: Generates G/P pairs that span 4 bits
   grey g_11_0 (G_11_0, {G_11_8,G_7_0}, P_11_8);

   // Stage 6: Generates G/P pairs that span 2 bits
   grey g_5_0 (G_5_0, {G_5_4,G_3_0}, P_5_4);
   grey g_9_0 (G_9_0, {G_9_8,G_7_0}, P_9_8);
   grey g_13_0 (G_13_0, {G_13_12,G_11_0}, P_13_12);

   // Last grey cell stage 
   grey g_2_0 (G_2_0, {g[2],G_1_0}, p[2]);
   grey g_4_0 (G_4_0, {g[4],G_3_0}, p[4]);
   grey g_6_0 (G_6_0, {g[6],G_5_0}, p[6]);
   grey g_8_0 (G_8_0, {g[8],G_7_0}, p[8]);
   grey g_10_0 (G_10_0, {g[10],G_9_0}, p[10]);
   grey g_12_0 (G_12_0, {g[12],G_11_0}, p[12]);

   // Final Stage: Apply c_k+1=G_k_0
   assign c[1]=g[0];
   assign c[2]=G_1_0;
   assign c[3]=G_2_0;
   assign c[4]=G_3_0;
   assign c[5]=G_4_0;
   assign c[6]=G_5_0;
   assign c[7]=G_6_0;
   assign c[8]=G_7_0;
   assign c[9]=G_8_0;

   assign c[10]=G_9_0;
   assign c[11]=G_10_0;
   assign c[12]=G_11_0;
   assign c[13]=G_12_0;
   assign c[14]=G_13_0;

endmodule // brent_kung

// Black cell
module black(gout, pout, gin, pin);

 input logic [1:0] gin, pin;
 output gout, pout;

 assign pout=pin[1]&pin[0];
 assign gout=gin[1]|(pin[1]&gin[0]);

endmodule

// Grey cell
module grey(gout, gin, pin);

 input logic[1:0] gin;
 input logic pin;
 output gout;

 assign gout=gin[1]|(pin&gin[0]);

endmodule


// reduced Black cell
module rblk(hout, iout, gin, pin);

 input logic [1:0] gin, pin;
 output hout, iout;

 assign iout=pin[1]&pin[0];
 assign hout=gin[1]|gin[0];

endmodule

// reduced Grey cell
module rgry(hout, gin);

 input logic[1:0] gin;
 output hout;

 assign hout=gin[1]|gin[0];

endmodule

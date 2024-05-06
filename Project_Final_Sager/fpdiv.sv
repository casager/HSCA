module fpdiv(final_ans, inputNum, inputDenom, rm, 
	     start, reset, clk, en_a, en_b, en_rem, sel_mux3, sel_mux5, mux_final, G, rrem_out);

   input logic [31:0]  inputNum, inputDenom;
   input logic 	       clk, start, reset, en_a, en_b, en_rem;
   input logic         rm; 
   input logic [1:0]   sel_mux3;
   input logic [2:0]   sel_mux5;
   
   output logic [31:0] final_ans;
   output logic [1:0]  mux_final;   
   output logic 	       G;
   output logic [63:0]        rrem_out;

   logic [63:0]        rrem;
   logic [63:0]        regrem_out;
   logic [31:0]        num, denom; 
   logic 	       sign;
   logic [7:0] 	       exp;
   logic [31:0]        ia_out, rega_out, regb_out, regc_out, mux3_out, mux5_out;
   logic [63:0]        mul_out, oc_out; 
   
   logic [31:0]        q_const, qp_const, qm_const;
   logic [31:0]        Q_sum1, QP_sum1, QM_sum1,  Q_sum0, QP_sum0, QM_sum0;
   logic [31:0]        Q_sum, QP_sum, QM_sum, Qmux_out;
   logic [22:0]        final_mant;
   
   logic [63:0]        N_rem;
   logic [31:0]        mplier;
   logic [31:0]        mcand_q;
   logic [63:0]        mul_out2;     
   
   assign sign = inputNum[31] ^ inputDenom[31];
   assign num = {1'b1, inputNum[22:0], 8'h0}; 
   assign denom = {1'b1, inputDenom[22:0], 8'h0};

   // IA = 0.75
   assign ia_out = 32'b0110_0000_0000_0000_0000_0000_0000_0000;    
   // changed this from mux2 to mux3 for remainder   
   mux3 #(32) mux3(ia_out, regc_out, denom, sel_mux3, mux3_out); 
   mux5 #(32) mux5(num, denom, rega_out, regb_out, mcand_q, sel_mux5, mux5_out);
   // multiply module
   assign mul_out = mux3_out * mux5_out;   
   // OC implementation
   assign oc_out = {1'b0, ~mul_out[62:0]};

   // regs (change TC to OC here as well)
   flopenr #(32) rega(clk, reset, en_a, mul_out[62:31], rega_out);
   flopenr #(32) regb(clk, reset, en_b, mul_out[62:31], regb_out);
   flopenr #(32) regc(clk, reset, en_b, oc_out[62:31], regc_out);
   flopenr #(64) reg_rem(clk, reset, en_rem, mul_out, regrem_out);
   flopenr #(64) reg_rem2(clk, reset, en_rem, rrem, rrem_out);    

   // Compute remainder
   mux2 #(32) mux2({Q_sum0[31:7], 7'h0}, {Q_sum1[31:7], 7'h0}, Q_sum1[31], mcand_q);   
   //assign mul_out2 = mcand_q * denom;   
   assign N_rem = rega_out[31] ? {1'b0, num, 31'h0} : {num, 32'h0};
   //assign rrem = mul_out + ~N_rem + 32'h1;
   //assign rrem = mul_out - N_rem; //aligns with correct code
   assign rrem = N_rem - mul_out; //changed to align with table

   assign q_const  = 32'b0000_0000_0000_0000_0000_0000_0100_0000;   
   assign qp_const = 32'b0000_0000_0000_0000_0000_0001_0100_0000;    
   assign qm_const = 32'b1111_1111_1111_1111_1111_1111_0011_1111;  

   assign Q_sum1  = rega_out + q_const;
   assign QP_sum1 = rega_out + qp_const;
   assign QM_sum1 = rega_out + qm_const + 1'b1;

   assign Q_sum0  = {rega_out[30:0], 1'b0} + q_const;
   assign QP_sum0 = {rega_out[30:0], 1'b0} + qp_const;
   assign QM_sum0 = {rega_out[30:0], 1'b0} + qm_const + 1'b1;

   assign Q_sum  = Q_sum1[31] ? Q_sum1 : Q_sum0;  
   assign QP_sum = Q_sum1[31] ? QP_sum1 : QP_sum0;
   assign QM_sum = Q_sum1[31] ? QM_sum1 : QM_sum0;

   // Pick G (after shift)
   assign G = Q_sum1[31] ? Q_sum1[7] : Q_sum0[7];
   // Combinational Logic for rounding (swap sign for Q*D - Q)

   // assign mux_final[0] = 1'b0; //logic for just rne
   // assign mux_final[1] = G & ~rrem_out[63]; 

   //logic for choosing rne vs. rz

   assign mux_final[0] = ~G & rrem_out[63] & ~rm; //logic for both modes
   assign mux_final[1] = G & ~rrem_out[63] & rm; 
  
   mux3 #(32) Qmux(Q_sum, QM_sum, QP_sum, mux_final, Qmux_out);
   
   assign final_mant = Qmux_out[30:8];
   // 1 subtracted from exponent if 0 in int digit   
   assign exp = ((inputNum[30:23] - inputDenom[30:23]) + 8'b0111_1111) - {7'b000_0000, ~Q_sum1[31]}; 
   assign final_ans = {sign, exp, final_mant};

endmodule //fpdiv

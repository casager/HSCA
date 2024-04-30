module fpdiv(rm, start, reset, clk, en_a, en_b, en_rem, sel_mux3, sel_mux4, 
inputNum, inputDenom, rrem, Q_sum, QP_sum, QM_sum, Qmux_out, final_mant, final_ans, Q_mant, QP_mant, QM_mant, mux_final);

   input logic [31:0]  inputNum, inputDenom;
   input logic 	       clk, start, reset, en_a, en_b, en_rem, rm; 
   input logic [1:0]   sel_mux3;
   input logic [1:0]   sel_mux4;
   
   //output logic [1:0]  op_type;
   output logic [31:0] final_ans;
   output logic [23:0] Q_mant, QP_mant, QM_mant;
   output logic [31:0] Q_sum, QP_sum, QM_sum, Qmux_out;
   output logic [22:0] final_mant;   
   output logic [63:0] rrem;
   output logic [1:0] mux_final;

   logic [63:0]        regrem_out;
   logic [31:0]        num, denom; //input and output as 23 bit [22:0], 2 int places and guard bits for 28 total
   logic 	       sign;
   logic [7:0] 	       exp;
   logic [31:0]        ia_out, rega_out, regb_out, regc_out, mux3_out, mux4_out;
   logic [63:0]        mul_out, oc_out; //set this to 56 bits as the output will have 2 integers, 26 fractional
   
   logic [31:0]        q_const, qp_const, qm_const;
   logic [31:0]        Q_sum1, QP_sum1, QM_sum1,  Q_sum0, QP_sum0, QM_sum0;
   logic G;
   logic [63:0]        N_rem;   
   
   
   assign sign = inputNum[31] ^ inputDenom[31];
   assign num = {1'b1, inputNum[22:0], 8'h0}; 
   assign denom = {1'b1, inputDenom[22:0], 8'h0};

   assign ia_out = 32'b0110_0000_0000_0000_0000_0000_0000_0000; //should represent 0.75
   // changed this from mux2 to mux3 for remainder   
   mux3 #(32) mux3(ia_out, regc_out, denom, sel_mux3, mux3_out); 
   mux4 #(32) mux4(num, denom, rega_out, regb_out, sel_mux4, mux4_out);
   // multiply module
   assign mul_out = mux3_out * mux4_out;
   
   // OC implementation
   assign oc_out = {1'b0, ~mul_out[62:0]}; //ask why this is occuring 

   // regs (change TC to OC here as well)
   // flops use the clock as well
   // chop bottom half mul_out, cut off first integer   
   flopenr #(32) rega(clk, reset, en_a, mul_out[62:31], rega_out);
   flopenr #(32) regb(clk, reset, en_b, mul_out[62:31], regb_out);
   flopenr #(32) regc(clk, reset, en_b, oc_out[62:31], regc_out);
   flopenr #(64) reg_rem(clk, reset, en_rem, mul_out, regrem_out); 

   // Compute remainder
   //assign N_rem = rega_out[26] ? {num, 27'h0} : {1'b0, num, 26'h0};//read quotient msb, why just num?
   //above is what he originally had for N_rem
   assign N_rem = {1'b0, num, 31'h0};
   assign rrem = regrem_out - N_rem; //radix point is correct form
//    assign rrem = N_rem - regrem_out;

   //assign q_const  = 31'b000_0000_0000_0000_0000_0000_0010_0000; //on Stine's
   assign q_const  = 32'b0000_0000_0000_0000_0000_0000_0100_0000; //Gives only 1 error with rest same
   // assign qp_const = 31'b000_0000_0000_0000_0000_0000_1010_0000; //on Stine's
   assign qp_const = 32'b0000_0000_0000_0000_0000_0001_0100_0000;
   //assign qm_const = 31'b111_1111_1111_1111_1111_1111_1001_1111; //on Stine's
   assign qm_const = 32'b1111_1111_1111_1111_1111_1111_0011_1111;

   // rega_out = 27 + 4 = 31 bits
   assign Q_sum1  = rega_out + q_const;
   assign QP_sum1 = rega_out + qp_const;
   assign QM_sum1 = rega_out + qm_const + 1'b1;

   assign Q_sum0  = {rega_out[30:0], 1'b0} + q_const;
   assign QP_sum0 = {rega_out[30:0], 1'b0} + qp_const;
   assign QM_sum0 = {rega_out[30:0], 1'b0} + qm_const + 1'b1;

   assign Q_sum  = rega_out[31] ? Q_sum1 : Q_sum0; 
   assign QP_sum = rega_out[31] ? QP_sum1 : QP_sum0;
   assign QM_sum = rega_out[31] ? QM_sum1 : QM_sum0;
   
    assign Q_mant = Q_sum[31:8];
    assign QP_mant = QP_sum[31:8];
    assign QM_mant = QM_sum[31:8];

   // Pick G (after shift)
   assign G = rega_out[31] ? Q_sum1[7] : Q_sum0[7];
   // Combinational Logic for rounding (swap sign for Q*D - Q)
   assign mux_final[0] = 1'b0; //setting to 0 for QM right now (not using)
   //assign mux_final[1] = G & ~rrem[53]; //Stine's
   assign mux_final[1] = G & ~rrem[63]; //if rem positive (0 in sign), should do QP

   mux3 #(32) Qmux(Q_sum, QM_sum, QP_sum, mux_final, Qmux_out);
   
   assign final_mant = Qmux_out[30:8];
   // 1 subtracted from exponent if 0 in int digit   
   assign exp = ((inputNum[30:23] - inputDenom[30:23]) + 8'b0111_1111) - {7'b000_0000, ~rega_out[31]}; 

   assign final_ans = {sign, exp, final_mant};

endmodule //fpdiv
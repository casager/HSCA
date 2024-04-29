module fpdiv(inputNum, inputDenom, clk, reset, en_a, en_b, en_rem, rm, out, tb_rega, tb_regb, tb_regc, sel_mux3, sel_mux4, rrem, Q_sum, QP_sum, QM_sum, Qmux_out, final_mant, final_ans, Q_mant, QP_mant, QM_mant, g_out, sign_out);

    input logic [31:0] inputNum, inputDenom;
    input logic clk, reset, en_a, en_b, en_rem, rm; //enable c not needed since en_b operates at same time
    input logic [1:0] sel_mux3;
    input logic [1:0] sel_mux4;

    output logic [53:0] out; 
    output logic [26:0] tb_rega, tb_regb, tb_regc; //output values of registers during every pass
    output logic [27:0] rrem; //rrem 28 bits bc need to see true sign for remainder
    output logic [23:0] Q_mant, QP_mant, QM_mant;
    output logic g_out;
    output logic [1:0] sign_out;
    //output logic [53:0] rrem; //what size does this need to be ?
    
    logic [26:0] regrem_out;
    //logic [53:0] regrem_out;

    logic [26:0] num, denom; //input and output as 23 bit [22:0], 2 int places and guard bits for 28 total
    logic sign;
    logic [7:0] exp;
    logic [26:0] ia_out, rega_out, regb_out, regc_out, mux3_out, mux4_out;
    logic [53:0] mul_out, oc_out; //set this to 56 bits as the output will have 2 integers, 26 fractional

    logic [2:0] comp_out;
    logic [1:0] rem2;
    logic Q_bit, QP_bit, QM_bit, rem_bit;
    logic [2:0] Q3bit;
    logic [1:0] Q2bit;
    logic [26:0] q_const, qp_const, qm_const;
    logic [26:0] Q_sum1, QP_sum1, QM_sum1,  Q_sum0, QP_sum0, QM_sum0, Q_shift;
    output logic [26:0] Q_sum, QP_sum, QM_sum, Qmux_out;
    output logic [22:0] final_mant;
    output logic [31:0] final_ans;


    //assign ia_out = 24'h60_0000; //can change to "better" guess
    assign sign = inputNum[31] ^ inputDenom[31];

    assign num = {1'b1, inputNum[22:0], 3'h0}; 
    assign denom = {1'b1, inputDenom[22:0], 3'h0};
    // assign num = {2'b01, inputNum[22:0], 3'b000}; 
    // assign denom = {2'b01, inputDenom[22:0], 3'b000};
    assign ia_out = 27'b0110_0000_0000_0000_0000_0000_000; //should represent 0.75
    mux3 #(27) mux3(ia_out, regc_out, denom, sel_mux3, mux3_out); //changed this from mux2 to mux3 for remainder
    mux4 #(27) mux4(num, denom, rega_out, regb_out, sel_mux4, mux4_out);
    //multiply module
    assign mul_out = mux3_out * mux4_out;
    
    //do not need either of these
    //determine ulp for rne (G * (L + R + sticky))
    //assign sticky = |mul_out[20:0];
    // assumption is 23 is int bit, 21 is round bit (0.11), and sticky is past that
    //assign ulp = mul_out[22] & (mul_out[23] | mul_out[21] | sticky); 

    //rne ask about this section (dont need, just chopping off bits)
    //adder #(26) add1(mul_out[46:23], {23'h0, ulp}, rne_out);

    //2c being used instead of OC
    //adder #(26) add2(~rne_out[23:0], {23'h0, vdd}, twocmp_out); //where is vdd
    
    //OC implementation
    assign oc_out = {1'b0, ~mul_out[52:0]}; //ask why this is occuring 

    //regs (change TC to OC here as well)
    //flops use the clock as well
    flopenr #(27) rega(clk, reset, en_a, mul_out[52:26], rega_out);//chop bottom half mul_out, cut off first integer
    flopenr #(27) regb(clk, reset, en_b, mul_out[52:26], regb_out);
    flopenr #(27) regc(clk, reset, en_b, oc_out[52:26], regc_out);

    flopenr #(27) reg_rem(clk, reset, en_rem, mul_out[52:26], regrem_out); //should multiply d by q
    //flopenr #(54) reg_rem(clk, reset, en_rem, mul_out, regrem_out);
    
    //assign rrem = regrem_out - {num, 27'b0000_0000_0000_0000_0000_0000_000}; //subtracting the numerator after multiplication
    //assign rrem = {num, 27'b0000_0000_0000_0000_0000_0000_000} - regrem_out;

    //assign rrem = regrem_out - num; //radix point is correct form //change to make room for sign
    assign rrem = {1'b0, regrem_out} - {1'b0, num}; //regrem_out and num inherently positive, remainder might not be
    //assign rrem = {1'b0, num} - {1'b0, regrem_out};
    
    //assign rrem = num - regrem_out;
    //assign scaled_rrem = rrem[26:0];

    assign tb_rega = rega_out;
    assign tb_regb = regb_out;
    assign tb_regc = regc_out;

    assign out = mul_out; //wil need to change back to 23 bits
    //assign q = rega_out;
    //assign out = mul_out[51:29]; //will need an output of 23 bits (fraction) but not until end

    comparator #(28) comp1(rrem, 28'b0000_0000_0000_0000_0000_0000_0000, comp_out); //checks sign bit
    assign rem2 = comp_out[2:1];

    // //num[2] is the guard bit, rem2 is output from comparator //CHANGE NUM TO REGA_OUT
    // assign Q_bit = (rm & (~rega_out[2] | rem2[0])) | (~rm & (rega_out[2] | ~rem2[0])); //found using KMAP (rm = 1 does RN)
    // assign QP_bit = rm & (rega_out[2] & ~rem2[0]); //RN mode and KMAP logic
    // assign QM_bit = ~rm & (~rega_out[2] & rem2[0]);
        
    assign g_bit = (rega_out[2] & rega_out[26]) | (Q_shift[2] & ~rega_out[26]); //guard bit will change depending on shift or not (MAYBE)
    assign Q_bit = (rm & (~g_bit | rem2[0])) | (~rm & (g_bit | ~rem2[0]));
    assign QP_bit = rm & (g_bit & ~rem2[0]);
    assign QM_bit = ~rm & (~g_bit & rem2[0]);

    assign g_out = g_bit;
    assign sign_out = rem2;

    // //num[2] is the guard bit, rem2 is output from comparator //CHANGE NUM TO REGA_OUT
    // assign rem_bit = (rega_out[2] & rega_out[26]) | (Q_shift[2] & ~rega_out[26]); //guard bit will change depending on shift or not (MAYBE)
    // //assign Q_bit = (rm & (~rega_out[2] | ~rem2[0])) | (~rm & (rega_out[2] | ~rem2[0])); //found using KMAP (rm = 1 does RN)
    // assign Q_bit = (rm & (~rem_bit | ~rem2[0])) | (~rm & (rem_bit | ~rem2[0]));
    // //assign QP_bit = rm & (rega_out[2] & rem2[0]); //RN mode and KMAP logic
    // assign QP_bit = rm & (rem_bit & rem2[0]);
    // //assign QM_bit = ~rm & (~rega_out[2] & rem2[0]);
    // assign QM_bit = ~rm & (~rem_bit & rem2[0]);

    assign Q3bit = {Q_bit, QP_bit, QM_bit};

    enc32 Qenc(Q3bit, Q2bit);

    //placement at bit 25
    assign q_const = 27'b0_00_0000_0000_0000_0000_0000_0010; //first bit accounts for integer being added
    assign qp_const =  27'b0_00_0000_0000_0000_0000_0001_0100;
    assign qm_const = 27'b1_11_1111_1111_1111_1111_1111_0011;

    //change placement at bit 23 for increment, decrement
    // assign q_const = 27'b0_00_0000_0000_0000_0000_0000_0100; //first bit accounts for integer being added
    // assign qp_const =  27'b0_00_0000_0000_0000_0000_0000_1100;
    // assign qm_const = 27'b1_11_1111_1111_1111_1111_1111_1011;

    // //change placement at bit 23 for increment, decrement
    // assign q_const = 27'b0_00_0000_0000_0000_0000_0000_0010; //first bit accounts for integer being added
    // assign qp_const =  27'b0_00_0000_0000_0000_0000_0000_0110;
    // assign qm_const = 27'b1_11_1111_1111_1111_1111_1111_1101;

    //placement at bit 27
    // assign q_const = 27'b0_00_0000_0000_0000_0000_0000_0010; //first bit accounts for integer being added
    // assign qp_const =  27'b0_00_0000_0000_0000_0000_0000_1010;
    // assign qm_const = 27'b1_11_1111_1111_1111_1111_1111_1001;

    assign Q_sum1 = rega_out + q_const;
    assign QP_sum1 = rega_out + qp_const;
    assign QM_sum1 = rega_out + qm_const + 1'b1;

    assign Q_shift = {rega_out[25:0],1'b0};
    
    assign Q_sum0 = {rega_out[25:0],1'b0} + q_const;
    //assign Q_sum0 = {rega_out[25:3],1'b0, rega_out[2:0]} + q_const;
    //assign Q_sum0 = {Q_sum1[25:0],1'b0}; //changed from adding q_const after shift to adding it before shift
    assign QP_sum0 = {rega_out[25:0],1'b0} + qp_const;
    //assign QP_sum0 = {rega_out[25:3],1'b0, rega_out[2:0]} + qp_const;
    //assign QP_sum0 = {QP_sum1[25:0],1'b0};
    assign QM_sum0 = {rega_out[25:0],1'b0} + qm_const + 1'b1;
    //assign QM_sum0 = {rega_out[25:3],1'b0, rega_out[2:0]} + qm_const + 1'b1;
    //assign QM_sum0 = {QM_sum1[25:0],1'b0}; //may need to check this so last bit is correct

    assign Q_sum = rega_out[26] ? Q_sum1 : Q_sum0; //rega_out[26] shows if Q shifted or not 
    assign QP_sum = rega_out[26] ? QP_sum1 : QP_sum0;
    assign QM_sum = rega_out[26] ? QM_sum1 : QM_sum0;

    assign Q_mant = Q_sum[26:3];
    assign QP_mant = QP_sum[26:3];
    assign QM_mant = QM_sum[26:3];

    //mux3 #(27) mux3(ia_out, regc_out, denom, sel_mux3, mux3_out);
    mux3 #(27) Qmux(Q_sum, QP_sum, QM_sum, Q2bit, Qmux_out); //change this to logic to get correct Q answers

    assign final_mant = Qmux_out[25:3];
    assign exp = ((inputNum[30:23] - inputDenom[30:23]) + 8'b0111_1111) - {7'b000_0000, ~rega_out[26]}; //1 subtracted from exponent if 0 in int digit

    assign final_ans = {sign, exp, final_mant};



    //mux3 #(27) q_mux_upper(q_const, qp_const, qm_const, Q2bit, qmux_out) //this just outputs the correct q, qp, or qm

endmodule //fpdiv
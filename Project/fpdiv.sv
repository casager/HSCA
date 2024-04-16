module fpdiv(inputNum, inputDenom, clk, reset, en_a, en_b, out, tb_rega, tb_regb, tb_regc, sel_mux2, sel_mux4);

    input logic [31:0] inputNum, inputDenom;
    input logic clk, reset, en_a, en_b; //enable c not needed since en_b operates at same time
    input logic sel_mux2;
    input logic [1:0] sel_mux4;

    output logic [27:0] out; 
    output logic [27:0] tb_rega, tb_regb, tb_regc; //output values of registers during every pass

    logic [27:0] num, denom; //input and output as 23 bit [22:0], 2 int places and guard bits for 28 total
    logic [27:0] ia_out, rega_out, regb_out, regc_out, mux2_out, mux4_out;
    logic [55:0] mul_out, oc_out; //set this to 56 bits as the output will have 2 integers, 26 fractional

    //assign ia_out = 24'h60_0000; //can change to "better" guess
    assign num = {1'b1, inputNum[22:0], 4'h0};
    assign denom = {1'b1, inputDenom[22:0], 4'h0};
    assign ia_out = 28'h600_0000; //should represent 0.75
    mux2 #(28) mux2(ia_out, regc_out, sel_mux2, mux2_out);
    mux4 #(28) mux4(num, denom, rega_out, regb_out, sel_mux4, mux4_out);
    //multiply module
    assign mul_out = mux2_out * mux4_out;
    
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
    assign oc_out = {1'b0, ~mul_out[54:0]}; //ask why this is occuring 

    //regs (change TC to OC here as well)
    //flops use the clock as well
    flopenr #(28) rega(clk, reset, en_a, mul_out[54:27], rega_out);//chop bottom half mul_out, did not take higher integer how does this work??
    flopenr #(28) regb(clk, reset, en_b, mul_out[54:27], regb_out);
    flopenr #(28) regc(clk, reset, en_b, oc_out[54:27], regc_out);

    assign tb_rega = rega_out;
    assign tb_regb = regb_out;
    assign tb_regc = regc_out;

    assign out = mul_out; //wil need to change back to 23 bits
    //assign q = rega_out;
    //assign out = mul_out[51:29]; //will need an output of 23 bits (fraction) but not until end

endmodule //fpdiv
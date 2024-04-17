module fpdiv(inputNum, inputDenom, clk, reset, en_a, en_b, en_rem, out, tb_rega, tb_regb, tb_regc, sel_mux3, sel_mux4, rrem);

    input logic [31:0] inputNum, inputDenom;
    input logic clk, reset, en_a, en_b, en_rem; //enable c not needed since en_b operates at same time
    input logic [1:0] sel_mux3;
    input logic [1:0] sel_mux4;

    output logic [53:0] out; 
    output logic [26:0] tb_rega, tb_regb, tb_regc; //output values of registers during every pass
    output logic [26:0] rrem; 
    //output logic [53:0] rrem; //what size does this need to be ?
    
    logic [26:0] regrem_out;
    //logic [53:0] regrem_out;

    logic [26:0] num, denom; //input and output as 23 bit [22:0], 2 int places and guard bits for 28 total
    logic [26:0] ia_out, rega_out, regb_out, regc_out, mux3_out, mux4_out;
    logic [53:0] mul_out, oc_out; //set this to 56 bits as the output will have 2 integers, 26 fractional

    //assign ia_out = 24'h60_0000; //can change to "better" guess
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

    assign rrem = regrem_out - num; //radix point is correct form
    //assign rrem = num - regrem_out;
    //assign scaled_rrem = rrem[26:0];

    assign tb_rega = rega_out;
    assign tb_regb = regb_out;
    assign tb_regc = regc_out;

    assign out = mul_out; //wil need to change back to 23 bits
    //assign q = rega_out;
    //assign out = mul_out[51:29]; //will need an output of 23 bits (fraction) but not until end

endmodule //fpdiv
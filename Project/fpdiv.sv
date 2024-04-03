module fpdiv(num, denom, clk, reset, en_a, en_b, en_c, out);

    input logic [25:0] num, denom;

    output logic [22:0] out; 

    logic [26:0] ia_out, rega_out, regb_out, regc_out, mux2_out, mux4_out, oc_out
    logic [53:0] mul_out
    logic sel_mux2, sel_mux4, sticky, ulp;

    //assign ia_out = 24'h60_0000; //can change to "better" guess
    assign ia_out = 27'h60_0000; //should represent 0.75
    mux2 #(27) mux2(ia_out, regc_out, sel_mux2, mux2_out);
    mux4 #(27) mux4(num, denom, rega_out, regb_out, sel_mux4, mux4_out);
    //multiply module
    assign mul_out = mux2_out * mux4_out;
    
    //do not need either of these
    //determine ulp for rne (G * (L + R + sticky))
    assign sticky = |mul_out[20:0];
    // assumption is 23 is int bit, 21 is round bit (0.11), and sticky is past that
    assign ulp = mul_out[22] & (mul_out[23] | mul_out[21] | sticky); 

    //rne ask about this section (dont need, just chopping off bits)
    //adder #(26) add1(mul_out[46:23], {23'h0, ulp}, rne_out);

    //2c being used instead of OC
    //adder #(26) add2(~rne_out[23:0], {23'h0, vdd}, twocmp_out); //where is vdd
    
    //OC implementation
    assign oc_out = ~mul_out;

    //regs (change TC to OC here as well)
    flopenr #(27) rega(clk, reset, en_a, mul_out[53:27], rega_out);//chop bottom half mul_out
    flopenr #(27) regb(clk, reset, en_b, mul_out[53:27], regb_out);
    flopenr #(27) regc(clk, reset, en_c, oc_out[53:27], regc_out);
    //assign q = rega_out;
    //assign out = mul_out[51:29]; //will need an output of 23 bits but not until end

endmodule //fpdiv
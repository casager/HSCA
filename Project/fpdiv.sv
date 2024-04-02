module fpdiv(num, denom, clk, reset, en_a, en_b, en_c);

    input logic [23:0] num, denom;

    output logic [23:0] q; 

    logic [23:0] ia_out, rega_out, regb_out, regc_out, mux2_out, mux4_out;
    logic [23:0] mul_out, rne_out, twocmp_out;
    logic sel_mux2, sel_mux4, sticky, ulp;

    assign ia_out = 24'h60_0000; //can change to "better" guess
    mux2 #(24) mux2(ia_out, regc_out, sel_mux2, mux2_out);
    mux4 #(24) mux4(num, denom, rega_out, regb_out, sel_mux4, mux4_out);
    //multiply module
    assign mul_out = mux2_out * mux4_out;
    
    //determine ulp for rne (G * (L + R + sticky))
    assign sticky = |mul_out[20:0];
    // assumption is 23 is int bit, 21 is round bit (0.11), and sticky is past that
    assign ulp = mul_out[22] & (mul_out[23] | mul_out[21] | sticky); 

    //rne ask about this section
    adder #(24) add1(mul_out[46:23], {23'h0, ulp}, rne_out);
    //2c being used instead of OC
    adder #(24) add2(~rne_out[23:0], {23'h0, vdd}, twocmp_out);
    
    //regs (change TC to OC here as well)
    flopenr #(24) rega(clk, reset, en_a, rne_out, rega_out);
    flopenr #(24) regb(clk, reset, en_b, rne_out, regb_out);
    flopenr #(24) regc(clk, reset, en_c, twocmp_out, regc_out);
    assign q = rega_out;

endmodule //fpdiv
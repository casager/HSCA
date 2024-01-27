module hw1_1 (a, b, c, as, bs, cs, z,  zs);

    input logic [63:0] a, b, c;
    input logic signed [63:0] as, bs, cs;
    output logic [127:0] z;
    output logic signed [127:0] zs;

    assign z = a*b+{64'h0, c};
    assign zs = as*bs+cs; //instead of using {64'h0, c} since this might mess up signed addition

endmodule // sample
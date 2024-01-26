module sample (input logic [63:0] a, b, c, input logic signed [63:0] as, bs, cs, output logic [127:0] z, output logic signed [127:0] zs);

    assign z = a*b+{64'h0, c};
    assign zs = as*bs+{64'h0, cs};

endmodule // sample
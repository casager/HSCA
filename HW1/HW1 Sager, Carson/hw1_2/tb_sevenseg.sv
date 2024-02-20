`timescale 1ns/1ps
module tb;

    logic   [3:0] data;
    logic   [6:0] segments;
    logic   clk;

    sevenseg dut (data, segments);

    //10 ns clock
    initial 
        begin
            clk = 1'b1;
            forever #5 clk = ~clk;
        end

    initial 
        begin

            #10 data = 4'h0;
            #10 data = 4'h1;
            #10 data = 4'h2;
            #10 data = 4'h3;
            #10 data = 4'h4;
            #10 data = 4'h5;
            #10 data = 4'h6;
            #10 data = 4'h7;
            #10 data = 4'h8;
            #10 data = 4'h9;
            #10 data = 4'hA;
            #10 data = 4'hB;
            #10 data = 4'hC;
            #10 data = 4'hD;
            #10 data = 4'hE;
            #10 data = 4'hF;

        end           

endmodule // tb
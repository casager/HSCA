module cla64 (a, b, cin, sum);

input logic [63:0] a, b;
input logic cin;

output logic [63:0] sum;

logic [63:0] g, p;
logic [15:0] gout, pout; //should be 21 output bits of each (16,4,1) BEST WAY
logic [3:0] gout2, pout2; //4 bits that combine the others
logic gout3, pout3; //1 final bit for final level (may not need)

logic c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;
logic c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31;
logic c32, c33, c34, c35, c36, c37, c38, c39, c40, c41, c42, c43, c44, c45, c46, c47;
logic c48, c49, c50, c51, c52, c53, c54, c55, c56, c57, c58, c59, c60, c61, c62, c63;

rfa rfa0(a[0], b[0], cin, sum[0], g[0], p[0]);
rfa rfa1(a[1], b[1], c1, sum[1], g[1], p[1]);
rfa rfa2(a[2], b[2], c2, sum[2], g[2], p[2]);
rfa rfa3(a[3], b[3], c3, sum[3], g[3], p[3]);
bclg4 bclg0(cin, g[3:0], p[3:0], gout[0], pout[0], c1, c2, c3);

rfa rfa4(a[4], b[4], c4, sum[4], g[4], p[4]);
rfa rfa5(a[5], b[5], c5, sum[5], g[5], p[5]);
rfa rfa6(a[6], b[6], c6, sum[6], g[6], p[6]);
rfa rfa7(a[7], b[7], c7, sum[7], g[7], p[7]);
bclg4 bclg1(c4, g[7:4], p[7:4], gout[1], pout[1], c5, c6, c7);

rfa rfa8(a[8], b[8], c8, sum[8], g[8], p[8]);
rfa rfa9(a[9], b[9], c9, sum[9], g[9], p[9]);
rfa rfa10(a[10], b[10], c10, sum[10], g[10], p[10]);
rfa rfa11(a[11], b[11], c11, sum[11], g[11], p[11]);
bclg4 bclg2(c8, g[11:8], p[11:8], gout[2], pout[2], c9, c10, c11);

rfa rfa12(a[12], b[12], c12, sum[12], g[12], p[12]);
rfa rfa13(a[13], b[13], c13, sum[13], g[13], p[13]);
rfa rfa14(a[14], b[14], c14, sum[14], g[14], p[14]);
rfa rfa15(a[15], b[15], c15, sum[15], g[15], p[15]);
bclg4 bclg3(c12, g[15:12], p[15:12], gout[3], pout[3], c13, c14, c15);
bclg4 bclgLevel2_0(cin, gout[3:0], pout[3:0], gout2[0], pout2[0], c4, c8, c12);

rfa rfa16(a[16], b[16], c16, sum[16], g[16], p[16]);
rfa rfa17(a[17], b[17], c17, sum[17], g[17], p[17]);
rfa rfa18(a[18], b[18], c18, sum[18], g[18], p[18]);
rfa rfa19(a[19], b[19], c19, sum[19], g[19], p[19]);
bclg4 bclg4(c16, g[19:16], p[19:16], gout[4], pout[4], c17, c18, c19);

rfa rfa20(a[20], b[20], c20, sum[20], g[20], p[20]);
rfa rfa21(a[21], b[21], c21, sum[21], g[21], p[21]);
rfa rfa22(a[22], b[22], c22, sum[22], g[22], p[22]);
rfa rfa23(a[23], b[23], c23, sum[23], g[23], p[23]);
bclg4 bclg5(c20, g[23:20], p[23:20], gout[5], pout[5], c21, c22, c23);

rfa rfa24(a[24], b[24], c24, sum[24], g[24], p[24]);
rfa rfa25(a[25], b[25], c25, sum[25], g[25], p[25]);
rfa rfa26(a[26], b[26], c26, sum[26], g[26], p[26]);
rfa rfa27(a[27], b[27], c27, sum[27], g[27], p[27]);
bclg4 bclg6(c24, g[27:24], p[27:24], gout[6], pout[6], c25, c26, c27);

rfa rfa28(a[28], b[28], c28, sum[28], g[28], p[28]);
rfa rfa29(a[29], b[29], c29, sum[29], g[29], p[29]);
rfa rfa30(a[30], b[30], c30, sum[30], g[30], p[30]);
rfa rfa31(a[31], b[31], c31, sum[31], g[31], p[31]);
bclg4 bclg7(c28, g[31:28], p[31:28], gout[7], pout[7], c29, c30, c31);
bclg4 bclgLevel2_1(c16, gout[7:4], pout[7:4], gout2[1], pout2[1], c20, c24, c28);

rfa rfa32(a[32], b[32], c32, sum[32], g[32], p[32]);
rfa rfa33(a[33], b[33], c33, sum[33], g[33], p[33]);
rfa rfa34(a[34], b[34], c34, sum[34], g[34], p[34]);
rfa rfa35(a[35], b[35], c35, sum[35], g[35], p[35]);
bclg4 bclg8(c32, g[35:32], p[35:32], gout[8], pout[8], c33, c34, c35);

rfa rfa36(a[36], b[36], c36, sum[36], g[36], p[36]);
rfa rfa37(a[37], b[37], c37, sum[37], g[37], p[37]);
rfa rfa38(a[38], b[38], c38, sum[38], g[38], p[38]);
rfa rfa39(a[39], b[39], c39, sum[39], g[39], p[39]);
bclg4 bclg9(c36, g[39:36], p[39:36], gout[9], pout[9], c37, c38, c39);

rfa rfa40(a[40], b[40], c40, sum[40], g[40], p[40]);
rfa rfa41(a[41], b[41], c41, sum[41], g[41], p[41]);
rfa rfa42(a[42], b[42], c42, sum[42], g[42], p[42]);
rfa rfa43(a[43], b[43], c43, sum[43], g[43], p[43]);
bclg4 bclg10(c40, g[43:40], p[43:40], gout[10], pout[10], c41, c42, c43);

rfa rfa44(a[44], b[44], c44, sum[44], g[44], p[44]);
rfa rfa45(a[45], b[45], c45, sum[45], g[45], p[45]);
rfa rfa46(a[46], b[46], c46, sum[46], g[46], p[46]);
rfa rfa47(a[47], b[47], c47, sum[47], g[47], p[47]);
bclg4 bclg11(c44, g[47:44], p[47:44], gout[11], pout[11], c45, c46, c47);
bclg4 bclgLevel2_2(c32, gout[11:8], pout[11:8], gout2[2], pout2[2], c36, c40, c44);

rfa rfa48(a[48], b[48], c48, sum[48], g[48], p[48]);
rfa rfa49(a[49], b[49], c49, sum[49], g[49], p[49]);
rfa rfa50(a[50], b[50], c50, sum[50], g[50], p[50]);
rfa rfa51(a[51], b[51], c51, sum[51], g[51], p[51]);
bclg4 bclg12(c48, g[51:48], p[51:48], gout[12], pout[12], c49, c50, c51);

rfa rfa52(a[52], b[52], c52, sum[52], g[52], p[52]);
rfa rfa53(a[53], b[53], c53, sum[53], g[53], p[53]);
rfa rfa54(a[54], b[54], c54, sum[54], g[54], p[54]);
rfa rfa55(a[55], b[55], c55, sum[55], g[55], p[55]);
bclg4 bclg13(c52, g[55:52], p[55:52], gout[13], pout[13], c53, c54, c55);

rfa rfa56(a[56], b[56], c56, sum[56], g[56], p[56]);
rfa rfa57(a[57], b[57], c57, sum[57], g[57], p[57]);
rfa rfa58(a[58], b[58], c58, sum[58], g[58], p[58]);
rfa rfa59(a[59], b[59], c59, sum[59], g[59], p[59]);
bclg4 bclg14(c56, g[59:56], p[59:56], gout[14], pout[14], c57, c58, c59);

rfa rfa60(a[60], b[60], c60, sum[60], g[60], p[60]);
rfa rfa61(a[61], b[61], c61, sum[61], g[61], p[61]);
rfa rfa62(a[62], b[62], c62, sum[62], g[62], p[62]);
rfa rfa63(a[63], b[63], c63, sum[63], g[63], p[63]);
bclg4 bclg15(c60, g[63:60], p[63:60], gout[15], pout[15], c61, c62, c63);
bclg4 bclgLevel2_3(c48, gout[15:12], pout[15:12], gout2[3], pout2[3], c52, c56, c60);

bclg4 bclgLevel3_0(cin, gout2[3:0], pout2[3:0], gout3, pout3, c16, c32, c48); //don't need gout3/pout3 for final level (9 gates instead)


endmodule // cla64

module rfa (a, b, c, sum, g, p);

    input logic a,b,c;
    output logic sum,g,p;

    assign p = a ^ b; 
    assign g = a & b;

    assign sum = p ^ c;

endmodule //rfa

module bclg4 (cin, g, p, gout, pout, c[1], c[2], c[3]);

    input logic cin;
    input logic [3:0] g, p;

    output logic gout, pout;
    output logic [3:1] c;
    //output logic cout;

    //assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    //assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign gout =  g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign pout = (p[3] & p[2] & p[1] & p[0]);

endmodule //bclg4
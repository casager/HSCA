module sbtm_div (input logic [11:0] a, output logic [10:0] ia_out);

   // bit partitions
   logic [3:0] x0;
   logic [2:0] x1;
   logic [3:0] x2;
   logic [2:0] x2_1cmp;   
   // mem outputs
   logic [12:0] y0;
   logic [4:0] 	y1;
   // input to CPA
   logic [14:0] op1;
   logic [14:0] op2;
   logic [14:0] p;   

   assign x0 = a[10:7];
   assign x1 = a[6:4];
   assign x2 = a[3:0];   

   sbtm_a0 mem1 ({x0, x1}, y0);
   // 1s cmp per sbtm/stam
   assign x2_1cmp = x2[3] ? ~x2[2:0] : x2[2:0];   
   sbtm_a1 mem2 ({x0, x2_1cmp}, y1);
   assign op1 = {1'b0, y0, 1'b0};
   // 1s cmp per sbtm/stam
   assign op2 = x2[3] ? {1'b1, {8{1'b1}}, ~y1, 1'b1} :
		{1'b0, 8'b0, y1, 1'b1};
   
   // CPA
   assign {cout, p} = op1 + op2 + 1'b0;   
   assign ia_out = p[14:4];

endmodule // sbtm

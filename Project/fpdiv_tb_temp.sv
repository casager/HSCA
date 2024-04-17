//`timescale 1ns/1ps
module stimulus ();
//module fpdiv(inputNum, inputDenom, clk, reset, en_a, en_b, en_c, out);
   logic [31:0] inputNum, inputDenom;
   logic  clk;
   logic  reset;
   logic  en_a, en_b;
   logic [26:0] out; //will need to change back to 23 bits
   logic [1:0] sel_mux4;
   logic sel_mux2;
   logic [26:0] tb_rega, tb_regb, tb_regc;
   
   integer handle3;
   integer desc3;
   
   // Instantiate DUT
   fpdiv dut (inputNum, inputDenom, clk, reset, en_a, en_b, out, tb_rega, tb_regb, tb_regc, sel_mux2, sel_mux4);

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("TEMP.out");
	// Tells when to finish simulation
	#500 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "%b %b || %b %b %b %b || %b %b %b || %b", 
		    clk, reset, sel_mux2, sel_mux4, en_a, en_b, tb_rega, tb_regb, tb_regc, out);
     end   
   
   initial 
     begin
	// #0  reset = 1'b1;
	// #5 reset = 1'b0;
	// #0  inputNum = 32'b0000_0000_0110_0000_0010_1011_1011_1010; //first 9 bits for integer/exponent
	// #0  inputDenom = 32'b0000_0000_0100_1001_0001_1110_0001_0001;

     #0  inputNum = 32'b0000_0000_0000_0000_0000_0000_0000_0000; //first 9 bits for integer/exponent
	#0  inputDenom = 32'b0000_0000_0000_0000_0000_0000_0000_0000;

     #5 sel_mux4 = 2'b00; //iteration 1
     #0 sel_mux2 = 1'b0; //multiply input numerator by IA
	#0 en_a = 1'b1;
	#0 en_b = 1'b0;
     
     #10 sel_mux4 = 2'b01; //multiply input denom by IA
	#0 en_a = 1'b0;
	#0 en_b = 1'b1;     
     
     #10 sel_mux4 = 2'b10; //iteration 1
     #0 sel_mux2 = 1'b1; //now multilpy numbers by what is in C register (nothing there yet)
	#0 en_a = 1'b1;
	#0 en_b = 1'b0; 

     #10 sel_mux4 = 2'b11;
	#0 en_a = 1'b0;
	#0 en_b = 1'b1; 

     #10 sel_mux4 = 2'b10; //iteration 2
	#0 en_a = 1'b1;
	#0 en_b = 1'b0; 

     #10 sel_mux4 = 2'b11;
	#0 en_a = 1'b0;
	#0 en_b = 1'b1; 

     #10 sel_mux4 = 2'b10; //iteration 3
	#0 en_a = 1'b1;
	#0 en_b = 1'b0; 

     #10 sel_mux4 = 2'b11;
	#0 en_a = 1'b0;
	#0 en_b = 1'b1; 

     #10 sel_mux4 = 2'b10; //iteration 4
	#0 en_a = 1'b1;
	#0 en_b = 1'b0; 

     #10 sel_mux4 = 2'b11;
	#0 en_a = 1'b0;
	#0 en_b = 1'b1; 

     #10 sel_mux4 = 2'b10; //iteration 5
	#0 en_a = 1'b1;
	#0 en_b = 1'b0; 

     #10 sel_mux4 = 2'b11;
	#0 en_a = 1'b0;
	#0 en_b = 1'b1; 

     #10 sel_mux4 = 2'b10; //iteration 6
	#0 en_a = 1'b1;
	#0 en_b = 1'b0; 

     #10 sel_mux4 = 2'b11;
	#0 en_a = 1'b0;
	#0 en_b = 1'b1; 
     end

endmodule // FSM_tb


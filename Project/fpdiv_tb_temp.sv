//`timescale 1ns/1ps
module stimulus ();
//module fpdiv(inputNum, inputDenom, clk, reset, en_a, en_b, en_c, out);
   logic [31:0] inputNum, inputDenom;
   logic  clk;
   logic  reset;
   logic  en_a, en_b, en_rem;
   logic [53:0] out; //will need to change back to 23 bits
   logic [1:0] sel_mux4;
   logic [1:0] sel_mux3;
   logic [26:0] tb_rega, tb_regb, tb_regc;
   //logic [26:0] scaled_rrem;
   logic [27:0] rrem;
   //logic [53:0] rrem;
   logic [26:0] Q_sum, QP_sum, QM_sum, Qmux_out;
   logic [22:0] final_mant;
   logic rm;
   logic [23:0] Q_mant, QP_mant, QM_mant;

   logic [31:0] final_ans;
    
   integer handle3;
   integer desc3;
   
   // Instantiate DUT
   fpdiv dut (inputNum, inputDenom, clk, reset, en_a, en_b, en_rem, rm, out, tb_rega, tb_regb, tb_regc, sel_mux3, sel_mux4, rrem, Q_sum, QP_sum, QM_sum, Qmux_out, final_mant, final_ans, Q_mant, QP_mant, QM_mant);

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

//    always @(negedge clk) //automatically at each 10
   always
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "%b %b || %b %b || %b %b %b || %b %b %b || %b || %h %h %h || %b %b %b || %b || %h || %h", 
		    clk, reset, sel_mux3, sel_mux4, en_a, en_b, en_rem, tb_rega, tb_regb, tb_regc, rrem, Q_mant, QP_mant, QM_mant, Q_sum, QP_sum, QM_sum, Qmux_out, final_mant, final_ans);
     end   
     //changed the Q*_sum values to only show which mantissa will be visible
     //Qmux_out is the selection of Q, QP, QM in the mux using remainder and guard digit
     //final_mant takes the first 23 bits in decimal of Qmux_out and final_ans should be answer
   initial 
     begin
	// #0  reset = 1'b1;
	// #5 reset = 1'b0;

     // #0  inputNum = 32'b0000_0000_0_000_0000_0000_0000_0000_0000; //represents N =1 D =1
	// #0  inputDenom = 32'b0000_0000_0_000_0000_0000_0000_0000_0000;

     // #0  inputNum = 32'b0000_0000_0_11011000011110010011111; //1.8456 //first 9 bits for integer/exponent
	// #0  inputDenom = 32'b0000_0000_0_00111111000101000001001; //1.2464

     // #0  inputNum = 32'b0000_0000_0_00111111000101000001001; //1.2464 //first 9 bits for integer/exponent
	// #0  inputDenom = 32'b0000_0000_0_11011000011110010011111; //1.8456

     #0  inputNum = 32'h8683F7FF; //1.03100574016571045 //first test case of f32_div_rne
	#0  inputDenom = 32'hC07F3FFF; //1.9941405057907104

     // #0  inputNum = 32'h9EDE38F7; //1.736113429069519 //second test case of f32_div_rne
	// #0  inputDenom = 32'h3E7F7F7F; //1.996078372001648
     
     // #0  inputNum = 32'h4F951295; //1.16462957859039307 //3rd test case of f32_div_rne
	// #0  inputDenom = 32'h41E00002; //1.7500002384185791

     // #0  inputNum = 32'hbed56444; //rand test case of f32_div_rne
	// #0  inputDenom = 32'h3e7ff400; 

     //start
     #0  rm = 1'b1;
     #5 sel_mux4 = 2'b00; //iteration 1
     #0 sel_mux3 = 2'b00; //multiply input numerator by IA
	#0 en_a = 1'b1;
	#0 en_b = 1'b0;
     #0 en_rem = 1'b0;
     
     //input denom
     #10 sel_mux4 = 2'b01; //multiply input denom by IA
	#0 en_a = 1'b0;
	#0 en_b = 1'b1;     
     
     //cycle through these
     #10 sel_mux4 = 2'b10; //iteration 2
     #0 sel_mux3 = 2'b01; //now multilpy numbers by what is in C register (nothing there yet)
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

     #10 sel_mux4 = 2'b10;
     #0 sel_mux3 = 2'b10;
	#0 en_a = 1'b0;
	#0 en_b = 1'b0;
     #0 en_rem = 1'b1;
     end

endmodule // FSM_tb


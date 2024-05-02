//`timescale 1ns/1ps
module stimulus;

  logic [31:0]  inputNum;   
  logic [31:0]  inputDenom;   
  logic  	 rm;		
  //logic [1:0]	 op_type; //should be Q2bit output	
  logic en_a, en_b, en_rem;
  logic [1:0] sel_mux3;
  logic [1:0] sel_mux4;
  logic [1:0] mux_final;
  logic [64:0] rrem;
  logic G;
  
  logic 	 start;
  logic 	 reset;
  
  logic [31:0]  final_ans;	
  logic [4:0] 	 Flags;   	
  logic 	 Denorm;   	
  logic 	 done;
  
  logic 	 clk;
  logic [31:0]  yexpected;
  logic [31:0]  vectornum, errors;    // bookkeeping variables
  logic [103:0] testvectors[50000:0]; // array of testvectors
  logic [7:0] 	 flags_expected; //could be extra credit
  
  integer 	 handle3;
  integer 	 desc3;   

  // instantiate device under test
  fpdiv dut (final_ans, inputNum, inputDenom, rm, start, reset, clk, en_a, en_b, en_rem, sel_mux3, sel_mux4, mux_final, G, rrem);

  // 1 ns clock
  initial 
    begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	handle3 = $fopen("f32_div_rne_20.out");
	$readmemh("f32_div_rne_20.tv", testvectors);
	//handle3 = $fopen("f32_div_rne_5000.out");
	//$readmemh("f32_div_rne_5000.tv", testvectors);	
	vectornum = 0; errors = 0;
	start = 1'b0;
	// reset
	reset = 1; #27; reset = 0;
     end

   // Test vector
   always @(posedge clk)
     begin
	if (~reset)
	  begin
	     #0; {inputNum, inputDenom, yexpected, flags_expected} = testvectors[vectornum];
	     #50 start = 1'b1;
	     repeat (2)
	       @(posedge clk);
	     // deassert start after 2 cycles
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

	     start = 1'b0;	
	     repeat (10)
	       @(posedge clk);
	     desc3 = handle3;
	     $fdisplay(desc3, "%h_%h_%h_%b_%b | %h_%b | %b | %b |%b", inputNum, inputDenom, final_ans, Flags, Denorm, yexpected, (final_ans==yexpected), mux_final, G, rrem[64]);
	     vectornum = vectornum + 1;
	     if (final_ans!=yexpected) errors = errors + 1;
	     if ((testvectors[vectornum] === 104'bx)) begin
		$display("Simulation succeeded");
		$display("%d tests completed with %d errors", vectornum, errors);
		$stop;
	     end	     
	  end // if (~reset)
	$display("%d vectors processed", vectornum);	
     end // always @ (posedge clk)
   
endmodule // stimulus

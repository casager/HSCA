module FSM (Out, reset_b, clock, a, b);
   
   output logic Out;
   input logic 	reset_b, clock, a, b;

   typedef enum logic [1:0] {S0, S1, S2, S3} statetype;
   statetype state, nextState;
   
   // State Register
   always_ff @ (posedge clock, negedge reset_b) 
     begin
	if (~reset_b)
	  state <= S0;
	else
	  state <= nextState;
     end   

   // Next State Logic
   always_comb 
     begin
	case (state)
	  S0: begin
	     nextState = a ? S1 : S0;	     
	     Out = 1'b0;
	  end
	  S1: begin
	     nextState = b ? S2 : S0;	     
	     Out = 1'b0;	     
	  end
	  S2: begin
	     nextState = (a & b) ? S2 : S0;
	     Out = (a & b) ? 1 : 0;
	  end
	  default: begin
	     nextState = S0;
	     Out = 1'bx;
	  end
	endcase
     end
  
endmodule // FSM
module enc32 (Qin, Qout);

	input logic [2:0]	Qin;
	output logic [1:0]	Qout;

always_comb
	case (Qin)
		3'b100 : Qout = 2'b00; //use q_const
		3'b010 : Qout = 2'b01; //use qp_const
		3'b001 : Qout = 2'b10; //use qm_const
		default : Qout = 2'b00;
	endcase
endmodule // enc32
module enc94 (movein, moveout);

	input logic [8:0]	movein;
	output logic [3:0]	moveout;

always_comb
	case (movein)
		9'b000_000_001 : moveout = 4'b0000;
		9'b000_000_010 : moveout = 4'b0001;
		9'b000_000_100 : moveout = 4'b0010;
		9'b000_001_000 : moveout = 4'b0011;
		9'b000_010_000 : moveout = 4'b0100;
		9'b000_100_000 : moveout = 4'b0101;
		9'b001_000_000 : moveout = 4'b0110;
		9'b010_000_000 : moveout = 4'b0111;
		9'b100_000_000 : moveout = 4'b1000;
		default : moveout = 4'b0000;
	endcase
endmodule // enc94
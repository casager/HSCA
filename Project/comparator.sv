module comparator #(parameter WIDTH=32) 
  (input logic [WIDTH-1:0] a, b,
  output logic [2:0]    flags);

  logic 		  eq, lt, ltu;
  
  assign eq = (a == b);
  assign ltu = (a < b);
  assign lt = ($signed(a) < $signed(b));
  
  assign flags = {eq, lt, ltu};
  
endmodule
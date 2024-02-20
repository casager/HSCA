module gray_input (Out, reset_b, clock, In);

    output logic [2:0] Out;
    input logic reset_b, clock, In;

    typedef enum logic [2:0] {S0 = 3'b000, 
    S1 = 3'b001, 
    S2 = 3'b010, 
    S3 = 3'b011, 
    S4 = 3'b100, 
    S5 = 3'b101, 
    S6 = 3'b110, 
    S7 = 3'b111} statetype;
    statetype state, nextState;

    // State Register
    always_ff @ (posedge clock, negedge reset_b) 
        begin
            if (~reset_b)
                state <= S0;
            else
                state <= nextState;
        end   

    always_comb
        begin
            case(state)
                S0: begin
                    nextState = In ? S1 : S7;	     
                    Out = 3'b000;
                end
                S1: begin
                    nextState = In ? S2 : S0;	     
                    Out = 3'b001;	     
                end
                S2: begin
                    nextState = In ? S3 : S1;	     
                    Out = 3'b011;	     
                end                
                S3: begin
                    nextState = In ? S4 : S2;
                    Out = 3'b010;
                end
                S4: begin
                    nextState = In ? S5 : S3;	     
                    Out = 3'b110;
                end
                S5: begin
                    nextState = In ? S6 : S4;	     
                    Out = 3'b111;	     
                end
                S6: begin
                    nextState = In ? S7 : S5;
                    Out = 3'b101;
                end
                S7: begin
                    nextState = In ? S0 : S6;	     
                    Out = 3'b100;	     
                end
                default: begin
                    nextState = S0;
                    Out = 1'bx;
                end
            endcase
        end
endmodule //gray_code
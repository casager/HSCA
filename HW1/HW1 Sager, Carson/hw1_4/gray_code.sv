module gray_code (Out, reset_b, clock);

    output logic [2:0] Out;
    input logic reset_b, clock;

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
                    nextState = S1;	     
                    Out = 3'b000;
                end
                S1: begin
                    nextState = S2;	     
                    Out = 3'b001;	     
                end
                S2: begin
                    nextState = S3;	     
                    Out = 3'b011;	     
                end                
                S3: begin
                    nextState = S4;
                    Out = 3'b010;
                end
                S4: begin
                    nextState = S5;	     
                    Out = 3'b110;
                end
                S5: begin
                    nextState = S6;	     
                    Out = 3'b111;	     
                end
                S6: begin
                    nextState = S7;
                    Out = 3'b101;
                end
                S7: begin
                    nextState = S0;	     
                    Out = 3'b100;	     
                end
                default: begin
                    nextState = S0;
                    Out = 1'bx;
                end
            endcase
        end
endmodule //gray_code
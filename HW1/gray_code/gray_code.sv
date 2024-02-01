module gray_code (Out, reset_b, clock);

    output logic [2:0] Out;
    input logic reset_b, clock;

    typedef enum [2:0] {S0 = 3'b000, 
    S1 = 3'b001, 
    S2 = 3'b010,
    S3 = 3'b011,
    S4 = 3'b100,
    S5 = 3'b101,
    S6 = 3'b110,
    S7 = 3'b111} statetype;
    statetype counter;

    // State Register
    always_ff @ (posedge clock, negedge reset_b) 
        begin
            if (~reset_b)
                counter <= S0;
            else
                counter <= counter + 1;
        end   

    always_comb
        begin
            case(counter)
                S0: Out = 3'b000;
                S1: Out = 3'b001;
                S2: Out = 3'b011;
                S3: Out = 3'b010;
                S4: Out = 3'b110;
                S5: Out = 3'b111;
                S6: Out = 3'b101;
                S7: Out = 3'b100;
            endcase
        end
endmodule //gray_code

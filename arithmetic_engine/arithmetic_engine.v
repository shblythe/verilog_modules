`default_nettype none

module arithmetic_engine(
    input   [7:0]   i_a,
    input   [7:0]   i_b,
    input   [2:0]   i_instruction,

    output  reg [7:0]   out
    );

    always @(i_a, i_b, i_instruction) begin
        case (i_instruction)
            3'b000 :  out = i_a | i_b;    // OR
            3'b001 :  out = ~(i_a & i_b);  // NAND
            3'b010 :  out = ~(i_a | i_b);  // NOR
            3'b011 :  out = i_a & i_b;    // AND
            3'b100 :  out = i_a + i_b;    // ADD
            3'b101 :  out = i_a - i_b;    // SUB
        endcase
    end
endmodule


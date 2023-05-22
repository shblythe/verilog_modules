`default_nettype none

module logic_engine(
    input   [7:0]   i_a,
    input   [7:0]   i_b,
    input   [1:0]   i_instruction,

    output  reg [7:0]   out
    );

    always @(i_a, i_b, i_instruction) begin
        case (i_instruction)
            2'b00 :  out = i_a | i_b;    // OR
            2'b01 :  out = ~(i_a & i_b);  // NAND
            2'b10 :  out = ~(i_a | i_b);  // NOR
            2'b11 :  out = i_a & i_b;    // AND
        endcase
    end
endmodule


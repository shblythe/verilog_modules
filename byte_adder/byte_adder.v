//`default_nettype none

module byte_adder(
    input   [7:0]  i_a,
    input   [7:0]  i_b,

    output  [7:0]  o_r,
    output          o_c
    );

    wire [8:0]  result;

    assign result = i_a + i_b;

    assign o_r = result[7:0];
    assign o_c = result[8];
endmodule


`default_nettype none

module byte_negate(
    input   [7:0]  in,

    output  [7:0]  out
    );

    assign out = -in;

endmodule


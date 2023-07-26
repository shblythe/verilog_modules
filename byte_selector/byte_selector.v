`default_nettype none

module byte_selector(
    input   [7:0]   in0,
    input   [7:0]   in1,
    input           select,

    output  reg [7:0]   out
    );


    always @(select,in0,in1) begin
        if (select==1'b1)
            out = in1;
        else
            out = in0;
    end

endmodule


`default_nettype none

module byte_switch(
    input   [7:0]   in,
    input           enable,

    output  reg [7:0]   out
    );

    always @(enable,in) begin
        if (enable==1'b1)
            out = in;
        else
            out = 8'bZ;
    end

endmodule


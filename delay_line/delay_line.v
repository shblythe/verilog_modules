`default_nettype none

module delay_line #(
    parameter DELAY = 2
    )
    (
    input   in,
    input   clk,

    output  reg out
    );

    reg [DELAY-1:0] shift;

    always @(posedge clk) begin
        shift[DELAY-1:1] <= shift[DELAY-2:0];
        shift[0] <= in;
        out <= shift[DELAY-1];
    end

endmodule


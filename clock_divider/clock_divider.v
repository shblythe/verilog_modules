`ifndef __CLOCK_DIVIDER
`define __CLOCK_DIVIDER

module clock_divider #(
    // Parameters
    parameter   DIVIDER         = 12000000,
    parameter   DIV_WIDTH       = 24
)
(
    // Inputs
    input       clk,
    input       rst,

    // Outputs
    output reg  out
    );

    // Internal signals
    reg div_clk;
    reg [DIV_WIDTH:0] count;

    // Clock divider
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            count <= 0;
            out <= 1;
        end else if (count == DIVIDER/2 - 1) begin
            count <= 0;
            out <= ~out;
        end else begin
            count <= count + 1;
        end
    end
endmodule

`endif

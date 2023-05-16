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
    output      out
    );

    // Internal signals
    reg div_clk;
    reg [DIV_WIDTH:0] count;

    assign out = div_clk;

    // Clock divider
    always @ (posedge clk or rst) begin
        if (rst == 1'b1) begin
            count <= 0;
            div_clk <= 1;
        end else begin
            count <= count + 1;
            if (count >= DIVIDER-1)
                count <= 0;
            div_clk <= (count < (DIVIDER/2))? 1'b1 : 1'b0;
        end
    end

endmodule

`endif

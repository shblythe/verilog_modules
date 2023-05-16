`default_nettype none
// Manage reset output with switch input and forcing a reset on power-up

`ifndef __RESET
`define __RESET

module reset #(
        parameter COUNT_LIMIT       = 7,
        parameter COUNT_WIDTH       = 3
    )
    (
        // Inputs
        input       clk,
        input       i_rst_button,

        // Outputs
        output reg  o_rst
    );
    reg [COUNT_WIDTH-1:0] reset_count = COUNT_LIMIT;

    always @(posedge clk or i_rst_button) begin
        if (i_rst_button == 1'b1)
            o_rst <= 1;
        else if (reset_count > 0) begin
            o_rst <= 1;
            reset_count <= reset_count - 1;
        end else
            o_rst <= 0;
    end
endmodule

`endif


`default_nettype none
// Automatic binary counter with optionally divided clock

`ifndef __CLK_COUNTER
`define __CLK_COUNTER

`include "verilog_modules/clock_divider/clock_divider.v"

module clk_counter #(
        parameter COUNT_LIMIT       = 3,
        parameter COUNT_WIDTH       = 2,
        parameter CLOCK_DELAY       = 1000,
        parameter CLOCK_DELAY_WIDTH = 10
    )
    (
        // Inputs
        input       clk,
        input       rst,

        // Outputs
        output      reg [(COUNT_WIDTH-1):0] count
    );

    wire clkcnt;

    generate
        if (CLOCK_DELAY==0) begin
            assign clkcnt = clk;
        end else begin
            clock_divider #(
                .DIV_WIDTH(CLOCK_DELAY_WIDTH),
                .DIVIDER(CLOCK_DELAY)
            ) clkdiv (
                .clk(clk),
                .rst(rst),
                .out(clkcnt)
            );
        end
    endgenerate

    always @ (posedge clkcnt or posedge rst) begin
        if (rst == 1'b1)
            count <= 'b0;
        else if (count == COUNT_LIMIT)
            count <= 'b0;
        else
            count <= count + 1'b1;
    end

endmodule

`endif


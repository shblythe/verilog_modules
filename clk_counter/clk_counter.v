`default_nettype none
// Automatic binary counter with divided clock

`include "../clock_divider/clock_divider.v"

module clk_counter #(
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

    clock_divider #(
        .DIV_WIDTH(CLOCK_DELAY_WIDTH),
        .DIVIDER(CLOCK_DELAY)
    ) clkdiv (
        .clk(clk),
        .rst(rst),
        .out(clkcnt)
    );

    always @ (posedge clkcnt or posedge rst) begin
        if (rst == 1'b1)    count <= 'b0;
        else                count <= count + 1'b1;
    end

endmodule



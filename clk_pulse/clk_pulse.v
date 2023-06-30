`default_nettype none
// Clock pulse with defined width and optionally divided clock

`include "verilog_modules/clk_counter/clk_counter.v"

module clk_pulse #(
        parameter COUNT_LIMIT       = 15,
        parameter COUNT_WIDTH       = 4,
        parameter PULSE_START       = 1,
        parameter PULSE_LIMIT       = 11,
        parameter CLOCK_DELAY       = 0,
        parameter CLOCK_DELAY_WIDTH = 1
    )
    (
        // Inputs
        input       clk,
        input       rst,

        // Outputs
        output reg  pulse
    );

    wire    [(COUNT_WIDTH-1):0] count;

    clk_counter #(
        .COUNT_LIMIT(COUNT_LIMIT),
        .COUNT_WIDTH(COUNT_WIDTH),
        .CLOCK_DELAY_WIDTH(CLOCK_DELAY_WIDTH),
        .CLOCK_DELAY(CLOCK_DELAY)
    ) clkcnt (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    always @ (count or rst) begin
        if (rst == 1'b1)
            pulse <= 1'b0;
        else if(count >= PULSE_START && count < PULSE_LIMIT)
            pulse <= 1'b1;
        else
            pulse <= 1'b0;
    end

endmodule



`default_nettype none
// Display an LED matrix multiplexed by row

`include "verilog_modules/clk_counter/clk_counter.v"
`include "verilog_modules/clk_pulse/clk_pulse.v"
`include "verilog_modules/async_mux/async_mux.v"
`include "verilog_modules/binary_decoder/binary_decoder.v"

module led_mux #(
        parameter NUM_ROWS              = 4,
        parameter NUM_ROWS_WIDTH        = 2,
        parameter NUM_COLS              = 8,
        parameter CLOCK_DELAY           = 1000,
        parameter CLOCK_DELAY_WIDTH     = 10,
        parameter ROW_OUTPUT_ACTIVE_LOW = 0,
        parameter COL_OUTPUT_ACTIVE_LOW = 0,
        parameter COL_PULSE_CLOCK_START = 50,
        parameter COL_PULSE_CLOCK_LIMIT = 100
    )
    (
        // Inputs
        input       clk,
        input       i_rst,
        input       [(NUM_COLS-1):0]    i_rows [0:(NUM_ROWS-1)],

        // Outputs
        output      [(NUM_COLS-1):0]    o_cols,
        output      [(NUM_ROWS-1):0]    o_rows
    );

    reg [(NUM_ROWS_WIDTH-1):0] row;

    // Deal with column duty-cycle, and inversion of outputs if necessary
    wire    [(NUM_COLS-1):0]    pre_cols;
    wire    [(NUM_ROWS-1):0]    pre_rows;
    wire    reg cols_duty;
    if (COL_OUTPUT_ACTIVE_LOW)
        assign o_cols = ~(pre_cols & (cols_duty ? -1 : 0));
    else
        assign o_cols = (pre_cols & (cols_duty ? -1 : 0));
    if (ROW_OUTPUT_ACTIVE_LOW)
        assign o_rows = ~pre_rows;
    else
        assign o_rows = pre_rows;

    clk_counter #(
        .CLOCK_DELAY_WIDTH(CLOCK_DELAY_WIDTH),
        .CLOCK_DELAY(CLOCK_DELAY),
        .COUNT_WIDTH(NUM_ROWS_WIDTH),
        .COUNT_LIMIT(NUM_ROWS)
    ) clkcnt (
        .clk(clk),
        .rst(i_rst),
        .count(row)
    );

    clk_pulse #(
        .COUNT_LIMIT(CLOCK_DELAY-1),
        .COUNT_WIDTH(CLOCK_DELAY_WIDTH),
        .PULSE_START(COL_PULSE_CLOCK_START),
        .PULSE_LIMIT(COL_PULSE_CLOCK_LIMIT),
        .CLOCK_DELAY(0),
        .CLOCK_DELAY_WIDTH(1)
    ) clkpulse (
        .clk(clk),
        .rst(i_rst),
        .pulse(cols_duty)
    );

    async_mux #(
        .OUTPUT_WIDTH(NUM_COLS),
        .INPUTS(NUM_ROWS),
        .INPUTS_WIDTH(NUM_ROWS_WIDTH)
    ) cols_mux (
        .select(row),
        .inputs(i_rows),
        .out(pre_cols)
    );

    binary_decoder #(
        .OUTPUTS(NUM_ROWS),
        .OUTPUTS_WIDTH(NUM_ROWS_WIDTH)
    ) bin_dec (
        .select(row),
        .out(pre_rows)
    );

endmodule



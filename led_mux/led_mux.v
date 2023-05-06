`default_nettype none
// Display an LED matrix multiplexed by row

`include "../clk_counter/clk_counter.v"
`include "../async_mux/async_mux.v"
`include "../binary_decoder/binary_decoder.v"

module led_mux #(
        parameter NUM_ROWS          = 4,
        parameter NUM_ROWS_WIDTH    = 2,
        parameter NUM_COLS          = 8,
        parameter CLOCK_DELAY       = 1000,
        parameter CLOCK_DELAY_WIDTH = 10
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

    wire clkmux;

    reg [(NUM_ROWS_WIDTH-1):0] row;

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

    async_mux #(
        .OUTPUT_WIDTH(NUM_COLS),
        .INPUTS(NUM_ROWS),
        .INPUTS_WIDTH(NUM_ROWS_WIDTH)
    ) cols_mux (
        .select(row),
        .inputs(i_rows),
        .out(o_cols)
    );

    binary_decoder #(
        .OUTPUTS(NUM_ROWS),
        .OUTPUTS_WIDTH(NUM_ROWS_WIDTH)
    ) bin_dec (
        .select(row),
        .out(o_rows)
    );

endmodule



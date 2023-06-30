`default_nettype none
// Composite video testcard

`include "verilog_modules/clk_pulse/clk_pulse.v"
`include "verilog_modules/clk_counter/clk_counter.v"
`include "verilog_modules/reset/reset.v"

module video_testcard
    (
        // Inputs
        input       clk,
        input       i_rst_button,

        // Outputs
        output reg  o_sync,
        output o_white
    );

    // Number of 12MHz clock cycles for some approx microsecond timings
    localparam SCANLINE_64 = 768;       // accurate
    localparam HALFSCANLINE_32 = 384;   // accurate
    localparam BROADSYNC_27_3 = 327;    // rounded down from 327.6 to guarantee >=4.7us gap between broad syncs
    localparam SHORTSYNC_2_35 = 29;     // rounded up from 28.2 to guarantee >=2.35us short sync pulse
    localparam HSYNC_4_7 = 57;          // rounded up from 56.4 to guarantee >=4.7us hsync pulse
    localparam TEXTBORDER_5_175 = 62;   // rounded down from 62.1 - prob not critical
    localparam TEXTAREA_41_6 = 499;     // rounded down from 499.2 - not critical
    localparam BACKPORCH_5_7 = 69;      // rounded up from 68.4 to guarantee minimum width
    localparam FULL_X_LEFT_BORDER = HSYNC_4_7+BACKPORCH_5_7+TEXTBORDER_5_175;

    // Some other useful constants
    localparam HALFSCAN_NUM_BROADSYNCS = 5;
    localparam SCANLINE_FIRST_DISPLAY = 5;
    localparam SCANLINE_FIRST_TEXT = 51;
    localparam SCANLINE_LAST_TEXT = 280;
    localparam SCANLINE_LAST_DISPLAY = 308;

    wire rst;
    wire broad_sync;
    wire short_sync;
    wire hsync;

    wire [9:0] half_scan_line;
    wire [8:0] scan_line;
    wire [7:0] pixel_y;
    wire [9:0] raw_pixel_x;
    wire [8:0] pixel_x;

    assign scan_line[8:0] = half_scan_line[9:1];

    wire textsafe;
    wire textsafe_x;
    wire textsafe_y;

    assign textsafe_y = (scan_line >= SCANLINE_FIRST_TEXT && scan_line <= SCANLINE_LAST_TEXT);

    assign pixel_y = textsafe_y ? scan_line-SCANLINE_FIRST_TEXT : 0;
    assign pixel_x = textsafe_x ? raw_pixel_x-FULL_X_LEFT_BORDER+1 : 0;

    assign textsafe = textsafe_y & textsafe_x;

    assign o_white = (textsafe == 0) ? 0 : ((pixel_y & 7) == 0 || (pixel_x & 7) == 0 ? 1 : 0);

    reset reset (
        .clk(clk),
        .i_rst_button(i_rst_button),
        .o_rst(rst)
    );

    clk_pulse #(
        .COUNT_LIMIT(HALFSCANLINE_32-1),
        .COUNT_WIDTH(9),
        .PULSE_START(0),
        .PULSE_LIMIT(BROADSYNC_27_3-1)
    ) broad_sync_pulse (
        .clk(clk),
        .rst(rst),
        .pulse(broad_sync)
    );

    clk_pulse #(
        .COUNT_LIMIT(HALFSCANLINE_32-1),
        .COUNT_WIDTH(9),
        .PULSE_START(0),
        .PULSE_LIMIT(SHORTSYNC_2_35-1)
    ) short_sync_pulse (
        .clk(clk),
        .rst(rst),
        .pulse(short_sync)
    );

    clk_pulse #(
        .COUNT_LIMIT(SCANLINE_64-1),
        .COUNT_WIDTH(10),
        .PULSE_START(0),
        .PULSE_LIMIT(HSYNC_4_7-1)
    ) hsync_pulse (
        .clk(clk),
        .rst(rst),
        .pulse(hsync)
    );

    clk_pulse #(
        .COUNT_LIMIT(SCANLINE_64-1),
        .COUNT_WIDTH(10),
        .PULSE_START(FULL_X_LEFT_BORDER-1),
        .PULSE_LIMIT(FULL_X_LEFT_BORDER+TEXTAREA_41_6-1)
    ) textsafe_x_pulse (
        .clk(clk),
        .rst(rst),
        .pulse(textsafe_x)
    );

    clk_counter #(
        .CLOCK_DELAY(HALFSCANLINE_32),
        .CLOCK_DELAY_WIDTH(9),
        .COUNT_LIMIT(623),
        .COUNT_WIDTH(10)
    ) half_scan_line_counter (
        .clk(clk),
        .rst(rst),
        .count(half_scan_line)
    );

    // So we have 230 pixels in the y direction
    // Assuming 16:9, that would mean ~409 pixels in the x direction
    // Our text area is 499 12MHz clock cycles wide, so that won't be square,
    // but let's go with it for now
    clk_counter #(
        .CLOCK_DELAY(0),
        .COUNT_LIMIT(SCANLINE_64-1),
        .COUNT_WIDTH(10)
    ) raw_pixel_x_counter (
        .clk(clk),
        .rst(rst),
        .count(raw_pixel_x)
    );

    always @ ( half_scan_line or broad_sync or short_sync or hsync ) begin
        if (half_scan_line < HALFSCAN_NUM_BROADSYNCS)
            o_sync <= ~broad_sync;
        else if (scan_line < SCANLINE_FIRST_DISPLAY || scan_line > SCANLINE_LAST_DISPLAY)
            o_sync <= ~short_sync;
        else
            o_sync <= ~hsync;
    end

endmodule


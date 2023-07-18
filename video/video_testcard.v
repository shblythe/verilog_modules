`default_nettype none
// Composite video testcard module
`include "verilog_modules/clk_counter/clk_counter.v"
`include "verilog_modules/raster_font/raster_font.v"

module video_testcard
    (
        // Inputs
        input       clk,
        input       rst,

        // Outputs
        output o_sync,
        output o_white
    );

    reg         pixel;
    wire [8:0]  x;
    wire [7:0]  y;
    wire        enable;
    wire [2:0]  test_mode;

    video_raw video (
        .clk(clk),
        .rst(rst),
        .i_pixel(pixel),
        .o_sync(o_sync),
        .o_white(o_white),
        .o_enable(enable),
        .o_pixel_x(x),
        .o_pixel_y(y)
    );

    clk_counter #(
        .COUNT_LIMIT(5),
        .COUNT_WIDTH(3),
        .CLOCK_DELAY(24000000),
        .CLOCK_DELAY_WIDTH(25)
    ) uut (
        .clk(clk),
        .rst(rst),
        .count(test_mode)
    );

    wire [2:0] offset;

    clk_counter #(
        .CLOCK_DELAY(239616),
        .CLOCK_DELAY_WIDTH(25),
        .COUNT_LIMIT(7),
        .COUNT_WIDTH(3)
    ) half_scan_line_counter (
        .clk(clk),
        .rst(rst),
        .count(offset)
    );

    wire [5:0] raster_font_row;
    raster_font font
    (
        .o_raster(raster_font_row),
        .i_char(y/8),
        .i_row(y%8)
    );

    /*
    initial
        pixel <= (enable == 0) ? 0 : ((x & 1) == 0);
    */

    always @ ( test_mode or rst ) begin
        if (rst == 1)
            pixel <= 0;
        else
            case (test_mode)
                1:          pixel <= (enable == 0) ? 0 : (((y+offset) & 7) == 0 || ((x+offset) & 7) == 0 ? 1 : 0);
                2:          pixel <= (enable == 0) ? 0 : (raster_font_row >> (6 - x % 6)) & 1;
                3:          pixel <= (enable == 0) ? 0 : 1;
                4:          pixel <= (enable == 0) ? 0 : ((y & 1) == 0);
                5:          pixel <= (enable == 0) ? 0 : ((x & 1) == 0);
                default:    pixel <= (enable == 0) ? 0 : ((y & 7) == 0 || (x & 7) == 0 ? 1 : 0);
            endcase
    end

endmodule



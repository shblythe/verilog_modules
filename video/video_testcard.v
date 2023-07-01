`default_nettype none
// Composite video testcard module

module video_testcard
    (
        // Inputs
        input       clk,
        input       rst,

        // Outputs
        output o_sync,
        output o_white
    );

    wire        pixel;
    wire [8:0]  x;
    wire [7:0]  y;
    wire        enable;

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

    assign pixel = (enable == 0) ? 0 : ((y & 7) == 0 || (x & 7) == 0 ? 1 : 0);

endmodule



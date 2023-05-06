`default_nettype none
`timescale 1 ns / 10 ps

module led_mux_tb ();

    localparam DURATION = 10000;    // 10us
    localparam NUM_COLS = 8;
    localparam NUM_ROWS = 4;

    // Internal signals (tied to UUT outputs)
    wire    [(NUM_COLS-1):0]   o_cols;
    wire    [(NUM_ROWS-1):0]   o_rows;

    // Storage elements (tied to UUT inputs)
    reg     clk = 0;
    reg     rst = 0;
    reg     [(NUM_COLS-1):0]    i_rows  [0:(NUM_ROWS-1)];

    // ~ 12MHz clock
    always begin
        #41.667
        clk = ~clk;
    end

    // UUT
    led_mux #(
        .NUM_ROWS(NUM_ROWS),
        .NUM_ROWS_WIDTH(2),
        .NUM_COLS(NUM_COLS),
        .CLOCK_DELAY(10),
        .CLOCK_DELAY_WIDTH(4)
    ) uut (
        .clk(clk),
        .i_rst(rst),
        .i_rows(i_rows),
        .o_cols(o_cols),
        .o_rows(o_rows)
    );


    // Set up default row values, then
    // pulse reset at the beginning
    initial begin
        i_rows[0] = 8'b00001111;
        i_rows[1] = 8'b11110000;
        i_rows[2] = 8'b11001100;
        i_rows[3] = 8'b10101010;
        #10
        rst = 1'b1;
        #1;
        rst = 1'b0;
    end

    // Run sim, output to .vcd file
    initial begin
        $dumpfile("led_mux_tb.vcd");
        // First parameter here is number of levels to dump signals from
        // 1- just in the testbench
        // 2- in testbench and signals inside the uut module
        // 0- all levels!
        $dumpvars(0, led_mux_tb);

        // Wait for given amount of time to complete simulation
        #(DURATION)

        // Notify and end simulation
        $display("Finished!");
        $finish;
    end

endmodule


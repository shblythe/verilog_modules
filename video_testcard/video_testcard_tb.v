// Define timescale for sim
`timescale 1 ns / 10 ps

// Test bench

module video_testcard_tb();

    // Internal signals (mapped to outputs)
    wire    o_sync;
    wire    o_white;

    // Storage elements (mapped to inputs)
    reg     clk = 0;
    reg     rst = 0;

    // Sim time
    localparam DURATION = 100000000;    // 100 ms

    // ~ 12MHz clock
    always begin
        #41.667
        clk = ~clk;
    end

    // UUT
    video_testcard uut (
        .clk(clk),
        .i_rst_button(rst),
        .o_sync(o_sync),
        .o_white(o_white)
    );

    // Pulse reset after 1 us
    initial begin
        #1000
        rst = 1'b1;
        #1;
        rst = 1'b0;
    end

    // Run sim, output to .vcd file
    initial begin
        $dumpfile("video_testcard_tb.vcd");
        // First parameter here is number of levels to dump signals from
        // 1- just in the testbench
        // 2- in testbench and signals inside the uut module
        // 0- all levels!
        $dumpvars(0, video_testcard_tb);

        // Wait for given amount of time to complete simulation
        #(DURATION)

        // Notify and end simulation
        $display("Finished!");
        $finish;
    end

endmodule


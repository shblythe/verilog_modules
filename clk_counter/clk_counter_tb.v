// Define timescale for sim
`timescale 1 ns / 10 ps

// Test bench

module clk_counter_tb();

    localparam COUNT_WIDTH = 4;

    // Internal signals (mapped to outputs)
    wire    [(COUNT_WIDTH-1):0] count;

    // Storage elements (mapped to inputs)
    reg     clk = 0;
    reg     rst = 0;

    // Sim time
    localparam DURATION = 10000;    // 10 us

    // ~ 12MHz clock
    always begin
        #41.667
        clk = ~clk;
    end

    // UUT
    clk_counter #(
        .COUNT_LIMIT(9),
        .COUNT_WIDTH(COUNT_WIDTH),
        .CLOCK_DELAY(10),
        .CLOCK_DELAY(4)
    ) uut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    // Pulse reset at the beginning
    initial begin
        #10
        rst = 1'b1;
        #1;
        rst = 1'b0;
    end

    // Run sim, output to .vcd file
    initial begin
        $dumpfile("clk_counter_tb.vcd");
        // First parameter here is number of levels to dump signals from
        // 1- just in the testbench
        // 2- in testbench and signals inside the uut module
        // 0- all levels!
        $dumpvars(0, clk_counter_tb);

        // Wait for given amount of time to complete simulation
        #(DURATION)

        // Notify and end simulation
        $display("Finished!");
        $finish;
    end

endmodule


// Define timescale for sim
`timescale 1 ns / 10 ps

// Test bench

module program_counter_tb();

    localparam COUNT_WIDTH = 8;

    // Internal signals (mapped to outputs)
    wire    [(COUNT_WIDTH-1):0] count;

    // Storage elements (mapped to inputs)
    reg     clk = 1;
    reg     rst = 0;
    reg     set = 0;
    reg     [(COUNT_WIDTH-1):0] set_value = 8'd128;

    // Sim time
    localparam DURATION = 1000;    // 1 us

    // ~ 12MHz clock
    always begin
        #41.667
        clk = ~clk;
    end

    // UUT
    program_counter #(
        .COUNT_LIMIT(255),
        .COUNT_WIDTH(COUNT_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .count(count),
        .set(set),
        .set_value(set_value)
    );

    // Pulse reset at the beginning
    initial begin
        #10
        rst = 1'b1;
        #1;
        rst = 1'b0;

        // Pulse set about half way through
        #450;
        set = 1'b1;
        #50;
        set = 1'b0;
    end

    // Run sim, output to .vcd file
    initial begin
        $dumpfile("program_counter_tb.vcd");
        // First parameter here is number of levels to dump signals from
        // 1- just in the testbench
        // 2- in testbench and signals inside the uut module
        // 0- all levels!
        $dumpvars(0, program_counter_tb);

        // Wait for given amount of time to complete simulation
        #(DURATION)

        // Notify and end simulation
        $display("Finished!");
        $finish;
    end

endmodule


// Define timescale for sim
`timescale 1 ns / 10 ps

// Test bench

module register_block_tb();

    // Internal signals (tied to outputs)
    wire    [7:0] r1;
    wire    [7:0] r2;
    wire    [7:0] output_bus;

    // Storage elements (mapped to inputs)
    reg     clk = 1;
    reg     rst = 0;
    reg     w_en = 0;
    reg     r_en = 0;
    reg     [7:0] input_bus;
    reg     [2:0] src;
    reg     [2:0] dst;

    //
    // Sim time
    localparam DURATION = 10000;    // 10 us

    // ~ 12MHz clock
    always begin
        #41.667
        clk = ~clk;
    end

    // UUT
    register_block uut (
        .clk(clk),
        .rst(rst),
        .r1(r1),
        .r2(r2),
        .output_bus(output_bus),
        .write_enable(w_en),
        .read_enable(r_en),
        .input_bus(input_bus),
        .src_reg(src),
        .dst_reg(dst)
    );

    // Pulse reset at the beginning
    initial begin
        #10
        rst = 1'b1;
        #1;
        rst = 1'b0;

        // Write 0x55 to reg 1
        dst = 3'd1;
        input_bus = 8'h55;
        w_en = 1'b1;
        #85;
        w_en = 1'b0;

        // Write 0xaa to reg 2
        dst = 3'd2;
        input_bus = 8'haa;
        w_en = 1'b1;
        #85;
        w_en = 1'b0;

        // Copy reg 1 to reg 5
        dst = 3'd5;
        input_bus = r1;
        w_en = 1'b1;
        #85;
        w_en = 1'b0;

        // Put reg 5 on output bus
        dst = 3'd0;
        src = 3'd5;
        r_en = 1'b1;
        #85;
        r_en = 1'b0;
    end

    // Run sim, output to .vcd file
    initial begin
        $dumpfile("register_block_tb.vcd");
        // First parameter here is number of levels to dump signals from
        // 1- just in the testbench
        // 2- in testbench and signals inside the uut module
        // 0- all levels!
        $dumpvars(0, register_block_tb);

        // Wait for given amount of time to complete simulation
        #(DURATION)

        // Notify and end simulation
        $display("Finished!");
        $finish;
    end

endmodule


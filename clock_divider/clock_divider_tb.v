// Define timescale for simulation: <time_unit> / <time_precision>
// Specific to iverilog!
// 1 unit of delay is 1ns, fractions will be rounded to 10ps
`timescale 1 ns / 10 ps

// Define our testbench
//

module clock_divider_tb();

    // Internal signals
    wire    out;

    // Storage elements (set initial values to 0)
    reg     clk = 0;
    reg     rst = 0;

    // Simulation time: 10000 * 1 ns = 10 us
    localparam DURATION = 10000;

    // Generate clock signal: 1 / ((2*41.67)*1ns)=11,999,040.08 MHz
    always begin
        // Delay for 41.67 time units
        // 10ps precision means that 41.667 is rounded to 41.67 ns
        #41.667

        // Toggle clock line
        clk =~ clk;
    end

    // Instantiate UUT
    clock_divider #(.DIV_WIDTH(4), .DIVIDER(9)) uut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Pulse reset line high at the beginning
    initial begin
        #10
        rst = 1'b1;
        #1
        rst = 1'b0;
    end

    // Run simulation, output to .vcd file
    initial begin
        $dumpfile("clock_divider_tb.vcd");
        // First parameter here is number of levels to dump signals from
        // 1- just in the testbench
        // 2- in testbench and signals inside the uut module
        // 0- all levels!
        $dumpvars(0, clock_divider_tb);

        // Wait for given amount of time to complete simulation
        #(DURATION)

        // Notify and end simulation
        $display("Finished!");
        $finish;
    end
endmodule

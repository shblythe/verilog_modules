//`default_nettype none
`timescale 1 ns / 10 ps

module delay_line_tb ();

    localparam DURATION         = 10000;

    // Internal signals (tied to UUT outputs)
    wire       res;

    // Storage elements (tied to UUT inputs)
    reg        in   =0;
    reg        clk  =1;

    delay_line #(
        .DELAY(5)
    ) uut
    (
        .in(in),
        .clk(clk),
        .out(res)
    );

    // ~ 12MHz clock
    always begin
        #41.667
        clk = ~clk;
    end

    always begin
        #1000
        in = ~in;
    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("delay_line_tb.vcd");
        $dumpvars(0, delay_line_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

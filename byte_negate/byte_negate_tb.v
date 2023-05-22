//`default_nettype none
`timescale 1 ns / 10 ps

module byte_negate_tb ();

    localparam DURATION         = 10000;

    // Internal signals (tied to UUT outputs)
    wire    [7:0]   res;

    // Storage elements (tied to UUT inputs)
    reg     [7:0]   in;

    byte_negate uut
    (
        .in(in),
        .out(res)
    );

    initial begin
        in = 8'h01;
        #1000;

        in = 8'h00;
        #1000;

        in = 8'h7f;
        #1000;

        in = 8'h20;
        #1000;

        in = 8'hff;
        #1000;

        in = 8'h80;
        #1000;

    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("byte_negate_tb.vcd");
        $dumpvars(0, byte_negate_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

//`default_nettype none
`timescale 1 ns / 10 ps

module byte_switch_tb ();

    localparam DURATION         = 10000;

    // Internal signals (tied to UUT outputs)
    wire    [7:0]   res;

    // Storage elements (tied to UUT inputs)
    reg     [7:0]   in;
    reg             enable;

    byte_switch uut
    (
        .in(in),
        .enable(enable),
        .out(res)
    );

    initial begin
        in = 8'h01;
        enable = 1'b1;
        #1000;

        in = 8'h00;
        enable = 1'b0;
        #1000;

        in = 8'h7f;
        enable = 1'b1;
        #1000;

        in = 8'h20;
        enable = 1'b0;
        #1000;

        in = 8'hff;
        enable = 1'b1;
        #1000;

        in = 8'h80;
        enable = 1'b0;
        #1000;

    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("byte_switch_tb.vcd");
        $dumpvars(0, byte_switch_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

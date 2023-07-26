//`default_nettype none
`timescale 1 ns / 10 ps

module byte_selector_tb ();

    localparam DURATION         = 10000;

    // Internal signals (tied to UUT outputs)
    wire    [7:0]   res;

    // Storage elements (tied to UUT inputs)
    reg     [7:0]   in0;
    reg     [7:0]   in1;
    reg             select;

    byte_selector uut
    (
        .in0(in0),
        .in1(in1),
        .select(select),
        .out(res)
    );

    initial begin
        in0 = 8'h01;
        in1 = 8'h10;
        select = 1'b1;
        #500;

        select = 1'b0;
        #500;

        in0 = 8'h00;
        in1 = 8'hff;
        #500;

        select = 1'b1;
        #500;

        in0 = 8'h7f;
        in1 = 8'hf7;
        #500;

        select = 1'b0;
        #500;

        in0 = 8'h20;
        in1 = 8'h02;
        #500;

        select = 1'b1;
        #500;

        in0 = 8'hff;
        in1 = 8'haa;
        #500;

        select = 1'b0;
        #500;

        in0 = 8'h80;
        in1 = 8'h08;
        #500;

        select = 1'b1;
        #500;

    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("byte_selector_tb.vcd");
        $dumpvars(0, byte_selector_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

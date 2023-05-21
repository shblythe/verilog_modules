//`default_nettype none
`timescale 1 ns / 10 ps

module byte_adder_tb ();

    localparam DURATION         = 10000;

    // Internal signals (tied to UUT outputs)
    wire    [7:0]   res;
    wire            carry;

    // Storage elements (tied to UUT inputs)
    reg     [7:0]   input1;
    reg     [7:0]   input2;

    byte_adder uut
    (
        .i_a(input1),
        .i_b(input2),
        .o_r(res),
        .o_c(carry)
    );

    initial begin
        input1 = 8'haa;
        input2 = 8'h55;
        #1000;

        input1 = 8'h12;
        input2 = 8'h23;
        #1000;

        input1 = 8'hff;
        input2 = 8'h01;
        #1000;

        input1 = 8'h80;
        input2 = 8'hc4;
        #1000;

        input1 = 8'hff;
        input2 = 8'hff;
        #1000;

        input1 = 8'h00;
        input2 = 8'h00;
        #1000;
    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("byte_adder_tb.vcd");
        $dumpvars(0, byte_adder_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

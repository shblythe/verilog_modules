//`default_nettype none
`timescale 1 ns / 10 ps

module logic_engine_tb ();

    localparam DURATION         = 10000;

    localparam OR               = 2'b00;
    localparam NAND             = 2'b01;
    localparam NOR              = 2'b10;
    localparam AND              = 2'b11;

    // Internal signals (tied to UUT outputs)
    wire    [7:0]   res;

    // Storage elements (tied to UUT inputs)
    reg     [7:0]   input1;
    reg     [7:0]   input2;
    reg     [1:0]   instruction;

    logic_engine uut
    (
        .i_a(input1),
        .i_b(input2),
        .out(res),
        .i_instruction(instruction)
    );

    initial begin
        instruction = OR;
        input1 = 8'haa;
        input2 = 8'h55;
        #1000;

        instruction = NAND;
        input1 = 8'h12;
        input2 = 8'h23;
        #1000;

        instruction = AND;
        input1 = 8'hff;
        input2 = 8'h01;
        #1000;

        instruction = NOR;
        input1 = 8'h80;
        input2 = 8'hc4;
        #1000;

        instruction = NAND;
        input1 = 8'hff;
        input2 = 8'hff;
        #1000;

        instruction = NOR;
        input1 = 8'h00;
        input2 = 8'h00;
        #1000;
    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("logic_engine_tb.vcd");
        $dumpvars(0, logic_engine_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

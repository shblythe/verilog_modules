//`default_nettype none
`timescale 1 ns / 10 ps

module arithmetic_engine_tb ();

    localparam DURATION         = 10000;

    localparam OR               = 3'b000;
    localparam NAND             = 3'b001;
    localparam NOR              = 3'b010;
    localparam AND              = 3'b011;
    localparam ADD              = 3'b100;
    localparam SUB              = 3'b101;

    // Internal signals (tied to UUT outputs)
    wire    [7:0]   res;

    // Storage elements (tied to UUT inputs)
    reg     [7:0]   input1;
    reg     [7:0]   input2;
    reg     [2:0]   instruction;

    arithmetic_engine uut
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

        instruction = ADD;
        input1 = 8'h55;
        input2 = 8'h55;
        #1000;

        input1 = 8'hFF;
        input2 = 8'h01;
        #1000;

        instruction = SUB;
        input1 = 8'hAA;
        input2 = 8'h55;
        #1000;

        input1 = 8'h00;
        input2 = 8'h01;
        #1000;

    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("arithmetic_engine_tb.vcd");
        $dumpvars(0, arithmetic_engine_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

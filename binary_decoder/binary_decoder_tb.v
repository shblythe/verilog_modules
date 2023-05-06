`default_nettype none
`timescale 1 ns / 10 ps

module binary_decoder_tb ();

    localparam OUTPUTS          = 4;
    localparam OUTPUTS_WIDTH    = 2;
    localparam DURATION         = 10000;

    // Internal signals (tied to UUT outputs)
    wire    [(OUTPUTS-1):0]         out;

    // Storage elements (tied to UUT inputs)
    reg     [(OUTPUTS_WIDTH-1):0]   select;

    binary_decoder #(
        .OUTPUTS(OUTPUTS),
        .OUTPUTS_WIDTH(OUTPUTS_WIDTH)
    ) uut
    (
        .select(select),
        .out(out)
    );

    integer isel;

    initial begin
        while (1) begin
            for (isel = 0; isel < OUTPUTS; isel=isel+1 ) begin
                select = isel;
                #1000;
            end
        end
    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("binary_decoder_tb.vcd");
        $dumpvars(0, binary_decoder_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

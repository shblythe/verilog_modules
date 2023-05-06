`default_nettype none
`timescale 1 ns / 10 ps

module async_mux_tb();

    // Internal signals (tied to UUT outputs)
    wire [7:0] out;

    // Storage elements (tied to UUT inputs)
    reg [1:0] select     = 0;
    reg [7:0] in [3:0];

    // Simulation time
    localparam DURATION = 10000;   // 100 us

    // Instantiate UUT
    async_mux #(
    ) uut (
        .out(out),
        .select(select),
        .inputs(in)
    );

    // Run test
    integer isel;   // button loop
    integer ibnc;   // bounce loop
    initial begin
        in[0] = 8'b00001111;
        in[1] = 8'b11110000;
        in[2] = 8'b11001100;
        in[3] = 8'b10101010;
        while (1) begin
            for (isel = 0; isel < 4; isel = isel + 1) begin
                select = isel;
                #1000;
            end
        end
    end


    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("async_mux_tb.vcd");
        $dumpvars(0, async_mux_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

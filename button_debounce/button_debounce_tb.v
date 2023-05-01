`default_nettype none
`timescale 1 ns / 10 ps

module button_debounce_tb();

    // Internal signals (tied to UUT outputs)
    wire debounced_button;

    // Storage elements (tied to UUT inputs)
    reg clk     = 0;
    reg button;

    // Simulation time
    localparam DURATION = 100000;   // 100 us

    // Generate clock signal ~12 MHz
    always begin
        #41.67
        clk = ~clk;
    end

    // Instantiate UUT
    button_debounce #(
        .DEBOUNCE_TOTAL(120) // 10 us
    ) uut (
        .clk(clk),
        .but(button),
        .butd(debounced_button)
    );

    // Run test
    integer ibut;   // button loop
    integer ibnc;   // bounce loop
    initial begin
        for (ibut = 0; ibut < 4; ibut = ibut + 1) begin
            button = 0;
            #11000  // 11 us
            for (ibnc = 0; ibnc < 25; ibnc = ibnc + 1) begin
                button = {$random} %2;
                #100;    // 0.1 us, so total 2.5 us
            end
            button = 1;
            #11000  // 11 us
            for (ibnc = 0; ibnc < 25; ibnc = ibnc + 1) begin
                button = {$random} %2;
                #100;    // 0.1 us, so total 2.5 us
            end
        end
    end


    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("button_debounce_tb.vcd");
        $dumpvars(0, button_debounce_tb);

        // Wait for completion
        #(DURATION)

        // Done
        $display("Finished!");
        $finish;
    end

endmodule

`timescale 1 ns / 10 ps

// Define our testbench

module raster_font_tb();

    // Internal signals
    wire    [5:0]   raster;

    // Storage elements
    reg     [5:0]   char;
    reg     [3:0]   row;

    // Simulation time
    localparam DURATION = 10000;    // 10 us

    // Instantiate UUT
    raster_font uut
    (
        .o_raster(raster),
        .i_char(char),
        .i_row(row)
    );

    // Run test: write to location and read back
    //
    integer a;
    initial begin

        // Test : read all
        //
        for (char = 0; char < 32; char = char + 1) begin
            for (row = 0; row < 8; row = row + 1) begin
                #41.67;
            end
        end
    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("raster_font_tb.vcd");
        $dumpvars(0, raster_font_tb);

        // Wait for sim to complete
        #(DURATION)

        // Notify and end sim
        $display("Finished!");
        $finish;
    end
endmodule


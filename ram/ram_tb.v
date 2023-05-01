`timescale 1 ns / 10 ps

// Define our testbench

module ram_tb();

    // Internal signals
    wire    [7:0]   r_data;

    // Storage elements
    reg             clk     = 0;
    reg             w_en    = 0;
    reg             r_en    = 0;
    reg     [3:0]   w_addr;
    reg     [3:0]   r_addr;
    reg     [7:0]   w_data;

    // Simulation time
    localparam DURATION = 10000;    // 10 us

    // Generate clock signal ~12 MHz
    always begin
        #41.67
        clk = ~clk;
    end

    // Instantiate UUT
    ram #(
        .INIT_FILE("mem_init.txt")
    ) uut
    (
        .clk(clk),
        .w_en(w_en),
        .r_en(r_en),
        .w_addr(w_addr),
        .r_addr(r_addr),
        .w_data(w_data),
        .r_data(r_data)
    );

    // Run test: write to location and read back
    //
    integer a;
    initial begin

        // Test 1: read all
        //
        for (a = 0; a < 16; a = a + 1) begin
            #(2*41.67)
            r_addr = a;
            r_en = 1;
            #(2*41.67)
            r_addr = 0;
            r_en = 0;
        end

        // Test 2: write to address 0x0f and read it back
        #(2*41.67)
        w_addr = 'hf;
        w_data = 'hA5;
        w_en = 1;
        #(2*41.67)
        w_addr = 0;
        w_data = 0;
        w_en = 0;
        r_addr = 'hf;
        r_en = 1;
        #(2*41.67)
        r_addr = 0;
        r_en = 0;
    end

    // Run sim
    initial begin
        // Create sim output file
        $dumpfile("ram_tb.vcd");
        $dumpvars(0, ram_tb);
        
        // Wait for sim to complete
        #(DURATION)

        // Notify and end sim
        $display("Finished!");
        $finish;
    end
endmodule


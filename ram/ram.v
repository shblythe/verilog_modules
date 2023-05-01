// Inferred block RAM

module ram  #(
    parameter INIT_FILE = ""
)
(
    // Inputs
    input       clk,
    input       w_en,
    input       r_en,
    input [3:0] w_addr,
    input [3:0] r_addr,
    input [7:0] w_data,

    // Output
    output reg [7:0] r_data
    );

    // Memory block, 8 bits wide, 16 bytes deep
    reg [7:0] mem [0:15];

    // Interact with the memory block
    always @ (posedge clk) begin

        // Write
        if (w_en == 1'b1)
            mem[w_addr] <= w_data;

        // Read
        if (r_en == 1'b1)
            r_data <= mem[r_addr];
    end

    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);
    end

endmodule




// Raster font

module raster_font
(
    // Inputs
    input [5:0] i_char,
    input [2:0] i_row,

    // Output
    output [5:0] o_raster
    );

    localparam INIT_FILE="font_bin.txt";

    // Memory block, 6 bits wide, 32(chars)*8(rows) words deep
    reg [5:0] mem [255:0];

    assign o_raster = mem[i_char*8+i_row];

    initial if (INIT_FILE) begin
        $readmemh(INIT_FILE, mem);
    end

endmodule




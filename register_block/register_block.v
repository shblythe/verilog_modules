`default_nettype none
// Register block, 6 8-bit registers
//  The R1,R2 values are exposed always from 2 8-bit output buses
//  8-bit general input and output buses
//  3-bit source address bus to select output register
//  3-bit dest address bus to select input register
//  1-bit WE pin, to enable write from input bus to dest register on clock
//  1-bit OE pin, to enable read from source address to output but, else
//          output bus is high-Z
//  All registers reset to 0 on RST

`ifndef __REGISTER_BLOCK
`define __REGISTER_BLOCK

module register_block
    (
        // Inputs
        input       clk,
        input       rst,
        input       write_enable,
        input       read_enable,
        input       [7:0] input_bus,
        input       [2:0] src_reg,
        input       [2:0] dst_reg,

        // Outputs
        output      wire [7:0] r1,
        output      wire [7:0] r2,
        output      reg [7:0] output_bus
    );

    reg [7:0]   registers [5:0];

    assign r1 = registers[1];
    assign r2 = registers[2];

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            registers[0] <= 'b0;
            registers[1] <= 'b0;
            registers[2] <= 'b0;
            registers[3] <= 'b0;
            registers[4] <= 'b0;
            registers[5] <= 'b0;
        end else begin
            if (read_enable == 1'b1)
                output_bus = registers[src_reg];
            else
                output_bus = 8'bZ;
            if (write_enable == 1'b1)
                registers[dst_reg] = input_bus;
        end
    end

endmodule

`endif


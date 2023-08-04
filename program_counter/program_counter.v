`default_nettype none
// Automatic binary counter with optionally divided clock

`ifndef __PROGRAM_COUNTER
`define __PROGRAM_COUNTER

module program_counter #(
        parameter COUNT_LIMIT       = 255,
        parameter COUNT_WIDTH       = 8
    )
    (
        // Inputs
        input       clk,
        input       rst,
        input       set,
        input       [(COUNT_WIDTH-1):0] set_value,

        // Outputs
        output      reg [(COUNT_WIDTH-1):0] count
    );

    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1)
            count <= 'b0;
        else if (set == 1'b1)
            count <= set_value;
        else if (count == COUNT_LIMIT)
            count <= 'b0;
        else
            count <= count + 1'b1;
    end

endmodule

`endif


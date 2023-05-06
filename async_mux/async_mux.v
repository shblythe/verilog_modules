`default_nettype none
// Output one of N inputs based on a binary-encoded selection
//
// Needs SystemVerilog!

module async_mux #(
    parameter OUTPUT_WIDTH      = 8,
    parameter INPUTS            = 4,
    parameter INPUTS_WIDTH      = 2
)
(
        // Inputs
        input           [(INPUTS_WIDTH-1):0]          select,

        // Can't do this without SystemVerilog, have an array of inputs like this.
        input           [(OUTPUT_WIDTH-1):0]   inputs [0:(INPUTS-1)],

        // Outputs
        output  reg     [(OUTPUT_WIDTH-1):0]   out
    );

    assign out = inputs[select];

endmodule


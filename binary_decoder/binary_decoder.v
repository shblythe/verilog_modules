`default_nettype none
// Activate one of N outputs based on a binary-encoded selection

module binary_decoder #(
        parameter OUTPUTS       = 4,
        parameter OUTPUTS_WIDTH = 2
    )
    (
        // Inputs
        input       [(OUTPUTS_WIDTH-1):0]   select,
        
        // Outputs
        output      [(OUTPUTS-1):0]         out
    );

    assign out = 1 << select;

endmodule


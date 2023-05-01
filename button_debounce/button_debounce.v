`default_nettype none
// Count up on each button press and display on LEDs

module button_debounce #(
    parameter DEBOUNCE_WIDTH    = 22,
    parameter DEBOUNCE_TOTAL    = 22'd1200000
)
(
        // Inputs
        input           clk,
        input           but,

        // Outputs
        output  reg     butd
    );

    // Debounce but -> butd implemented as a Mealy state machine
    localparam STATE_IDLE       = 1'd0;
    localparam STATE_PRESSED    = 1'd1;
    reg state;
    reg [(DEBOUNCE_WIDTH-1):0] debounce_count;
    always @ (posedge clk) begin
        case (state)
            // Wait for button press
            STATE_IDLE: begin
                butd <= 0;
                if (but == 1'b1) begin
                    debounce_count <=0;
                    state <= STATE_PRESSED;
                end
            end
            
            STATE_PRESSED: begin
                if (but == 1'b0) begin
                    state <= STATE_IDLE;
                end else begin
                    debounce_count <= debounce_count + 1'b1;
                    if (debounce_count == DEBOUNCE_TOTAL-1) begin
                        butd <= 1;
                    end
                end
            end

            default: state <= STATE_IDLE;
        endcase
    end
endmodule


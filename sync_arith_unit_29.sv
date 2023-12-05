`define OP_SHIFT 2'b00
`define OP_ADD   2'b01
`define OP_DIV   2'b10
`define OP_U2    2'b11

module sync_arith_unit_29 #(parameter M = 8) (
    input wire [1:0] i_op,
    input wire [M-1:0] i_arg_A,
    input wire [M-1:0] i_arg_B,
    input wire i_clk,
    input wire i_reset,
    output reg [M-1:0] o_result,
    output reg [3:0] o_status
);

    // Status flags definitions
    localparam ERROR = 3;
    localparam ZEROS = 1;
    localparam OVERFLOW = 0;

    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) begin
            // Resetting the module
            o_result <= 0;
            o_status <= 0;
        end else begin
            // Resetting the status at the start of each cycle
            o_status <= 0;

            case (i_op)
                `OP_SHIFT: begin
                    int signed_arg_B = $signed(i_arg_B); // Convert to signed for proper shift
                    if (signed_arg_B < 0) begin
                        o_status[ERROR] <= 1'b1;
                        o_result <= {M{1'bx}}; // Undefined value
                    end else begin
                        o_result <= i_arg_A >> signed_arg_B;
                    end
                end

                `OP_ADD: begin
                    o_result <= i_arg_A + ~i_arg_B;
                    // Check for overflow
                    if (^o_result[M-1:0] != o_result[M-1]) begin
                        o_status[OVERFLOW] <= 1'b1;
                    end
                end

                `OP_DIV: begin
                    if (i_arg_B == 0) begin
                        o_status[ERROR] <= 1'b1;
                        o_result <= {M{1'bx}};
                    end else begin
                        o_result <= i_arg_A / i_arg_B;
                    end
                end

                `OP_U2: begin
                    if (i_arg_A[M-1] == 1'b0) begin
                        o_result <= i_arg_A;
                    end else begin
                        o_result <= (~i_arg_A + 1'b1);
                    end
                end

                default: begin
                    o_status[ERROR] <= 1'b1; // Unknown operation
                end
            endcase

            // Additional status checks
            if (o_result == 0) begin
                o_status[ZEROS] <= 1'b1;
            end
        end
    end
endmodule

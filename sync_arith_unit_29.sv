`timescale 1ns / 1ps

module sync_arith_unit_29 #(parameter M = 32) (
    input wire [M-1:0] iarg_A,    // Input argument A, M-bit wide
    input wire [M-1:0] iarg_B,    // Input argument B, M-bit wide
    input wire [3:0] iop,         // Operation code input, 4-bit wide
    input wire clk,               // Clock input
    input wire i_reset,           // Synchronous reset input
    output reg [M-1:0] o_result,  // Output result, M-bit wide
    output reg [3:0] o_status     // Output status, 4-bit wide
);

// Status flags definitions
localparam ERROR = 3;        // Error flag
localparam NOT_EVEN_1 = 2;   // Flag for odd number of ones in the result
localparam ZEROS = 1;        // Flag indicating all zeros in the result
localparam OVERFLOW = 0;     // Overflow flag

// ALU logic implementation
always @(posedge clk or negedge i_reset) begin
    if (!i_reset) begin
        // Resetting the module
        o_result <= 0;
        o_status <= 0;
    end else begin
        // Resetting the status at the start of each cycle
        o_status <= 0;

        case (iop)
            4'b0000: begin // Operation A<~B (Bitwise Right Shift)
                if (~iarg_B < 0) begin
                    o_status[ERROR] <= 1'b1;
                    o_result <= {M{1'bx}}; // Undefined value
                end else begin
                    o_result <= iarg_A >> ~iarg_B;
                end
            end
            4'b0001: begin // Operation AS~B (Check if A <= ~B)
                o_result <= (iarg_A <= ~iarg_B) ? {M{1'b1}} : {M{1'b0}};
            end
            4'b0010: begin // Operation A/B (Division)
                if (iarg_B == 0) begin
                    o_status[ERROR] <= 1'b1;
                    o_result <= {M{1'bx}}; // Undefined value
                end else begin
                    int signed_dividend = $signed(iarg_A);
                    int signed_divisor = $signed(iarg_B);
                    int signed_result = signed_dividend / signed_divisor;
                    o_result <= signed_result;
                end
            end
            4'b0011: begin // Operation ZM(A) => U2(A) (Code Conversion)
                if (iarg_A[M-1] == 1'b0) begin // Positive number
                    o_result <= iarg_A;
                end else begin // Negative number
                    o_result <= (~iarg_A + 1'b1) | (1'b1 << (M-1)); // Convert to Two's Complement
                end
            end
            default: begin
                o_status[ERROR] <= 1'b1; // Unknown operation
            end
        endcase
    end
end

endmodule

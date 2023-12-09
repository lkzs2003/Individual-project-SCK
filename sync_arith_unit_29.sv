`timescale 1ns / 1ps

module divider #(parameter M = 32) (
    input wire signed [M-1:0] dividend,  // Make inputs signed to handle negative numbers
    input wire signed [M-1:0] divisor,
    output reg signed [M-1:0] quotient,
    output reg signed [M-1:0] remainder
);

    integer i;
    reg signed [2*M-1:0] temp_dividend;  // Make temp_dividend signed

    always @* begin  // Use always @* for sensitivity list based on used signals
        quotient = 0;
        remainder = 0;
        temp_dividend = {{M{1'b0}}, dividend};

        if (divisor != 0) begin
            for (i = M-1; i >= 0; i = i - 1) begin
                remainder = (remainder << 1) | temp_dividend[2*M-1];
                temp_dividend = temp_dividend << 1;

                if (remainder >= 0) begin  // Compare with 0 instead of divisor
                    remainder = remainder - divisor;
                    quotient[i] = 1;
                end
            end
        end else begin
            quotient = {M{1'bx}};
            remainder = {M{1'bx}};
        end
    end
endmodule

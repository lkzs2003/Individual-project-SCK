`timescale 1ns / 1ps

module divider #(parameter M = 32) (
    input wire signed [M-1:0] dividend,
    input wire signed [M-1:0] divisor,
    output reg signed [M-1:0] quotient,
    output reg signed [M-1:0] remainder
);

    reg signed [M-1:0] signed_dividend;
    reg signed [M-1:0] signed_divisor;
    
    always @* begin
        signed_dividend = dividend;
        signed_divisor = divisor;
    end

    always @(posedge signed_dividend or negedge signed_dividend or
              posedge signed_divisor or negedge signed_divisor) begin
        if (signed_divisor !== 0) begin
            {quotient, remainder} <= signed_dividend / signed_divisor;
        end else begin
            {quotient, remainder} <= {M{1'bx}};
        end
    end
endmodule

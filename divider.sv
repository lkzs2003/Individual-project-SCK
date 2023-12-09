`timescale 1ns / 1ps

module divider #(parameter M = 32) (
    input wire clk,  // Dodano zegar
    input wire reset,  // Dodano reset
    input wire signed [M-1:0] dividend,
    input wire signed [M-1:0] divisor,
    output reg signed [M-1:0] quotient,
    output reg signed [M-1:0] remainder
);

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            quotient <= 0;
            remainder <= 0;
        end else if (divisor != 0) begin  // Poprawiona obsługa dzielenia przez zero
            quotient <= dividend / divisor;
            remainder <= dividend % divisor;
        end else begin
            quotient <= {M{1'bx}};
            remainder <= {M{1'bx}};
        end
    end
endmodule

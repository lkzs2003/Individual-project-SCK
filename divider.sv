`timescale 1ns / 1ps

module divider #(parameter M = 32) (
    input wire [M-1:0] dividend,
    input wire [M-1:0] divisor,
    output reg [M-1:0] quotient,
    output reg [M-1:0] remainder,
    output reg error // Flaga błędu dla dzielenia przez zero
);

    integer i;
    reg [M-1:0] temp_dividend;

    always @(dividend, divisor) begin
        quotient = 0;
        remainder = 0;
        temp_dividend = dividend;
        error = 0; // Domyślnie brak błędu

        // Sprawdzanie, czy dzielnik jest równy zero
        if (divisor == 0) begin
            error = 1; // Ustawienie flagi błędu
            quotient = {M{1'bx}}; // Niezdefiniowana wartość dla ilorazu
            remainder = {M{1'bx}}; // Niezdefiniowana wartość dla reszty
        end else begin
            for (i = M-1; i >= 0; i = i - 1) begin
                remainder = remainder << 1;
                remainder[0] = temp_dividend[i];
                if (remainder >= divisor) begin
                    remainder = remainder - divisor;
                    quotient[i] = 1;
                end
            end
        end
    end
endmodule

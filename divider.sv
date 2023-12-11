module divider #(
    parameter M = 32
) (
    input wire clk,
    input wire reset,
    input wire [M-1:0] dividend,
    input wire [M-1:0] divisor,
    output reg [M-1:0] quotient,
    output reg [M-1:0] remainder
);

    reg [2*M-1:0] internal_dividend;
    reg [M-1:0] internal_divisor;
    reg [M-1:0] temp_quotient;
    reg [5:0] count; // Licznik do iteracji

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            quotient <= 0;
            remainder <= 0;
            count <= 0;
        end else begin
            if (count == 0) begin
                if (divisor == 0) begin
                    quotient <= 0;  
                    remainder <= 0;
                end else begin
                    internal_dividend <= {M{1'b0}} | dividend;  // Rozszerzenie do 2*M bitów
                    internal_divisor <= divisor;
                    temp_quotient <= 0;
                    count <= M;
                end
            end else begin
                temp_quotient <= temp_quotient << 1;
                internal_dividend <= internal_dividend << 1;

                if (internal_dividend[M-1:M-1] >= internal_divisor) begin
                    internal_dividend <= internal_dividend - internal_divisor;
                    temp_quotient <= temp_quotient | 1;
                end

                count <= count - 1;
                if (count == 1) begin
                    quotient <= temp_quotient;
                    remainder <= internal_dividend[M-1:0];
                end
            end
        end
    end
endmodule

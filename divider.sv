module divider #(parameter M = 32) (
    input wire [M-1:0] A,
    input wire [M-1:0] B,
    output reg [M-1:0] quotient,
    output reg [M-1:0] remainder,
    output reg error
);

    integer i;
    reg [M-1:0] negated_B;
    reg [M-1:0] temp_remainder;

    always @(*) begin
        negated_B = ~B; // Negacja bitowa B
        quotient = 0;
        temp_remainder = 0;
        error = 0;

        // Sprawdzenie dzielenia przez zero
        if (negated_B == 0) begin
            error = 1;
            quotient = 'bx; // stan nieokreślony
            remainder = 'bx; 
        end else begin
            for (i = M-1; i >= 0; i = i - 1) begin
                temp_remainder = temp_remainder << 1;
                temp_remainder[0] = A[i];

                if (temp_remainder >= negated_B) begin
                    temp_remainder = temp_remainder - negated_B;
                    quotient[i] = 1;
                end
            end
            remainder = temp_remainder;
        end
    end
endmodule

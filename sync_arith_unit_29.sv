`include "divider.sv"

`timescale 1ns / 1ps

module sync_arith_unit_29 #(parameter M = 32) (
    input wire [M-1:0] iarg_A,
    input wire [M-1:0] iarg_B,
    input wire [3:0] iop,
    input wire clk,
    input wire i_reset,
    output reg [M-1:0] o_result,
    output reg [3:0] o_status
);

    // Definicje operacji
    localparam OP_BITWISE_SHIFT = 4'b0000;
    localparam OP_COMPARE_AS = 4'b0001;
    localparam OP_DIVIDE = 4'b0010;
    localparam OP_ZM_TO_U2 = 4'b0011;

    // Status flags definitions
    localparam ERROR = 3;
    localparam NOT_EVEN_1 = 2;
    localparam ZEROS = 1;
    localparam OVERFLOW = 0;

    // Instancja modułu divider
    wire [M-1:0] div_quotient, div_remainder;
    divider #(.M(M)) div_unit (
        .clk(clk),
        .reset(i_reset),
        .dividend(iarg_A),
        .divisor(~iarg_B), // Uwzględnienie zaprzeczenia B dla dzielenia
        .quotient(div_quotient),
        .remainder(div_remainder)
    );

    always @(posedge clk or negedge i_reset) begin
        if (!i_reset) begin
            o_result <= 0;
            o_status <= 0;
        end else begin
            // Resetowanie flag statusu
            o_status <= 0;

            case (iop)
                OP_BITWISE_SHIFT: begin
                if (iarg_B >= M) begin // Zmiana warunku na porównanie z szerokością wektora
                    o_status[ERROR] <= 1'b1;
                    o_result <= {M{1'bx}};
                end else begin
                    o_result <= iarg_A >> iarg_B;
                end
            end
                OP_COMPARE_AS: begin
                    o_result <= (iarg_A <= ~iarg_B) ? 32'b1 : 32'b0;
                end
                OP_DIVIDE: begin
                    if (iarg_B == 0) begin
                        o_status[ERROR] <= 1'b1;
                        o_result <= {M{1'bx}};
                    end else begin
                        o_result <= iarg_A / ~iarg_B;
                    end
                end
                OP_ZM_TO_U2: begin
                    if (iarg_A[M-1]) begin
                        o_result <= (~iarg_A + 1);
                    end else begin
                        o_result <= iarg_A;
                    end
                end
                default: begin
                    o_status[ERROR] <= 1'b1;
                end
            endcase

            // Ustawianie flagi ZEROS
            o_status[ZEROS] <= (o_result == 0);

            // Ustawianie flagi NOT EVEN_1
            o_status[NOT_EVEN_1] <= (^o_result) & ~o_status[ERROR];
        end
    end
endmodule

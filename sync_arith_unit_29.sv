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

    localparam OP_BITWISE_SHIFT = 4'b0000; 
    localparam OP_COMPARE_AS = 4'b0001; 
    localparam OP_DIVIDE = 4'b0010; 
    localparam OP_ZM_TO_U2 = 4'b0011; 

    localparam ERROR = 3; 
    localparam NOT_EVEN_1 = 2; 
    localparam ZEROS = 1; 
    localparam OVERFLOW = 0; 

    wire [M-1:0] quotient, remainder; // Iloraz i reszta z dzielenia
    wire division_error; // Sygnał błędu podczas dzielenia
    divider #(.M(M)) div_unit (
        .A(iarg_A),
        .B(~iarg_B),
        .quotient(quotient),
        .remainder(remainder),
        .error(division_error)
    );

    always @(posedge clk or negedge i_reset) begin
        if (!i_reset) begin
            o_result <= 0;
            o_status <= 0;
        end else begin
            o_status <= 4'b0000; // Resetuj status 
            case (iop)
                OP_BITWISE_SHIFT: begin
                    if (iarg_B >= M) begin
                        o_result <= 0;
                        o_status[OVERFLOW] <= 1'b1;
                    end else begin
                        o_result <= iarg_A >> iarg_B;
                    end
                    o_status[ZEROS] <= (o_result == 0);
                    o_status[NOT_EVEN_1] <= (^o_result);
                end
                OP_COMPARE_AS: begin
                    // Porównanie A <= ~B w kodzie ZM
                    if (iarg_A[M-1] == iarg_B[M-1]) begin
                        // Liczby mają taki sam znak
                        o_result <= (iarg_A < iarg_B) ? 1'b1 : 1'b0;
                    end else begin
                        // Liczby mają przeciwne znaki
                        o_result <= iarg_A[M-1] ? 1'b0 : 1'b1;
                    end
                end
                OP_DIVIDE: begin
                    if (division_error) begin
                        o_status <= 4'b1000; // Błąd
                        o_result <= {(M){1'bx}}; // Wynik nieokreślony
                    end else begin
                        o_result <= quotient;
                        o_status <= 4'b0000;
                    end
                end
                OP_ZM_TO_U2: begin
                    if (iarg_A[M-1]) begin
                        if (iarg_A == {1'b1, {(M-1){1'b0}}}) begin
                            o_result <= {(M){1'bx}}; // Wynik nieokreślony
                            o_status[ERROR] <= 1'b1; // Błąd
                        end else begin
                            o_result <= {1'b1, ~iarg_A[M-2:0] + 1'b1};
                        end
                    end else begin
                        o_result <= iarg_A; // Liczba dodatnia pozostaje bez zmian
                    end
                end
                default: begin
                    o_status[ERROR] <= 1'b1;
                end
            endcase

            o_status[ZEROS] <= (o_result == 0);
            o_status[NOT_EVEN_1] <= (^o_result) & ~o_status[ERROR];
        end
    end
endmodule

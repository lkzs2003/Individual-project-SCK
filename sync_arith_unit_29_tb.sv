`include "sync_arith_unit_29.sv"

`timescale 1ns / 1ps

module sync_arith_unit_29_tb;

    parameter M = 32;
    reg [M-1:0] iarg_A, iarg_B;
    reg [3:0] iop;
    reg clk, i_reset;
    wire [M-1:0] o_result;
    wire [3:0] o_status;

    sync_arith_unit_29 #(.M(M)) UUT (
        .iarg_A(iarg_A),
        .iarg_B(iarg_B),
        .iop(iop),
        .clk(clk),
        .i_reset(i_reset),
        .o_result(o_result),
        .o_status(o_status)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        i_reset = 1'b1;
        iarg_A = 0;
        iarg_B = 0;
        iop = 0;

        // Reset
        #10 i_reset = 1'b0;
        #20 i_reset = 1'b1;

        // Testy operacji przesunięcia bitowego
        performTest(32'b11111111111111110000000000000000, 32'b00000000000000000000000000000100, 4'b0000);
        performTest(32'b10101010101010100101010101010101, 32'b00000000000000000000000000001000, 4'b0000);
        performTest(32'b00010010001101000101011001111000, 32'b00000000000000000000000000010000, 4'b0000);

        // Testy operacji porównania
        performTest(32'b00000000000000000000000000001010, 32'b00000000000000000000000000000101, 4'b0001);
        performTest(32'b00000000000000000000000000010100, 32'b00000000000000000000000000011001, 4'b0001);
        performTest(32'b00000000000000000000000000001111, 32'b00000000000000000000000000001111, 4'b0001);

        // Testy operacji dzielenia
        performTest(32'b00000000000000000000000001100100, 32'b00000000000000000000000000001010, 4'b0010);
        performTest(32'b00000000000000000000000000110010, 32'b00000000000000000000000000000101, 4'b0010);
        performTest(32'b00000000000000000000000011001000, 32'b00000000000000000000000000010100, 4'b0010);

        // Testy operacji konwersji ZM -> U2
        performTest(32'b10000000000000000000000000000001, 32'b00000000000000000000000000000000, 4'b0011);
        performTest(32'b01111111111111111111111111111111, 32'b00000000000000000000000000000000, 4'b0011);
        performTest(32'b10000000000000010010001101000101, 32'b00000000000000000000000000000000, 4'b0011);

        // Zakończenie symulacji
        $finish;
    end

    task performTest;
        input [M-1:0] argA, argB;
        input [3:0] op;
        begin
            iarg_A <= argA;
            iarg_B <= argB;
            iop <= op;
            #10;
            $display("Test: iop=%b, iarg_A=%b, iarg_B=%b, o_result=%b, o_status=%b",
                     op, argA, argB, o_result, o_status);
            #10;
        end
    endtask

endmodule

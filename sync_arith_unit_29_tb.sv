`include "sync_arith_unit_29.sv"

`timescale 1ns / 1ps

module test_sync_arith_unit_29;

    parameter M = 32;
    reg [M-1:0] iarg_A;
    reg [M-1:0] iarg_B;
    reg [3:0] iop;
    reg clk;
    reg i_reset;
    wire [M-1:0] o_result;
    wire [3:0] o_status;

    // Instancja testowanego modułu
    sync_arith_unit_29 #(.M(M)) uut (
        .iarg_A(iarg_A),
        .iarg_B(iarg_B),
        .iop(iop),
        .clk(clk),
        .i_reset(i_reset),
        .o_result(o_result),
        .o_status(o_status)
    );

    // Procedura generowania zegara
    always #10 clk = ~clk; // Okres zegara 20ns

    // Procedura testowa
    initial begin
        // Inicjalizacja
        clk = 0;
        i_reset = 1;
        iarg_A = 0;
        iarg_B = 0;
        iop = 0;

        // Reset układu
        #20;
        i_reset = 0;
        #20;
        i_reset = 1;
        #20;

        // Testy dla OP_BITWISE_SHIFT
        performTest(32'b00000000000000000000000000000000, 32'b0, 4'b0000);
        performTest(32'b00000000000000000000000000000001, 32'b1, 4'b0000);
        performTest(32'b10101010101010101010101010101010, 32'b10, 4'b0000);
        performTest(32'b01010101010101010101010101010101, 32'b11, 4'b0000);
        performTest(32'b00110011001100110011001100110011, 32'b100, 4'b0000);

        // Testy dla OP_COMPARE_AS
        performTest(32'b00000000000000000000000000000000, 32'b0, 4'b0001);
        performTest(32'b11111111111111111111111111111111, 32'b1, 4'b0001);
        performTest(32'b10101010101010101010101010101010, 32'b10, 4'b0001);
        performTest(32'b01010101010101010101010101010101, 32'b11, 4'b0001);
        performTest(32'b00110011001100110011001100110011, 32'b100, 4'b0001);

        // Testy dla OP_DIVIDE
        performTest(32'b00000000000000000000000000000000, 32'b0, 4'b0010);
        performTest(32'b11111111111111111111111111111111, 32'b10, 4'b0010);
        performTest(32'b10101010101010101010101010101010, 32'b11, 4'b0010);
        performTest(32'b01010101010101010101010101010101, 32'b100, 4'b0010);
        performTest(32'b00110011001100110011001100110011, 32'b101, 4'b0010);

        // Testy dla OP_ZM_TO_U2
        performTest(32'b00000000000000000000000000000000, 32'b0, 4'b0011);
        performTest(32'b11111111111111111111111111111111, 32'b0, 4'b0011);
        performTest(32'b10101010101010101010101010101010, 32'b0, 4'b0011);
        performTest(32'b01010101010101010101010101010101, 32'b0, 4'b0011);
        performTest(32'b00110011001100110011001100110011, 32'b0, 4'b0011);
        

        // Dodatkowe testy dla OP_BITWISE_SHIFT z ~B mniejszym od zera
        iop = 4'b0000;
        iarg_A = 32'b10101010101010101010101010101010; iarg_B = 32'b11111111111111111111111111111111; #20; display_results();

        // Dodatkowe testy dla OP_DIVIDE z dzieleniem przez zero
        iop = 4'b0010;
        iarg_A = 32'b10101010101010101010101010101010; iarg_B = 32'b0; #20; display_results();

        // Zakończenie testów
        $finish;
    end

    task display_results;
        $display("Time: %t, Operation: %b, A: %b, B: %b, Result: %b, Status: %b", 
                 $time, iop, iarg_A, iarg_B, o_result, o_status);
    endtask
    // Task do przeprowadzania testów
    task performTest;
        input [M-1:0] argA, argB;
        input [3:0] op;
        begin
            iarg_A <= argA;
            iarg_B <= argB;
            iop <= op;
            #10;  // Czekanie na stabilizację stanu
            $display("Test: iop=%b, iarg_A=%b, iarg_B=%b, o_result=%b, o_status=%b", op, argA, argB, o_result, o_status);
            #10;  // Dodatkowy czas na obserwację wyników
        end
    endtask



endmodule

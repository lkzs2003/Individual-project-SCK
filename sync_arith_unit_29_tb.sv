`include "sync_arith_unit_29.sv"

`timescale 1ns / 1ps

module test_sync_arith_unit_29;

    parameter M = 32;
    reg [M-1:0] iarg_A;
    reg [M-1:0] iarg_B;
    reg [3:0] iop;
    reg [31:0] time_counter;
    reg [31:0] time_limit = 1000; // Set the time limit for simulation

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, test_sync_arith_unit_29);

        clk = 0;
        i_reset = 0;
        time_counter = 0;

        while (time_counter < time_limit) begin
            #5; // Wait for 5 time units
            time_counter = time_counter + 5;
        end

        $finish;
    end
    reg clk;
    reg i_reset;
    wire [M-1:0] o_result;
    wire [3:0] o_status;

    localparam OP_BITWISE_SHIFT = 4'b0000;
    localparam OP_COMPARE_AS = 4'b0001;
    localparam OP_DIVIDE = 4'b0010;
    localparam OP_ZM_TO_U2 = 4'b0011;

    sync_arith_unit_29 #(.M(M)) uut (
        .iarg_A(iarg_A),
        .iarg_B(iarg_B),
        .iop(iop),
        .clk(clk),
        .i_reset(i_reset),
        .o_result(o_result),
        .o_status(o_status)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        i_reset = 0;
        #20;
        i_reset = 1;
        #20;

        perform_shift_tests();
        perform_compare_as_tests();
        perform_divide_tests();
        perform_zm_to_u2_tests();
        perform_flag_status();

        $finish;
    end

    // Testy dla OP_BITWISE_SHIFT
    task perform_shift_tests;
        begin
            performTest(32'hA5A5A5A5, 0, OP_BITWISE_SHIFT);
            performTest(32'hA5A5A5A5, 1, OP_BITWISE_SHIFT);
            performTest(32'hA5A5A5A5, 2, OP_BITWISE_SHIFT);
            performTest(32'hA5A5A5A5, 3, OP_BITWISE_SHIFT);
            performTest(32'hA5A5A5A5, 4, OP_BITWISE_SHIFT);
            performTest(32'hA5A5A5A5, 31, OP_BITWISE_SHIFT);
            performTest(32'hA5A5A5A5, 32, OP_BITWISE_SHIFT);
            performTest(32'hA5A5A5A5, 33, OP_BITWISE_SHIFT);
        end
    endtask

    // Testy dla OP_COMPARE_AS
    task perform_compare_as_tests;
        begin
            performTest(32'h00000001, 32'hFFFFFFFF, OP_COMPARE_AS);
            performTest(32'h00000002, 32'hFFFFFFFE, OP_COMPARE_AS);
            performTest(32'h00000003, 32'hFFFFFFFD, OP_COMPARE_AS);
            performTest(32'h00000004, 32'hFFFFFFFC, OP_COMPARE_AS);
            performTest(32'h00000005, 32'hFFFFFFFB, OP_COMPARE_AS);
            performTest(32'h7FFFFFFF, 32'h80000000, OP_COMPARE_AS);
            performTest(32'hFFFFFFFF, 32'h7FFFFFFF, OP_COMPARE_AS);
        end
    endtask

    // Testy dla OP_DIVIDE
    task perform_divide_tests;
        begin
            performTest(32'h00000010, 32'h00000002, OP_DIVIDE);
            performTest(32'hFFFFFFFF, 32'h00000001, OP_DIVIDE);
            performTest(32'h00000009, 32'h00000003, OP_DIVIDE);
            performTest(32'h00000008, 32'h00000002, OP_DIVIDE);
            performTest(32'h00000007, 32'h00000001, OP_DIVIDE);
            performTest(32'h12345678, 32'h00000002, OP_DIVIDE);
            performTest(32'hFFFFFFFF, 32'h00000000, OP_DIVIDE); // Dzielenie przez zero
            performTest(32'h00000001, 32'hFFFFFFFF, OP_DIVIDE);
        end
    endtask

    // Testy dla OP_ZM_TO_U2
    task perform_zm_to_u2_tests;
        begin
            performTest(32'h80000000, 0, OP_ZM_TO_U2);
            performTest(32'h7FFFFFFF, 0, OP_ZM_TO_U2);
            performTest(32'h80000001, 0, OP_ZM_TO_U2);
            performTest(32'h7FFFFFFE, 0, OP_ZM_TO_U2);
            performTest(32'h80000002, 0, OP_ZM_TO_U2);
            performTest(32'h00000001, 0, OP_ZM_TO_U2);
            performTest(32'hFFFFFFFF, 0, OP_ZM_TO_U2);
        end
    endtask

    // Testy flag statusu
    task perform_flag_status;
        begin
            performTest(32'h80000000, 32'h00000001, OP_DIVIDE); // Możliwy overflow
            performTest(32'h00000000, 32'h80000000, OP_COMPARE_AS); // Test flagi ZEROS
        end
    endtask

    task performTest;
        input [M-1:0] argA, argB;
        input [3:0] op;
        begin
            iarg_A <= argA;
            iarg_B <= argB;
            iop <= op;
            #20;
            display_results();
        end
    endtask

    task display_results;
        $display("Time: %t, Operation: %b, A: %b, B: %b, Result: %b, Status: %b", 
                 $time, iop, iarg_A, iarg_B, o_result, o_status);
    endtask

endmodule

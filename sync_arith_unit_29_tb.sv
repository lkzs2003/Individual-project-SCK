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

initial begin
    // Initialization
    $dumpfile("waveform.vcd");
    $dumpvars(0, sync_arith_unit_29_tb);
    clk = 0;
    i_reset = 1;
    iarg_A = 0;
    iarg_B = 0;
    iop = 0;

    // Reset
    #10;
    i_reset = 0;
    #10;
    i_reset = 1;
    #10;

    // Test Cases
    // Test Case 1: Bitwise Right Shift
    iarg_A = 15; iarg_B = 3; iop = 4'b0000;
    #20;

    // Test Case 2: Check if A <= ~B
    iarg_A = 10; iarg_B = 5; iop = 4'b0001;
    #20;

    // Test Case 3: Division A / ~B
    iarg_A = 20; iarg_B = 4; iop = 4'b0010;
    #20;

    // Test Case 4: Conversion ZM(A) => U2(A)
    iarg_A = 8'b10000001; iop = 4'b0011;
    #20;

    #100; // Wait for some time to observe the results
    $finish; // Finish simulation
end

// Generating a clock signal
always #5 clk = ~clk;

// Monitor values
initial begin
    $monitor("Time = %t, iarg_A = %d, iarg_B = %d, iop = %b, o_result = %d, o_status = %b",
             $time, iarg_A, iarg_B, iop, o_result, o_status);
end

endmodule

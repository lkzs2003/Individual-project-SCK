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
    // initialization
    clk = 0;
    i_reset = 0;
    iarg_A = 0;
    iarg_B = 0;
    iop = 0;

    // Reset
    #10;
    i_reset = 1;
    #10;
    i_reset = 0;
    #10;
    i_reset = 1;

end

// generating a clock signal
always #5 clk = ~clk;

endmodule

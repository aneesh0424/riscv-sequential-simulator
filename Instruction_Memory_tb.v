`timescale 1ns/1ps
`include "Instruction_Memory.v"

module Instruction_Memory_tb;

    reg clk;
    reg reset;
    reg [63:0] addr;
    wire [31:0] instr;

    Instruction_Memory uut(
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .instr(instr)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task run_test;
        input [4:0]  tno;
        input        t_reset;
        input [63:0] t_addr;
        input [31:0] expected;
        begin
            @(negedge clk);
            reset = t_reset;
            addr  = t_addr;

            #6;

            $display("Test %0d", tno);
            $display("Reset       = %b", reset);
            $display("Address     = %0d", addr);
            $display("Instruction = %h", instr);

            if (instr === expected)
                $display("PASS\n");
            else begin
                $display("FAIL");
                $display("Expected    = %h\n", expected);
            end
        end
    endtask

    initial begin
        $dumpfile("Instruction_Memory_tb.vcd");
        $dumpvars(0, Instruction_Memory_tb);

        run_test(1, 1'b0, 64'd0,  32'h00500113);
        run_test(2, 1'b0, 64'd4,  32'h00A00193);
        run_test(3, 1'b0, 64'd8,  32'h003100B3);
        run_test(4, 1'b0, 64'd12, 32'h40310133);

        #20 $finish;
    end
endmodule
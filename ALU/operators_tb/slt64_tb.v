`timescale 1ns/1ps
`include "slt64.v"

module slt64_tb;

    reg  [63:0] a, b;
    wire [63:0] out;
    wire zero, overflow, carry;

    slt64 uut(
        .a(a),
        .b(b),
        .out(out),
        .zero(zero),
        .overflow(overflow),
        .carry(carry)
    );

    task run_test;
        input [4:0] tno;
        input [63:0] ta, tb;
        reg [63:0] expected_out;
        reg expected_zero;
        begin
            a = ta;
            b = tb;
            #10;

            expected_out  = ($signed(ta) < $signed(tb)) ? 64'd1 : 64'd0;
            expected_zero = (expected_out == 64'b0);

            $display("Test %0d", tno);
            $display("A = %h", a);
            $display("B = %h", b);
            $display("OUT = %h  ZERO=%b OVERFLOW=%b CARRY=%b", out, zero, overflow, carry);

            if (out === expected_out &&
                zero === expected_zero &&
                overflow === 1'b0 &&
                carry === 1'b0)
                $display("PASS\n");
            else begin
                $display("FAIL");
                $display("Expected OUT=%h ZERO=%b OVERFLOW=0 CARRY=0\n", expected_out, expected_zero);
            end
        end
    endtask

    initial begin
        $dumpfile("slt64_tb.vcd");
        $dumpvars(0, slt64_tb);

        run_test(1, 64'sd5, 64'sd10);
        run_test(2, 64'sd10, 64'sd5);
        run_test(3, -64'sd5, 64'sd3);
        run_test(4, 64'sd3, -64'sd5);
        run_test(5, 64'h8000000000000000, 64'h7FFFFFFFFFFFFFFF);
        run_test(6, 64'sd7, 64'sd7);

        #20 $finish;
    end

endmodule

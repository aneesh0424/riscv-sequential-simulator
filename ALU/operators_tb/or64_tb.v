`timescale 1ns/1ps
`include "or64.v"

module or64_tb;

    reg  [63:0] a, b;
    wire [63:0] out;
    wire zero, overflow, carry;

    or64 uut(
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
        reg  [63:0] expected_out;
        reg         expected_zero;
        begin
            a = ta;
            b = tb;
            #10;

            expected_out  = ta | tb;
            expected_zero = (expected_out == 64'b0);

            $display("Test %0d", tno);
            $display("A   = %h", a);
            $display("B   = %h", b);
            $display("OUT = %h  ZERO=%b OVERFLOW=%b CARRY=%b", out, zero, overflow, carry);

            if (out === expected_out &&
                zero === expected_zero &&
                overflow === 1'b0 &&
                carry === 1'b0)
                $display("PASS\n");
            else begin
                $display("FAIL");
                $display("Expected OUT=%h ZERO=%b OVERFLOW=0 CARRY=0\n",
                         expected_out, expected_zero);
            end
        end
    endtask

    initial begin
        $dumpfile("or64_tb.vcd");
        $dumpvars(0, or64_tb);

        run_test(1, 64'h0, 64'h0);                 
        run_test(2, 64'hFFFF0000FFFF0000, 64'h0000FFFF0000FFFF);
        run_test(3, 64'hAAAAAAAAAAAAAAAA, 64'h5555555555555555);
        run_test(4, 64'h123456789ABCDEF0, 64'h123456789ABCDEF0);

        #20 $finish;
    end

endmodule

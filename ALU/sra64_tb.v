`timescale 1ns/1ps
`include "sra64.v"

module sra64_tb;

    reg  [63:0] a, b;
    wire [63:0] out;
    wire zero, overflow, carry;

    sra64 uut(
        .a(a),
        .b(b),
        .out(out),
        .zero(zero),
        .overflow(overflow),
        .carry(carry)
    );

    task run_test;
        input [4:0]  tno;
        input [63:0] ta, tb;
        reg   [63:0] expected_out;
        reg          expected_zero;
        reg          sign;
        begin
            a = ta;
            b = tb;
            #10;

            sign = ta[63];


            expected_out = $signed(ta) >>> tb[5:0];
            expected_zero = (expected_out == 64'b0);

            $display("Test %0d", tno);
            $display("A = %h", a);
            $display("B = %0d (hex=%h)", b, b);
            $display("OUT = %h  ZERO=%b  OVERFLOW=%b  CARRY=%b",
                     out, zero, overflow, carry);

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
        $dumpfile("sra64_tb.vcd");
        $dumpvars(0, sra64_tb);

        run_test(1, 64'h0000000000000080, 64'd1);
        run_test(2, 64'hFFFFFFFFFFFFFF80, 64'd1);
        run_test(3, 64'hFFFFFFFFFFFFFFF0, 64'd4);
        run_test(4, 64'h8000000000000000, 64'd63);
        run_test(5, 64'h0000000000000001, 64'd64);
        run_test(6, 64'hFFFFFFFFFFFFFFFF, 64'd64);

        #20 $finish;
    end

endmodule

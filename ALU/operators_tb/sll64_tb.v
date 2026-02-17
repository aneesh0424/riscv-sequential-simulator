`timescale 1ns/1ps
`include "sll64.v"

module sll64_tb;

    reg  [63:0] a, b;
    wire [63:0] out;
    wire zero, overflow, carry;

    sll64 uut(
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
        reg          expected_overflow;
        begin
            a = ta;
            b = tb;
            #10;


            expected_out = ta << tb[5:0];
            expected_zero = (expected_out == 64'b0);
            expected_overflow = (ta[63] ^ expected_out[63]);

            $display("Test %0d", tno);
            $display("A = %h", a);
            $display("B = %0d (hex=%h)", b, b);
            $display("OUT = %h  ZERO=%b  OVERFLOW=%b  CARRY=%b",
                     out, zero, overflow, carry);

            if (out === expected_out &&
                zero === expected_zero &&
                overflow === expected_overflow &&
                carry === 1'b0)
                $display("PASS\n");
            else begin
                $display("FAIL");
                $display("Expected OUT=%h ZERO=%b OVERFLOW=%b CARRY=0\n",
                         expected_out, expected_zero, expected_overflow);
            end
        end
    endtask

    initial begin
        $dumpfile("sll64_tb.vcd");
        $dumpvars(0, sll64_tb);

        run_test(1, 64'h0000000000000001, 64'd0);
        run_test(2, 64'h0000000000000001, 64'd1);
        run_test(3, 64'h00000000000000F0, 64'd4);
        run_test(4, 64'h0000000000000001, 64'd63);
        run_test(5, 64'hFFFFFFFFFFFFFFFF, 64'd64);
        run_test(6, 64'h123456789ABCDEF0, 64'd100);

        #20 $finish;
    end

endmodule

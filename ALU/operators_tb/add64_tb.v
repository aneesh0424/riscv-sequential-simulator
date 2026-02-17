`timescale 1ns/1ps
`include "add64.v"

module add64_tb;

    reg  [63:0] a, b;
    wire [63:0] sum;
    wire carry, overflow;

    add64 uut(
        .a(a),
        .b(b),
        .sum(sum),
        .zero(zero),
        .overflow(overflow),
        .carry(carry)
    );

    task run_test;
        input [4:0]  tno;
        input [63:0] ta, tb;
        reg   [64:0] expected_full;
        reg   [63:0] expected_sum;
        reg          expected_carry;
        reg          expected_overflow;
        reg          expected_zero;
        begin
            a = ta;
            b = tb;
            #10;

            expected_full  = {1'b0, ta} + {1'b0, tb};
            expected_sum   = expected_full[63:0];
            expected_carry = expected_full[64];
            expected_zero  = (sum == 64'b0);

            expected_overflow =
                (~(ta[63] ^ tb[63])) & (expected_sum[63] ^ ta[63]);

            $display("Test %0d", tno);
            $display("A = %h", a);
            $display("B = %h", b);
            $display("SUM = %h  CARRY=%b  OVERFLOW=%b Zero=%b", sum, carry, overflow, zero);

            if (sum === expected_sum && carry === expected_carry && overflow === expected_overflow && zero==expected_zero)
                $display("PASS\n");
            else begin
                $display("FAIL");
                $display("Expected SUM=%h  CARRY=%b  OVERFLOW=%b\n Zero=%b\n",
                         expected_sum, expected_carry, expected_overflow, expected_zero);
            end
        end
    endtask
    
    initial begin
        $dumpfile("add64_tb.vcd");
        $dumpvars(0, add64_tb);

        run_test(1, 64'd10, 64'd20);
        run_test(2, 64'hFFFFFFFFFFFFFFFF, 64'd1);
        run_test(3, 64'h7FFFFFFFFFFFFFFF, 64'd1);
        run_test(4, 64'd5, 64'hFFFFFFFFFFFFFFFD);

        #20 $finish;
    end
endmodule

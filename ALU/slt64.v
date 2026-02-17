`include "sub64.v"
module slt64(input  [63:0]a, b, output [63:0] out, output zero,overflow,carry);

    wire [63:0] diff;
    wire sub_carry,sub_overflow,sub_zero;

    sub64 sub_inst(
        .a(a),
        .b(b),
        .sum(diff),
        .carry(sub_carry),
        .overflow(sub_overflow),
        .zero(sub_zero)
    );

    wire slt_bit;
    xor (slt_bit, diff[63], sub_overflow);

    assign out = {63'b0, slt_bit};
    assign zero = (out == 64'b0);
    assign carry = 1'b0;
    assign overflow = 1'b0;

endmodule

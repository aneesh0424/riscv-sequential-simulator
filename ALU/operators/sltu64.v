`include "sub64.v"
module sltu64(input [63:0]a, b, output [63:0]out, output zero,overflow,carry);

    wire [63:0] diff;
    wire borrow_flag;
    wire sub_overflow, sub_zero;

    sub64 sub_inst(
        .a(a),
        .b(b),
        .sum(diff),
        .carry(borrow_flag),
        .overflow(sub_overflow),
        .zero(sub_zero)
    );

    assign out = {63'b0, borrow_flag};
    assign zero = (out == 64'b0);
    assign overflow = 1'b0;
    assign carry = 1'b0;

endmodule
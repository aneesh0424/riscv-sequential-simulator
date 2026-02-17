module sra64(input [63:0]a, b, output [63:0]out, output zero,overflow,carry);

    wire [5:0] shift_amt;
    assign shift_amt = b[5:0];

    wire sign;
    assign sign = a[63];

    wire [63:0] s1, s2, s4, s8, s16, s32;

    assign s1  = shift_amt[0] ? {sign,   a[63:1]}       : a;
    assign s2  = shift_amt[1] ? {{2{sign}},  s1[63:2]}  : s1;
    assign s4  = shift_amt[2] ? {{4{sign}},  s2[63:4]}  : s2;
    assign s8  = shift_amt[3] ? {{8{sign}},  s4[63:8]}  : s4;
    assign s16 = shift_amt[4] ? {{16{sign}}, s8[63:16]} : s8;
    assign s32 = shift_amt[5] ? {{32{sign}}, s16[63:32]}: s16;

    assign out = s32;
    assign zero = (out == 64'b0);
    assign carry = 1'b0;
    assign overflow = 1'b0;

endmodule
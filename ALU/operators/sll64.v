module sll64(input [63:0]a, b, output [63:0]out, output zero, overflow, carry);

    wire [5:0] shift_amt;
    assign shift_amt = b[5:0];

    wire [63:0] s1, s2, s4, s8, s16, s32;

    assign s1  = shift_amt[0] ? {a[62:0], 1'b0}     : a;
    assign s2  = shift_amt[1] ? {s1[61:0], 2'b0}    : s1;
    assign s4  = shift_amt[2] ? {s2[59:0], 4'b0}    : s2;
    assign s8  = shift_amt[3] ? {s4[55:0], 8'b0}    : s4;
    assign s16 = shift_amt[4] ? {s8[47:0], 16'b0}   : s8;
    assign s32 = shift_amt[5] ? {s16[31:0], 32'b0}  : s16;

    assign out = s32;
    assign zero = (out == 64'b0);
    assign carry = 1'b0;
    xor(overflow,a[63],out[63]);
endmodule
module full_adder(input a,b,c_in, output sum,carry);
    wire axb, a_and_b, axb_and_cin;
    xor(axb,a,b);
    xor(sum,axb,c_in);
    and(a_and_b,a,b);
    and(axb_and_cin,axb,c_in);
    or(carry,a_and_b,axb_and_cin);
endmodule


module add64(input [63:0] a,b, output [63:0]sum, output zero,overflow,carry);
    wire [64:0]c;
    assign c[0] = 1'b0;
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin
            full_adder inst (.a(a[i]),.b(b[i]),.c_in(c[i]),.sum(sum[i]),.carry(c[i+1]));
        end
    endgenerate
    assign carry = c[64];
    xor(overflow,c[63],c[64]);
    assign zero = (sum == 64'b0);
endmodule


module sub64(input [63:0] a,b, output [63:0]sum, output zero,overflow,carry);
    wire [64:0]c;
    wire [63:0]b_inv;
    genvar j;
    generate
        for(j=0; j< 64;j=j+1) begin
            xor x1(b_inv[j], b[j], 1'b1);
        end
    endgenerate
    assign c[0] = 1'b1;
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin
            full_adder inst (.a(a[i]),.b(b_inv[i]),.c_in(c[i]),.sum(sum[i]),.carry(c[i+1]));
        end
    endgenerate
    assign carry = ~c[64];
    xor(overflow,c[63],c[64]);
    assign zero = (sum == 64'b0);
endmodule


module xor64(input [63:0]a, b, output [63:0]out, output zero,overflow,carry);
    genvar i;
    generate
        for (i=0;i<64;i=i+1) begin
            xor(out[i],a[i],b[i]);
        end
    endgenerate
    assign zero=(out==64'b0);
    assign overflow=1'b0;
    assign carry=1'b0;
endmodule


module or64(input [63:0]a, b, output [63:0]out, output zero,overflow,carry);
    genvar i;
    generate
        for (i=0;i<64;i=i+1) begin
            or(out[i],a[i],b[i]);
        end
    endgenerate
    assign zero=(out==64'b0);
    assign overflow=1'b0;
    assign carry=1'b0;
endmodule


module and64(input [63:0]a, b, output [63:0]out, output zero,overflow,carry);
    genvar i;
    generate
        for (i=0;i<64;i=i+1) begin
            and(out[i],a[i],b[i]);
        end
    endgenerate
    assign zero=(out==64'b0);
    assign overflow=1'b0;
    assign carry=1'b0;
endmodule


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


module srl64(input [63:0]a, b, output [63:0]out, output zero,overflow,carry);

    wire [5:0] shift_amt;
    assign shift_amt = b[5:0];

    wire [63:0] s1, s2, s4, s8, s16, s32;

    assign s1  = shift_amt[0] ? {1'b0,   a[63:1]}    : a;
    assign s2  = shift_amt[1] ? {2'b0,   s1[63:2]}   : s1;
    assign s4  = shift_amt[2] ? {4'b0,   s2[63:4]}   : s2;
    assign s8  = shift_amt[3] ? {8'b0,   s4[63:8]}   : s4;
    assign s16 = shift_amt[4] ? {16'b0,  s8[63:16]}  : s8;
    assign s32 = shift_amt[5] ? {32'b0,  s16[63:32]} : s16;

    assign out = s32;
    assign zero = (out == 64'b0);
    assign carry = 1'b0;
    xor(overflow,a[63],out[63]);

endmodule


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



module alu_64_bit(input [63:0]a,b, input [3:0]opcode, output [63:0]result, output cout,carry_flag,overflow_flag,zero_flag);

    localparam  ADD_Oper  = 4'b0000,
                SLL_Oper  = 4'b0001,
                SLT_Oper  = 4'b0010,
                SLTU_Oper = 4'b0011,
                XOR_Oper  = 4'b0100,
                SRL_Oper  = 4'b0101,
                OR_Oper   = 4'b0110,
                AND_Oper  = 4'b0111,
                SUB_Oper  = 4'b1000,
                SRA_Oper  = 4'b1101;

    wire [63:0] add_out, sub_out, and_out, or_out, xor_out;
    wire [63:0] sll_out, srl_out, sra_out, slt_out, sltu_out;

    wire add_c, sub_c, and_c, or_c, xor_c;
    wire sll_c, srl_c, sra_c, slt_c, sltu_c;

    wire add_o, sub_o, and_o, or_o, xor_o;
    wire sll_o, srl_o, sra_o, slt_o, sltu_o;

    wire add_z, sub_z, and_z, or_z, xor_z;
    wire sll_z, srl_z, sra_z, slt_z, sltu_z;


    add64 add_u(.a(a), .b(b), .sum(add_out), .zero(add_z), .overflow(add_o), .carry(add_c));
    sub64 sub_u(.a(a), .b(b), .sum(sub_out), .zero(sub_z), .overflow(sub_o), .carry(sub_c));

    and64 and_u(.a(a), .b(b), .out(and_out), .zero(and_z), .overflow(and_o), .carry(and_c));
    or64  or_u (.a(a), .b(b), .out(or_out),  .zero(or_z),  .overflow(or_o),  .carry(or_c));
    xor64 xor_u(.a(a), .b(b), .out(xor_out), .zero(xor_z), .overflow(xor_o), .carry(xor_c));

    sll64 sll_u(.a(a), .b(b), .out(sll_out), .zero(sll_z), .overflow(sll_o), .carry(sll_c));
    srl64 srl_u(.a(a), .b(b), .out(srl_out), .zero(srl_z), .overflow(srl_o), .carry(srl_c));
    sra64 sra_u(.a(a), .b(b), .out(sra_out), .zero(sra_z), .overflow(sra_o), .carry(sra_c));

    slt64  slt_u (.a(a), .b(b), .out(slt_out),  .zero(slt_z),  .overflow(slt_o), .carry(slt_c));
    sltu64 sltu_u(.a(a), .b(b), .out(sltu_out), .zero(sltu_z), .overflow(sltu_o), .carry(sltu_c));

    reg [63:0] res_sel;
    reg        c_sel, o_sel, z_sel;

    always @(*) begin

        case(opcode)

            ADD_Oper: begin
                res_sel = add_out;
                c_sel   = add_c;
                o_sel   = add_o;
                z_sel   = add_z;
            end

            SUB_Oper: begin
                res_sel = sub_out;
                c_sel   = sub_c;
                o_sel   = sub_o;
                z_sel   = sub_z;
            end

            AND_Oper: begin
                res_sel = and_out;
                c_sel   = and_c;
                o_sel   = and_o;
                z_sel   = and_z;
            end

            OR_Oper: begin
                res_sel = or_out;
                c_sel   = or_c;
                o_sel   = or_o;
                z_sel   = or_z;
            end

            XOR_Oper: begin
                res_sel = xor_out;
                c_sel   = xor_c;
                o_sel   = xor_o;
                z_sel   = xor_z;
            end

            SLL_Oper: begin
                res_sel = sll_out;
                c_sel   = sll_c;
                o_sel   = sll_o;
                z_sel   = sll_z;
            end

            SRL_Oper: begin
                res_sel = srl_out;
                c_sel   = srl_c;
                o_sel   = srl_o;
                z_sel   = srl_z;
            end

            SRA_Oper: begin
                res_sel = sra_out;
                c_sel   = sra_c;
                o_sel   = sra_o;
                z_sel   = sra_z;
            end

            SLT_Oper: begin
                res_sel = slt_out;
                c_sel   = slt_c;
                o_sel   = slt_o;
                z_sel   = slt_z;
            end

            SLTU_Oper: begin
                res_sel = sltu_out;
                c_sel   = sltu_c;
                o_sel   = sltu_o;
                z_sel   = sltu_z;
            end

            default: begin
                res_sel = 64'b0;
                c_sel   = 1'b0;
                o_sel   = 1'b0;
                z_sel   = 1'b1;
            end

        endcase
    end

    assign result        = res_sel;
    assign carry_flag    = c_sel;
    assign overflow_flag = o_sel;
    assign zero_flag     = z_sel;
    assign cout = carry_flag;

endmodule

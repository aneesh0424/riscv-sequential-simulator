`include "full_adder.v"
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
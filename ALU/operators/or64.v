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

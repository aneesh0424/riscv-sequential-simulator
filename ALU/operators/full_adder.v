module full_adder(input a,b,c_in, output sum,carry);
    wire axb, a_and_b, axb_and_cin;
    xor(axb,a,b);
    xor(sum,axb,c_in);
    and(a_and_b,a,b);
    and(axb_and_cin,axb,c_in);
    or(carry,a_and_b,axb_and_cin);
endmodule
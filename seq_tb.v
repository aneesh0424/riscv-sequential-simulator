`timescale 1ns/1ps
`include "seq.v"

module seq_tb;

    reg clk;
    reg reset;
    integer i;

    // Instantiate DUT
    seq uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ✅ Proper debug monitor (outside initial)
    always @(negedge clk) begin

        $display("PC=%h INSTR=%h opcode=%b RegWrite=%b WriteReg=%d WriteData=%h",
                 uut.pc_out,
                 uut.instr,
                 uut.instr[6:0],
                 uut.reg_write_en,
                 uut.instr[11:7],
                 uut.write_data);
        $display("MemToReg=%b", uut.MemToReg);
        $display("read1=%h read2=%h imm=%h alu_in2=%h alu_result=%h",
                uut.read_data1,
                uut.read_data2,
                uut.imm,
                uut.alu_in2,
                uut.alu_result);
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;

        #200;
        #10;

        $display("\n==== REGISTER FILE CONTENTS ====");
        for (i = 0; i < 32; i = i + 1)
            $display("x%0d = %016h", i, uut.register_file_inst.registers[i]);

        $finish;
    end

endmodule
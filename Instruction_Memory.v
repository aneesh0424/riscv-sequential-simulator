module Instruction_Memory(input clk,reset, input[63:0] addr, output[31:0] instr);

    reg [7:0] memory[4095:0];
    integer i;

    initial begin
        for (i = 0; i < 4096; i = i + 1)
                memory[i] = 8'h00;
        $readmemh("../instructions.txt", memory);
    end

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4096; i = i + 1)
                memory[i] <= 8'h00;
        end
    end

    assign instr = {memory[addr[11:0]],memory[addr[11:0]+1],memory[addr[11:0]+2],memory[addr[11:0]+3]};

endmodule
module Data_Memory(input clk,reset,MemRead,MemWrite, input[63:0] address,write_data, output[63:0] read_data);

    reg[7:0] memory[1023:0];
    integer k;

    initial begin
    for (k = 0; k < 1024; k = k + 1)
        memory[k] = 8'h00;
    end

    always @(posedge clk) begin
        if (reset) begin
            for (k = 0; k < 1024; k = k + 1)
                memory[k] <= 8'h0;
        end else begin
            if (MemWrite) begin
                memory[address]     <= write_data[63:56];
                memory[address + 1] <= write_data[55:48];
                memory[address + 2] <= write_data[47:40];
                memory[address + 3] <= write_data[39:32];
                memory[address + 4] <= write_data[31:24];
                memory[address + 5] <= write_data[23:16];
                memory[address + 6] <= write_data[15:8];
                memory[address + 7] <= write_data[7:0];
            end
        end
    end

    assign read_data = MemRead ? {memory[address],memory[address+1],memory[address+2],memory[address+3],memory[address+4],memory[address+5],memory[address+6],memory[address+7]} : 64'b0;

endmodule
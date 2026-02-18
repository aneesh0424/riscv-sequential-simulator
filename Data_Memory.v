module Data_Memory(clk, reset, address, write_data, MemRead, MemWrite, read_data);
    input clk, reset, MemRead, MemWrite;
    input [63:0] address, write_data;
    output reg [63:0] read_data;

    reg [7:0] Dmemory [0:1023];
    integer k;

    always @(posedge clk) begin
        if (reset) begin
            for (k = 0; k < 1024; k = k + 1)
                Dmemory[k] <= 8'h0;
        end else begin
            if (MemWrite) begin
                Dmemory[address]   <= write_data[7:0];
                Dmemory[address+1] <= write_data[15:8];
                Dmemory[address+2] <= write_data[23:16];
                Dmemory[address+3] <= write_data[31:24];
                Dmemory[address+4] <= write_data[39:32];
                Dmemory[address+5] <= write_data[47:40];
                Dmemory[address+6] <= write_data[55:48];
                Dmemory[address+7] <= write_data[63:56];
                $writememh("data_mem.txt", Dmemory);
            end

            if (MemRead) begin
                read_data <= { Dmemory[address+7], Dmemory[address+6],
                               Dmemory[address+5], Dmemory[address+4],
                               Dmemory[address+3], Dmemory[address+2],
                               Dmemory[address+1], Dmemory[address] };
            end
        end
    end

endmodule

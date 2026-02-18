`timescale 1ns/1ps

module Data_Memory_tb;

    reg clk;
    reg reset;
    reg MemRead;
    reg MemWrite;
    reg [63:0] address;
    reg [63:0] write_data;
    wire [63:0] read_data;

    // Instantiate DUT
    Data_Memory uut (
        .clk(clk),
        .reset(reset),
        .address(address),
        .write_data(write_data),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .read_data(read_data)
    );

    // 🔷 Clock Generation (10 ns period)
    always #5 clk = ~clk;

    initial begin

        // Optional waveform dump
        $dumpfile("data_mem.vcd");
        $dumpvars(0, Data_Memory_tb);

        clk = 0;
        reset = 1;
        MemRead = 0;
        MemWrite = 0;
        address = 0;
        write_data = 0;

        $display("--------------------------------------------------");
        $display("Time\tMemWrite MemRead Address   WriteData          ReadData");
        $display("--------------------------------------------------");

        // =====================================================
        // RESET MEMORY
        // =====================================================
        #10;
        reset = 0;

        // =====================================================
        // WRITE 64-bit value to address 100
        // =====================================================
        address = 64'd100;
        write_data = 64'h1122334455667788;
        MemWrite = 1;
        #10;

        MemWrite = 0;

        // =====================================================
        // READ FROM SAME ADDRESS
        // =====================================================
        MemRead = 1;
        #10;   // One clock latency

        $display("%0t\t%b\t%b\t%0d\t%h\t%h",
                 $time, MemWrite, MemRead,
                 address, write_data, read_data);

        MemRead = 0;

        // =====================================================
        // WRITE ANOTHER VALUE
        // =====================================================
        address = 64'd200;
        write_data = 64'hAABBCCDDEEFF0011;
        MemWrite = 1;
        #10;

        MemWrite = 0;

        // READ BACK
        MemRead = 1;
        #10;

        $display("%0t\t%b\t%b\t%0d\t%h\t%h",
                 $time, MemWrite, MemRead,
                 address, write_data, read_data);

        MemRead = 0;

        $display("--------------------------------------------------");

        #20;
        $finish;
    end

endmodule


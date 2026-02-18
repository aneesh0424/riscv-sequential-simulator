module Immediate_Generation(
    input  [31:0] instr,
    output reg [63:0] imm
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)

            // I-TYPE (ADDI, LW, JALR, ADDIW, etc.)
            7'b0010011,  // ALU immediate
            7'b0000011,  // LOAD
            7'b1100111,  // JALR
            7'b0011011:  // RV64 W-immediate
            begin
                imm = {{52{instr[31]}}, instr[31:20]};
            end

            // S-TYPE (Stores)
            7'b0100011:
            begin
                imm = {{52{instr[31]}}, instr[31:25], instr[11:7]};
            end

            // B-TYPE (Branches)
            7'b1100011:
            begin
                imm = {{51{instr[31]}},
                       instr[31],
                       instr[7],
                       instr[30:25],
                       instr[11:8],
                       1'b0};
            end

            // U-TYPE (LUI, AUIPC)
            7'b0110111,  // LUI
            7'b0010111:  // AUIPC
            begin
                imm = {{32{instr[31]}}, instr[31:12], 12'b0};
            end

            // J-TYPE (JAL)
            7'b1101111:
            begin
                imm = {{43{instr[31]}},
                       instr[31],
                       instr[19:12],
                       instr[20],
                       instr[30:21],
                       1'b0};
            end

            default:
                imm = 64'b0;

        endcase
    end

endmodule


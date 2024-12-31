`timescale 1ns / 1ps
module controller(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg RegWrite,
    output reg [1:0] ALUSrc,
    output reg [3:0] ALUOp,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg Branch,
    output reg Link,
    output reg BranchFromPC,
    output reg ReverseBranchCondition
    );

    always @ ( opcode or funct3 or funct7 ) begin
        case (opcode)
            7'b0110011 : begin //R-type: ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU
                ALUSrc = 2'b00;
                case (funct3)
                    'h7 : ALUOp = 4'b0000;
                    'h6 : ALUOp = 4'b0001;
                    'h5 : ALUOp = {1'b1, 1'b0, 1'b0, funct7[5]};
                    'h4 : ALUOp = 4'b0101;
                    'h3 : ALUOp = 4'b1101;
                    'h2 : ALUOp = 4'b1100;
                    'h1 : ALUOp = 4'b1010;
                    'h0 : ALUOp = {1'b0, funct7[5], 1'b1, 1'b0};
                endcase
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            7'b0010011 : begin //I-type: ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI, SLTI, SLTIU
                ALUSrc = 1;
                case (funct3)
                    'h7 : ALUOp = 4'b0000;
                    'h6 : ALUOp = 4'b0001;
                    'h5 : ALUOp = {1'b1, 1'b0, 1'b0, funct7[5]};
                    'h4 : ALUOp = 4'b0101;
                    'h3 : ALUOp = 4'b1101;
                    'h2 : ALUOp = 4'b1100;
                    'h1 : ALUOp = 4'b1010;
                    'h0 : ALUOp = 4'b0010;
                endcase
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            7'b0110111, //U-type: LUI
            7'b0010111 : begin //U-type: AUIPC
                ALUSrc = {~opcode[5], 1'b1};
                ALUOp = 4'b0010;
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            7'b0000011 : begin //I-type: LB, LW
                ALUSrc = 2'b01;
                ALUOp = 4'b0010;
                MemRead = 1;
                MemToReg = 1;
                MemWrite = 0;
                RegWrite = 1;
            end
            7'b0100011 : begin //S-type: SB, SW
                ALUSrc = 2'b01;
                ALUOp = 4'b0010;
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 1;
                RegWrite = 0;
            end
            7'b1100011 : begin //B-type: BEQ
                ALUSrc = 2'b00;
                case (funct3)
                    'h7 : begin ALUOp = 4'b1101; ReverseBranchCondition = 0; end
                    'h6 : begin ALUOp = 4'b1101; ReverseBranchCondition = 1; end
                    'h5 : begin ALUOp = 4'b1100; ReverseBranchCondition = 0; end
                    'h4 : begin ALUOp = 4'b1100; ReverseBranchCondition = 1; end
                    'h1 : begin ALUOp = 4'b0110; ReverseBranchCondition = 1; end
                    'h0 : begin ALUOp = 4'b0110; ReverseBranchCondition = 0; end
                endcase
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 0;
            end
            7'b1100111, //I-type: JALR
            7'b1101111 : begin //J-type: JAL
                ALUSrc = 2'b00;
                ALUOp = 4'b1111;
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            default : begin //NOP, though according to spec, a nop is implemented as addi, x0, x0, 0
                ALUSrc = 2'b00;
                ALUOp = 4'b1111;
                MemRead = 0;
                MemWrite = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 0;
            end
        endcase

        if (opcode[6:4] == 'b110) begin
            Branch = 1;
            Link = (opcode[2]) ? 1 : 0;
            BranchFromPC = (opcode[2]) ? (opcode[3]) : 1;
        end
        else  begin
            Branch = 0;
            Link = 0;
            BranchFromPC = 0;
        end
    end

endmodule

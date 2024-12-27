`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 08:36:49 PM
// Design Name: 
// Module Name: Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg RegWrite,
    output reg ALUSrc,
    output reg [3:0] ALUOp,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg Branch,
    output reg Link,
    output reg BranchFromPC
    );

    always @ ( opcode or funct3 or funct7 ) begin
        case (opcode)
            7'b0110011 : begin //R-type: ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU
                ALUSrc = 0;
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
            7'b0110111 : begin //U-type: LUI
                ALUSrc = 1;
                ALUOp = 4'b0010;
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            7'b0000011 : begin //I-type: LB, LW
                ALUSrc = 1;
                ALUOp = 4'b0010;
                MemRead = 1;
                MemToReg = 1;
                MemWrite = 0;
                RegWrite = 1;
            end
            7'b0100011 : begin //S-type: SB, SW
                ALUSrc = 1;
                ALUOp = 4'b0010;
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 1;
                RegWrite = 0;
            end
            7'b1100011 : begin //B-type: BEQ
                ALUSrc = 0;
                case (funct3)
                    'h7, 'h6 : ALUOp = 4'b1101;
                    'h5, 'h4 : ALUOp = 4'b1100;
                    'h1, 'h0 : ALUOp = 4'b0110;
                endcase
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 0;
            end
            7'b1100111, //JALR
            7'b1101111 : begin //J-type: JAL, JALR
                ALUSrc = 0;
                ALUOp = 4'b1111;
                MemRead = 0;
                MemToReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            default : begin //NOP
                ALUSrc = 0;
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

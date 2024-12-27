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
    output reg RegWrite,
    output reg ALUSrc,
    output reg [1:0] ALUOp,
    output reg MemWrite,
    output reg MemRead,
    output reg MemToReg,
    output reg Branch,
    output reg Link,
    output reg BranchFromPC
    );

    always @ (opcode) begin
        case (opcode)
            'b0110011 : begin //R-type: ADD, SUB, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU
                ALUSrc = 'b0;
                ALUOp = 'b10;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b0;
                RegWrite = 'b1;
            end
            'b0010011 : begin //I-type: ADDI, XORI, ORI, ANDI, SLLI, SRLI, SRAI, SLTI, SLTIU
                ALUSrc = 'b1;
                ALUOp = 'b10;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b0;
                RegWrite = 'b1;
            end
            'b0110111 : begin //U-type: LUI
                ALUSrc = 'b1;
                ALUOp = 'b00;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b0;
                RegWrite = 'b1;
            end
            'b0000011 : begin //I-type: LB, LW
                ALUSrc = 'b1;
                ALUOp = 'b00;
                MemRead = 'b1;
                MemToReg = 'b1;
                MemWrite = 'b0;
                RegWrite = 'b1;
            end
            'b0100011 : begin //S-type: SB SW
                ALUSrc = 'b1;
                ALUOp = 'b00;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b1;
                RegWrite = 'b0;
            end
            'b1100011 : begin //B-type: BEQ
                ALUSrc = 'b0;
                ALUOp = 'b01;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b0;
                RegWrite = 'b0;
            end
            'b1100111, //JALR
            'b1101111 : begin //J-type: JAL
                ALUSrc = 'b0;
                ALUOp = 'b11;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b0;
                RegWrite = 'b1;
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

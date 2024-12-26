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
    output reg Branch
    );

    always @ (opcode) begin
        case (opcode)
            'b0110011 : begin //R-type: ADD, XOR
                ALUSrc = 'b0;
                ALUOp = 'b10;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b0;
                RegWrite = 'b1;
                Branch = 'b0;
            end
            'b0010011 : begin //I-type: ORI, SRAI
                ALUSrc = 'b1;
                ALUOp = 'b10;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b0;
                RegWrite = 'b1;
                Branch = 'b0;
            end
            'b0110111 : begin //U-type: LUI
                ALUSrc = 'b1;
                ALUOp = 'b00;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b0;
                RegWrite = 'b1;
                Branch = 'b0;
            end
            'b0000011 : begin //I-type: Memory loads
                ALUSrc = 'b1;
                ALUOp = 'b00;
                MemRead = 'b1;
                MemToReg = 'b1;
                MemWrite = 'b0;
                RegWrite = 'b1;
                Branch = 'b0;
            end
            'b0100011 : begin //S-type: Memory stores
                ALUSrc = 'b1;
                ALUOp = 'b00;
                MemRead = 'b0;
                MemToReg = 'b0;
                MemWrite = 'b1;
                RegWrite = 'b0;
                Branch = 'b0;
            end
        endcase
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 08:41:31 PM
// Design Name: 
// Module Name: ALU_Controller
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


module ALUControl(
    input [1:0] ALU_Op,
    output reg [3:0] op,
    input [2:0] funct3,
    input [6:0] funct7
    );

    always @ ( ALU_Op or funct3 or funct7) begin
        case (ALU_Op)
            'b00 : op = 'b0010;
            'b01 : op = 'b0110;
            'b10 : begin
                case (funct3)
                    'h0 : op = {1'b0, funct7[5], 1'b1, 1'b0};
                    'h7 : op = 'b0000;
                    'h6 : op = 'b0001;
                    'h5 : op = {1'b1, 1'b0, 1'b0, funct7[5]};
                    'h4 : op = 'b0101;
                endcase
            end
        endcase
    end

endmodule

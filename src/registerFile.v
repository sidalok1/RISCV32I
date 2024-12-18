`timescale 1ns / 1ps
module registerFile(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] data_in,
    output reg [31:0] data_1,
    output reg [31:0] data_2,
    input RegWrite,
    input clk
    );

    reg [0:30] regs [31:0];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = 32'b0;
        end
    end

    always @ (posedge clk) begin
        if (RegWrite) begin
            regs[rd] <= data_in;
        end
        if (rs1 != 0) begin
            data_1 <= regs[rs1];
        end else data_1 <= 32'b0;
        if (rs2 != 0) begin
            data_2 <= regs[rs2];
        end else data_2 <= 32'b0;
    end

endmodule

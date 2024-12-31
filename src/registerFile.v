`timescale 1ns / 1ps
module registerFile(
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] data_in,
    output reg [31:0] data_1,
    output reg [31:0] data_2,
    input RegWrite
    );

    reg [31:0] regs [0:31];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = 32'b0;
        end
        regs[3] = 32'h400; //gp
    end

    always @ ( rs1 or rs2 ) begin
        data_1 = regs[rs1];
        data_2 = regs[rs2];
    end

    always @ ( posedge clk ) begin
        if ( RegWrite && rd ) regs[rd] = data_in;
    end

endmodule
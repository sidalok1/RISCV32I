module immediateGenerator (
    input [31:0] instruction,
    output reg [31:0] imm
);

    always @ (instruction) begin
        case (instruction)
            'b0010011,
            'b0000011,
            'b1110011 : imm = {{20{instruction[31]}}, instruction[31:20]}; //I type
            'b0100011 : imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; //S type
            'b1100011 : imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //B type
            'b1101111 : imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction[11:8], 1'b0}; //J type
            'b0110111,
            'b0010111 : imm = {instruction[31:12], 12'b0}; //U type
        endcase
    end
endmodule

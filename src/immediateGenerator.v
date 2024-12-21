module immediateGenerator (
    input [31:0] instruction,
    output reg [31:0] imm
);

    always @ (instruction) begin
        case (instruction[6:5])
            'b00 : imm = (instruction[2]) ? //I or U type
                {instruction[31:12], 12'b0} :
                {{20{instruction[31]}}, instruction[31:20]};
            'b01 : imm = (instruction[2]) ? //S or U type
                {instruction[31:12], 12'b0} :
                {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        endcase
    end
endmodule

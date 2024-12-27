module immediateGenerator (
    input [31:0] inst,
    output reg [31:0] imm
);

    always @ (inst) begin
        case (inst[6:0])
            'b0010011 : case (inst[14:12])
                default : imm = {{20{inst[31]}}, inst[31:20]};
                'h1, 'h5 : imm = {27'b0, inst[24:20]};
            endcase
            'b0000011, 'b1110011, 'b1100111 :
                imm = {{20{inst[31]}}, inst[31:20]}; //I type
            'b0100011 : 
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]}; //S type
            'b1100011 : 
                imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0}; //B type
            'b1101111 : 
                imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0}; //J type
            'b0110111, 'b0010111 : 
                imm = {inst[31:12], 12'b0}; //U type
            default : imm = 32'b0;
        endcase
    end
endmodule

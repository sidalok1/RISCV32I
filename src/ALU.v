module ALU (
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] operation,
    output reg [31:0] out,
    output zero
);

    wire signed [31:0] in1Signed;
    wire signed [31:0] in2Signed;

    assign in1Signed = in1;
    assign in2Signed = in2;

    assign zero = out == 0;

    always @ (in1 or in2 or operation) begin
        case (operation)
            'b0000: out = in1 & in2; //AND
            'b0001: out = in1 | in2; //OR
            'b0010: out = in1Signed + in2Signed; //ADD
            'b0110: out = in1Signed - in2Signed; //SUB
            'b1000: out = in1 >> in2; //SRL
            'b1001: out = in1 >>> in2; //SRA
            'b0101: out = in1 ^ in2; //XOR
            'b1100: out = in1Signed < in2Signed; //SLT
            'b1101: out = in1 < in2; //SLTU
            'b1010: out = in1 << in2; //SLL
            'b1111: out = 0;
        endcase
    end

endmodule
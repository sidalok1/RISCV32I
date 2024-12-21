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
            'b0000: out = in1 & in2;
            'b0001: out = in1 | in2;
            'b0010: out = in1Signed + in2Signed;
            'b0010: out = in1Signed - in2Signed;
            'b1000: out = in1 >> in2;
            'b1001: out = in1 >>> in2;
            'b0101: out = in1 ^ in2;
        endcase
    end

endmodule
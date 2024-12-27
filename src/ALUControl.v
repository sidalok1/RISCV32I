module ALUControl(
    input [1:0] ALU_Op,
    output reg [3:0] op,
    input [2:0] funct3,
    input [6:0] funct7
    );

    always @ ( ALU_Op or funct3 or funct7 ) begin
        case (ALU_Op)
            'b00 : op = 'b0010;
            'b01 : begin
                case (funct3)
                    'h0, 'h1 : op = 'b0110;
                    'h4, 'h5 : op = 'b1100;
                    'h6, 'h7 : op = 'b1101;
                endcase
            end
            'b10 : begin
                case (funct3)
                    'h0 : op = {1'b0, funct7[5], 1'b1, 1'b0};
                    'h7 : op = 'b0000;
                    'h6 : op = 'b0001;
                    'h5 : op = {1'b1, 1'b0, 1'b0, funct7[5]};
                    'h4 : op = 'b0101;
                    'h3 : op = 'b1101;
                    'h2 : op = 'b1100;
                    'h1 : op = 'b1010;
                endcase
            end
            'b11 : op = 'b1111;
        endcase
    end

endmodule

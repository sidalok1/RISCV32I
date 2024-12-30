module immediateGenerator (
    input [31:0] inst,
    output wire [31:0] imm
);
    localparam I = 5'b00001;
    localparam S = 5'b00010;
    localparam B = 5'b00100;
    localparam U = 5'b01000;
    localparam J = 5'b10000;
    localparam R = 5'b00000;

    reg [4:0] type;

    assign {imm[31]} = inst[31];

    assign {imm[30:20]} =
    (type & U) ?
        inst[30:20] : {11{inst[31]}};

    assign {imm[19:12]} =
    (type & (J | U)) ?
        inst[19:12] : {8{inst[31]}};

    assign {imm[11]} =
    (type & (I | S)) ?
        inst[31] : (type & B) ?
            inst[7] : (type & J) ?
                inst[20] : 0;
                
    assign {imm[10:5]} =
    (type & U) ?
        6'b0 : inst[30:25];
        
    assign {imm[4:1]} =
    (type & (I | J)) ?
        inst[24:21] : (type & (S | B)) ?
            inst[11:8] : 4'b0;
            
    assign {imm[0]} =
    (type & I) ?
        inst[20] : (type & S) ?
            inst[7] : 0;
            
    always @ (inst) case (inst[6:0])
            'b0010011, 'b0000011, 'b1110011, 'b1100111 :
                type = I;
            'b0100011 :
                type = S;
            'b1100011 :
                type = B;
            'b1101111 :
                type = J;
            'b0110111, 'b0010111 :
                type = U;
            default :
                type = R;
    endcase
endmodule

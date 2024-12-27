module programCounter (
    input clk,
    output reg [31:0] PC
);

    initial PC = 0;

    always @ ( posedge clk ) PC <= PC + 4;

endmodule
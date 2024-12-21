module dataMemory(
    input clk,
    input [31:0] address,
    input [31:0] writeData,
    input [2:0] funct3,
    input MemWrite,
    input MemRead,
    output reg [31:0] readData
);

    reg [7:0] memory [0:4095];
    wire [31:0] data;

    wire [31:0] word;
    wire [7:0] byte;

    assign word = {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};
    assign byte = memory[address];

    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1) memory[i] = 8'b0;
    end

    always @ ( address or writeData ) begin
        case (funct3)
            'h0: begin //byte
                if (MemRead) readData = {{24{byte[7]}}, byte};
            end
            'h2: begin //word
                if (MemRead) readData = word;
            end
        endcase
    end

    always @ ( posedge clk ) begin
        case (funct3)
            'h0: begin //byte
                if (MemWrite)
                    memory[address] = writeData[7:0];
            end
            'h2: begin //word
                if (MemWrite)
                    {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]} = writeData;
            end
        endcase
    end
endmodule
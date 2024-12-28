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
    wire [15:0] half;
    wire [7:0] byte;

    assign word = {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};
    assign half = {memory[address + 1], memory[address]};
    assign byte = memory[address];

    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1) memory[i] = 8'b0;
    end

    always @ ( address or writeData ) begin //load
        case (funct3)
            'h0:  //byte
                if (MemRead) readData = {{24{byte[7]}}, byte};
            'h1:  //halfword
                if (MemRead) readData = {{16{byte[7]}}, half};
            'h2:  //word
                if (MemRead) readData = word;
            'h4:  //byte (unsigned)
                if (MemRead) readData = {24'b0, byte};
            'h5: //halfword (unsigned)
                if (MemRead) readData = {16'b0, half};
        endcase
    end

    always @ ( posedge clk ) begin //store
        case (funct3)
            'h0: //byte
                if (MemWrite)
                    memory[address] = writeData[7:0];
            'h1: //halfword
                if (MemWrite)
                    {memory[address + 1], memory[address]} = writeData[15:0];
            'h2: //word
                if (MemWrite)
                    {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]} = writeData;
        endcase
    end
endmodule
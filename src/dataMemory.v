module dataMemory(
    input clk,
    input [31:0] address,
    input [31:0] writeData,
    input [2:0] funct3,
    input MemWrite,
    input MemRead,
    output reg [31:0] readData,
    input [31:0] PC,
    output wire [31:0] instruction
);

    localparam WORD = 3'h0, HALF = 3'h1, BYTE = 3'h2, UBYTE = 3'h4, UHALF = 3'h5;

    reg [7:0] memory [0:4095];
    wire [31:0] data;

    wire [31:0] word;
    wire [15:0] half;
    wire [7:0] byte;

    assign word = {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};
    assign half = {memory[address + 1], memory[address]};
    assign byte = memory[address];

    assign instruction = {memory[PC + 3], memory[PC + 2], memory[PC + 1], memory[PC]};

    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1) memory[i] = 8'b0;
        $readmemh("test/init.mem", memory);
    end

    always @ ( word or half or byte ) begin //load
        if (MemRead)
            case (funct3)
                WORD:   readData = {{24{byte[7]}}, byte};
                HALF:   readData = {{16{byte[7]}}, half};
                BYTE:   readData = word;
                UBYTE:  readData = {24'b0, byte};
                UHALF:  readData = {16'b0, half};
            endcase
    end

    always @ ( posedge clk ) begin //store
        if (MemWrite)
            case (2 - funct3)
                BYTE: memory[address] <= writeData[7:0];
                HALF: {memory[address + 1], memory[address]} <= writeData[15:0];
                WORD: {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]} <= writeData;
            endcase
    end
endmodule
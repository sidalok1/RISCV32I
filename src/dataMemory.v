module dataMemory(
    input clk,
    input [31:0] address0,
    input [31:0] wrAddr,
    input [31:0] writeData,
    input [2:0] funct3,
    input MemWrite,
    input MemRead,
    output reg [31:0] readData0,
    input [31:0] address1,
    output wire [31:0] readData1
);

    localparam WORD = 3'h0, HALF = 3'h1, BYTE = 3'h2, UBYTE = 3'h4, UHALF = 3'h5;

    reg [7:0] memory [0:4095];

    wire [31:0] word;
    wire [15:0] half;
    wire [7:0] byte;

    assign word = {memory[address0 + 3], memory[address0 + 2], memory[address0 + 1], memory[address0]};
    assign half = {memory[address0 + 1], memory[address0]};
    assign byte = memory[address0];
    assign readData1 = {memory[address1 + 3], memory[address1 + 2], memory[address1 + 1], memory[address1]};

    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1) memory[i] = 8'b0;
        $readmemh("test/init.mem", memory);
    end

    always @ ( word or half or byte) begin
        if (MemRead)
            case (funct3)
                WORD:   readData0 = {{24{byte[7]}}, byte};
                HALF:   readData0 = {{16{byte[7]}}, half};
                BYTE:   readData0 = word;
                UBYTE:  readData0 = {24'b0, byte};
                UHALF:  readData0 = {16'b0, half};
            endcase
    end

    always @ ( posedge clk ) begin
        if (MemWrite)
            case (2 - funct3)
                BYTE: memory[wrAddr] <= writeData[7:0];
                HALF: {memory[wrAddr + 1], memory[wrAddr]} <= writeData[15:0];
                WORD: {memory[wrAddr + 3], memory[wrAddr + 2], memory[wrAddr + 1], memory[wrAddr]} <= writeData;
            endcase
    end
endmodule
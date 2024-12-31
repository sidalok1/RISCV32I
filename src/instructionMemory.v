module instructionMemory(
    input wire [31:0] address,
    output wire [31:0] instruction
);

    reg [7:0] memory [0:4095];

    assign instruction = {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};

    initial begin
        $readmemh("test/init.mem", memory);
    end





endmodule

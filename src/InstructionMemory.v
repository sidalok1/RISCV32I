module InstructionMemory(
    input wire clk,
    input wire [31:0] address,
    output wire [31:0] instruction
);

    reg [7:0] memory [0:4095];

    initial begin
        $readmemh("test/instructions.mem", memory);
    end

    assign instruction = {memory[address + 3], memory[address + 2], memory[address + 1], memory[address]};



endmodule

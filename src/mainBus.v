module mainBus(input clk);

    wire [31:0] instruction;

    reg [31:0] ProgramCounter;

    InstructionMemory instMem(
        .clk(clk),
        .address(ProgramCounter),
        .instruction(instruction)
    );

    initial begin
        ProgramCounter <= -4;
    end

    always @ (posedge clk) begin

        ProgramCounter <= ProgramCounter + 4;

    end
endmodule
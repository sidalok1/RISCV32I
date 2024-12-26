module mainBus(input clk);

    wire [31:0] instruction;

    reg [31:0] ProgramCounter;

    //Instruction Memory module
    instructionMemory instMem(
        .address(ProgramCounter),
        .instruction(instruction)
    );


    //Controller modules
    wire RegWriteSIG;
    wire ALUSrcSIG;
    wire [1:0] ALUOpSIG;
    wire MemWriteSIG;
    wire MemReadSIG;
    wire MemToRegSIG;
    wire BranchSIG;
    controller cont(
        .opcode(instruction[6:0]),
        .RegWrite(RegWriteSIG),
        .ALUSrc(ALUSrcSIG),
        .ALUOp(ALUOpSIG),
        .MemWrite(MemWriteSIG),
        .MemRead(MemReadSIG),
        .MemToReg(MemToRegSIG),
        .Branch(BranchSIG)
    );

    wire [3:0] FU1_SIG;
    ALUControl FU1_control(
        .ALU_Op(ALUOpSIG),
        .op(FU1_SIG),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25])
    );

    //Register File module
    wire [31:0] regFileRead1;
    wire [31:0] regFileRead2;
    wire [31:0] regFileWrite;
    registerFile regFile(
        .clk(clk),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .RegWrite(RegWriteSIG),
        .data_1(regFileRead1),
        .data_2(regFileRead2),
        .data_in(regFileWrite)
    );


    //Immediate Generator Module
    wire [31:0] immediate;
    immediateGenerator immGen(.instruction(instruction), .imm(immediate));


    //ALU modules
    wire [31:0] ALUdata2;
    assign ALUdata2 = (ALUSrcSIG) ? immediate : regFileRead2;

    wire [31:0] FU1_data;
    wire FU1_zero;
    ALU FU1(
        .in1(regFileRead1),
        .in2(ALUdata2),
        .operation(FU1_SIG),
        .out(FU1_data),
        .zero(FU1_zero)
    );


    //Memory controller Module

    wire [31:0] memoryData;
    dataMemory mem(
        .clk(clk),
        .address(FU1_data),
        .funct3(instruction[14:12]),
        .MemWrite(MemWriteSIG),
        .MemRead(MemReadSIG),
        .writeData(regFileRead2),
        .readData(memoryData)
    );

    assign regFileWrite = (MemToRegSIG) ? memoryData : FU1_data;

    //PC module. Will need to be moved to its own module on implementation of branches
    initial begin
        ProgramCounter <= -4;
    end

    always @ (posedge clk) begin

        ProgramCounter <= ProgramCounter + 4;

    end
endmodule
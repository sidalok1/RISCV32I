module mainBus(input clk);

    reg [31:0] PC;
    //wires

    //PC wires
    wire [31:0] linkAddress;
    assign linkAddress = PC + 4;
    wire [31:0] branchAddress;
    wire BranchSIG;
    wire LinkSIG;
    wire BranchOriginSIG;

    //instruction wires
    wire [31:0] instruction;

    //controller wires
    wire RegWriteSIG;
    wire ALUSrcSIG;
    wire [3:0] ALUOpSIG;
    wire MemWriteSIG;
    wire MemReadSIG;
    wire MemToRegSIG;

    //register file wires
    wire [31:0] regFileRead1;
    wire [31:0] regFileRead2;
    wire [31:0] regFileWrite;

    wire [31:0] immediate;
    assign branchAddress = (BranchOriginSIG) ? PC + immediate : (regFileRead1 + immediate) & -32'd2;
    //ALU wires
    wire [31:0] ALUdata2;
    assign ALUdata2 = (ALUSrcSIG) ?
        immediate
            :
        regFileRead2;

    wire [31:0] FU1_data;
    wire FU1_zero;

    //memory wires
    wire [31:0] memoryData;
    assign regFileWrite = (MemToRegSIG) ?
        memoryData
            :
        (LinkSIG) ?
            linkAddress
                :
            FU1_data;

    //MODULE INSTANTIATIONS

    //Instruction Memory module
    instructionMemory instMem(
        .address(PC),
        .instruction(instruction)
    );

    //Controller modules
    controller cont(
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .RegWrite(RegWriteSIG),
        .ALUSrc(ALUSrcSIG),
        .ALUOp(ALUOpSIG),
        .MemWrite(MemWriteSIG),
        .MemRead(MemReadSIG),
        .MemToReg(MemToRegSIG),
        .Branch(BranchSIG),
        .Link(LinkSIG),
        .BranchFromPC(BranchOriginSIG)
    );


    //Register File module
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
    immediateGenerator immGen(.inst(instruction), .imm(immediate));

    //ALU modules
    ALU FU1(
        .in1(regFileRead1),
        .in2(ALUdata2),
        .operation(ALUOpSIG),
        .out(FU1_data),
        .zero(FU1_zero)
    );

    //Memory controller Module
    dataMemory mem(
        .clk(clk),
        .address(FU1_data),
        .funct3(instruction[14:12]),
        .MemWrite(MemWriteSIG),
        .MemRead(MemReadSIG),
        .writeData(regFileRead2),
        .readData(memoryData)
    );

    initial PC = 0;

    always @ (posedge clk) begin
        if (BranchSIG && FU1_zero)
            PC <= branchAddress;
        else
            PC <= linkAddress;
    end

endmodule
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
        wire ReverseSIG;

    //instruction wires
        wire [31:0] instruction;

    //controller wires
        wire RegWriteSIG;
        wire [1:0] ALUSrcSIG;
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
        wire [31:0] ALUdata1;
        wire [31:0] ALUdata2;

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

    //Controller modules
        controller cont(
            .opcode(FD_Instruction[6:0]),
            .funct3(FD_Instruction[14:12]),
            .funct7(FD_Instruction[31:25]),
            .RegWrite(RegWriteSIG),
            .ALUSrc(ALUSrcSIG),
            .ALUOp(ALUOpSIG),
            .MemWrite(MemWriteSIG),
            .MemRead(MemReadSIG),
            .MemToReg(MemToRegSIG),
            .Branch(BranchSIG),
            .Link(LinkSIG),
            .BranchFromPC(BranchOriginSIG),
            .ReverseBranchCondition(ReverseSIG)
        );
    //Register File module
        registerFile regFile(
            .clk(clk),
            .rs1(FD_Instruction[19:15]),
            .rs2(FD_Instruction[24:20]),
            .rd(MW_RD),
            .RegWrite(MW_RegWriteSIG),
            .data_1(regFileRead1),
            .data_2(regFileRead2),
            .data_in(MW_RegWriteData)
        );
    //Immediate Generator Module
        immediateGenerator immGen(.inst(FD_Instruction), .imm(immediate));
    //ALU modules
        ALU FU1(
            .in1(ALUdata1),
            .in2(ALUdata2),
            .operation(DE_ALUOpSIG),
            .out(FU1_data),
            .zero(FU1_zero)
        );
    //Memory controller Module
        dataMemory mem(
            .clk(clk),
            .address0(FU1_data),
            .funct3(instruction[14:12]),
            .MemWrite(EM_MemWriteSIG),
            .MemRead(EM_MemReadSIG),
            .wrAddr(EM_ALUResult),
            .writeData(EM_ReadData2),
            .readData0(memoryData),
            .address1(PC),
            .readData1(instruction)
        );

    //STAGES
        //fetch/decode
            reg [31:0] FD_PC;
            reg [31:0] FD_Instruction;

            always @ ( posedge clk ) begin
                FD_PC <= PC;
                FD_Instruction <= instruction;
            end

            initial #1 PC = 0;

            always @ (posedge clk) begin
                if (EM_BranchSIG && (EM_Zero ^ EM_ReverseSIG))
                    PC <= EM_BranchAddress;
                else
                    PC <= linkAddress;
            end

        //decode/execute
            reg [31:0] DE_PC;
            reg [31:0] DE_Read1;
            reg [31:0] DE_Read2;
            reg [4:0] DE_RD;
            reg [31:0] DE_Imm;
            reg DE_RegWriteSIG;
            reg [1:0] DE_ALUSrcSIG;
            reg [3:0] DE_ALUOpSIG;
            reg DE_MemWriteSIG;
            reg DE_MemReadSIG;
            reg DE_MemToRegSIG;

            reg DE_BranchSIG;
            reg DE_LinkSIG;
            reg DE_BranchOriginSIG;
            reg DE_ReverseSIG;

            always @ ( posedge clk ) begin
                DE_PC <= FD_PC;
                DE_Read1 <= regFileRead1;
                DE_Read2 <= regFileRead2;
                DE_Imm <= immediate;

                DE_RegWriteSIG <= RegWriteSIG;
                DE_ALUSrcSIG <= ALUSrcSIG;
                DE_ALUOpSIG <= ALUOpSIG;
                DE_MemWriteSIG <= MemWriteSIG;
                DE_MemReadSIG <= MemReadSIG;
                DE_MemToRegSIG <= MemToRegSIG;

                DE_BranchSIG <= BranchSIG;
                DE_BranchOriginSIG <= BranchOriginSIG;
                DE_LinkSIG <= LinkSIG;
                DE_ReverseSIG <= ReverseSIG;
                DE_RD <= FD_Instruction[11:7];
            end

        //execute/memory

            reg [31:0] EM_BranchAddress;
            reg EM_BranchSIG;
            reg EM_ReverseSIG;
            reg EM_Zero;
            reg [31:0] EM_ALUResult;
            reg [31:0] EM_ReadData2;
            reg [4:0] EM_RD;

            reg EM_MemReadSIG;
            reg EM_MemWriteSIG;
            reg EM_RegWriteSIG;
            reg EM_MemToRegSIG;

            assign ALUdata1 = (DE_ALUSrcSIG[1]) ?
                DE_PC
                    :
                DE_Read1;

            assign ALUdata2 = (DE_ALUSrcSIG[0]) ?
                DE_Imm
                    :
                DE_Read2;

            always @ ( posedge clk ) begin
                EM_BranchAddress <= (DE_BranchOriginSIG) ? DE_PC + DE_Imm : (DE_Read1 + DE_Imm) & -32'd2;
                EM_BranchSIG <= DE_BranchSIG;
                EM_ReverseSIG <= DE_ReverseSIG;

                EM_Zero <= FU1_zero;
                EM_ALUResult <= FU1_data;

                EM_ReadData2 <= DE_Read2;

                EM_MemReadSIG <= DE_MemReadSIG;
                EM_MemWriteSIG <= DE_MemWriteSIG;
                EM_RegWriteSIG <= DE_RegWriteSIG;
                EM_MemToRegSIG <= DE_MemToRegSIG;

                EM_RD <= DE_RD;
            end

        //memory/write back

        wire [31:0] MW_RegWriteData;
        wire [4:0] MW_RD;
        wire MW_RegWriteSIG;

        assign MW_RegWriteData = (EM_MemToRegSIG) ? memoryData : EM_ReadData2;

        assign MW_RD = EM_RD;

        assign MW_RegWriteSIG = EM_RegWriteSIG;


endmodule
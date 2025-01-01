
opfmt = {
    "0110011":"R",
    "0010011":"I",
    "0000011":"I",
    "0100011":"S",
    "1100011":"B",
    "1101111":"J",
    "1100111":"I",
    "0110111":"U",
    "0010111":"U",
    "1110011":"I"
}

iopcode = {
    "0010011":"arith",
    "0000011":"load",
    "1100111":"jalr"
}

uopcode = {
    "0110111":"lui",
    "0010111":"auipc"
}

ropfunct3 = {
    "000":"ADDorSUB",
    "001":"sll",
    "010":"slt",
    "011":"sltu",
    "100":"xor",
    "101":"SHIFTRIGHT",
    "110":"or",
    "111":"and",
}

iopfunct3 = {
    "000":"addi",
    "001":"slli",
    "010":"slti",
    "011":"sltiu",
    "100":"xori",
    "101":"SHIFTRIGHT",
    "110":"ori",
    "111":"andi",
}

lopfunct3 = {
    "000":"lb",
    "001":"lh",
    "010":"lw",
    "100":"lbu",
    "101":"lhu",
}

sopfunct3 = {
    "000":"sb",
    "001":"sh",
    "010":"sw",
}

bopfunct3 = {
    "000":"beq",
    "001":"bne",
    "100":"blt",
    "101":"bge",
    "110":"bltu",
    "111":"bgeu",
}

class instruction:
    __slots__ = ('type', 'op', 'rd', 'rs1', 'rs2', 'imm')
    def __init__(self, data: str):
        try:
            bits = f"{int(data, 16):0>32b}"
        except ValueError:
            self.type = "N/A"
            self.op = f"Invalid string: {data}"
        else:
            opcode =    bits[31-6   :   32-0]
            rd =        bits[31-11  :   32-7]
            funct3 =    bits[31-14  :   32-12]
            rs1 =       bits[31-19  :   32-15]
            rs2 =       bits[31-24  :   32-20]
            funct7 =    bits[31-31   :   32-25]
            try:
                instType = opfmt[opcode]
                match instType:
                    case "R":
                        self.type = "R"
                        self.rd = int(rd, 2)
                        self.rs1 = int(rs1, 2)
                        self.rs2 = int(rs2, 2)
                        f3 = ropfunct3[funct3]
                        match f3:
                            case "ADDorSUB":
                                if funct7 == "0100000":
                                    self.op = "sub"
                                else:
                                    self.op = "add"
                            case "SHIFTRIGHT":
                                if funct7 == "0100000":
                                    self.op = "sra"
                                else:
                                    self.op = "srl"
                            case _:
                                self.op = f3
                    case "I":
                        self.type = "I"
                        self.rd = int(rd, 2)
                        self.rs1 = int(rs1, 2)
                        imm = int(funct7[1:] + rs2, 2)
                        if funct7[0] == '1':
                            self.imm = imm - 2048
                        else:
                            self.imm = imm
                        op = iopcode[opcode]
                        if op == "arith":
                            f3 = iopfunct3[funct3]
                            if f3 == "SHIFTRIGHT":
                                if funct7 == "0100000":
                                    self.op = "srai"
                                else:
                                    self.op = "srli"
                            else: self.op = f3
                        elif op == "load":
                            self.op = lopfunct3[funct3]
                        else: self.op = op
                    case "S":
                        self.type = "S"
                        self.rs1 = int(rs1, 2)
                        self.rs2 = int(rs2, 2)
                        imm = int(funct7[1:] + rd, 2)
                        if funct7[0] == '1':
                            self.imm = imm - 2048
                        else:
                            self.imm = imm
                        self.op = sopfunct3[funct3]
                    case "B":
                        self.type = "B"
                        self.rs1 = int(rs1, 2)
                        self.rs2 = int(rs2, 2)
                        imm = int(rd[4] + funct7[1:] + rd[0:4] + '0', 2)
                        if funct7[0] == '1':
                            self.imm = imm - 2048
                        else:
                            self.imm = imm
                        self.op = bopfunct3[funct3]
                    case "U":
                        self.type = "U"
                        self.rd = int(rd, 2)
                        imm = int(funct7[1:] + rs2 + rs1 + funct3, 2)
                        if funct7[0] == '1':
                            self.imm = imm - (2**19)
                        else:
                            self.imm = imm
                        self.op = uopcode[opcode]
                    case "J":
                        self.type = "J"
                        self.rd = int(rd, 2)
                        imm = int(rs1 + funct3 + rs2[4] + funct7[1:] + rs2[0:4] + '0', 2)
                        if funct7[0] == '1':
                            self.imm = imm - (2**19)
                        else:
                            self.imm = imm
                        self.op = "jal"
            except KeyError:
                self.type = "N/A"
                self.op = f"Invalid instruction: {data}"

    def __repr__(self):
        match self.type:
            case "R":
                return f"{self.op:<4} x{self.rd}, x{self.rs1}, x{self.rs2}"
            case "I":
                return f"{self.op:<4} x{self.rd}, x{self.rs1}, {self.imm}"
            case "S":
                return f"{self.op:<4} x{self.rs2}, {self.imm}({self.rs1})"
            case "B":
                return f"{self.op:<4} x{self.rs1}, x{self.rs2}, {self.imm}"
            case "U":
                return f"{self.op:<4} x{self.rd}, {self.imm}"
            case "J":
                return f"{self.op:<4} x{self.rd}, {self.imm}"
            case "N/A":
                return self.op


if __name__ == "__main__":
    test = instruction("00cff2b7")
    print(test)
#!/home/sid/bin/python3
import sys
from decode import instruction as dis

colors = {
    "R":"?dark red?",
    "I":"?dark goldenrod?",
    "LI":"?dark olive green?",
    "S":"?dark magenta?",
    "B":"?dark blue?",
    "JI":"?dark violet?",
    "J":"?dark violet?",
    "U":"?dark orange?"
}

def disassemble(instr):
    instruction = dis(instr)
    color = colors.get(instruction.type,"")
    return color + instruction.__repr__()

def main():
    while True:
        try:
            inst: str = input()
        except EOFError:
            return 0
        if not inst:
            return 0
        print(disassemble(inst), end='\n', flush=True)

if __name__ == '__main__':
    sys.exit(main())
#!/home/sid/bin/python3
import sys
from decode import instruction as dis

def disassemble(instr):
    return dis(instr).__repr__()

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
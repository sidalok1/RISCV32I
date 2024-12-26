import pathlib as pl
import subprocess as sp
import numpy as np
import logging as log
import argparse
import re
logger = log.getLogger(__name__)

rv32i = {
'add': '0110011',
'sub': '0110011',
'xor': '0110011',
'or': '0110011',
'and': '0110011',
'sll': '0110011',
'srl': '0110011',
'sra': '0110011',
'slt': '0110011',
'sltu': '0110011',

'addi': '0010011',
'xori': '0010011',
'ori': '0010011',
'andi': '0010011',
'slli': '0010011',
'srli': '0010011',
'srai': '0010011',
'slti': '0010011',
'sltiu': '0010011',

'lb': '0000011',
'lw': '0000011',

'sb': '0100011',
'sw': '0100011',

'beq': '1100011',
'bne': '1100011',
'blt': '1100011',
'bge': '1100011',
'bltu': '1100011',
'bgeu': '1100011',

'jal': '1101111',
'jalr': '1100111',

'lui': '0110111',

}

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='RISCV32I assembler')
    parser.add_argument('filename', type=argparse.FileType('r'))
    args = parser.parse_args()
    f = args.filename.read().splitlines()

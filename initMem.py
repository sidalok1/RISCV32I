#!python3
def little(code: str) -> str:
    words = code.splitlines()
    bytecode = list()
    for line in words:
        bytecode.extend([line[6:8], line[4:6], line[2:4], line[0:2]])
    return '\n'.join(bytecode)

if __name__ == '__main__':
    with open('./test/init.mem', 'w') as mem:
        machineCode = open('./traces/test.txt', 'r').read()
        mem.write(little(machineCode))

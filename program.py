def little(words) -> str:
    bytecode = list()
    for line in words:
        bytecode.extend([line[6:8], line[4:6], line[2:4], line[0:2]])
    return "\n".join(bytecode)

if __name__ == "__main__":
    with open('./test/init.mem', 'w') as mem:
        machineCode = open('./traces/test.txt', 'r').read()
        data = little(machineCode.splitlines())
        data += "\n@400\n"
        globalVars = open('./traces/globals.txt', 'r').readlines()
        vars = list()
        for var in globalVars:
            vars.append(f"{int(var):0>8x}")
        data += little(vars)
        mem.write(data)
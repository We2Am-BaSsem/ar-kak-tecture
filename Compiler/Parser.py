opMap = {
    "nop": "00000",
    "hlt": "00001",
    "setc": "00010",
    "not": "00011",
    "inc": "00100",
    "out": "00101",
    "in": "00110",
    "add": "01000",
    "sub": "01001",
    "mov": "01010",
    "and": "01011",
    "iadd": "01100",
    "ldd": "10000",
    "std": "10001",
    "ldm": "10010",
    "push": "10011",
    "pop": "10100",
    "jz": "11000",
    "jn": "11001",
    "jc": "11010",
    "jmp": "11011",
    "call": "11100",
    "ret": "11101",
    "int": "11110",
    "rti": "11111",
}
operandMap = {
    "nop": [],
    "hlt": [],
    "setc": [],
    "not": ["r01"],
    "inc": ["r01"],
    "out": ["r01"],
    "in": ["r01"],
    "add": ["r0", "r1", "r2"],
    "sub": ["r0", "r1", "r2"],
    "mov": ["r0", "r1"],
    "and": ["r0", "r1", "r2"],
    "iadd": ["r0", "r1", "i"],
    "ldd": ["r0", "r1", "i"],
    "std": ["r1", "r2", "i"],
    "ldm": ["r0", "i"],
    "push": ["r0"],
    "pop": ["r0"],
    "jz": ["r0"],
    "jn": ["r0"],
    "jc": ["r0"],
    "jmp": ["r0"],
    "call": ["r0"],
    "ret": [],
    "int": ["i"],
    "rti": [],
}

progarmStart = 10
stackException = 65
memException = 129
interupt1 = 257
interupt2 = 513

file = open("Compiler/Code1.txt", "r")
memory = []
code = []
memory.append("{0:032b}".format(progarmStart)[15:-1])
memory.append("{0:032b}".format(progarmStart)[31:15])
memory.append("{0:032b}".format(stackException)[15:-1])
memory.append("{0:032b}".format(stackException)[31:15])
memory.append("{0:032b}".format(memException)[15:-1])
memory.append("{0:032b}".format(memException)[31:15])
memory.append("{0:032b}".format(interupt1)[15:-1])
memory.append("{0:032b}".format(interupt1)[31:15])
memory.append("{0:032b}".format(interupt2)[15:-1])
memory.append("{0:032b}".format(interupt2)[31:15])
print(memory)

for line in file:
    line = line.replace(",", " ").lower()
    instructions = line.split()
    immFlag = False
    # print(instructions)
    operands = operandMap[instructions[0]]
    op = opMap[instructions[0]]
    codeLine = ["0"] * 16
    codeLine[0:5] = op
    for i in range(len(operands)):
        if operands[i][0] == "r":
            if "0" in operands[i]:
                codeLine[5:8] = "{0:03b}".format(int(instructions[i + 1][1]))
            if "1" in operands[i]:
                codeLine[8:11] = "{0:03b}".format(int(instructions[i + 1][1]))
            if "2" in operands[i]:
                codeLine[11:14] = "{0:03b}".format(int(instructions[i + 1][1]))
        else:
            immFlag = True
    if immFlag:
        codeLine[-1] = "1"
    code.append("".join(codeLine))
    if immFlag and instructions[-1][0] == "x":
        code.append("{0:016b}".format(
            int(instructions[i + 1][1:].replace('"', ''), 16)))
    if immFlag and instructions[-1][0] == "d":
        code.append("{0:016b}".format(
            int(instructions[i + 1][1:].replace('"', ''))))

code.append(opMap["hlt"] + "00000000000")
# print(instructions, codeLine)

# print(code)
# print(len(code))

outputFile = open("Compiler/InstructionMEmeory.mem", "w")
for instruction in code:
    outputFile.write(instruction)
    outputFile.write("\n")


outputFile.close()
file.close()

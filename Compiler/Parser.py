import os

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
    "push": ["r1"],
    "pop": ["r0"],
    "jz": ["r1"],
    "jn": ["r1"],
    "jc": ["r1"],
    "jmp": ["r1"],
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

file = open(os.getcwd() + "/Compiler/Branch_copy.asm", "r")
memory = ["0000000000000000"] * 2 ** 20
code = []


def memoryInserion(address, index):
    memory[index] = "{0:032b}".format(int(address, 16))[0:16]
    memory[index + 1] = "{0:032b}".format(int(address, 16))[16:32]


address = 0
for line in file:
    print(line)
    if line[0] == "#" or line == "\n":
        continue
    if "#" in line:
        line = line[0 : line.index("#")]
    if ".ORG" in line:
        if any(
            ext in line
            for ext in [
                ".ORG 0 ",
                ".ORG 2 ",
                ".ORG 4 ",
                ".ORG 6 ",
                ".ORG 8 ",
                ".ORG 0\n",
                ".ORG 2\n",
                ".ORG 4\n",
                ".ORG 6\n",
                ".ORG 8\n",
            ]
        ):
            memoryInserion(file.__next__(), int(line[5:]))
            continue
        else:
            line = line.replace("\n", "")
            address = int("{0:0.0f}".format(int(line[5:], 16)))
            print(line[5:])
            print("{0:0.0f}".format(int(line[5:], 16)))
            continue

    line = line.replace(",", " ").lower()
    instructions = line.split()
    immFlag = False

    print(instructions)

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
    memory[address] = "".join(codeLine)
    address += 1
    if immFlag:
        memory[address] = "{0:016b}".format(int(instructions[i + 1], 16))
        address += 1

outputFile = open(os.getcwd() + "/Compiler/Branch_copy.mem", "w")

outputFile.write(
    "// memory data file (do not edit the following line - required for mem load use)\n"
)
outputFile.write(
    "// instance=/processor/fetch_unit/instructionmemory/InstructionMemory\n"
)
outputFile.write(
    "// format=mti addressradix=h dataradix=b version=1.0 wordsperline=1\n"
)

for i in range(len(memory)):
    outputFile.write(f"{hex(i)[2:]}: {memory[i]}\n")


outputFile.close()
file.close()
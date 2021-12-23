def toBinary(a):
    return (
        1
        if a == "1"
        else 2
        if a == "2"
        else 3
        if a == "3"
        else 4
        if a == "4"
        else 5
        if a == "5"
        else 6
        if a == "6"
        else 7
        if a == "7"
        else 8
        if a == "8"
        else 9
        if a == "9"
        else 10
        if a == "a"
        else 11
        if a == "b"
        else 12
        if a == "c"
        else 13
        if a == "d"
        else 14
        if a == "e"
        else 15
    )


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

file = open("Compiler/Code1.txt", "r")
code = []
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
            if instructions[i + 1][0] == "x":
                print(str(bin(toBinary(instructions[i + 1][1:])))[2:])
            if instructions[i + 1][0] == "d":
                print(str(bin(int(instructions[i + 1][1:].replace('"',''))))[2:])

    if immFlag:
        codeLine[-1] = "1"
    code.append("".join(codeLine))
    # print(instructions, codeLine)
    # if immFlag:

# print(code)
# print(len(code))

outputFile = open("Compiler/InstructionMEmeory.mem", "w")
for instruction in code:
    outputFile.write(instruction)
    outputFile.write("\n")


outputFile.close()
file.close()

vsim -gui work.ALU


add wave -position insertpoint  \
sim:/ALU/opCode \
sim:/ALU/d1 \
sim:/ALU/d2 \
sim:/ALU/imm \
sim:/ALU/oldZ \
sim:/ALU/oldN \
sim:/ALU/ALUOut \
sim:/ALU/cout \
sim:/ALU/newZ \
sim:/ALU/newN \
sim:/ALU/ALUExceptionSignal 

#1
force -freeze sim:/ALU/opCode 00011 
force -freeze sim:/ALU/d1 16#0000 0
force -freeze sim:/ALU/oldZ 0 
force -freeze sim:/ALU/oldN 0
run

#2
force -freeze sim:/ALU/opCode 00100 
force -freeze sim:/ALU/d1 16#FFFF 0
run

#3
force -freeze sim:/ALU/opCode 01000 
force -freeze sim:/ALU/d1 16#FFFF 0
force -freeze sim:/ALU/d2 16#FFFF 0
run

#4
force -freeze sim:/ALU/opCode 01000 
force -freeze sim:/ALU/d1 16#1234 0
force -freeze sim:/ALU/d2 16#3DEF 0
run

#5
force -freeze sim:/ALU/opCode 01001
force -freeze sim:/ALU/d1 16#0000 0
force -freeze sim:/ALU/d2 16#FFFF 0
run

#6
force -freeze sim:/ALU/opCode 01001
force -freeze sim:/ALU/d1 16#3DEF 0
force -freeze sim:/ALU/d2 16#1234 0
run

#7
force -freeze sim:/ALU/opCode 01010
force -freeze sim:/ALU/d1 16#3DEF 0
run

#8
force -freeze sim:/ALU/opCode 01011
force -freeze sim:/ALU/d1 16#F24A 0
force -freeze sim:/ALU/d2 16#1244 0
run

#9
force -freeze sim:/ALU/opCode 01100
force -freeze sim:/ALU/d1 16#F24A 0
force -freeze sim:/ALU/imm 16#F24A 0
run

#10
force -freeze sim:/ALU/opCode 10000
force -freeze sim:/ALU/d1 16#0000 0
force -freeze sim:/ALU/imm 16#FFFF 0
run

#11
force -freeze sim:/ALU/opCode 10001
force -freeze sim:/ALU/d2 16#1234 0
force -freeze sim:/ALU/imm 16#3DEF 0
run

#12
force -freeze sim:/ALU/opCode 10010
force -freeze sim:/ALU/imm 16#3DEF 0
run
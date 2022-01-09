# all numbers in hex format
# we always start by reset signal
# this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 2  #this is empty stack exception handler address
400

.ORG 4  #this is invalid addess exception handler address
450

.ORG 6  #this is int 0
200

.ORG 8  #this is int 2
250


.ORG 10
IN R1     #R1=30
IN R2     #R2=50
IN R3     #R3=100
IN R4     #R4=300
INC R4
INC R4
JMP R1 
INC R1	  # this statement shouldn't be executed

#check flag fowarding  
.ORG 30
MOV R6,R2
AND R5,R1,R5   #R5=0 , Z = 1
INC R6
INC R6
INC R6
JMP R1
NOP
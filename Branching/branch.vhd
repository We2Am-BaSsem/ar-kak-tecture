
Library ieee;
use ieee.std_logic_1164.all;


entity branching is 

port(

ALUEx,StackEx,PCregOutput,RRdst : IN std_logic_vector(31 downto 0);
--pc reg output has pc_of_current_instruction+1 (or pc_of_current_instructionpc+2)
carryflag,negativeflag,zeroflag : IN std_logic;
instruction13to11               : IN std_logic_vector(2 downto 0);

FlushDecode,FlushEx,XofSP,POP,FnJMP : IN std_logic;

nextPC                          : OUT  std_logic_vector(31 downto 0)
);
end branching;

signal branchTaken :  std_logic;
signal first_mux,second_mux,third_mux :      std_logic_vector(31 downto 0);
architecture branching_architecture of branching is 

begin   
    if(instruction13to11="000") and (zeroflag=1) then
        branchTaken<="1";
    else if (instruction13to11="001") and (negativeflag=1)then
        branchTaken<="1";
    else if (instruction13to11="010") and (carryflag=1)then
        branchTaken<="1";
    else if (instruction13to11="011") then
        branchTaken<="1";
    else
        branchTaken<="0";

    if(branchTaken="1")then
        first_mux<=RRdst;
    else 
    first_mux<=PCregOutput;


    --here should be the code of secondmux
    if(Flushdecode="") and(FlushEx="") then
        second_mux<=ALUEx
    else if (Flushdecode="") and(FlushEx="")then
        second_mux<=StackEx
    else 
    second_mux<=first_mux;



    if(POP and FnJMP) then
        third_mux<=XofSP;
    else
        third_mux<=second_mux;


end architecture





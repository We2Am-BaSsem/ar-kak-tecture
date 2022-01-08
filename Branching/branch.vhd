LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY branching IS

    PORT (

        ALUEx, StackEx, PCregOutput, RRdst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        --pc reg output has pc_of_current_instruction+1 (or pc_of_current_instructionpc+2)
        carryflag, negativeflag, zeroflag : IN STD_LOGIC;
        instruction13to11 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        FlushDecode, FlushEx, XofSP, POP, FnJMP : IN STD_LOGIC;

        nextPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END branching;

SIGNAL branchTaken : STD_LOGIC;
SIGNAL first_mux, second_mux, third_mux : STD_LOGIC_VECTOR(31 DOWNTO 0);
ARCHITECTURE branching_architecture OF branching IS

BEGIN
    IF (instruction13to11 = "000") AND (zeroflag = 1) THEN
        branchTaken <= "1";
    ELSE
        IF (instruction13to11 = "001") AND (negativeflag = 1) THEN
            branchTaken <= "1";
        ELSE
            IF (instruction13to11 = "010") AND (carryflag = 1) THEN
                branchTaken <= "1";
            ELSE
                IF (instruction13to11 = "011") THEN
                    branchTaken <= "1";
                ELSE
                    branchTaken <= "0";

                    IF (branchTaken = "1") THEN
                        first_mux <= RRdst;
                    ELSE
                        first_mux <= PCregOutput;
                        --here should be the code of secondmux
                        IF (Flushdecode = "") and(FlushEx="") THEN
                            second_mux <= ALUEx
                                ELSE
                                IF (Flushdecode = "") and(FlushEx="") THEN
                                    second_mux <= StackEx
                                    ELSE
                                    second_mux <= first_mux;

                                    IF (POP AND FnJMP) THEN
                                        third_mux <= XofSP;
                                    ELSE
                                        third_mux <= second_mux;
                                END ARCHITECTURE

                                    IF (POP AND FnJMP) THEN
                                        third_mux <= XofSP;
                                    ELSE
                                        third_mux <= second_mux;
                                END ARCHITECTURE

                            IF (POP AND FnJMP) THEN
                                third_mux <= XofSP;
                                ELSE
                                third_mux <= second_mux;
                                END ARCHITECTURE

                            IF (POP AND FnJMP) THEN
                                third_mux <= XofSP;
                                ELSE
                                third_mux <= second_mux;
                                END ARCHITECTURE
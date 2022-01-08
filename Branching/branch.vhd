LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;


-- enC : in std_logic := '0';
--         flags_in : in std_logic_vector(2 downto 0) := (OTHERS => '0');   
ENTITY branching IS

    PORT (

    alu_ex_address, PCregOutput,XofSP : IN STD_LOGIC_VECTOR(31 DOWNTO 0):= (OTHERS => '0');
    RRdst                             : in std_logic_vector(15 downto 0):= (OTHERS => '0');
    carryflag, negativeflag, zeroflag : IN STD_LOGIC:= '0';
    instruction13to11                 : IN STD_LOGIC_VECTOR(2 DOWNTO 0):= (OTHERS => '0');

    alu_ex, POP, FnJMP                : IN STD_LOGIC:= '0';

    nextPC                            : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):= (OTHERS => '0');
    pc_changed                        : OUT STD_LOGIC:= '0' --input to mux at PC
    );
END entity branching;

ARCHITECTURE branching_architecture OF branching IS

SIGNAL branchTaken : STD_LOGIC;
SIGNAL first_mux, second_mux, third_mux : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    process(instruction13to11,zeroflag,negativeflag,carryflag, RRdst, PCregOutput)
    begin
        IF (instruction13to11 = "000") AND (zeroflag = '1') THEN
            branchTaken <= '1';
        ELSIF (instruction13to11 = "001") AND (negativeflag = '1') THEN
            branchTaken <= '1';
        ELSIF (instruction13to11 = "010") AND (carryflag = '1') THEN
            branchTaken <= '1';
        ELSIF (instruction13to11 = "011") THEN
            branchTaken <= '1';
        ELSE
            branchTaken <= '0';
        end if;

        IF (branchTaken = '1') THEN
            first_mux <= (31 downto 16 => RRdst(15)) & RRdst;
        ELSE
            first_mux <= PCregOutput;
        end if;

        --here should be the code of secondmux
        IF (alu_ex = '1') THEN
            second_mux <= alu_ex_address;
        ELSE
            second_mux <= first_mux;
        end if; 

        IF (POP = '1')AND ( FnJMP = '1') THEN
            third_mux <= XofSP;
        ELSE
            third_mux <= second_mux;
        end if;

        if (third_mux /= PCregOutput) then branchTaken <= '1'; end if ;
    end process;
    
    nextPC <= third_mux;
    pc_changed <= branchTaken;

END ARCHITECTURE;
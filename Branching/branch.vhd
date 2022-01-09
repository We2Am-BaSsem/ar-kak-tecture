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
    opCode                 : IN STD_LOGIC_VECTOR(4 DOWNTO 0):= (OTHERS => '0');

    alu_ex, POP, FnJMP,clk                : IN STD_LOGIC:= '0';

    nextPC                            : OUT STD_LOGIC_VECTOR(31 DOWNTO 0):= (OTHERS => '0');
    pc_changed                        : OUT STD_LOGIC:= '0' --input to mux at PC
    );
END entity branching;

ARCHITECTURE branching_architecture OF branching IS

SIGNAL branchTaken                      : STD_LOGIC:= '0';
SIGNAL pc_changed_temp                  : STD_LOGIC:= '0';
SIGNAL first_mux, second_mux, third_mux : STD_LOGIC_VECTOR(31 DOWNTO 0):= (OTHERS => '0');

BEGIN
    process(opCode, RRdst,clk,zeroflag,negativeflag,POP,FnJMP,alu_ex,branchTaken,clk)
    --process(opCode,zeroflag,negativeflag,carryflag, RRdst, PCregOutput)
    begin
        --if(rising_edge(clk)) then
      
        IF (opCode = "11000") AND (zeroflag = '1') THEN
            branchTaken <= '1';
        ELSIF (opCode = "11001") AND (negativeflag = '1') THEN
            branchTaken <= '1';
        ELSIF (opCode = "11010") AND (carryflag = '1') THEN
            branchTaken <= '1';
        ELSIF (opCode = "11011") THEN
            branchTaken <= '1';
        ELSE
            branchTaken <= '0';
        end if;

        -- if (opCode(4 downto 3)= "11")then 

            if (POP = '1')AND ( FnJMP = '1') then 
                nextPC<= XofSP;
                pc_changed<='1';
            elsif (alu_ex='1')then
                nextPC<=alu_ex_address;
                pc_changed<='1';
            elsif (branchTaken='1') then
                nextPC<="0000000000000000" & RRdst;
                pc_changed<='1';
            else 
                nextPC<=PCregOutput;
                pc_changed<='0';
            end if;




        -- else  
        -- pc_changed_temp<='0';
        -- nextPC<=PCregOutput;
        -- end if;


        --    end if;
        end process;
        --pc_changed<=pc_changed_temp;
 

END ARCHITECTURE;
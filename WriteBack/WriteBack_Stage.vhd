LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY WriteBack_Stage IS -- single bit adder
    PORT (
        MemtoReg, clk, InSignal : IN STD_LOGIC := '0';
        PopD, ALUout, Inport : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        WBD : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
END WriteBack_Stage;

ARCHITECTURE WriteBack_Stage OF WriteBack_Stage IS
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF falling_edge(clk) THEN
            IF (MemtoReg = '0') THEN
                WBD <= ALUout;
            ELSE
                WBD <= PopD;
            END IF;
        END IF;
    END PROCESS;
END WriteBack_Stage;
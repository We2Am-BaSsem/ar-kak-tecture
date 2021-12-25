LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY WriteBack_Stage IS -- single bit adder
    PORT (
        MemtoReg, clk : IN STD_LOGIC := '0';
        PopD, ALUout : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        WBD : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
END WriteBack_Stage;

ARCHITECTURE WriteBack OF WriteBack_Stage IS
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF (MemtoReg = '0') THEN
                WBD <= ALUout;
            ELSE
                WBD <= PopD;
            END IF;
        END IF;
        -- IF falling_edge(clk) THEN

        -- END IF;
    END PROCESS;
END WriteBack;
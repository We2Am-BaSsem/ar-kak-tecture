LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


ENTITY ex_mem_buffer IS
    GENERIC (n : INTEGER := 32);
    PORT (
        D : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
        Q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
        clk, rst, en : IN STD_LOGIC := '0'
    );
    --memtoreg, memwrite,memread,pop,push,fnjump, ALUout, DataToStore(D1), PC
END ENTITY;

ARCHITECTURE nbits_register OF my_register IS
BEGIN
    PROCESS (clk, rst, en)
    BEGIN
        IF en = '1' THEN
            IF rst = '1' THEN
                Q <= (OTHERS => '0');
            ELSIF rising_edge(clk) THEN
                Q <= D;
            END IF;
        END IF;
    END PROCESS;
END nbits_register;
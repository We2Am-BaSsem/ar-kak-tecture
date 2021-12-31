LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY ex_mem_buffer IS
    PORT (
        D : IN STD_LOGIC_VECTOR(128 DOWNTO 0) := (OTHERS => '0');
        Q : OUT STD_LOGIC_VECTOR(128 DOWNTO 0) := (OTHERS => '0');
        clk, rst, en : IN STD_LOGIC := '0'
    );
    --  memtoreg(1bit), memwrite(1bit),memread(1bit),pop(1bit),push(1bit),fnjump(1bit), => 6 bits
    --  ALUout(16bit), DataToStore(D1)(16bit), PC(32bit) => 64bits
    --  Used 70bits
END ENTITY;

ARCHITECTURE nbits_register OF my_register IS
BEGIN
    PROCESS (clk, rst, en)
    BEGIN
        IF en = '1' THEN
            IF rst = '1' THEN
                Q <= (OTHERS => '0');
            ELSIF falling_edge(clk) THEN
                Q <= D;
            END IF;
        END IF;
    END PROCESS;
END nbits_register;
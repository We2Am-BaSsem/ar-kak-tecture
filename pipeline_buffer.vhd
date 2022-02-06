LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY pipeline_buffer IS
    GENERIC (n : INTEGER := 128);
    PORT (
        D : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
        Q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
        clk, rst, en : IN STD_LOGIC := '0'
    );
    --  Logic Says:  We Write Data In Least Significant To Read It From Least Significant
    -------------------------------------------------------------------------------------------
    -- dec_ex_buffer:
    -- memtoreg(1bit), memwrite(1bit),memread(1bit),pop(1bit),push(1bit),fnjump(1bit), opCode(5bits) => 11 bits
    -- Instruction[26:24](3bit) , Instruction[23:21](3bit), Instruction[20:18](3bit) => 9bits 
    -- Data(D1)(16bit), Data(D2)(16bit), Imm(16) => 64bits
    -- PC(32bit) => 64bits
    -- Used 74-bits
    -------------------------------------------------------------------------------------------
    -- ex_mem_buffer:
    --  memtoreg(1bit), memwrite(1bit),memread(1bit),pop(1bit),push(1bit),fnjump(1bit) => 6 bits
    --  ALUout(16bit), DataToStore(D1)(16bit), PC(32bit) => 64bits
    --  Used 70-bits
    -------------------------------------------------------------------------------------------
    -- mem_wb_buffer:
    --  memtoreg(1bit) => 1 bit
    --  ALUout(16bit), dataout(16bit) => 32bits
    --  Used 33-bits
    -------------------------------------------------------------------------------------------

END ENTITY;

ARCHITECTURE pipeline_buffer OF pipeline_buffer IS
BEGIN
    PROCESS (clk, rst, en)
    BEGIN
        IF en = '1' THEN
            IF rst = '1' AND rising_edge(clk) THEN
                Q <= (OTHERS => '0');
            ELSIF rising_edge(clk) THEN
                Q <= D;
            END IF;
        END IF;
    END PROCESS;
END pipeline_buffer;
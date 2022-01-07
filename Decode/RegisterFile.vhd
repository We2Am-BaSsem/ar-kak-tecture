LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RegisterFile IS
    PORT (
        --each input is a slice of the opcode coming from the fetch stage
        readAddr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- instruction (7 downto 5)
        readAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- instruction (4 downto 2)
        writeAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- insturction (10 downto 8)
        writeData : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --make sure is it 16 bits or 32 bits?
        regWrite : IN STD_LOGIC; --from control unit
        readData1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- output to execute
        readData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- output to execute
    );
END ENTITY RegisterFile;

ARCHITECTURE Behavioral OF RegisterFile IS
    TYPE reg_file_type IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL array_reg : reg_file_type := (x"0000",
    x"0000",
    x"0000",
    x"0000",
    x"0000",
    x"0000",
    x"0000",
    x"0000"
    ); --initiaizing registers
BEGIN
    PROCESS (regWrite, writeData, writeAddr) --writes data on signal regWrite
    BEGIN
        IF (regWrite = '1') THEN
            array_reg(to_integer(unsigned(writeAddr))) <= writeData;
        END IF;
    END PROCESS;

    -- array_reg(to_integer(unsigned(writeAddr))) <= writeData WHEN regWrite = '1';

    --reading is done regardless of anything
    readData1 <= array_reg(to_integer(unsigned(readAddr1)));
    readData2 <= array_reg(to_integer(unsigned(readAddr2)));

END ARCHITECTURE Behavioral;
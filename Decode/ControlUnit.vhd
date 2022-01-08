LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ControlUnit IS
    PORT (
        instruction : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- slice [15,11] of the total opcode
        aluEx,
        memEx : IN STD_LOGIC;
        memRead,
        memToReg,
        memWrite,
        regWrite,
        pop,
        push,
        fnJmp,
        flushDecode, flushExecute : OUT STD_LOGIC := '0'; --?
        outSignal : OUT STD_LOGIC := '0';
        inSignal : OUT STD_LOGIC := '0'
    );
END ENTITY ControlUnit;

ARCHITECTURE dataflow OF ControlUnit IS
    SIGNAL out_vector : STD_LOGIC_VECTOR(6 DOWNTO 0); --will work on output signals first without exception
BEGIN
    PROCESS (instruction)
    BEGIN
        -- memRead<='0';
        -- memToReg<='0';
        -- memWrite<='0';
        -- regWrite<='0';
        -- pop<='0';     
        -- fnJmp<='0';   
        -- flushDecode<='0';
        -- flushExecute<='0'; 
        -- for some reason, if these are uncommented, 1 are output as X, will change to with Select 

        IF (instruction = "00000"
            OR instruction = "00001"
            OR instruction = "00010"
            OR instruction = "00101"
            OR instruction = "10000"
            OR instruction = "11000"
            OR instruction = "11001"
            OR instruction = "11010"
            OR instruction = "11011") THEN
            out_vector <= "0000000";
        ELSIF (instruction = "00011"
            OR instruction = "00100"
            OR instruction = "00110"
            OR instruction = "01000"
            OR instruction = "01001"
            OR instruction = "01010"
            OR instruction = "01011"
            OR instruction = "01100"
            OR instruction = "10010") THEN
            out_vector <= "0000100";
        ELSIF (instruction = "10001") THEN
            out_vector <= "0000110";
        ELSIF (instruction = "10011") THEN
            out_vector <= "0110100";
        ELSIF (instruction = "10100") THEN
            out_vector <= "0001000";
        ELSIF (instruction = "11100") THEN
            out_vector <= "0000001";
        ELSIF (instruction = "11101"
            OR instruction = "11111") THEN
            out_vector <= "0000011";
        ELSE
            out_vector <= "0100001";
        END IF;

        IF (instruction = "10011" OR instruction = "11100" OR instruction = "11110") THEN
            out_vector(6) <= '1';
            out_vector(4) <= '0';
            out_vector(2) <= '0';
        ELSE
            out_vector(6) <= '0';
        END IF;

        IF (instruction = "10100" OR instruction = "11101" OR instruction = "11111") THEN
            out_vector(1) <= '1';
            out_vector(4) <= '1';
            out_vector(2) <= '1';
        ELSE
            out_vector(1) <= '0';
        END IF;

        IF (instruction = "10001") THEN
            out_vector(3) <= '1';
        ELSIF (instruction = "10000") then 
            out_vector(5) <= '1';
            out_vector(4) <= '1';
            out_vector(2) <= '1';
        END IF;
    END PROCESS;
    inSignal <= '1' WHEN instruction = "00110";
    outSignal <= '1' WHEN instruction = "00101";
    push <= out_vector(6);
    memRead <= out_vector(5);
    memToReg <= out_vector(4);
    memWrite <= out_vector(3);
    regWrite <= out_vector(2);
    pop <= out_vector(1);
    fnJmp <= out_vector(0);
END ARCHITECTURE dataflow;
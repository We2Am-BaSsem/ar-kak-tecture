LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY WriteBack_Stage IS -- single bit adder
    PORT (
        regWriteSignalInput : IN STD_LOGIC := '0';
        writeAddressInput : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        MemtoReg, clk, InSignal : IN STD_LOGIC := '0';
        PopD, ALUout, Inport : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        WBD : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        regWriteSignalOutput : OUT STD_LOGIC := '0';
        writeAddressOutput : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0')
    );
END WriteBack_Stage;

ARCHITECTURE WriteBack_Stage OF WriteBack_Stage IS
BEGIN
    PROCESS (clk) IS
    BEGIN
        IF falling_edge(clk) THEN
            IF (MemtoReg = '0') THEN
                WBD <= ALUout;
                regWriteSignalOutput <= regWriteSignalInput;
                writeAddressOutput <= writeAddressInput;
            ELSE
                WBD <= PopD;
                regWriteSignalOutput <= regWriteSignalInput;
                writeAddressOutput <= writeAddressInput;
            END IF;
        END IF;
    END PROCESS;
END WriteBack_Stage;
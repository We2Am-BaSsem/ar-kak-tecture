LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY ALUControl IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        ALUSelectors : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY ALUControl;

ARCHITECTURE ALUControl OF ALUControl IS
BEGIN

    ALUSelectors(1 DOWNTO 0) <= b"11" WHEN opCode(2 DOWNTO 0) = b"010"
                            ELSE b"01" WHEN opCode(1 DOWNTO 0) = b"11" AND opCode(3) = '1'
                            ELSE b"10" WHEN opCode(1 DOWNTO 0) = b"11" AND opCode(3) = '0'
                            ELSE b"00";
    ALUSelectors(3) <= NOT opCode(3);
    ALUSelectors(6) <= opCode(3);
    ALUSelectors(4) <= opCode(4) AND opCode(0);
    ALUSelectors(2) <= opCode(3) AND opCode(0);
    ALUSelectors(5) <= opCode(4) OR (opCode(2) AND opCode(3));

END ALUControl;
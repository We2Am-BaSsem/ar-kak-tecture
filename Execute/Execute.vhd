LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALUControl IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        ALUSelectors : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY ALUControl;

ARCHITECTURE ALUControl OF ALUControl IS
BEGIN

    ALUSelectors(1 DOWNTO 0) <= b"11" WHEN opCode(2 DOWNTO 0) = b"010"
                            ELSE b"01" WHEN opCode(1 DOWNTO 0) = b"11" AND opCode(3) = '0'
                            ELSE b"10" WHEN opCode(1 DOWNTO 0) = b"11" 
                            ELSE b"00";
    ALUSelectors(3) <= NOT opCode(3);
    ALUSelectors(6) <= opCode(3);
    ALUSelectors(4) <= opCode(4) AND opCode(0);
    ALUSelectors(2) <= opCode(3) AND opCode(0);
    ALUSelectors(5) <= opCode(4) OR (opCode(2) AND opCode(3));

END ALUControl;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY ALUCompute IS
    PORT (
        ALUSelectors : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        d1, d2, imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALUOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
END ENTITY ALUCompute;

ARCHITECTURE ALUCompute OF ALUCompute IS
    SIGNAL tobeadded1: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL tobeadded2: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL tobeadded1_17: STD_LOGIC_VECTOR(16 DOWNTO 0);
    SIGNAL tobeadded2_17: STD_LOGIC_VECTOR(16 DOWNTO 0);
    SIGNAL s00_17: STD_LOGIC_VECTOR(16 DOWNTO 0);
    SIGNAL s11: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL s10: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL s01: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL s00: STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    tobeadded1 <= d1 WHEN ALUSelectors(4) = '0' ELSE d2;
    tobeadded2 <= x"0001" WHEN ALUSelectors(6 DOWNTO 5) = b"00" 
                ELSE d2 WHEN ALUSelectors(6 DOWNTO 5) = b"10"
                ELSE imm;
    tobeadded1_17 <= b"0" & tobeadded1;
    tobeadded2_17 <= b"0" & tobeadded2;
    s00_17 <= tobeadded1_17 + tobeadded2_17 WHEN ALUSelectors(2) = '1'
                ELSE tobeadded1_17 - tobeadded2_17;	
    cout <= s00_17(16);
    s00 <= s00_17(15 DOWNTO 0);
    s10 <= D1 AND D2;
    s01 <= NOT D1;
    s11 <= d1 WHEN ALUSelectors(3) = '0' ELSE imm;
    WITH ALUSelectors(1 DOWNTO 0) SELECT
    ALUOut <=
        s00 WHEN b"00",
        s10 WHEN b"10",
        s01 WHEN b"01",
        s11 WHEN b"11",
        x"0000" WHEN others; 
END ALUCompute;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALUToFlags IS
    PORT (
        oldN, oldZ : IN STD_LOGIC;
        ALUSelectors : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUOut: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        newN, newZ : OUT STD_LOGIC
    );
END ENTITY ALUToFlags;

ARCHITECTURE ALUToFlags OF ALUToFlags IS
BEGIN
    newN <= ALUOut(15) WHEN ALUSelectors = b"11" ELSE oldN;
    newZ <= '1' WHEN ALUOut = x"0000" AND ALUSelectors = b"11"
 	ELSE '0' WHEN ALUSelectors = b"11"
	ELSE oldZ;
END ALUToFlags;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALU IS
    PORT (
        oldN, oldZ : IN STD_LOGIC;
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        d1, d2, imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALUOut: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        newN, newZ : OUT STD_LOGIC;
        cout : OUT STD_LOGIC;
        ALUExceptionSignal : OUT STD_LOGIC
    );
END ENTITY ALU;

ARCHITECTURE ALU OF ALU IS

SIGNAL ALUSelectors: STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ALUOutSig: STD_LOGIC_VECTOR(15 DOWNTO 0);

COMPONENT ALUControl IS
PORT (
    opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    ALUSelectors : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
);
END COMPONENT;

COMPONENT ALUCompute IS
PORT (
    ALUSelectors : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    d1, d2, imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    ALUOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    cout : OUT STD_LOGIC
);
END COMPONENT;

COMPONENT ALUToFlags IS
PORT (
    oldN, oldZ : IN STD_LOGIC;
    ALUSelectors : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    ALUOut: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    newN, newZ : OUT STD_LOGIC
);
END COMPONENT;

BEGIN
    Control: ALUControl PORT MAP(opCode,ALUSelectors);
    Compute: ALUCompute PORT MAP(ALUSelectors, d1, d2, imm, ALUOutSig, cout);
    ToFlags: ALUToFlags PORT MAP(oldN, oldZ, ALUSelectors(1 DOWNTO 0), ALUOutSig, newN, newZ);
    
    ALUOut <= ALUOutSig;

    ALUExceptionSignal <= '1' WHEN ALUOutSig >= 2 ** 20 AND opCode(4 DOWNTO 1) = b"1000" ELSE '0';
END ALU;

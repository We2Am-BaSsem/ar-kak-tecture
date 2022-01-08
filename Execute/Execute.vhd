LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALUControl IS
    PORT (
        IgnoreSignal : OUT STD_LOGIC := '0';
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        ALUSelectors : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
        EnableOutPort : OUT STD_LOGIC := '0'
    );
END ENTITY ALUControl;

ARCHITECTURE ALUControl OF ALUControl IS
BEGIN

    IgnoreSignal <= '1' WHEN opCode = b"00000" OR opCode = b"00010" OR opCode = b"00101" OR opCode = b"00110" --todo: remove last check 00110
        ELSE
        '0';

    EnableOutPort <= '1' WHEN opCode = b"00101" ELSE
        '0';

    ALUSelectors(1 DOWNTO 0) <= b"11" WHEN opCode(2 DOWNTO 0) = b"010"
ELSE
    b"01" WHEN opCode(1 DOWNTO 0) = b"11" AND opCode(3) = '0'
ELSE
    b"10" WHEN opCode(1 DOWNTO 0) = b"11"
ELSE
    b"00";

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
        ALUSelectors : IN STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
        d1, d2, imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        ALUOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        cout : OUT STD_LOGIC := '0'
    );
END ENTITY ALUCompute;

ARCHITECTURE ALUCompute OF ALUCompute IS
    SIGNAL tobeadded1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tobeadded2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tobeadded1_17 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tobeadded2_17 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s00_17 : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s11 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s10 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s01 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s00 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
    tobeadded1 <= d1 WHEN ALUSelectors(4) = '0' ELSE
        d2;
    tobeadded2 <= x"0001" WHEN ALUSelectors(6 DOWNTO 5) = b"00"
        ELSE
        d2 WHEN ALUSelectors(6 DOWNTO 5) = b"10"
        ELSE
        imm;
    tobeadded1_17 <= b"0" & tobeadded1;
    tobeadded2_17 <= b"0" & tobeadded2;
    s00_17 <= tobeadded1_17 + tobeadded2_17 WHEN ALUSelectors(2) = '0'
        ELSE
        tobeadded1_17 - tobeadded2_17;
    cout <= s00_17(16);
    s00 <= s00_17(15 DOWNTO 0);
    s10 <= D1 AND D2;
    s01 <= NOT D1;
    s11 <= d1 WHEN ALUSelectors(3) = '0' ELSE
        imm;
    WITH ALUSelectors(1 DOWNTO 0) SELECT
    ALUOut <=
        s00 WHEN b"00",
        s10 WHEN b"10",
        s01 WHEN b"01",
        s11 WHEN b"11",
        x"0000" WHEN OTHERS;
END ALUCompute;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALUToFlags IS
    PORT (
        ALUSelectors : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
        ALUOut : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        newN, newZ, en, enc : OUT STD_LOGIC := '0'
    );
END ENTITY ALUToFlags;

ARCHITECTURE ALUToFlags OF ALUToFlags IS
BEGIN
    newN <= ALUOut(15);
    newZ <= '1' WHEN ALUOut = x"0000" 
        ELSE '0';
    en <= '0' WHEN ALUSelectors = b"11" ELSE '1';
    enC <= '1' WHEN ALUSelectors = b"00" ELSE '0';
END ALUToFlags;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ALU IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        d1, d2, imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        ALUOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        newN, newZ, , en, enc : OUT STD_LOGIC := '0';
        cout : OUT STD_LOGIC := '0';
        ALUExceptionSignal : OUT STD_LOGIC := '0';
        EnableOutPort : OUT STD_LOGIC := '0'
    );
END ENTITY ALU;

ARCHITECTURE ALU OF ALU IS

    SIGNAL ALUSelectors : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ALUOutSig : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL IgnoreSignal_s : STD_LOGIC := '0';
    COMPONENT ALUControl IS
        PORT (
            IgnoreSignal : OUT STD_LOGIC := '0';
            opCode : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
            ALUSelectors : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
            EnableOutPort : OUT STD_LOGIC := '0'
        );
    END COMPONENT;

    COMPONENT ALUCompute IS
        PORT (
            ALUSelectors : IN STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
            d1, d2, imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
            ALUOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
            cout : OUT STD_LOGIC := '0'
        );
    END COMPONENT;

    COMPONENT ALUToFlags IS
        PORT (
            ALUOut : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
            newN, newZ : OUT STD_LOGIC := '0'
        );
    END COMPONENT;
BEGIN
    Control : ALUControl PORT MAP(IgnoreSignal_s, opCode, ALUSelectors, EnableOutPort);
    Compute : ALUCompute PORT MAP(ALUSelectors, d1, d2, imm, ALUOutSig, cout);
    ToFlags : ALUToFlags PORT MAP(ALUSelectors(1 DOWNTO 0), ALUOutSig, newN, newZ, en, enc);

    ALUOut <= ALUOutSig WHEN IgnoreSignal_s = '0'
        ELSE
        (OTHERS => '0');

    ALUExceptionSignal <= '1' WHEN ALUOutSig >= x"FF00" AND opCode(4 DOWNTO 1) = b"1000" ELSE
        '0';
END ALU;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DataForward IS
    PORT (
        Rsrc        : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        ReadData    : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        MemRdst     : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        MemData     : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        ExRdst      : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        ExData      : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        Data        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY DataForward;

ARCHITECTURE DataForward OF DataForward IS
BEGIN
    Data <= ExData WHEN ExRdst = Rsrc
      ELSE MemData WHEN MemRdst = Rsrc
      ELSE ReadData;
END DataForward;
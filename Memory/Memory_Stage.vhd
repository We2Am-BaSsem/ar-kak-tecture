
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY Memory_Stage IS
    PORT (
        clk : IN STD_LOGIC := '0';
        we, re, pushpsignal, popsignal, controlsignal : IN STD_LOGIC := '0';
        address : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        InvalidMemoryExceptionSignal, EmptyStackExceptionSignal : INOUT STD_LOGIC := '0';
        stackout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY Memory_Stage;

ARCHITECTURE Memory_Stage OF Memory_Stage IS
    COMPONENT my_register IS
        PORT (
            D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            clk, en : IN STD_LOGIC
        );
    END COMPONENT;
    COMPONENT Memory IS
        PORT (
            clk : IN STD_LOGIC;
            we, re, pushpsignal, popsignal, controlsignal : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SP : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            InvalidMemoryExceptionSignal, EmptyStackExceptionSignal : INOUT STD_LOGIC;
            stackout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL SP, newSP : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF");
    SIGNAL en : STD_LOGIC := '0';
BEGIN
    en <= pushpsignal OR popsignal;
    EmptyStackExceptionSignal <= '1' WHEN popsignal = '1' AND ((SP + 1 >= 2 ** 20) OR (controlsignal = '1' AND SP + 2 >= 2 ** 20))
        ELSE
        '0';
    newSP <= SP + 2 WHEN SP + 2 <= 2 ** 20 - 1 AND popsignal = '1' AND controlsignal = '1'
        ELSE
        SP + 1 WHEN SP + 1 <= 2 ** 20 - 1 AND popsignal = '1' AND controlsignal = '0'
        ELSE
        SP - 2 WHEN pushpsignal = '1' AND controlsignal = '1'
        ELSE
        SP - 1 WHEN pushpsignal = '1' AND controlsignal = '0';

    SP_Register : my_register PORT MAP(D => newSP, Q => SP, clk => clk, en => en);
    DataMemory : Memory PORT MAP(
        clk => clk,
        we => we, re => re, pushpsignal => pushpsignal, popsignal => popsignal, controlsignal => controlsignal,
        address => address, datain => datain, pc => pc, SP => newSP,
        InvalidMemoryExceptionSignal => InvalidMemoryExceptionSignal, EmptyStackExceptionSignal => EmptyStackExceptionSignal,
        stackout => stackout, dataout => dataout
    );
END Memory_Stage;
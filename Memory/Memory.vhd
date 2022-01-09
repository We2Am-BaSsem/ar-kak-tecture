LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY Memory IS
    PORT (
        clk : IN STD_LOGIC := '0';
        we, re, pushpsignal, popsignal, controlsignal : IN STD_LOGIC := '0';
        address : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        SP : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF");
        EmptyStackExceptionSignal : IN STD_LOGIC := '0';
        stackout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY Memory;

ARCHITECTURE Memory OF Memory IS
    TYPE ram_type IS ARRAY(0 TO 2 ** 20 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type := (OTHERS => (OTHERS => '0'));
BEGIN
    PROCESS (SP, popsignal, pushpsignal, controlsignal, we, address, re, datain) IS
        VARIABLE tempAddress : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"00000000");
    BEGIN
        IF EmptyStackExceptionSignal = '0' THEN
            IF popsignal = '1' THEN
                IF (controlsignal = '1') THEN
                    stackout <= ram(to_integer(unsigned((SP)))) & ram(to_integer(unsigned((SP - 1))));
                    -- SP <= SP + 2;
                ELSE
                    dataout <= ram(to_integer(unsigned((SP))));
                    -- SP <= SP + 1;
                END IF;
            ELSIF re = '1' THEN
                tempAddress := X"0000" & address;
                dataout <= ram(to_integer(unsigned((tempAddress))));
            END IF;
            IF (pushpsignal = '1') THEN
                IF (controlsignal = '1') THEN
                    ram(to_integer(unsigned((SP)))) <= pc(31 DOWNTO 16);
                    ram(to_integer(unsigned((SP - 1)))) <= pc(15 DOWNTO 0);
                    -- SP <= SP - 2;
                ELSE
                    ram(to_integer(unsigned((SP)))) <= datain;
                    -- SP <= SP - 1;s
                END IF;
            ELSIF we = '1' THEN
                tempAddress := X"0000" & address;
                ram(to_integer(unsigned((tempAddress)))) <= datain;
            END IF;
        END IF;
    END PROCESS;
END Memory;
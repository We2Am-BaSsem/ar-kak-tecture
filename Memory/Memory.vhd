LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY Memory IS
    PORT (
        clk : IN STD_LOGIC := '0';
        we, re, pushpsignal, popsignal, controlsignal : IN STD_LOGIC := '0';
        address : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        SP : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF");
        InvalidMemoryExceptionSignal, EmptyStackExceptionSignal : INOUT STD_LOGIC := '0';
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY Memory;

ARCHITECTURE Memory OF Memory IS
    TYPE ram_type IS ARRAY(0 TO 2 ** 20 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type := (OTHERS => (OTHERS => '0'));

BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF (address(31 DOWNTO 16) /= STD_LOGIC_VECTOR'(x"0000")) THEN
                InvalidMemoryExceptionSignal <= '1';
                -- REPORT "Invalid Address" SEVERITY warning;
            ELSIF popsignal = '1' AND ((SP + 1 >= 2 ** 20) OR (controlsignal = '1' AND SP + 2 >= 2 ** 20)) THEN
                EmptyStackExceptionSignal <= '1';
                -- REPORT "Pop Empty Stack" SEVERITY warning;
            ELSE
                IF popsignal = '1' THEN
                    dataout <= ram(to_integer(unsigned((SP))));
                    IF (controlsignal = '1') THEN
                        SP <= SP + 2;
                    ELSE
                        SP <= SP + 1;
                    END IF;
                ELSIF re = '1' THEN
                    dataout <= ram(to_integer(unsigned((address))));
                END IF;
            END IF;
        END IF;
        IF falling_edge(clk) THEN
            IF (address(31 DOWNTO 16) /= STD_LOGIC_VECTOR'(x"0000")) THEN
                InvalidMemoryExceptionSignal <= '0';
            ELSIF (popsignal = '1' AND ((SP + 1 >= 2 ** 20) OR (controlsignal = '1' AND SP + 2 >= 2 ** 20))) THEN
                EmptyStackExceptionSignal <= '0';
            ELSE
                IF (pushpsignal = '1') THEN
                    ram(to_integer(unsigned((SP)))) <= datain;
                    IF (controlsignal = '1') THEN
                        SP <= SP - 2;
                    ELSE
                        SP <= SP - 1;
                    END IF;
                ELSIF we = '1' THEN
                    ram(to_integer(unsigned((address)))) <= datain;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Memory;
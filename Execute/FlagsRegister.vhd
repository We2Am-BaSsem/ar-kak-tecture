LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

--flags(2): carry flag
--flags(1): negative flag
--flags(0): zero flag
ENTITY FlagsRegister IS
    PORT (
        clk : IN STD_LOGIC := '0';
        rst : IN STD_LOGIC := '0';
        enNZ : IN STD_LOGIC := '0';
        enC : IN STD_LOGIC := '0';
        flags_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        flags_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY FlagsRegister;

ARCHITECTURE rtl OF FlagsRegister IS
BEGIN
    PROCESS (rst, flags_in, enNZ, enC)
    BEGIN
        IF rst = '1' THEN
            flags_out <= (OTHERS => '0');
        ELSE
            IF enNZ = '1' THEN
                flags_out(1 DOWNTO 0) <= flags_in(1 DOWNTO 0);
            END IF;
            IF enC = '1' THEN
                flags_out(2) <= flags_in(2);
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;
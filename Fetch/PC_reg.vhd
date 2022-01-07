LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned;

ENTITY PC_register IS
    GENERIC (n : INTEGER := 32);
    PORT (
        clk : IN STD_LOGIC := '0';
        Rst : IN STD_LOGIC := '0';
        beginning_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
        q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0')
    );
END PC_register;

ARCHITECTURE arch_PC_register OF PC_register
    IS
BEGIN
    PROCESS (clk, Rst)
    BEGIN
        IF Rst = '1' THEN --instuction out will be the address of the beginning of the instuctions
            q <= beginning_address;
        ELSIF rising_edge(clk) THEN
            q <= d;--std_logic_vector(unsigned(d)+unsigned(value_to_add));
        END IF;
    END PROCESS;
END arch_PC_register;
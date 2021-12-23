

Library ieee;
use ieee.std_logic_1164.all;
use  ieee.std_logic_unsigned;

ENTITY PC_register IS
    GENERIC ( n : integer := 32);
    PORT
    (
        clk,Rst : IN std_logic;
        d : IN std_logic_vector(n-1 DOWNTO 0);
        -- is_jmp : IN std_logic; -- to be revisited
        -- jmp_address:IN std_logic_vector(n-1 downto 0); --to be revisited
        q : OUT std_logic_vector(n-1 DOWNTO 0)
    );
END PC_register;

ARCHITECTURE arch_PC_register OF PC_register
    IS
        BEGIN
        PROCESS (clk,Rst)
            BEGIN
                IF Rst = '1' THEN
                    q <= (OTHERS=>'0');
                ELSIF rising_edge(clk)  THEN 
                    q <= d;--std_logic_vector(unsigned(d)+unsigned(value_to_add));
                END IF;
        END PROCESS;
    END arch_PC_register;



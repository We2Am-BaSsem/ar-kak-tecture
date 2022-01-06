

Library ieee;
use ieee.std_logic_1164.all;
use  ieee.std_logic_unsigned;

ENTITY PC_register IS
    GENERIC ( n : integer := 32);
    PORT
    (
        clk : IN std_logic:= '0';
        Rst : IN std_logic := '0';
        beginning_address: in std_logic_vector(31 downto 0);
        d : IN std_logic_vector(n-1 DOWNTO 0) := (OTHERS => '0');
        q : OUT std_logic_vector(n-1 DOWNTO 0) := (OTHERS => '0')
    );
END PC_register;

ARCHITECTURE arch_PC_register OF PC_register
    IS
        BEGIN
        PROCESS (clk,Rst)
            BEGIN
                IF Rst = '1' THEN --instuction out will be the address of the beginning of the instuctions
                    q <= beginning_address;
                ELSIF rising_edge(clk)  THEN 
                    q <= d;--std_logic_vector(unsigned(d)+unsigned(value_to_add));
                END IF;
        END PROCESS;
    END arch_PC_register;



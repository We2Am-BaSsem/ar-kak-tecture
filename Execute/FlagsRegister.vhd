library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--flags(2): carry flag
--flags(1): negative flag
--flags(0): zero flag
entity FlagsRegister is
    port (
        clk : IN STD_LOGIC := '0';
        rst : IN STD_LOGIC := '0';
	    enNZ : in std_logic := '0';
        enC : in std_logic := '0';
        flags_in : in std_logic_vector(2 downto 0) := (OTHERS => '0');   
        flags_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0')
    );
end entity FlagsRegister;

architecture rtl of FlagsRegister is  
begin
    PROCESS (rst, flags_in,enNZ,enC)
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
        END if;
    END PROCESS;
end architecture rtl;
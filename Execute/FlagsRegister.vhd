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
	en : in std_logic := '0';
        flags_in : in std_logic_vector(2 downto 0) := (OTHERS => '0');   
        flags_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0')
    );
end entity FlagsRegister;

architecture rtl of FlagsRegister is  
begin
    PROCESS (rst, flags_in,en)
    BEGIN
        IF rst = '1' THEN
            flags_out <= (OTHERS => '0');
        ELSE
            IF en = '1' THEN
                flags_out <= flags_in;
            END IF;
        END if;
    END PROCESS;
end architecture rtl;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY PCNadder IS
    GENERIC (n : INTEGER := 32);
    PORT (
        a : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
        value_to_add_bit : IN STD_LOGIC := '0'; --get from fetchunit
        cin : IN STD_LOGIC := '0';
        s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0'); -- connect to getchunit
        cout : OUT STD_LOGIC := '0'
    );
END PCNadder;

ARCHITECTURE PCarch_Nadder OF PCNadder IS
    COMPONENT my_adder IS
        PORT (
            a, b, cin : IN STD_LOGIC;
            s, cout : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL temp : STD_LOGIC_VECTOR(n DOWNTO 0);
    SIGNAL b : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
BEGIN
    b <= x"00000002" WHEN value_to_add_bit = '1' ELSE
        x"00000001";
    temp(0) <= cin;
    loop1 : FOR i IN 0 TO n - 1 GENERATE
        fx : my_adder PORT MAP(a(i), b(i), temp(i), s(i), temp(i + 1));
    END GENERATE;
    Cout <= temp(n);
END PCarch_Nadder;
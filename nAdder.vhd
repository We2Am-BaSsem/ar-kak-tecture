LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY Nadder IS
    GENERIC (n : INTEGER := 16);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        cin : IN STD_LOGIC;
        s : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
END Nadder;

ARCHITECTURE arch_Nadder OF Nadder IS
    COMPONENT my_adder IS
        PORT (
            a, b, cin : IN STD_LOGIC;
            s, cout : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL temp : STD_LOGIC_VECTOR(n DOWNTO 0);
BEGIN
    temp(0) <= cin;
    loop1 : FOR i IN 0 TO n - 1 GENERATE
        fx : my_adder PORT MAP(a(i), b(i), temp(i), s(i), temp(i + 1));
    END GENERATE;
    Cout <= temp(n);
END arch_Nadder;

Library ieee;
use ieee.std_logic_1164.all;


ENTITY PCNadder IS
    GENERIC (n : integer := 32);
PORT 
(
    a                    : IN std_logic_vector(n-1 DOWNTO 0) ;
    value_to_add_bit     : IN std_logic;  --get from fetchunit
    cin                  : IN std_logic;
    s                    : OUT std_logic_vector(n-1 DOWNTO 0); -- connect to getchunit
    cout                 : OUT std_logic
);
END PCNadder;





ARCHITECTURE PCarch_Nadder OF PCNadder IS
COMPONENT my_adder IS
PORT( a,b,cin : IN std_logic; s,cout : OUT std_logic);
END COMPONENT;
SIGNAL temp : std_logic_vector(n DOWNTO 0);
SIGNAL b : std_logic_vector (n-1 DOWNTO 0);
BEGIN
b <= x"00000002" when value_to_add_bit = '1' else x"00000001";
temp(0) <= cin;
loop1: FOR i IN 0 TO n-1 GENERATE
fx: my_adder PORT MAP(a(i),b(i),temp(i),s(i),temp(i+1));
END GENERATE;
Cout <= temp(n);
END PCarch_Nadder;



LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY my_adder IS -- single bit adder
    PORT (
        a, b, cin : IN STD_LOGIC;
        s, cout : OUT STD_LOGIC);
END my_adder;
ARCHITECTURE a_my_adder OF my_adder IS
BEGIN
    s <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND (a XOR b));
END a_my_adder;
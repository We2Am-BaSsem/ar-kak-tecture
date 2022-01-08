LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY my_register IS
	PORT (
		D : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
		Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF");
		clk, en : IN STD_LOGIC := '0'
	);
END ENTITY;

ARCHITECTURE nbits_register OF my_register IS
BEGIN
	PROCESS (clk, en)
	BEGIN
		IF en = '1'AND rising_edge(clk) THEN
			Q <= D;
		END IF;
	END PROCESS;
END nbits_register;
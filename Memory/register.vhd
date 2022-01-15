LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY my_register IS
	PORT (
		D : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
		Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF");
		EmptyStackExceptionSignal : OUT STD_LOGIC := '0';
		clk, en : IN STD_LOGIC := '0'
	);
END ENTITY;

ARCHITECTURE nbits_register OF my_register IS
BEGIN
	PROCESS (clk, en, D)
	BEGIN
		IF en = '1'AND falling_edge(clk) THEN
			IF (D > x"000FFFFF") THEN
				EmptyStackExceptionSignal <= '1';
			ELSE
				Q <= D;
			END IF;
		END IF;
		IF D <= x"000FFFFF" AND falling_edge(clk) THEN
			EmptyStackExceptionSignal <= '0';
		END IF;
	END PROCESS;
END nbits_register;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY InstructionMemory IS
	
	PORT(
		--connect it to tri-state buffer to put its data on bus
		clk : IN std_logic;
		--we  : IN std_logic; --write enable, memory is over-written by data from bus
		address : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0) 
		);
END ENTITY InstructionMemory;

ARCHITECTURE arch_InstructionMemory OF InstructionMemory IS

	TYPE InstructionMemory_type IS ARRAY(0 TO 2**24-1) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL InstructionMemory : InstructionMemory_type := (OTHERS => (OTHERS => '0'));

	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					
					dataout <= InstructionMemory(to_integer(unsigned(address))) & InstructionMemory(to_integer(unsigned(address))+1);
				END IF;
		END PROCESS;
END arch_InstructionMemory;




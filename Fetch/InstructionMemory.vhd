LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY InstructionMemory IS
	generic (n :integer :=32);
	PORT(
		--connect it to tri-state buffer to put its data on bus
		clk : IN std_logic;
		--we  : IN std_logic; --write enable, memory is over-written by data from bus
		address : IN  std_logic_vector(n-1 DOWNTO 0);
		--datain  : IN  std_logic_vector(n-1 DOWNTO 0);
		dataout : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY InstructionMemory;

ARCHITECTURE arch_InstructionMemory OF InstructionMemory IS

	TYPE InstructionMemory_type IS ARRAY(0 TO 2**6-1) OF std_logic_vector(n-1 DOWNTO 0);
	SIGNAL InstructionMemory : InstructionMemory_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					--IF we = '1' THEN
					--	InstructionMemory(to_integer(unsigned(address))) <= datain;
					--END IF;
					dataout <= InstructionMemory(to_integer(unsigned(address)));
				END IF;
		END PROCESS;
END arch_InstructionMemory;



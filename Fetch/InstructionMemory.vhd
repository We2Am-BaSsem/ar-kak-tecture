LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY InstructionMemory IS

	PORT (
		--connect it to tri-state buffer to put its data on bus
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		--we  : IN std_logic; --write enable, memory is over-written by data from bus
		address : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
		beginning_address_of_operations : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
		ALU_EX_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
		Stack_Exception_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

		int0_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
		int1_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

		dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
	);
END ENTITY InstructionMemory;

ARCHITECTURE arch_InstructionMemory OF InstructionMemory IS

	TYPE InstructionMemory_type IS ARRAY(0 TO 2 ** 20 - 1) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL InstructionMemory : InstructionMemory_type := (OTHERS => (OTHERS => '0'));
BEGIN
	PROCESS (clk, rst) IS
	BEGIN
		beginning_address_of_operations <= InstructionMemory(0) & InstructionMemory(1);
		Stack_Exception_address <= InstructionMemory(2) & InstructionMemory(3);
		ALU_EX_address <= InstructionMemory(4) & InstructionMemory(5);
		int0_address <= InstructionMemory(6) & InstructionMemory(7);
		int1_address <= InstructionMemory(8) & InstructionMemory(9);

		-- 2 , 3    ->  empty stack 
		-- 4, 5      -> ALU exception

		-- 6 ,7     ->  int 0
		-- 8,9      ->  int 1 

		IF rising_edge(clk) THEN

			dataout <= InstructionMemory(to_integer(unsigned(address))) & InstructionMemory(to_integer(unsigned(address)) + 1);
		END IF;
	END PROCESS;
END arch_InstructionMemory;
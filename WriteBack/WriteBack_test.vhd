LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std_unsigned.ALL;
ENTITY WriteBack_test IS
END WriteBack_test;

ARCHITECTURE testbench_WriteBack OF WriteBack_test IS
	SIGNAL testMemtoReg, testClk : STD_LOGIC;
	SIGNAL testPopD, testALUout, testWBD : STD_LOGIC_VECTOR(15 DOWNTO 0);
	CONSTANT clk_period : TIME := 100 ps;
BEGIN

	PROCESS
	BEGIN
		testClk <= '0';
		WAIT FOR clk_period/2;
		testClk <= '1';
		WAIT FOR clk_period/2;
	END PROCESS;

	PROCESS
	BEGIN

		testMemtoReg <= '0';
		testALUout <= STD_LOGIC_VECTOR'(x"FFFF");
		WAIT FOR clk_period;
		ASSERT(testWBD = x"FFFF") REPORT "Test Failure: Memory Was Written" SEVERITY ERROR;

		testPopD <= STD_LOGIC_VECTOR'(x"0001");
		testALUout <= STD_LOGIC_VECTOR'(x"FF0F");
		WAIT FOR clk_period;
		ASSERT(testWBD = x"FF0F") REPORT "Test Failure: Memory Was Written" SEVERITY ERROR;

		testMemtoReg <= '1';
		testPopD <= STD_LOGIC_VECTOR'(x"0011");
		testALUout <= STD_LOGIC_VECTOR'(x"F00F");
		WAIT FOR clk_period;
		ASSERT(testWBD = x"0011") REPORT "Test Failure: Memory Was Written" SEVERITY ERROR;

		WAIT;
	END PROCESS;

	uut : ENTITY work.WriteBack_Stage PORT MAP (
		MemtoReg => testMemtoReg, clk => testClk,
		PopD => testPopD, ALUout => testALUout,
		WBD => testWBD
		);

END testbench_WriteBack;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std_unsigned.ALL;
ENTITY Memory_test IS
END Memory_test;

ARCHITECTURE testbench_Memory OF Memory_test IS
	SIGNAL testDatain, testDataout : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL testAddress : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL testSP : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF");
	SIGNAL teststackoutput, testpc : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL testClk, testwe, testre, testException1, testException2, testpushpsignal, testpoppsignal, testcontrolsignal : STD_LOGIC := '0';
	CONSTANT clk_period : TIME := 100 ps;
	CONSTANT SPstart : STD_LOGIC_VECTOR(31 DOWNTO 0) := STD_LOGIC_VECTOR'(x"000FFFFF");
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
		-- Test That Memory is not Written When we = 0
		testwe <= '0';
		testDatain <= STD_LOGIC_VECTOR'(x"FFFF");
		testAddress <= STD_LOGIC_VECTOR'(x"0000");
		WAIT FOR clk_period;
		ASSERT(testDataout = x"0000") REPORT "Test Failure: Memory Was Written" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;

		-- Write In Memory
		testwe <= '1';
		testre <= '1';
		testDatain <= STD_LOGIC_VECTOR'(x"1111");
		testAddress <= STD_LOGIC_VECTOR'(x"0001");
		WAIT FOR clk_period;
		ASSERT(testDataout = x"1111") REPORT "Test Failure: Output Is Not Correct" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';

		-- Write In Memory Last Address In Memory
		-- testwe <= '1';
		-- testre <= '1';
		-- testDatain <= STD_LOGIC_VECTOR'(x"1111");
		-- testAddress <= STD_LOGIC_VECTOR'(x"FFFF");
		-- WAIT FOR clk_period;
		-- ASSERT(testException1 = '1') REPORT "Test Failure: Tried To Access Invalid Data" SEVERITY ERROR;
		-- testwe <= '0';
		-- testre <= '0';
		-- testAddress <= STD_LOGIC_VECTOR'(x"0000");

		-- Pop Empty Stack
		testpoppsignal <= '1';
		WAIT FOR clk_period;
		ASSERT(testException2 = '1') REPORT "Test Failure: Tried To Pop Empty Stack" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testSP = SPstart) REPORT "Test Failure: Tried To Pop Empty Stack" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpoppsignal <= '0';

		-- Push into The Stack
		testpushpsignal <= '1';
		testDatain <= STD_LOGIC_VECTOR'(x"FFFF");
		WAIT FOR clk_period;
		ASSERT(testSP = SPstart - 1) REPORT "Test Failure: Did Not Push Into The Stack" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpushpsignal <= '0';

		-- Push into The Stack
		testpushpsignal <= '1';
		testDatain <= STD_LOGIC_VECTOR'(x"FECF");
		WAIT FOR clk_period;
		ASSERT(testSP = SPstart - 2) REPORT "Test Failure: Did Not Push Into The Stack" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpushpsignal <= '0';

		-- RET
		testpoppsignal <= '1';
		testcontrolsignal <= '1';
		WAIT FOR clk_period;
		ASSERT(teststackoutput = x"FFFFFECF") REPORT "Test Failure: Failed To Pop 32 Bits Of Stack" SEVERITY ERROR;
		ASSERT(testSP = SPstart) REPORT "Test Failure: Stack Pointer Is Not Correct" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpoppsignal <= '0';
		testcontrolsignal <= '0';

		-- Push into The Stack
		testpushpsignal <= '1';
		testDatain <= STD_LOGIC_VECTOR'(x"0000");
		WAIT FOR clk_period;
		ASSERT(testSP = SPstart - 1) REPORT "Test Failure: Did Not Push Into The Stack" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpushpsignal <= '0';

		-- Push into The Stack
		testpushpsignal <= '1';
		testDatain <= STD_LOGIC_VECTOR'(x"0100");
		WAIT FOR clk_period;
		ASSERT(testSP = SPstart - 2) REPORT "Test Failure: Did Not Push Into The Stack" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpushpsignal <= '0';

		-- Push into The Stack
		testpushpsignal <= '1';
		testDatain <= STD_LOGIC_VECTOR'(x"010F");
		WAIT FOR clk_period;
		ASSERT(testSP = SPstart - 3) REPORT "Test Failure: Did Not Push Into The Stack" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpushpsignal <= '0';

		-- pop form The Stack
		testpoppsignal <= '1';
		WAIT FOR clk_period;
		ASSERT(testDataout = x"010F") REPORT "Test Failure: Output Is Not Correct" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testSP = SPstart - 2) REPORT "Test Failure: Tried To Pop Empty Stack" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpoppsignal <= '0';

		-- call
		testpushpsignal <= '1';
		testcontrolsignal <= '1';
		testpc <= x"FFFFFECF";
		WAIT FOR clk_period;
		ASSERT(testSP = SPstart - 4) REPORT "Test Failure: Stack Pointer Is Not Correct" SEVERITY ERROR;
		ASSERT(testException1 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		ASSERT(testException2 = '0') REPORT "Test Failure: Unexpected Exception Occured" SEVERITY ERROR;
		testwe <= '0';
		testre <= '0';
		testpushpsignal <= '0';
		testcontrolsignal <= '0';

		WAIT;
	END PROCESS;

	uut : ENTITY work.Memory PORT MAP (
		clk => testClk, we => testwe, re => testre, address => testAddress,
		datain => testDatain, dataout => testDataout,
		pushpsignal => testpushpsignal, popsignal => testpoppsignal, controlsignal => testcontrolsignal, SP => testSP,
		stackout => teststackoutput, pc => testpc,
		InvalidMemoryExceptionSignal => testException1, EmptyStackExceptionSignal => testException2
		);

END testbench_Memory;
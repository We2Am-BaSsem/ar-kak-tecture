LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std_unsigned.ALL;
ENTITY Processor_test IS
END Processor_test;

ARCHITECTURE testbench_Processor OF Processor_test IS
    SIGNAL testClk : STD_LOGIC;
    SIGNAL testrst : STD_LOGIC := '0';
    CONSTANT clk_period : TIME := 100 ps;
BEGIN

    PROCESS
    BEGIN
        testClk <= '0';
        WAIT FOR clk_period/2;
        testClk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;
    uut : ENTITY work.Processor PORT MAP (
        clk => testClk,
        rst => testrst
        );

END testbench_Processor;
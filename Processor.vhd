LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Processor IS
    GENERIC (n : INTEGER := 16);

    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC

    );
END ENTITY Processor;

ARCHITECTURE arKAKtectureProcessor OF Processor IS

    SIGNAL fetched_instruction : STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
    ------------------------------------------------------------------------
    SIGNAL memRead_s,
    memToReg_s,
    memWrite_s,
    regWrite_s,
    pop_s,
    fnJmp_s,
    flushDecode_s,
    flushExecute_s : STD_LOGIC; --outputs of control_unit 
    --todo: integrate with execution
    SIGNAL memEx_s : STD_LOGIC := '0';
    ---------------------------------------------------------------------------
    SIGNAL readData1_s,
    readData2_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --outputs od register file  --todo: integrate with execution
    ---------------------------------------------------------------------------
    SIGNAL stackOut_s : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL memOut_s : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN

    fetch_unit : ENTITY work.FetchUnit(a_FetchUnit)
        PORT MAP(
            clk => clk,
            rst => rst,
            value_to_add_pc => x"0001", --todo integratee with whoever gonna decide the value to be added
            instruction_out => fetched_instruction
        );
    control_unit : ENTITY work.ControlUnit(dataflow)
        PORT MAP(
            instruction => fetched_instruction(15 DOWNTO 11),
            aluEx => '0', --todo
            memEx => memEx_s,
            memRead => memRead_s,
            memToReg => memToReg_s,
            memWrite => memWrite_s,
            regWrite => regWrite_s,
            pop => pop_s,
            fnJmp => fnJmp_s,
            flushDecode => flushDecode_s,
            flushExecute => flushExecute_s
        );

    register_file : ENTITY work.RegisterFile(Behavioral)
        PORT MAP(
            --each input is a slice of the opcode coming from the fetch stage
            readAddr1 => fetched_instruction(7 DOWNTO 5),
            readAddr2 => fetched_instruction(4 DOWNTO 2),
            writeAddr => fetched_instruction(10 DOWNTO 8),
            writeData => (OTHERS => '0'), -----to do:integrate  
            regWrite => regWrite_s,
            readData1 => readData1_s,
            readData2 => readData2_s
        );

    ALU : ENTITY work.ALU(ALU)
        PORT MAP(
            oldN => '0',
            oldZ => '0',
            opCode => fetched_instruction(15 DOWNTO 11),
            d1 => readData1_s,
            d2 => readData2_s,
            imm => (OTHERS => '0')
        );

    Memory : ENTITY work.Memory_Stage(Memory_Stage)
        PORT MAP(
            clk => clk,

            -- todo: push signal from ALUControl
            we => memWrite_s, re => memRead_s, pushpsignal => '0', popsignal => pop_s, controlsignal => fnJmp_s,

            -- todo: output from ALU(ALUOut)
            address => x"0000",

            -- todo : Rsrc1 IN CASE OF (push, pop, call)
            -- Rsrc1 IN CASE OF (STD)
            datain => x"0000",
            pc => x"00000000",

            EmptyStackExceptionSignal => memEx_s,
            stackout => stackOut_s, dataout => memOut_s
        );
END ARCHITECTURE arKAKtectureProcessor;
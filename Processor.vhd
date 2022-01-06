LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY Processor IS
    GENERIC (n : INTEGER := 16);

    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC

    );
END ENTITY Processor;

ARCHITECTURE arKAKtectureProcessor OF Processor IS

    SIGNAL fetched_instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL pc_reg_out_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL adder_output_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL cout_sig : STD_LOGIC;
    SIGNAL temp_zero : STD_LOGIC := '0';

    ------------------------------------------------------------------------
    SIGNAL memRead_s,
    memToReg_s,
    memWrite_s,
    regWrite_s,
    pop_s,
    push_s,
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
    SIGNAL ALUOut_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ---------------------------------------------------------------------------
    SIGNAL ExMemBufferInput, ExMemBufferOutput : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL stackOut_s : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL memOut_s : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    ---------------------------------------------------------------------------
    SIGNAL MemWBBufferInput, MemWBBufferOutput : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WriteBackData_s : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
    -----------------------------------Fetch unit--------------------------------
    fetch_unit : ENTITY work.FetchUnit(a_FetchUnit)
        PORT MAP(
            clk => clk,
            rst => rst,
            adder_output => adder_output_sig,
            instruction_out => fetched_instruction,
            pc_reg_out => pc_reg_out_sig
        );
    pcAdder : ENTITY work.PCNadder(PCarch_Nadder)
        PORT MAP(
            a => pc_reg_out_sig,
            value_to_add_bit => fetched_instruction(16),
            cin => temp_zero,
            s => adder_output_sig,
            cout => cout_sig
        );

    -----------------------------------Decode--------------------------------
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
            writeData => WriteBackData_s,
            regWrite => regWrite_s,
            readData1 => readData1_s,
            readData2 => readData2_s
        );

    -----------------------------------Execute--------------------------------
    ALU : ENTITY work.ALU(ALU)
        PORT MAP(
            oldN => '0',
            oldZ => '0',
            opCode => fetched_instruction(15 DOWNTO 11),
            d1 => readData1_s,
            d2 => readData2_s,
            imm => (OTHERS => '0'),
            ALUOut => ALUOut_s
        );

    -----------------------------------Memory--------------------------------
    ExMemBufferInput(69 DOWNTO 0) <= memToReg_s & memWrite_s & memRead_s
    & pop_s & push_s & fnJmp_s & ALUOut_s & readData1_s & pc_reg_out_sig;
    ExMemBuffer : ENTITY work.pipeline_buffer(pipeline_buffer)
        PORT MAP(
            D => ExMemBufferInput,
            Q => ExMemBufferOutput,
            clk => clk, rst => '0', en => '1'
        );

    Memory : ENTITY work.Memory_Stage(Memory_Stage)
        PORT MAP(
            clk => clk,
            we => ExMemBufferOutput(68), re => ExMemBufferOutput(67),
            popsignal => ExMemBufferOutput(66), pushpsignal => ExMemBufferOutput(65),
            controlsignal => ExMemBufferOutput(64),
            address => ExMemBufferOutput(63 DOWNTO 48),
            datain => ExMemBufferOutput(47 DOWNTO 32),
            pc => ExMemBufferOutput(31 DOWNTO 0),
            EmptyStackExceptionSignal => memEx_s,
            stackout => stackOut_s, dataout => MemWBBufferInput(15 DOWNTO 0)
        );

    -----------------------------------Write Back--------------------------------
    MemWBBufferInput(32 DOWNTO 16) <= ExMemBufferOutput(69) & ExMemBufferOutput(63 DOWNTO 48);
    MemWBBuffer : ENTITY work.pipeline_buffer(pipeline_buffer)
        PORT MAP(
            D => MemWBBufferInput,
            Q => MemWBBufferOutput,
            clk => clk, rst => '0', en => '1'
        );
        
    WriteBack : ENTITY work.WriteBack_Stage(WriteBack_Stage)
        PORT MAP(
            MemtoReg => MemWBBufferOutput(32), clk => clk,
            PopD => MemWBBufferOutput(15 DOWNTO 0), ALUout => MemWBBufferOutput(31 DOWNTO 16),
            WBD => WriteBackData_s
        );
END ARCHITECTURE arKAKtectureProcessor;
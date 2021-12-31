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
    signal cout_sig   : std_logic;
    signal temp_zero : std_logic := '0';
    
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
    SIGNAL ALUOut_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ---------------------------------------------------------------------------
    SIGNAL stackOut_s : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL memOut_s : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    ---------------------------------------------------------------------------
    SIGNAL WriteBackData_s : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN


    -----------------------------------Fetch unit--------------------------------
    fetch_unit : ENTITY work.FetchUnit(a_FetchUnit)
        PORT MAP(
            clk => clk,
            rst => rst,
            adder_output =>adder_output_sig,
            instruction_out => fetched_instruction,
            pc_reg_out =>pc_reg_out_sig
        );
    pcAdder : entity work.PCNadder(PCarch_Nadder)
        port map(
            a                    =>pc_reg_out_sig,
            value_to_add_bit     =>fetched_instruction(16),
            cin                  =>temp_zero,
            s                    =>adder_output_sig,
            cout                 =>cout_sig
        );
    --------------------------------------------------------------------------
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

    ALU : ENTITY work.ALU(ALU)
        PORT MAP(
            clk => clk,
            oldN => '0',
            oldZ => '0',
            opCode => fetched_instruction(15 DOWNTO 11),
            d1 => readData1_s,
            d2 => readData2_s,
            imm => (OTHERS => '0'),
            ALUOut => ALUOut_s
        );

    Memory : ENTITY work.Memory_Stage(Memory_Stage)
        PORT MAP(
            clk => clk,

            -- todo: push signal from ALUControl
            we => memWrite_s, re => memRead_s, pushpsignal => '0', popsignal => pop_s, controlsignal => fnJmp_s,

            -- todo: output from ALU(ALUOut)
            address => ALUOut_s,

            -- todo : Rsrc1 IN CASE OF (push, pop, call)
            -- Rsrc1 IN CASE OF (STD)
            datain => x"0000",
            pc => x"00000000",

            EmptyStackExceptionSignal => memEx_s,
            stackout => stackOut_s, dataout => memOut_s
        );

    WriteBack : ENTITY work.WriteBack_Stage(WriteBack_Stage)
        PORT MAP(
            MemtoReg => memToReg_s, clk => clk,
            PopD => memOut_s, ALUout => ALUOut_s,
            WBD => WriteBackData_s
        );
END ARCHITECTURE arKAKtectureProcessor;
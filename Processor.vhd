LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY Processor IS
    GENERIC (n : INTEGER := 16);

    PORT (
        clk : IN STD_LOGIC := '0';
        rst : IN STD_LOGIC := '0';
        InPort : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
        OutPort : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY Processor;

ARCHITECTURE arKAKtectureProcessor OF Processor IS
    SIGNAL In_Signal, Out_Signal : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    SIGNAL pc_reg_out_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL adder_output_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL new_instruction_address : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL cout_sig : STD_LOGIC;
    SIGNAL temp_zero : STD_LOGIC := '0';

    SIGNAL fetched_instruction_buffer_input_fetchstage : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fetched_instruction_buffer_output_fetchstage : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fetched_instruction_buffer_output_decodestage : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ALU_exceptionaddress_sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Stack_exceptionaddress_sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    SIGNAL INT0_address_sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INT1_address_sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fetch_decode_buffer_input : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL nextPC_sig : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pcchanged_sig : STD_LOGIC;
    ------------------------------------------------------------------------
    SIGNAL
    regWrite_s,
    -- memRead_s,
    -- memToReg_s,
    -- memWrite_s,
    -- pop_s,
    -- push_s,
    -- fnJmp_s,
    flushDecode_s,
    flushExecute_s : STD_LOGIC; --outputs of control_unit 
    --todo: integrate with execution
    SIGNAL memEx_s, aluEx_s : STD_LOGIC := '0';
    SIGNAL writeAddress_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
    ---------------------------------------------------------------------------
    -- SIGNAL readData1_s,
    -- readData2_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --outputs od register file  --todo: integrate with execution
    ---------------------------------------------------------------------------
    SIGNAL DecExBufferInput, DecExBufferOutput : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    -- SIGNAL ALUOut_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL EnableOutPort_s : STD_LOGIC := '0';
    SIGNAL InPortSignal_s : STD_LOGIC := '0';
    SIGNAL enZandN_s : STD_LOGIC := '0';
    SIGNAL enC_s : STD_LOGIC := '0';
    SIGNAL flags_in_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL flags_out_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL opCode_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL d1_s, d2_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MemData_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ---------------------------------------------------------------------------
    SIGNAL ExMemBufferInput, ExMemBufferOutput : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL stackOut_s : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL memOut_s : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    ---------------------------------------------------------------------------
    SIGNAL MemWBBufferInput, MemWBBufferOutput : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WriteBackData_s : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    --------------------------------buffer resets------------------------------------
    SIGNAL flush_IF_ID : STD_LOGIC := '0';
    SIGNAL flush_ID_EX : STD_LOGIC := '0';
    SIGNAL flush_EX_MEM : STD_LOGIC := '0';

    -- signal flush_MEM_WB: std_logic := 0; not needed
BEGIN
    -----------------------------------Fetch unit--------------------------------
    fetch_unit : ENTITY work.FetchUnit(a_FetchUnit)
        PORT MAP(
            clk => clk,
            rst => rst,
            adder_output => new_instruction_address,
            instruction_out => fetched_instruction_buffer_input_fetchstage, -- this is the fetched instruction
            pc_reg_out => pc_reg_out_sig,
            ALU_exceptionaddress => ALU_exceptionaddress_sig,
            Stack_exceptionaddress => Stack_exceptionaddress_sig,
            INT0_address => INT0_address_sig,
            INT1_address => INT1_address_sig
        );
    pcAdder : ENTITY work.PCNadder(PCarch_Nadder)
        PORT MAP(
            a => pc_reg_out_sig,
            value_to_add_bit => fetched_instruction_buffer_input_fetchstage(16),
            cin => temp_zero,
            s => adder_output_sig,
            cout => cout_sig
        );

    new_instruction_address <= adder_output_sig WHEN pcchanged_sig = '0' ELSE
        nextPC_sig;
    --new_instruction_address <= adder_output_sig ;--when  stackexceptin='0' and pcchanged='0' else
    -- branch_output when  stackexceptin='0' and pcchanged='1' else
    -- Stack_exceptionaddress_sig when  stackexceptin='1' and pcchanged='0' else
    -- branch_output ;

    fetch_decode_buffer_input <= adder_output_sig & fetched_instruction_buffer_input_fetchstage;
    --flush_IF_ID <= '1' when (rst = '1') or (pcchanged_sig = '1') or (memEx_s ='1') else '0';
    flush_IF_ID <= rst OR pcchanged_sig OR memEx_s;
    --fetch decode stage
    fetched_instruction_buffer_fetchstage : ENTITY work.pipeline_buffer(pipeline_buffer)
        -- 63 down to 32 is the new instruction address
        -- 31 down to 0   is the currently fetched instduction
        GENERIC MAP(n => 64)
        PORT MAP(
            D => fetch_decode_buffer_input,
            Q => fetched_instruction_buffer_output_fetchstage,
            clk => clk,
            rst => flush_IF_ID,
            en => '1'
        );

    -----------------------------------Decode--------------------------------
    control_unit : ENTITY work.ControlUnit(dataflow)
        PORT MAP(
            instruction => fetched_instruction_buffer_output_fetchstage(31 DOWNTO 27),
            aluEx => aluEx_s,
            memEx => memEx_s,
            memRead => DecExBufferInput(65),
            memToReg => DecExBufferInput(67),
            memWrite => DecExBufferInput(66),
            regWrite => DecExBufferInput(70),
            pop => DecExBufferInput(64),
            push => DecExBufferInput(63),
            fnJmp => DecExBufferInput(62),
            flushDecode => flushDecode_s,
            flushExecute => flushExecute_s,
            outSignal => DecExBufferInput(68), --useless
            inSignal => DecExBufferInput(69) --useless
        );

    InPortSignal_s <= '1' WHEN fetched_instruction_buffer_output_fetchstage(31 DOWNTO 27) = "00110" ELSE
        '0';
    opCode_s <= "01010" WHEN fetched_instruction_buffer_output_fetchstage(31 DOWNTO 27) = "00110"
        ELSE
        fetched_instruction_buffer_output_fetchstage(31 DOWNTO 27);

    register_file : ENTITY work.RegisterFile(Behavioral)
        PORT MAP(
            --each input is a slice of the opcode coming from the fetch stage
            readAddr1 => fetched_instruction_buffer_output_fetchstage(23 DOWNTO 21),
            readAddr2 => fetched_instruction_buffer_output_fetchstage(20 DOWNTO 18),
            writeAddr => writeAddress_s,
            writeData => WriteBackData_s,
            regWrite => regWrite_s,
            InPortData => In_Signal,
            InPortSignal => InPortSignal_s,
            readData1 => DecExBufferInput(47 DOWNTO 32),
            readData2 => DecExBufferInput(31 DOWNTO 16)
        );
    --flush_ID_EX <= '1' when rst = '1' or pcchanged_sig = '1' or memEx_s ='1' else '0';
    flush_ID_EX <= rst OR pcchanged_sig OR memEx_s;

    --fetched instruction buffer for this stage
    --decode execute stage
    fetched_instruction_buffer_decodestage : ENTITY work.pipeline_buffer(pipeline_buffer)
        GENERIC MAP(
            n => 64
        )
        -- 63 down to 32 is the new instruction address
        -- 31 down to 0   is the currently fetched instduction
        PORT MAP(
            D => fetched_instruction_buffer_output_fetchstage,
            Q => fetched_instruction_buffer_output_decodestage,
            clk => clk,
            rst => flush_ID_EX,
            en => '1'
        );

    -----------------------------------Execute--------------------------------

    -----------------------------------I/O Ports--------------------------------
    INPORTREGISTER : ENTITY work.pipeline_buffer(pipeline_buffer)
        GENERIC MAP(n => 16)
        PORT MAP(
            D => InPort,
            Q => In_Signal,
            clk => clk,
            rst => rst,
            en => '1'
        );
    OUTPORTREGISTER : ENTITY work.pipeline_buffer(pipeline_buffer)
        GENERIC MAP(n => 16)
        PORT MAP(
            D => d1_s, --todo : make sure works right in sim
            Q => OutPort,
            clk => clk,
            rst => rst,
            en => EnableOutPort_s
        );
    ----------------------------------------------------------------
    DecExBufferInput(56 DOWNTO 48) <= fetched_instruction_buffer_output_fetchstage(26 DOWNTO 18);
    DecExBufferInput(61 DOWNTO 57) <= opCode_s;
    DecExBufferInput(15 DOWNTO 0) <= fetched_instruction_buffer_output_fetchstage(15 DOWNTO 0);
    DecExBufferInput(73 DOWNTO 71) <= fetched_instruction_buffer_output_fetchstage(26 DOWNTO 24);
    DecExBufferInput(74) <= InPortSignal_s;

    MemData_s <= MemWBBufferOutput(15 DOWNTO 0) WHEN MemWBBufferOutput(32) = '1'
        ELSE
        MemWBBufferOutput(31 DOWNTO 16);

    DecExBuffer : ENTITY work.pipeline_buffer(pipeline_buffer)
        PORT MAP(
            D => DecExBufferInput,
            Q => DecExBufferOutput,
            clk => clk,
            rst => flush_ID_EX,
            en => '1'
        );
    DataForward1 : ENTITY work.DataForward(DataForward)
        PORT MAP(
            Rsrc => DecExBufferOutput(53 DOWNTO 51),
            ReadData => DecExBufferOutput(47 DOWNTO 32),
            MemRdst => MemWBBufferOutput(38 DOWNTO 36),
            MemData => MemData_s,
            ExRdst => ExMemBufferOutput(75 DOWNTO 73),
            ExData => ExMemBufferOutput(63 DOWNTO 48),
            Data => d1_s,
            InpPortSignal => DecExBufferOutput(74)
        );
    DataForward2 : ENTITY work.DataForward(DataForward)
        PORT MAP(
            Rsrc => DecExBufferOutput(50 DOWNTO 48),
            ReadData => DecExBufferOutput(31 DOWNTO 16),
            MemRdst => MemWBBufferOutput(38 DOWNTO 36),
            MemData => MemData_s,
            ExRdst => ExMemBufferOutput(75 DOWNTO 73),
            ExData => ExMemBufferOutput(63 DOWNTO 48),
            Data => d2_s,
            InpPortSignal => DecExBufferOutput(74)
        );
    ALU : ENTITY work.ALU(ALU)
        PORT MAP(
            opCode => DecExBufferOutput(61 DOWNTO 57),
            d1 => d1_s,
            d2 => d2_s,
            imm => DecExBufferOutput(15 DOWNTO 0),
            ALUOut => ExMemBufferInput(63 DOWNTO 48),
            EnableOutPort => EnableOutPort_s,
            en => enZandN_s,
            enc => enC_s,
            newZ => flags_in_s(0),
            newN => flags_in_s(1),
            cout => flags_in_s(2),
            ALUExceptionSignal => aluEx_s
        );
    FlagsRegister : ENTITY work.FlagsRegister(rtl)
        PORT MAP(
            clk => clk,
            rst => rst,
            enNZ => enZandN_s,
            enC => enC_s,
            flags_in => flags_in_s,
            flags_out => flags_out_s
        );

    BranchALUStage : ENTITY work.branching(branching_architecture)
        PORT MAP(
            alu_ex_address => ALU_exceptionaddress_sig,
            PCregOutput => fetched_instruction_buffer_output_decodestage(63 DOWNTO 32),
            RRdst => d1_s, --DecExBufferOutput(47 DOWNTO 32),
            carryflag => flags_out_s(2),
            negativeflag => flags_out_s(1),
            zeroflag => flags_out_s(0),
            opCode => DecExBufferOutput(61 DOWNTO 57), --fetched_instruction_buffer_output_decodestage(31 downto 27) ,
            alu_ex => aluEx_s,
            XofSP => (OTHERS => '0'),
            POP => '0',
            FnJMP => '0',
            clk => clk,
            nextPC => nextPC_sig,
            pc_changed => pcchanged_sig
        );
    -----------------------------------Memory--------------------------------
    ExMemBufferInput(71 DOWNTO 64) <= DecExBufferOutput(69) & DecExBufferOutput(68) & DecExBufferOutput(67) & DecExBufferOutput(66) & DecExBufferOutput(65)
    & DecExBufferOutput(64) & DecExBufferOutput(63) & DecExBufferOutput(62);

    ExMemBufferInput(47 DOWNTO 0) <= d1_s & fetched_instruction_buffer_output_decodestage(31 DOWNTO 0);
    ExMemBufferInput(75 DOWNTO 72) <= DecExBufferOutput(73 DOWNTO 70);

    --flush_EX_MEM <= '1' when rst = '1' or memEx_s = '1' else '0';
    flush_EX_MEM <= rst OR memEx_s;
    ExMemBuffer : ENTITY work.pipeline_buffer(pipeline_buffer)
        PORT MAP(
            D => ExMemBufferInput,
            Q => ExMemBufferOutput,
            clk => clk, rst => flush_EX_MEM, en => '1'
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
    MemWBBufferInput(34 DOWNTO 16) <= ExMemBufferOutput(71) & ExMemBufferOutput(70) & ExMemBufferOutput(69) & ExMemBufferOutput(63 DOWNTO 48);
    MemWBBufferInput(38 DOWNTO 35) <= ExMemBufferOutput(75 DOWNTO 72);
    MemWBBuffer : ENTITY work.pipeline_buffer(pipeline_buffer)
        PORT MAP(
            D => MemWBBufferInput,
            Q => MemWBBufferOutput,
            clk => clk, rst => rst, en => '1'
        );

    WriteBack : ENTITY work.WriteBack_Stage(WriteBack_Stage)
        PORT MAP(
            regWriteSignalInput => MemWBBufferOutput(35), writeAddressInput => MemWBBufferOutput(38 DOWNTO 36),
            MemtoReg => MemWBBufferOutput(32), clk => clk, InSignal => MemWBBufferOutput(34),
            PopD => MemWBBufferOutput(15 DOWNTO 0), ALUout => MemWBBufferOutput(31 DOWNTO 16),
            Inport => In_Signal,
            WBD => WriteBackData_s,
            regWriteSignalOutput => regWrite_s, writeAddressOutput => writeAddress_s
        );
    -- regWrite_s <= MemWBBufferOutput(35);
    -- writeAddress_s <= MemWBBufferOutput(38 DOWNTO 36);
    -- Out_Signal <= WriteBackData_s WHEN MemWBBufferOutput(33) = '1';
END ARCHITECTURE arKAKtectureProcessor;
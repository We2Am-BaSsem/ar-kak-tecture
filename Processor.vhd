LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Processor IS
    generic (n :integer :=16);

    PORT (
        clk :in std_logic;
        rst :in std_logic

    );
END ENTITY Processor;

ARCHITECTURE arKAKtectureProcessor OF Processor IS

    signal fetched_instruction : std_logic_vector(n-1 downto 0);
    ------------------------------------------------------------------------
    signal  memRead_s,
            memToReg_s,
            memWrite_s,
            regWrite_s,
            pop_s,     
            fnJmp_s,   
            flushDecode_s,
            flushExecute_s    :   std_logic;  --outputs of control_unit 
                                              --todo: integrate with execution
    ---------------------------------------------------------------------------
    signal readData1_s,
            readData2_s  : std_logic_vector(15 downto 0);
    --outputs od register file  --todo: integrate with execution
    

begin

    fetch_unit : entity work.FetchUnit(a_FetchUnit)
        port map(
        clk =>clk,
        rst =>rst,
        value_to_add_pc =>x"0001", --todo integratee with whoever gonna decide the value to be added
        instruction_out =>fetched_instruction
        );


    control_unit : entity work.ControlUnit(dataflow)
        port map(
            instruction =>fetched_instruction(15 downto 11),       
            aluEx =>'0', --todo
            memEx =>'0',  -- todo    
            memRead=>memRead_s,
            memToReg=>memToReg_s,
            memWrite=>memWrite_s,
            regWrite=>regWrite_s,
            pop    =>pop_s,
            fnJmp   =>fnJmp_s,
            flushDecode=>flushDecode_s,
            flushExecute=>flushExecute_s
        );

    register_file : entity work.RegisterFile(Behavioral)
        port map(
            --each input is a slice of the opcode coming from the fetch stage
            readAddr1=>fetched_instruction(7 downto 5),  
            readAddr2=>fetched_instruction(4 downto 2),  
            writeAddr=>fetched_instruction(10 downto 8),  
            writeData=>(others => '0'),   -----to do:integrate  
            regWrite =>regWrite_s,  
            readData1=>readData1_s,  
            readData2=>readData2_s  
        );

    ALU : entity work.ALU(ALU)
        port map(
            oldN => '0',
            oldZ => '0',
            opCode => fetched_instruction(15 downto 11),
            d1 => readData1_s,
            d2 => readData2_s,
            imm => (OTHERS => '0')
        );








END ARCHITECTURE arKAKtectureProcessor;
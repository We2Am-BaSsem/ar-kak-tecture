LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FetchUnit IS
    --generic (n :integer :=16);
    PORT (
        clk, rst : IN STD_LOGIC; -- value is rst when rst=1
        adder_output : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        -- connect with value_to_add_bit in PCNadder

        instruction_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        -- connect with value_to_add_bit in PCNadder
        pc_reg_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

        ALU_exceptionaddress : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        Stack_exceptionaddress : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

        INT0_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        INT1_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')

        -- connect it to a in PCNadder
    );
END ENTITY FetchUnit;

ARCHITECTURE a_FetchUnit OF FetchUnit IS

    SIGNAL pc_reg_output : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL beginning_address_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --SIGNAL adder_output: std_logic_vector(31 DOWNTO 0);
    SIGNAL adder_outputCarryout : STD_LOGIC;
    SIGNAL add_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL not_clk : STD_LOGIC;

BEGIN
    not_clk <= NOT(clk);
    instructionmemory : ENTITY work.InstructionMemory(arch_InstructionMemory)
        PORT MAP(
            clk => clk,
            rst => rst,
            address => pc_reg_output,
            dataout => instruction_out,
            beginning_address_of_operations => beginning_address_sig,
            ALU_EX_address => ALU_exceptionaddress,
            Stack_Exception_address => Stack_exceptionaddress,
            int0_address => INT0_address,
            int1_address => INT1_address
        );
    pc_reg : ENTITY work.PC_register(arch_PC_register)
        PORT MAP(
            clk => not_clk,
            Rst => rst,
            beginning_address => beginning_address_sig,
            d => adder_output,
            q => pc_reg_output
        );

    pc_reg_out <= pc_reg_output;
END ARCHITECTURE;
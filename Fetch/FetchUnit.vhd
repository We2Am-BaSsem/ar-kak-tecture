LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FetchUnit is
    --generic (n :integer :=16);
    port(
    clk ,rst: IN std_logic;  -- value is rst when rst=1
    adder_output : in std_logic_vector(31 downto 0); -- connect with value_to_add_bit in PCNadder
    
    instruction_out : out std_logic_vector(31 downto 0); -- connect with value_to_add_bit in PCNadder
    pc_reg_out       : out std_logic_vector(31 downto 0)  -- connect it to a in PCNadder
    );
end entity FetchUnit;



architecture a_FetchUnit of FetchUnit is 

SIGNAL pc_reg_output : std_logic_vector(31 DOWNTO 0);

signal beginning_address_sig: std_logic_vector(31 downto 0);
--SIGNAL adder_output: std_logic_vector(31 DOWNTO 0);
SIGNAL adder_outputCarryout: std_logic;
signal add_value:std_logic_vector(31 DOWNTO 0);
signal not_clk: std_logic ;



    begin
        not_clk<=not(clk);
        instructionmemory: entity work.InstructionMemory(arch_InstructionMemory) 
        port map(
            clk => clk,
            rst     => rst,
            address => pc_reg_output,
            dataout => instruction_out,
            beginning_address_of_operations=>beginning_address_sig
            );
            pc_reg : entity work.PC_register(arch_PC_register)
            port map(
                clk => not_clk ,
                Rst => rst,
                beginning_address=>beginning_address_sig,
                d=>adder_output,
                q=>pc_reg_output
                );
        
        pc_reg_out<=pc_reg_output;


    end architecture;



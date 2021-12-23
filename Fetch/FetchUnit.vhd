LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FetchUnit is
    generic (n :integer :=16);
    port(
    clk ,rst: IN std_logic;  -- value is rst when rst=1
    --address: IN std_logic_vector(15 DOWNTO 0);
    value_to_add_pc :  in std_logic_vector(n-1 downto 0);
    instruction_out : out std_logic_vector(n-1 downto 0)
    );
end entity FetchUnit;



architecture a_FetchUnit of FetchUnit is 

SIGNAL pc_reg_output : std_logic_vector(n-1 DOWNTO 0);
SIGNAL adder_output: std_logic_vector(n-1 DOWNTO 0);
SIGNAL adder_outputCarryout: std_logic;


    begin

    instructionmemory: entity work.InstructionMemory(arch_InstructionMemory)
        port map(
            clk => clk,
            address => pc_reg_output,
            dataout => instruction_out
        );
    pc_reg : entity work.PC_register(arch_PC_register)
        port map(
            clk => clk ,
            Rst => rst,
            d=>adder_output,
            q=>pc_reg_output
        );
    adder : entity work.Nadder(arch_Nadder)
        port map(
            a =>pc_reg_output,
            b=>value_to_add_pc,
            cin =>'0',
            s=>adder_output,
            cout =>adder_outputCarryout
        );




    end architecture;



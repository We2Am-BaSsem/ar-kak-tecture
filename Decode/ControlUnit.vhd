library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is
    port (
        instruction     :     in std_logic_vector(4 downto 0); -- slice [15,11] of the total opcode
        aluEx,
        memEx           :     in std_logic;
        memRead,
        memToReg,
        memWrite,
        regWrite,
        pop,     
        fnJmp,   
        flushDecode,
        flushExecute    :   out std_logic  := '0' --?
    );
end entity ControlUnit;

architecture dataflow of ControlUnit is
    signal out_vector: std_logic_vector(5 downto 0); --will work on output signals first without exception
begin
    process(instruction)
    begin
        -- memRead<='0';
        -- memToReg<='0';
        -- memWrite<='0';
        -- regWrite<='0';
        -- pop<='0';     
        -- fnJmp<='0';   
        -- flushDecode<='0';
        -- flushExecute<='0'; 
        -- for some reason, if these are uncommented, 1 are output as X, will change to with Select 

        if (instruction = "00000" 
            or instruction = "00001" 
            or instruction = "00010"
            or instruction = "00101"
            or instruction = "10000"
            or instruction = "11000"
            or instruction = "11001"
            or instruction = "11010"
            or instruction = "11011" )then
                out_vector <= "000000";           
        elsif (instruction = "00011"
            or instruction = "00100"
            or instruction = "00110"
            or instruction = "01000"
            or instruction = "01001"
            or instruction = "01010"
            or instruction = "01011"
            or instruction = "01100"
            or instruction = "10010" )then
                out_vector <= "000100";
        elsif (instruction = "10001") then
            out_vector <= "000110";
        elsif (instruction = "10011") then
            out_vector <= "110100";
        elsif (instruction = "10100")then
            out_vector <= "001000";
        elsif (instruction = "11100") then
            out_vector <= "000001";
        elsif (instruction = "11101"
            or instruction = "11111") then
                out_vector <= "000011";
        else out_vector <= "100001"; 
        end if;
    end process;
    
    memRead<=out_vector(5);
    memToReg<=out_vector(4);
    memWrite<=out_vector(3);
    regWrite<=out_vector(2);
    pop<=out_vector(1);     
    fnJmp<=out_vector(0);       
    
end architecture dataflow;
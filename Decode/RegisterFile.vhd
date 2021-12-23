library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegisterFile is
    port (
        --each input is a slice of the opcode coming from the fetch stage
        readAddr1:  in std_logic_vector(2 downto 0);  -- instruction (7 downto 5)
        readAddr2:  in std_logic_vector(2 downto 0);  -- instruction (4 downto 2)
        writeAddr:  in std_logic_vector(2 downto 0);  -- insturction (10 downto 8)
        writeData:  in std_logic_vector(15 downto 0);    --make sure is it 16 bits or 32 bits?
        regWrite:   in std_logic;    --from control unit
        readData1:  out std_logic_vector(15 downto 0); -- output to execute
        readData2:  out std_logic_vector(15 downto 0)   -- output to execute
    );
end entity RegisterFile;

architecture Behavioral of RegisterFile is
type reg_file_type is array(0 to 7) of std_logic_vector(15 downto 0);
signal array_reg: reg_file_type := ( x"0000",
                                     x"0000",
                                     x"0000",
                                     x"0000",
                                     x"0000",
                                     x"0000",
                                     x"0000",
                                     x"0000"
);  --initiaizing registers
begin
    process(regWrite)   --writes data on signal regWrite
    begin
        if(regWrite = '1') then
            array_reg(to_integer(unsigned(writeAddr))) <= writeData;
        end if;
    end process;

    --reading is done regardless of anything
    readData1 <= array_reg(to_integer(unsigned(readAddr1)));
    readData2 <= array_reg(to_integer(unsigned(readAddr2)));

end architecture Behavioral;
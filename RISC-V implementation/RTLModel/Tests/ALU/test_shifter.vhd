----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 19/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------
library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;


entity test_shifter is

end test_shifter;

architecture Behavioral of test_shifter is
    constant period: time := 20ns;
    signal a : data_type:="11111111111111110000000000000000";
    signal out_signal : data_type:=(others =>'0');  
    signal code : opcode_type;

begin

shifter: entity work.shifter(Behavioral)
port map(
    a => a,
    code => code,
    s => out_signal
);

    process_test:process begin
        code <= code_sll;
        wait for 10*period;
        code <= code_srl;
        wait for 10*period;
        code <= code_sra;
        wait for 10*period;
    end process;
end Behavioral;


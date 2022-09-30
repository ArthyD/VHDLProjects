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


entity test_logic_unit is

end test_logic_unit;

architecture Behavioral of test_logic_unit is
    constant period: time := 20ns;
    signal a : data_type:=(others =>'0');
    signal b : data_type:=(others =>'1');
    signal out_signal : data_type:=(others =>'0');
    signal code : opcode_type;
    --signal out_not : data_type:=(others =>'0');

begin

    logic_unit: entity work.logic_unit(Behavioral)
    port map(
        a => a,
        b => b,
        code => code,
        s => out_signal
    );
    
    process_test:process begin
            code <= code_and;
            wait for 10*period;
            code <= code_or;
            wait for 10*period;
            code <= code_xor;
            wait for 10*period;
        end process;
end Behavioral;
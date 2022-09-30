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


entity test_comparator is

end test_comparator;

architecture Behavioral of test_comparator is
    signal a : data_type:=(others =>'0');
    signal b : data_type:=(others =>'1');
    signal out_SLT : data_type:=(others =>'0');
    signal out_SLTU : data_type:=(others =>'0');

begin
comparator: entity work.comparator(SLL_Behavioral)
port map(
    a => a,
    b => b,
    c => out_SLT
);

comparator2: entity work.comparator(SLTU_Behavioral)
port map(
    a => a,
    b => b,
    c => out_SLTU
);


end Behavioral;
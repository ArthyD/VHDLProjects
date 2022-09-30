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

entity shifter is 
Port (
        a       :       in      data_type;
	    code	:	    in	    opcode_type;
        s       :       out	    data_type
);
end shifter;

architecture Behavioral of shifter is
    signal out_SLL : data_type:=(others =>'0');   
    signal out_SRL : data_type:=(others =>'0');   
    signal out_SRA : data_type:=(others =>'0');

begin

sll2: entity work.sll2(Behavioral)
port map(
    a => a,
    b => out_SLL
);

srl2: entity work.srl2(Behavioral)
port map(
    a => a,
    b => out_SRL
);    

sra2: entity work.sra2(Behavioral)
port map(
    a => a,
    b => out_SRA
);     

process_shifter : process(a, code) begin
case code is
when code_sll => s <= out_SLL;
when code_srl => s <= out_SRL;
when code_sra => s <= out_SRA;
when others => s <= (others =>'0');
end case;
end process;

end Behavioral;
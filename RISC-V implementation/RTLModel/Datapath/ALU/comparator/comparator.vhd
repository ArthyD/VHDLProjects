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

entity comparator is 
Port (
        a       :       in      data_type;
        b       :       in      data_type;
	    code	:	    in	    opcode_type;
        s       :       out	    data_type
);
end comparator;

architecture Behavioral of comparator is
    signal out_SLT : data_type:=(others =>'0');   
    signal out_SLTU : data_type:=(others =>'0');   

begin

slt2: entity work.slt2(Behavioral)
port map(
    a => a,
    b => b,
    c => out_SLT
);

sltu2: entity work.sltu2(Behavioral)
port map(
    a => a,
    b => b,
    c => out_SLTU
);    

process_shifter : process(a) begin
case code is
when code_slt => s <= out_SLT;
when code_sltu => s <= out_SLTU;
when others => s <= (others =>'0');
end case;
end process;

end Behavioral;


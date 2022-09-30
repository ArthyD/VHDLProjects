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

entity logic_unit is 
port(
    a	:	in	data_type;
    b   :   in  data_type;
    code:	in	opcode_type;
    s	:	out	data_type
);
end logic_unit;

architecture Behavioral of logic_unit is
    signal out_and : data_type:=(others =>'0');   
    signal out_or : data_type:=(others =>'0');   
    signal out_xor : data_type:=(others =>'0');
begin

and2: entity work.and2(Behavioral)
port map(
    a => a,
    b => b,
    c => out_and
);

or2: entity work.or2(Behavioral)
port map(
    a => a,
    b => b,
    c => out_or
); 

xor2: entity work.xor2(Behavioral)
port map(
    a => a,
    b => b,
    c => out_xor
); 

process_shifter : process(a,b,code) begin
    case code is
        when code_and => s <= out_and;
        when code_or => s <= out_or;
        when code_xor => s <= out_xor;
        when others => s <= (others =>'0');
    end case;
end process;
        
end Behavioral;


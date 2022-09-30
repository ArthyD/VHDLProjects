----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 19/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;

entity SLTU2 is 
port(
    a	:	in	data_type;
	b	:	in	data_type;
    c	:	out	data_type
);
end SLTU2;

architecture Behavioral of SLTU2 is
begin
    process_sltu: process(a,b) begin
    if (to_integer(unsigned(to_stdlogicvector(a))) < unsigned(b)) then
        c <= (others =>'1');

    else
        c <= (others =>'0');
    end if;
    end process;
end Behavioral;

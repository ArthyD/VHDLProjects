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

entity or2 is 
port(
    a	:	in	data_type;
	b	:	in	data_type;
    c	:	out	data_type
);
end or2;

architecture Behavioral of or2 is
begin
    c <= a OR b;
end Behavioral;
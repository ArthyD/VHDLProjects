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

entity xor2 is 
port(
    a	:	in	data_type;
	b	:	in	data_type;
    c	:	out	data_type
);
end xor2;

architecture Behavioral of xor2 is
begin
    c <= a XOR b;
end Behavioral;
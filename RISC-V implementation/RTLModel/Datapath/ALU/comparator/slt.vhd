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

entity SLT2 is 
port(
    a	:	in	data_type;
	b	:	in	data_type;
    c	:	out	data_type
);
end SLT2;

architecture Behavioral of SLT2 is
    signal int_a : integer;
    signal int_b : integer;
begin
    process_slt : process(a,b) begin
    --int_a <= to_integer(signed(a))  ;
    --int_b <= to_integer(signed(b))  ;
    
    if (a < b) then
        c <= (others =>'1');

    else
        c <= (others =>'0');
    end if;
    end process;
end Behavioral;
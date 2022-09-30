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

entity mux12_2x1 is
    port ( select_input : in bit;
        d_in_a, d_in_b : in bit_vector( 11 downto 0 );
        d_out : out bit_vector( 11 downto 0 )
    );
end mux12_2x1;

architecture RTL of mux12_2x1 is

begin

    process( d_in_a, d_in_b, select_input )
    
    begin
        if select_input = '0' then
            d_out <= d_in_a;
        else
            d_out <= d_in_b;
        end if;
    end process;
    
end RTL;

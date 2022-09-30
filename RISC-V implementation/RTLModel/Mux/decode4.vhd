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

entity decode4 is
    port ( s : in bit_vector( 1 downto 0 );
        en : in bit;
        d_out_a, d_out_b : out bit;
        d_out_c, d_out_d : out bit );
end decode4;

architecture RTL of decode4 is

begin

    process( s, en)
    begin
        if en = '0' then
            d_out_a <= '0'; d_out_b <= '0';
            d_out_c <= '0'; d_out_d <= '0';
        else
            case s is
                when "00" => 
                d_out_a <= '1'; 
                d_out_b <= '0';
                d_out_c <= '0'; 
                d_out_d <= '0';
                when "01" => 
                d_out_a <= '0'; 
                d_out_b <= '1';
                d_out_c <= '0'; 
                d_out_d <= '0';
                when "10" => 
                d_out_a <= '0'; 
                d_out_b <= '0';
                d_out_c <= '1'; 
                d_out_d <= '0';
                when "11" => 
                d_out_a <= '0'; 
                d_out_b <= '0';
                d_out_c <= '0'; 
                d_out_d <= '1';
            end case;
        end if;
    end process;
end RTL;

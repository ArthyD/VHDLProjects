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


entity demux1_1x4 is
    port(
        d_in: in bit; 
        select_input: in bit_vector(1 downto 0);
        d_out_a, d_out_b, d_out_c, d_out_d: out bit
    );
end demux1_1x4;

architecture RTL of demux1_1x4 is
begin
    process(d_in, select_input)
    begin
        d_out_a <= '0';
        d_out_b <= '0';
        d_out_c <= '0';
        d_out_d <= '0';

        case select_input is
            when "00" => d_out_a <= d_in;
            when "01" => d_out_b <= d_in;
            when "10" => d_out_c <= d_in;
            when "11" => d_out_d <= d_in;
        end case;
    end process;
end RTL;
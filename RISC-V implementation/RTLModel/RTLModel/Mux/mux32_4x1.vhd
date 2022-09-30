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

entity mux32_4x1 is
    port(
        select_input: in bit_vector(1 downto 0);
        d_in_a, d_in_b, d_in_c, d_in_d: in data_type;
        d_out: out data_type
    );
end mux32_4x1;

architecture RTL of mux32_4x1 is
begin
    with select_input select
        d_out <= d_in_d when "11",
                 d_in_c when "10",
                 d_in_b when "01",
                 d_in_a when "00";
end RTL;

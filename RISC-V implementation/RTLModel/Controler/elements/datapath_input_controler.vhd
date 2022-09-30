----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 26/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;

entity datapath_input_controler is
    Port(
        cmd_calc : in std_logic;
        calc_on_PC : in std_logic;
        pc : in addr_type;
        imm : in bit_vector(11 downto 0);
        output : out data_type
    );
end datapath_input_controler;

architecture RTL of datapath_input_controler is 
begin
    process_datapath_input_controler : process(cmd_calc,calc_on_PC,pc,imm) begin
        if cmd_calc = '1' then
            output <= "00000000000000000000" & imm;
        elsif calc_on_PC = '1' then
            output <= "0000000000000000" & pc;
        end if;
    end process;
end RTL;
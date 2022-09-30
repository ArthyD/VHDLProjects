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

entity instruction_controler is
    Port(
        memory_instruction : in data_type;
        input_instruction : in data_type;
        enable : in std_logic;
        instruction : out data_type
    );
end instruction_controler;

architecture RTL of instruction_controler is 
begin
    process_instr_controler : process(enable) begin
        if enable = '1' then
            instruction <= memory_instruction;
        end if;
    end process;
end RTL;
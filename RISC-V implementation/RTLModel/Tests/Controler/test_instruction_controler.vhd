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

entity test_instruction_controler is
--  Port ( );
end test_instruction_controler;

architecture Behavioral of test_instruction_controler is
    constant period: time :=20ns;
    signal memory_instruction : data_type;
    signal input_instruction : data_type;
    signal enable : std_logic;
    signal instruction : data_type;

begin
    controler: entity worK.instruction_controler(RTL)
    port map(
        memory_instruction => memory_instruction,
        input_instruction => input_instruction,
        enable => enable,
        instruction  => instruction
    );
    
    
    process_test: process begin
        memory_instruction <= (others => '1');
        wait for 10*period;
        enable <= '1';
        wait for 10*period;
        memory_instruction <= (others => '0');
        wait for 10*period;
        enable <= '0';
        wait for 10*period;
    end process;

end Behavioral;
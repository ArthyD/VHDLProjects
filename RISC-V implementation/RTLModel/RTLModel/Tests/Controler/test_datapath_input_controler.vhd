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

entity test_datapath_input_controler is
--  Port ( );
end test_datapath_input_controler;

architecture Behavioral of test_datapath_input_controler is
    constant period: time :=20ns;
    signal cmd_calc : std_logic;
    signal calc_on_PC : std_logic;
    signal pc : addr_type;
    signal imm : bit_vector(11 downto 0);
    signal output : data_type;

begin
    controler: entity worK.datapath_input_controler(RTL)
    port map(
        cmd_calc => cmd_calc,
        calc_on_PC => calc_on_PC,
        pc => pc,
        imm => imm,
        output => output
    );
    
    
    process_test: process begin
        pc <= (others => '0');
        imm <= "000000000111";
        cmd_calc <= '1';
        calc_on_PC <= '0';
        wait for 10*period;
        cmd_calc <= '0';
        calc_on_PC <= '1';
        wait for 10*period;
    end process;

end Behavioral;
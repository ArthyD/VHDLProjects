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

entity test_PC_increment is
--  Port ( );
end test_PC_increment;

architecture Behavioral of test_PC_increment is
    constant period: time :=20ns;
    signal pc_in : addr_type;
    signal pc_out : addr_type;
    

begin
    controler: entity worK.increment_PC(RTL)
    port map(
        pc => pc_in,
        pc_incr => pc_out
    );
    
    
    process_test: process begin
        pc_in <= (others => '0');
        wait for 10*period;
    end process;

end Behavioral;
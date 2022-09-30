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

entity test_address_controler is
--  Port ( );
end test_address_controler;

architecture Behavioral of test_address_controler is
    constant period: time :=20ns;
    signal reg1_content : data_type;
    signal enable : std_logic;
    signal address : addr_type;

begin
    controler: entity worK.address_controler(RTL)
    port map(
        register_content => reg1_content,
        enable => enable,
        address => address
    );
    
    
    process_test: process begin
        reg1_content <= (others => '1');
        wait for 10*period;
        enable <= '1';
        wait for 10*period;
        reg1_content <= (others => '0');
        wait for 10*period;
        enable <= '0';
        wait for 10*period;
    end process;

end Behavioral;
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

entity address_controler is
    Port(
        register_content : in data_type;
        enable : in std_logic;
        address : out addr_type
    );
end address_controler;

architecture RTL of address_controler is 
begin
    process_addr_controler : process(enable) begin
        if enable = '1' then
            address <= register_content(15 downto 0);
        end if;
    end process;
end RTL;
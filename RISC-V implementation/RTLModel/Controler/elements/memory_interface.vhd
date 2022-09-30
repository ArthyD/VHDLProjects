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

entity memory_interface is
    Port(
       -- addressing options --
       pc : in addr_type;
       addr : in addr_type;
       reg_content : in data_type;
       reg_content_to_write : in data_type;
       -- controler output --
       en_w_mem : in std_logic;
       en_r_mem : in std_logic;
       mem_access_mux : in std_logic_vector(1 downto 0);
       mem_access_type : in std_logic_vector(1 downto 0);
       -- memory input --
       data_to_write : out data_type;
       w_en : out std_logic;
       w_addr : out addr_type;
       w_mode : out std_logic_vector(1 downto 0);
       r_en : out std_logic;
       r_addr : out addr_type;
       r_mode : out std_logic_vector(1 downto 0)
    );
end memory_interface;

architecture RTL of memory_interface is 
    signal tmp_address : addr_type;
begin
    process_memory_interface : process(pc,addr,reg_content,reg_content_to_write,en_w_mem,en_r_mem,mem_access_mux,mem_access_type) begin
        -- Choose which component gives the address --
        case mem_access_mux is
            when "10" => tmp_address <= addr;
            when "11" => tmp_address <= reg_content(15 downto 0);
            when others => tmp_address <= pc;
        end case;
        -- Select operation on memory --
        if en_w_mem = '1' then 
            data_to_write <= reg_content_to_write;
            w_en <= '1';
            w_addr <= tmp_address;
            w_mode <= mem_access_type;
        elsif en_r_mem = '1' then
            r_en <= '1';
            r_addr <= tmp_address;
            r_mode <= mem_access_type;
        end if;
    end process;
end RTL;
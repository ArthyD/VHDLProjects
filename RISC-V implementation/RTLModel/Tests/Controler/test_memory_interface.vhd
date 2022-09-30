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

entity test_memory_interface is
--  Port ( );
end test_memory_interface;

architecture Behavioral of test_memory_interface is
    constant period: time :=20ns;
    signal en_addr : std_logic := '0';
    signal en_w_mem : std_logic := '0';
    signal en_r_mem : std_logic := '0';
    signal mem_access_mux : std_logic_vector(1 downto 0) := "00";
    signal mux_instr : std_logic := '0';
    signal mux_PC : std_logic := '0';
    signal mem_access_type : std_logic_vector(1 downto 0) := "00";
    signal pc : addr_type;
    signal address : addr_type;
    signal reg_data_a : data_type;
    signal data_to_write : data_type;
    signal w_en : std_logic;
    signal w_addr : addr_type;
    signal w_mode : std_logic_vector(1 downto 0);
    signal r_en : std_logic;
    signal r_addr : addr_type;
    signal r_mode : std_logic_vector(1 downto 0);
    
begin
    MemoryInterface: entity work.memory_interface(RTL)
    port map(
       pc => pc,
       addr => address,
       reg_content => reg_data_a,
       reg_content_to_write => reg_data_a,
       en_w_mem => en_w_mem,
       en_r_mem => en_r_mem,
       mem_access_mux => mem_access_mux,
       mem_access_type => mem_access_type,
       data_to_write => data_to_write,
       w_en => w_en,
       w_addr => w_addr,
       w_mode => w_mode,
       r_en => r_en,
       r_addr => r_addr,
       r_mode => r_mode
    );
    
    
    process_test: process begin
        pc <= (others => '1');
        en_w_mem <= '1';
        en_r_mem <= '0';
        mem_access_type <= "11";
        mem_access_mux <= "00";
        reg_data_a <= (others => '1');
        wait for 10*period;
        en_w_mem <= '1';
        en_r_mem <= '0';
        mem_access_type <= "01";
        wait for 10*period;
        
    end process;

end Behavioral;
----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 25/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.cpu_defs_pack.all;

entity test_controler is
    --  Port ( );
end test_controler;
    
architecture Behavioral of test_controler is

    constant period: time :=20ns;
    signal instruction : data_type;
    -- Output for regsisters and ALU --
    signal opcode : opcode_type;
    signal sel_in : bit_vector(1 downto 0);
    signal sel_out_a : bit_vector(1 downto 0);
    signal sel_out_b : bit_vector(1 downto 0);
    signal sel_out_c : bit_vector(1 downto 0);
    -- Output of FSM --
    signal en_calc : std_logic := '0';
    signal en_registers : std_logic := '0';
    signal en_PC : std_logic := '0';
    signal en_addr : std_logic := '0';
    signal en_w_mem : std_logic := '0';
    signal en_r_mem : std_logic := '0';
    signal en_instr : std_logic := '0';
    signal mem_access_mux : std_logic_vector(1 downto 0) := "00";
    signal mux_instr : std_logic := '0';
    signal mux_PC : std_logic := '0';
    signal mem_access_type : std_logic_vector(1 downto 0) := "00";
    -- Imm output --
    signal imm : bit_vector(11 downto 0);
    begin
        controler: entity work.controler(RTL)
        port map(
            instruction => instruction,
            -- Output for regsisters and ALU --
            opcode => opcode,
            sel_in => sel_in,
            sel_out_a => sel_out_a,
            sel_out_b => sel_out_b,
            sel_out_c => sel_out_c,
            -- Output for FSM --
            en_calc => en_calc,
            en_registers => en_registers,
            en_PC => en_PC,
            en_addr => en_addr,
            en_w_mem => en_w_mem,
            en_r_mem => en_r_mem,
            en_instr => en_instr,
            mem_access_mux => mem_access_mux,
            mux_instr => mux_instr,
            mux_PC => mux_PC,
            mem_access_type => mem_access_type,
            -- Imm output --
            imm => imm   
       );
       
       process_testID : process
       begin
        instruction <= "01010101000000001111100010000000";
        wait for 10*period;
        instruction <= "00010101000110001111100000000101";
        wait for 10*period;
        instruction <= "00010101010000001011100110001101";
        wait for 10*period;
        instruction <= "00001010100100001111010100011110";
       end process;
    
    end Behavioral;
----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 24/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.cpu_defs_pack.all;

entity test_ID is
    --  Port ( );
end test_ID;
    
architecture Behavioral of test_ID is
constant period: time :=20ns;
signal instruction : data_type;
-- Output for regsisters and ALU --
signal opcode : opcode_type;
signal sel_in : bit_vector(1 downto 0);
signal sel_out_a : bit_vector(1 downto 0);
signal sel_out_b : bit_vector(1 downto 0);
signal sel_out_c : bit_vector(1 downto 0);
-- Output for FSM input --
signal cmd_calc : std_logic := '0';
signal calc_on_PC : std_logic := '0';
signal op_w_mem : std_logic := '0';
signal op_r_mem : std_logic := '0';
signal mem_word : std_logic := '0';
signal mem_hword : std_logic := '0';
signal mem_byte : std_logic := '0';
-- Imm output --
signal imm : bit_vector(11 downto 0);
begin
    ID: entity work.instruction_decoder(Behavioral)
    port map(
        instruction => instruction,
        -- Output for regsisters and ALU --
        opcode => opcode,
        sel_in => sel_in,
        sel_out_a => sel_out_a,
        sel_out_b => sel_out_b,
        sel_out_c => sel_out_c,
        -- Output for FSM input --
        cmd_calc => cmd_calc,
        calc_on_PC => calc_on_PC,
        op_w_mem => op_w_mem,
        op_r_mem => op_r_mem,
        mem_word => mem_word,
        mem_hword => mem_hword,
        mem_byte => mem_byte,
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
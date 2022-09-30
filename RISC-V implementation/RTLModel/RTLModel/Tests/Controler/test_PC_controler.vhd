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

entity test_PC_controler is
--  Port ( );
end test_PC_controler;

architecture Behavioral of test_PC_controler is
    constant period: time :=20ns;
    signal reg1_content : data_type;
    signal reg2_content : data_type;
    signal opcode : opcode_type;
    signal pc_incr : addr_type := "0000000000000000";
    signal imm : bit_vector(11 downto 0);
    signal pc : addr_type := "0000000000000000";
begin
    controler: entity worK.PC_controler(RTL)
    port map(
        reg1_content => reg1_content,
        reg2_content => reg2_content,
        opcode => opcode,
        pc_incr => pc_incr,
        imm => imm,
        pc => pc
    );
    
    
    process_test: process begin
        reg1_content <= (others => '0');
        reg2_content <= (others => '0');
        opcode <= code_beq;
        imm <= "000000000111";
        wait for 10*period;
        reg2_content <= (others => '1');
        wait for 10*period;
        opcode <= code_jal;
        wait for 10*period;
        opcode <= code_blt;
        wait for 10*period;
        opcode <= code_bge;
    end process;

end Behavioral;

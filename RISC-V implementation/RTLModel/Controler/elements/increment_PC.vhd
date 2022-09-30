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

entity increment_PC is
    Port(
        pc : in addr_type;
        pc_incr : out addr_type
    );
end increment_PC;

architecture RTL of increment_PC is 
    signal adder_input : data_type := "0000000000000000" & pc;
    signal adder_output : data_type;
    begin
        add: entity work.adder(Behavioral)
        port map(
            a	=>	adder_input,
            b	=>	"00000000000000000000000000000100",
            neg_b	=>	'0',
            s	=>	adder_output
        ); 
        
        pc_incr <= adder_output(15 downto 0);
        
end RTL;
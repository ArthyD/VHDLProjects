----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 19/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;

entity ALU is
    Port (
            operand1       :       in      data_type;
            operand2       :       in      data_type;
            operation      :       in	   opcode_type;
            result         :       out     data_type
     );
end ALU;

architecture Behavioral of ALU is
    signal out_add : data_type:=(others =>'0');   
    signal out_sub : data_type:=(others =>'0');   
    signal out_logic_unit : data_type:=(others =>'0');
    signal out_shifter : data_type:=(others =>'0');
begin


add: entity work.adder(Behavioral)
port map(
    a	=>	operand1,
    b	=>	operand2,
    neg_b	=>	'0',
    s	=>	out_add
);

sub: entity work.adder(Behavioral)
port map(
    a	=>	operand1,
    b	=>	operand2,
    neg_b	=>	'1',
    s	=>	out_sub
);


logic: entity work.logic_unit(Behavioral)
port map(
    a => operand1,
    b => operand2,
    code => operation,
    s => out_logic_unit
);

shifter: entity work.shifter(Behavioral)
port map(
    a => operand1,
    code => operation,
    s => out_shifter
);


    process_ALU : process(operand1,operand2,operation) begin
    case operation is
        when code_add => result <= out_add;
        when code_sub => result <= out_sub;
        when code_and | code_or | code_xor => result <= out_logic_unit;
        when code_sra | code_sll | code_srl => result <= out_shifter;
        when others => null;
        end case;
    end process;
end Behavioral;
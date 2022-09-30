----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 19/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;

entity adder is
Port (
        a       :       in      data_type;
        b       :       in      data_type;
	neg_b	    :	in	bit;
        s       :       out	data_type
);
end adder;

architecture Behavioral of adder is

signal a_int, b_int, s_int, c_int : data_type;

begin

negate_b: process(a,b,neg_b)
begin
	if neg_b = '1' then
		b_int <= not(b);
	else
		b_int <= b;
	end if;
end process;

a_int <= a;

fa_0: entity work.full_adder(Behavioral)
port map (
        a       =>      a_int(0),
        b       =>      b_int(0),
        cin     =>      neg_b,
        s       =>      s_int(0),
        cout    =>      c_int(1)
);

g_full_adders: for i in 1 to data_width - 2 generate
fa_i: entity work.full_adder(Behavioral)
port map (
	a	=>	a_int(i),
	b	=>	b_int(i),
	cin	=>	c_int(i),
	s	=>	s_int(i),
	cout	=>	c_int(i+1)
);
end generate g_full_adders;

fa_msb: entity work.full_adder(Behavioral)
port map (
        a       =>      a_int(data_width - 1),
        b       =>      b_int(data_width - 1),
        cin     =>      c_int(data_width - 1),
        s       =>      s_int(data_width - 1),
        cout    =>      c_int(0)
);

s <= s_int;

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/06/2022 01:42:22 PM
-- Design Name: 
-- Module Name: test_adder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_adder is
--  Port ( );
Generic (
        input_width : integer := 64
);
end test_adder;

architecture Behavioral of test_adder is
    signal a : integer := 5;
    signal b : integer := 7;
    signal s : integer;
    signal a_bit : std_logic_vector(input_width-1 downto 0);
    signal b_bit : std_logic_vector(input_width-1 downto 0);
    signal s_bit : std_logic_vector(input_width-1 downto 0);
    

begin
a_bit <= std_logic_vector(to_signed(a, input_width));
b_bit <= std_logic_vector(to_signed(b, input_width));
adder: entity work.adder(Behavioral)
port map(
	a	=>	a_bit,
	b	=>	b_bit,
	neg_b	=>	'0',
	s	=>	s_bit
);


s <= to_integer(signed(s_bit));



end Behavioral;


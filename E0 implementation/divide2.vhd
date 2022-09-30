----------------------------------------------------------------------------------
-- Engineer: Docquois Arthur
-- 
-- Create Date: 06/08/2022 02:02:11 PM
-- Module Name: divide2 - Behavioral
-- Project Name: E0 implementation
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divide2 is
    Port ( input : in std_logic_vector(2 downto 0);
           output : out std_logic_vector(1 downto 0));
end divide2;

architecture Behavioral of divide2 is

begin
Divide_update: process(input)
begin
    output <= input(2 downto 1);
end process;

end Behavioral;

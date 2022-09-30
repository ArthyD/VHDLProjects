----------------------------------------------------------------------------------
-- Engineer: Docquois Arthur
-- 
-- Create Date: 06/08/2022 01:59:34 PM
-- Module Name: E0 - Behavioral
-- Project Name: E0 Implementation
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

entity T2 is
    Port ( input : in std_logic_vector(1 downto 0);
           output : out std_logic_vector(1 downto 0));
end T2;

architecture Behavioral of T2 is

begin
T2_update: process(input)
begin
    case input is
    when "00" => output <= "00";
    when "01" => output <= "11";
    when "10" => output <= "01";
    when "11" => output <= "10";
    when others => output <= "00";
    end case;
end process;

end Behavioral;

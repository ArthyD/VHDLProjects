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

entity T1 is
    Port ( input : in std_logic_vector(1 downto 0);
           output : out std_logic_vector(1 downto 0));
end T1;

architecture Behavioral of T1 is

begin
T1_update: process(input)
begin
    output <= input;
end process;


end Behavioral;

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

entity testE0WithSRL is
Port ( rst : out std_logic;
       clk : out std_logic);
end testE0WithSRL;

architecture Behavioral of testE0WithSRL is

signal clk_s: std_logic := '0';
constant period : time := 20ns;
begin
    clk <= clk_s;
    clk_s<= not clk_s after period/2;
    
    testE0_process : process
    begin
        rst<='1';
        wait for 2*period;
        rst <='0';
        wait for 200*period;
    end process;


end Behavioral;

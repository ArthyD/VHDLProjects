----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.09.2021 09:27:18
-- Design Name: 
-- Module Name: vga_splice - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_splice is
    Port ( active_video : in STD_LOGIC;
           vid_data : in STD_LOGIC_VECTOR (23 downto 0);
           VGA_R : out STD_LOGIC_VECTOR(3 downto 0);
           VGA_G : out STD_LOGIC_VECTOR(3 downto 0);
           VGA_B : out STD_LOGIC_VECTOR(3 downto 0));
end vga_splice;

architecture Behavioral of vga_splice is

begin

    process(vid_data,active_video)
    begin
        if active_video = '1' then
            VGA_R <= vid_data(19 downto 16);
            VGA_G <= vid_data(11 downto  8);
            VGA_B <= vid_data( 3 downto  0);
        else
            VGA_R <= (others => '0');
            VGA_G <= (others => '0');
            VGA_B <= (others => '0');
        end if;
    end process;

end Behavioral;

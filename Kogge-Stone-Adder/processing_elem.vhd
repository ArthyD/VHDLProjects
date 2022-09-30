----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2022 12:15:54 PM
-- Design Name: 
-- Module Name: processing_elem - Behavioral
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

entity processing_elem is
port (
	Gi	:	in	std_logic;
	Gj	:	in	std_logic;
	Pi	:	in	std_logic;
	Pj	:	in	std_logic;
	P	:	out	std_logic;
	G	:	out	std_logic
);
end processing_elem;

architecture Behavioral of processing_elem is
begin
P <= Pi and Pj;
G <= Gi or (Gj and Pi);

end Behavioral;
 

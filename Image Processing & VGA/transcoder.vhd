----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2022 09:43:35
-- Design Name: 
-- Module Name: transcoder - Behavioral
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

entity transcoder is
  Port ( 
      t_data_in : in std_logic_vector(7 downto 0);
      t_valid_s : in std_logic;
      sof_in : in std_logic;
      eol_in : in std_logic;
      t_ready_m : in std_logic;
      
      t_ready : out std_logic;
      t_valid : out std_logic;
      t_data_out : out std_logic_vector(23 downto 0);
      sof_out : out std_logic;
      eol_out : out std_logic);
end transcoder;

architecture Behavioral of transcoder is

begin

t_data_out <= t_data_in & t_data_in & t_data_in;
eol_out <= eol_in;
sof_out <= sof_in;
t_ready <= t_ready_m;
t_valid <= t_valid_s;


end Behavioral;

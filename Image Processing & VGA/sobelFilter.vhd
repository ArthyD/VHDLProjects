----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2022 16:22:35
-- Design Name: 
-- Module Name: sobelFilter - Behavioral
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

entity sobelFilter is
  Port ( 
  threshold : in std_logic_vector(11 downto 0);
  t_ready_m : in std_logic;
  t_valid_s : in std_logic;
  t_data_in : in std_logic_vector(71 downto 0) := (others => '0'); --9 pixels of lenth 8
  sof_in : in std_logic;
  eol_in : in std_logic; 
  
  sobel_t_ready : out std_logic;
  sobel_t_valid : out std_logic;
  sobel_t_data : out std_logic_vector(7 downto 0) := (others=>'0');
  sobel_sof_out : out std_logic;
  sobel_eol_out : out std_logic 
  
  );
end sobelFilter;


architecture Behavioral of sobelFilter is

signal sobel : unsigned(11 downto 0);
signal tmp1 : signed(10 downto 0);
signal tmp2 : signed(10 downto 0);
begin

sobel_sof_out <= sof_in;
sobel_eol_out <= eol_in;
sobel_t_ready <= t_ready_m;
sobel_t_valid <= t_valid_s;

tmp1 <= signed("000" & t_data_in(71 downto 64)) + signed("00" & t_data_in(63 downto 56) & "0") + signed("000" & t_data_in(55 downto 48)) - (signed("000" & t_data_in(23 downto 16)) + signed("00" & t_data_in(15 downto 8) & "0") + signed("000" & t_data_in(7 downto 0)));

tmp2 <= signed("000" & t_data_in(71 downto 64)) + signed("00" & t_data_in(47 downto 40) & "0") + signed("000" & t_data_in(23 downto 16)) - (signed("000" & t_data_in(55 downto 48)) + signed("00" & t_data_in(31 downto 24) & "0") + signed("000" & t_data_in(7 downto 0)));


sobel <= unsigned(abs("0" & tmp1) + abs("0" & tmp2));

sobel_t_data <= (others =>'1') when sobel > unsigned(threshold) else (others =>'0');


end Behavioral;




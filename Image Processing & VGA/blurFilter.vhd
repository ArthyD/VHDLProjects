----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2022 16:22:35
-- Design Name: 
-- Module Name: blurFilter - Behavioral
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

entity blurFilter is
  Port ( 
  
  t_ready_m : in std_logic;
  t_valid_s : in std_logic;
  t_data_in : in std_logic_vector(71 downto 0); --9 pixels of lenth 8
  sof_in : in std_logic;
  eol_in : in std_logic; 
  
  blur_t_ready : out std_logic;
  blur_t_valid : out std_logic;
  blur_t_data : out std_logic_vector(7 downto 0) := (others=>'0');
  blur_sof_out : out std_logic;
  blur_eol_out : out std_logic 
  
  );
end blurFilter;


architecture Behavioral of blurFilter is

signal blur : std_logic_vector(7 downto 0) := (others=>'0');
begin

blur_sof_out <= sof_in;
blur_eol_out <= eol_in;
blur_t_ready <= t_ready_m;
blur_t_valid <= t_valid_s;

 
 blur<= std_logic_vector( unsigned("0000" & t_data_in(71 downto 68)) + unsigned("000" & t_data_in(63 downto 59)) + unsigned("0000" & t_data_in(55 downto 52)) + 
 unsigned("000" & t_data_in(47 downto 43)) + unsigned("00" & t_data_in(39 downto 34)) + unsigned("000" & t_data_in(31 downto 27)) + unsigned("0000" & t_data_in(23 downto 20))
 + unsigned("000" & t_data_in(15 downto 11)) + unsigned("0000" & t_data_in(7 downto 4)) );
 

blur_t_data <= blur(6 downto 0) & "0";

end Behavioral;

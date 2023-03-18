----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2022 11:49:43
-- Design Name: 
-- Module Name: greyfilter - Behavioral
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

entity greyfilter is
  Port (
    clk : in std_logic;
    rst_n : in std_logic;
    t_data_s : in std_logic_vector(23 downto 0);
    t_valid_s : in std_logic;
    sof_in : in std_logic;
    eol_in : in std_logic;
    t_ready_m : in std_logic;
    
    grey_t_ready : out std_logic;
    grey_t_valid : out std_logic;
    grey_t_data_m : out std_logic_vector(7 downto 0);
    grey_sof_out : out std_logic;
    grey_eol_out : out std_logic
   );
end greyfilter;



architecture Behavioral of greyfilter is

constant N : integer := 7;

function F_REAL_TO_UNS(COEFF: real; N : integer) return unsigned is
    variable var : unsigned(N downto 0);
    begin
        var := to_unsigned(integer(COEFF * real(2**N)), N+1); --(1,N)
        return var;
 end function;
 
type t_state is (START, SEND);
signal current_state : t_state := START;

constant R_coeff_uns : unsigned(N downto 0) := F_REAL_TO_UNS(0.299,N); --(1,N)
constant G_coeff_uns : unsigned(N downto 0) := F_REAL_TO_UNS(0.587,N);
constant B_coeff_uns : unsigned(N downto 0) := F_REAL_TO_UNS(0.114,N);

signal grey : std_logic_vector(N+8 downto 0);

begin

--check : process(clk, rst_n)
--variable red :  unsigned(N+8 downto 0); --(9,N)
--variable green : unsigned(N+8 downto 0);
--variable blue : unsigned(N+8 downto 0); 
--begin 
      
-- if rising_edge(clk) then
--    if (rst_n = '0') then
--            grey_t_ready <= '1';
--            grey_t_valid <= '0';
--            grey_t_data_m <= (others => '0');
            
--            grey <= (others => '0');
--            current_state <= START;
--     else
     
--     case current_state is
--        when START =>
--            if t_valid_s = '1' then
--                grey_t_ready <= '1';
--                grey_t_valid <= '0';
--                current_state <= SEND;
--            end if;
       
            
--         when SEND =>
--               if t_ready_m = '1' then
--               grey_t_ready <= '0';
--               grey_t_valid <= '1';
--               red := unsigned(t_data_s(23 downto 16)) * R_coeff_uns; --(8,0)*(1,N) => (9,N)
--               green := unsigned(t_data_s(15 downto 8))* G_coeff_uns; --(9,N)
--               blue := unsigned(t_data_s(7 downto 0)) * B_coeff_uns; --(9,N)
--               grey <= std_logic_vector(red + green + blue); --(9,N)
--               grey_t_data_m(7 downto 0) <= "0000" & grey(N+7 downto N+4);
--               grey_t_data_m(15 downto 8) <= "0000" & grey(N+7 downto N+4);
--               grey_t_data_m(23 downto 16) <= "0000" & grey(N+7 downto N+4);
                
--               current_state <= START;
--               end if;
          
       
--       end case;
       
--       end if;
--       end if;
            
           
--end process;

grey_sof_out <= sof_in;
grey_eol_out <= eol_in;
grey_t_valid <= t_valid_s;
grey_t_ready <= t_ready_m;

grey <= std_logic_vector(unsigned(t_data_s(23 downto 16)) * R_coeff_uns + unsigned(t_data_s(15 downto 8))* G_coeff_uns + unsigned(t_data_s(7 downto 0)) * B_coeff_uns); --(9,N)
grey_t_data_m <= "0000" & grey(N+7 downto N+4);
--grey_t_data_m(15 downto 8) <= "0000" & grey(N+7 downto N+4);
--grey_t_data_m(23 downto 16) <= "0000" & grey(N+7 downto N+4);


end Behavioral;

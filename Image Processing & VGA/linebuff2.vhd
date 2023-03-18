----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2022 15:52:27
-- Design Name: 
-- Module Name: linebuff2 - Behavioral
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

entity lineBuffer2 is
  generic(
		X_DIM  : integer := 320;
		Y_DIM  : integer := 128;
		FRAME_X : integer := 640;
		FRAME_Y : integer := 480
	);
  Port (
      clk : in std_logic;
      rst_n : in std_logic;
      t_data_in : in std_logic_vector(7 downto 0);
      t_valid_s : in std_logic;
      sof_in : in std_logic;
      eol_in : in std_logic;
      t_ready_m : in std_logic;
      
      buff_t_ready : out std_logic;
      buff_t_valid : out std_logic;
      buff_t_data_m : out std_logic_vector(71 downto 0); --9 pixels of lenth 8
      buff_sof_out : out std_logic :='0';
      buff_eol_out : out std_logic := '0'
  
   );
end lineBuffer2;

architecture archi of lineBuffer2 is
    type t_line_buf is array (FRAME_X+2 downto 0) of std_logic_vector(9 downto 0);
    signal ligne1 : t_line_buf := (others=>(others=>'0'));
    signal ligne2 : t_line_buf := (others=>(others=>'0'));
    type t_line_buf3 is array (2 downto 0) of std_logic_vector(9 downto 0);
    signal last3 : t_line_buf3 := (others=>(others=>'0'));
    
begin

   process(clk, rst_n)
   begin
       if(rst_n = '0')then
            ligne1 <= (others=>(others=>'0'));
            ligne2 <= (others=>(others=>'0'));
            last3 <= (others=>(others=>'0'));
       elsif(rising_edge(clk))then
           if(sof_in = '1') then
                ligne1 <= (others=>(others=>'0'));
                ligne2 <= (others=>(others=>'0'));
                last3 <= (others=>(others=>'0'));
           end if;
           if(t_valid_s='1') then
               if(t_ready_m='1') then
                   ligne1(FRAME_X+2 downto 1) <= ligne1(FRAME_X+1 downto 0);
                   ligne1(0) <= ligne2(FRAME_X-1);
                   ligne2(FRAME_X+2 downto 1) <= ligne2(FRAME_X+1 downto 0);
                   ligne2(0) <= sof_in & eol_in & t_data_in  ;
                   last3(2 downto 1) <= last3(1 downto 0);
                   last3(0) <= sof_in & eol_in & t_data_in;
               end if;     
            end if;
           buff_t_data_m <= ligne1(FRAME_X)(7 downto 0) & ligne1(FRAME_X+1)(7 downto 0) & ligne1(FRAME_X+2)(7 downto 0)  & ligne2(FRAME_X)(7 downto 0) & ligne2(FRAME_X+1)(7 downto 0) & ligne2(FRAME_X+2)(7 downto 0) & last3(2)(7 downto 0) & last3(1)(7 downto 0) & last3(0)(7 downto 0);
           buff_sof_out <= ligne1(FRAME_X+1)(9);
           buff_eol_out <= ligne1(FRAME_X+1)(8); 
           if(t_ready_m='0') then
                buff_t_ready<='0';
           else
                buff_t_ready<='1';
           end if;
           if(t_valid_s='0') then
                buff_t_valid<='0';
           else
                buff_t_valid<='1';
           end if;           
       end if;
      end process;


end archi;

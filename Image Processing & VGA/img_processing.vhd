----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2022 11:35:16
-- Design Name: 
-- Module Name: img_processing - Behavioral
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

entity img_processing is
generic(
		X_DIM  : integer := 320;
		Y_DIM  : integer := 128;
		FRAME_X : integer := 640;
		FRAME_Y : integer := 480
	);
  Port ( 
      clk : in std_logic;
      rst_n : in std_logic;
      t_ready_m : in std_logic;
      t_valid_s : in std_logic;
      t_data_in : in std_logic_vector(23 downto 0) := (others => '0'); --9 pixels of lenth 8
      sof_in : in std_logic;
      eol_in : in std_logic; 
      mode : in std_logic_vector(2 downto 0);
      threshold : in std_logic_vector(11 downto 0);
      
      img_t_ready : out std_logic;
      img_t_valid : out std_logic;
      img_t_data : out std_logic_vector(23 downto 0) := (others=>'0');
      img_sof_out : out std_logic;
      img_eol_out : out std_logic 
  
  );
end img_processing;



architecture Behavioral of img_processing is

component greyfilter is
    port(
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
end component;


component blurFilter is
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
end component;

component sobelFilter is
  Port ( 

        t_ready_m : in std_logic;
        t_valid_s : in std_logic;
        t_data_in : in std_logic_vector(71 downto 0) := (others => '0'); --9 pixels of lenth 8
        sof_in : in std_logic;
        eol_in : in std_logic;
        threshold : in std_logic_vector(11 downto 0); 
        
        sobel_t_ready : out std_logic;
        sobel_t_valid : out std_logic;
        sobel_t_data : out std_logic_vector(7 downto 0) := (others=>'0');
        sobel_sof_out : out std_logic;
        sobel_eol_out : out std_logic 

);
end component;

component lineBuffer2 is
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
end component;

component transcoder is
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
        eol_out : out std_logic
    );
end component;

signal grey_t_ready : std_logic;
signal grey_t_valid : std_logic;
signal grey_t_data_m : std_logic_vector(7 downto 0);
signal grey_sof_out : std_logic;
signal grey_eol_out : std_logic;

signal blur1_t_ready : std_logic;
signal blur1_t_valid : std_logic;
signal blur1_t_data : std_logic_vector(7 downto 0) := (others=>'0');
signal blur1_sof_out : std_logic;
signal blur1_eol_out : std_logic;

signal blur2_t_ready : std_logic;
signal blur2_t_valid : std_logic;
signal blur2_t_data : std_logic_vector(7 downto 0) := (others=>'0');
signal blur2_sof_out : std_logic;
signal blur2_eol_out : std_logic;

signal sobel1_t_ready : std_logic;
signal sobel1_t_valid : std_logic;
signal sobel1_t_data : std_logic_vector(7 downto 0) := (others=>'0');
signal sobel1_sof_out : std_logic;
signal sobel1_eol_out : std_logic;

signal sobel2_t_ready : std_logic;
signal sobel2_t_valid : std_logic;
signal sobel2_t_data : std_logic_vector(7 downto 0) := (others=>'0');
signal sobel2_sof_out : std_logic;
signal sobel2_eol_out : std_logic;

signal buff1_t_ready : std_logic;
signal buff1_t_valid : std_logic;
signal buff1_t_data_m : std_logic_vector(71 downto 0); --9 pixels of lenth 8
signal buff1_sof_out : std_logic :='0';
signal buff1_eol_out : std_logic := '0';

signal buff2_t_ready : std_logic;
signal buff2_t_valid : std_logic;
signal buff2_t_data_m : std_logic_vector(71 downto 0); --9 pixels of lenth 8
signal buff2_sof_out : std_logic :='0';
signal buff2_eol_out : std_logic := '0';

signal buff3_t_ready : std_logic;
signal buff3_t_valid : std_logic;
signal buff3_t_data_m : std_logic_vector(71 downto 0); --9 pixels of lenth 8
signal buff3_sof_out : std_logic :='0';
signal buff3_eol_out : std_logic := '0';

signal buff4_t_ready : std_logic;
signal buff4_t_valid : std_logic;
signal buff4_t_data_m : std_logic_vector(71 downto 0); --9 pixels of lenth 8
signal buff4_sof_out : std_logic :='0';
signal buff4_eol_out : std_logic := '0';

signal transco_t_ready : std_logic;
signal transco_t_valid : std_logic;
signal transco_t_data_out : std_logic_vector(23 downto 0);
signal transco_sof_out : std_logic;
signal transco_eol_out : std_logic;
        

signal tmp_t_ready_in_grey : std_logic;
signal tmp_t_valid_out : std_logic;
signal tmp_t_data_m : std_logic_vector(7 downto 0); 
signal tmp_sof_out : std_logic :='0';
signal tmp_eol_out : std_logic := '0';



begin
Grey: greyfilter
    port map(
      clk => clk,
      rst_n => rst_n,
      t_data_s => t_data_in,
      t_valid_s => t_valid_s,
      sof_in => sof_in,
      eol_in => eol_in,
      t_ready_m => tmp_t_ready_in_grey,
      grey_t_ready => grey_t_ready,
      grey_t_valid => grey_t_valid,
      grey_t_data_m => grey_t_data_m,
      grey_sof_out => grey_sof_out,
      grey_eol_out => grey_eol_out 
    );
    
LineBuffer1: lineBuffer2
generic map(
		X_DIM  => X_DIM,
		Y_DIM => Y_DIM,
		FRAME_X => FRAME_X,
		FRAME_Y => FRAME_Y
	)
  port map (
      clk => clk,
      rst_n => rst_n,
      t_data_in => grey_t_data_m,
      t_valid_s => grey_t_valid,
      sof_in => grey_sof_out,
      eol_in => grey_eol_out,
      t_ready_m => blur1_t_ready ,
      buff_t_ready => buff1_t_ready,
      buff_t_valid => buff1_t_valid,
      buff_t_data_m => buff1_t_data_m,
      buff_sof_out => buff1_sof_out,
      buff_eol_out => buff1_eol_out
   );
   
 Blur1 : blurFilter
 port map(
         t_ready_m => buff2_t_ready,
         t_valid_s => buff1_t_valid,
         t_data_in => buff1_t_data_m,
         sof_in => buff1_sof_out,
         eol_in => buff1_eol_out,
         blur_t_ready => blur1_t_ready,
         blur_t_valid => blur1_t_valid,
         blur_t_data => blur1_t_data,
         blur_sof_out => blur1_sof_out,
         blur_eol_out => blur1_eol_out
 );
 
 LineBuff2: lineBuffer2
 generic map(
         X_DIM  => X_DIM,
         Y_DIM => Y_DIM,
         FRAME_X => FRAME_X,
         FRAME_Y => FRAME_Y
     )
   port map (
       clk => clk,
       rst_n => rst_n,
       t_data_in => blur1_t_data,
       t_valid_s => blur1_t_valid,
       sof_in => blur1_sof_out,
       eol_in => blur1_eol_out,
       t_ready_m => sobel1_t_ready ,
       buff_t_ready => buff2_t_ready,
       buff_t_valid => buff2_t_valid,
       buff_t_data_m => buff2_t_data_m,
       buff_sof_out => buff2_sof_out,
       buff_eol_out => buff2_eol_out
    );
    
Sobel1: sobelFilter
  port map ( 

      t_ready_m => transco_t_ready,
      t_valid_s => buff2_t_valid,
      t_data_in => buff2_t_data_m,
      sof_in => buff2_sof_out,
      eol_in => buff2_eol_out,
      sobel_t_ready => sobel1_t_ready,
      sobel_t_valid => sobel1_t_valid,
      sobel_t_data => sobel1_t_data,
      sobel_sof_out => sobel1_sof_out,
      sobel_eol_out => sobel1_eol_out,
      threshold => threshold

);

 LineBuffer3: lineBuffer2
 generic map(
         X_DIM  => X_DIM,
         Y_DIM => Y_DIM,
         FRAME_X => FRAME_X,
         FRAME_Y => FRAME_Y
     )
   port map (
       clk => clk,
       rst_n => rst_n,
       t_data_in => grey_t_data_m,
       t_valid_s => grey_t_valid,
       sof_in => grey_sof_out,
       eol_in => grey_eol_out,
       t_ready_m => sobel2_t_ready ,
       buff_t_ready => buff3_t_ready,
       buff_t_valid => buff3_t_valid,
       buff_t_data_m => buff3_t_data_m,
       buff_sof_out => buff3_sof_out,
       buff_eol_out => buff3_eol_out
    );
    
Sobel2: sobelFilter
  port map ( 

      t_ready_m => transco_t_ready,
      t_valid_s => buff3_t_valid,
      t_data_in => buff3_t_data_m,
      sof_in => buff3_sof_out,
      eol_in => buff3_eol_out,
      sobel_t_ready => sobel2_t_ready,
      sobel_t_valid => sobel2_t_valid,
      sobel_t_data => sobel2_t_data,
      sobel_sof_out => sobel2_sof_out,
      sobel_eol_out => sobel2_eol_out,
      threshold => threshold

);

LineBuffer4: lineBuffer2
generic map(
		X_DIM  => X_DIM,
		Y_DIM => Y_DIM,
		FRAME_X => FRAME_X,
		FRAME_Y => FRAME_Y
	)
  port map (
      clk => clk,
      rst_n => rst_n,
      t_data_in => grey_t_data_m,
      t_valid_s => grey_t_valid,
      sof_in => grey_sof_out,
      eol_in => grey_eol_out,
      t_ready_m => blur2_t_ready,
      buff_t_ready => buff4_t_ready,
      buff_t_valid => buff4_t_valid,
      buff_t_data_m => buff4_t_data_m,
      buff_sof_out => buff4_sof_out,
      buff_eol_out => buff4_eol_out
   );
   
 Blur2 : blurFilter
 port map(
         t_ready_m => transco_t_ready,
         t_valid_s => buff4_t_valid,
         t_data_in => buff4_t_data_m,
         sof_in => buff4_sof_out,
         eol_in => buff4_eol_out,
         blur_t_ready => blur2_t_ready,
         blur_t_valid => blur2_t_valid,
         blur_t_data => blur2_t_data,
         blur_sof_out => blur2_sof_out,
         blur_eol_out => blur2_eol_out
 );
 
Transco : transcoder
port map(
        t_data_in => tmp_t_data_m,
        t_valid_s => tmp_t_valid_out,
        sof_in => tmp_sof_out,
        eol_in => tmp_eol_out,
        t_ready_m => t_ready_m,
        t_ready => transco_t_ready,
        t_valid => transco_t_valid,
        t_data_out => transco_t_data_out,
        sof_out => transco_sof_out,
        eol_out => transco_eol_out
);

outputProcess : process(clk,mode)
begin
    case mode is
        when "001" => -- grey         
            tmp_t_data_m <= grey_t_data_m;
            img_t_data <= transco_t_data_out;
            
            tmp_sof_out <= grey_sof_out;
            img_sof_out <= transco_sof_out;
            
            tmp_eol_out <= grey_eol_out;
            img_eol_out <= transco_eol_out;
            
            tmp_t_valid_out <= grey_t_valid;
            img_t_valid <= transco_t_valid;
            
            tmp_t_ready_in_grey <= t_ready_m;
            img_t_ready <= grey_t_ready;
        when "011" => -- grey + blur
            tmp_t_data_m <= blur1_t_data;
            img_t_data <= transco_t_data_out;
            
            tmp_sof_out <= blur1_sof_out;
            img_sof_out <= transco_sof_out;
            
            tmp_eol_out <= blur1_eol_out;
            img_eol_out <= transco_eol_out;
            
            tmp_t_valid_out <= blur1_t_valid;
            img_t_valid <= transco_t_valid;
            
            tmp_t_ready_in_grey <= buff4_t_ready;
            img_t_ready <= grey_t_ready;
        when "111" => -- grey + blur + sobel
            tmp_t_data_m <= sobel1_t_data;
            img_t_data <= transco_t_data_out;
            
            tmp_sof_out <= sobel1_sof_out;
            img_sof_out <= transco_sof_out;
            
            tmp_eol_out <= sobel1_eol_out;
            img_eol_out <= transco_eol_out;
            
            tmp_t_valid_out <= sobel1_t_valid;
            img_t_valid <= transco_t_valid;
            
            tmp_t_ready_in_grey <= buff1_t_ready;
            img_t_ready <= grey_t_ready;
        when "101" => -- gery + sobel
            tmp_t_data_m <= sobel2_t_data;
            img_t_data <= transco_t_data_out;
            
            tmp_sof_out <= sobel2_sof_out;
            img_sof_out <= transco_sof_out;
            
            tmp_eol_out <= sobel2_eol_out;
            img_eol_out <= transco_eol_out;
            
            tmp_t_valid_out <= sobel2_t_valid;
            img_t_valid <= transco_t_valid;
            
            tmp_t_ready_in_grey <= buff3_t_ready;
            img_t_ready <= grey_t_ready;
        when others => -- no process
            img_t_data <= t_data_in;
            img_sof_out <= sof_in;
            img_eol_out <= eol_in;
            img_t_valid <= t_valid_s;
            img_t_ready <= t_ready_m;
        
     end case;
end process;
end Behavioral;




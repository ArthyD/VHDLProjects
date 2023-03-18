----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.11.2022 09:39:40
-- Design Name: 
-- Module Name: lineBuffer - Behavioral
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

entity lineBuffer is
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
end lineBuffer;

architecture Behavioral of lineBuffer is

--signal pixel : std_logic_vector(7 downto 0);


type t_line_buf is array (FRAME_X-1 downto 0) of std_logic_vector(7 downto 0);

signal ligne1 : t_line_buf := (others=>(others=>'0'));
signal ligne2 : t_line_buf := (others=>(others=>'0'));
signal ligne3 : t_line_buf := (others=>(others=>'0'));
signal ligne4 : t_line_buf := (others=>(others=>'0'));
 
type t_state is (START, FILL, PROCESSANDSEND, RECEIVE);
signal current_state : t_state := START;
signal futur_state : t_state;

constant FRAME_SIZE : integer := FRAME_X*FRAME_Y;
signal lineCnt  : integer range 0 to FRAME_X;
signal frameCnt : integer range 0 to FRAME_SIZE;
signal rowCnt  : integer := 1;


begin


process (clk, rst_n) is
begin
  if rst_n = '0' then
    current_state <= START;
--    buff_t_ready <= '0';
--    buff_t_valid <= '0';
    --buff_t_data_m <= (others => '0');
  elsif rising_edge(clk) then
    current_state <= futur_state;
  end if;
end process;

stateCompute : process(current_state, t_valid_s, t_ready_m,lineCnt,rowCnt)
begin
  case current_state is 
            
  when START =>
       if rowCnt = 2 and lineCnt = FRAME_X-1 then 
            buff_t_valid <= '1';
            buff_t_ready <= '0';
            futur_state <= PROCESSANDSEND;
            buff_sof_out <= '1';
       else
           buff_t_ready <= '1';
           buff_t_valid <= '0';
          futur_state <= FILL;       
       end if; 
       
  when FILL => 
        if t_valid_s = '0' then
              buff_t_ready <= '1';
              buff_t_valid <= '0';
              futur_state <= FILL;
          else 
              buff_t_ready <= '1';
              buff_t_valid <= '0';
              futur_state <= START;
          end if;
            
            
  when PROCESSANDSEND =>
        if rowCnt = 2 and lineCnt = 0 then
            buff_sof_out <= '1';
        else 
            buff_sof_out <= '0';
        end if;
        if lineCnt = FRAME_X - 1 then 
            buff_eol_out <= '1';
        else 
            buff_eol_out <= '0';
        end if;
        if t_ready_m = '0' then
            buff_t_valid <= '1';
            buff_t_ready <= '0';     
            futur_state <= PROCESSANDSEND;
        elsif t_ready_m = '1' then --and rowCnt < FRAME_Y - 3 then
            buff_t_valid <= '0';
            buff_t_ready <= '1';
            futur_state <= RECEIVE;
        end if;
  
            
       
   when RECEIVE =>
        if t_valid_s = '0' then
            buff_t_valid <= '0';
            buff_t_ready <= '1';
            futur_state <= RECEIVE;
        else 
            buff_t_valid <= '1';
            buff_t_ready <= '0';
            futur_state <= PROCESSANDSEND;
        end if;
   
   end case;
            
end process;

compute : process(current_state,sof_in)
variable copie2 : t_line_buf;
variable copie3 : t_line_buf;
variable copie4 : t_line_buf;
begin
    case current_state is
        when START =>
            if sof_in = '1' then
                lineCnt <= 0;

            end if;
            if lineCnt = FRAME_X - 1 then
                     rowCnt <= rowCnt + 1;
                     lineCnt <= 0;
            else
                lineCnt <= lineCnt + 1;
            end if;            
            

        
     when FILL =>
        if rowCnt = 1 then 
             ligne2(lineCnt) <= t_data_in;
        elsif rowCnt = 2 then
             ligne3(lineCnt) <= t_data_in;
             
        end if; 
     
     
     when PROCESSANDSEND =>
        
        if rowCnt = FRAME_Y - 1 then 
         if lineCnt = 0 then
               buff_t_data_m(7 downto 0) <= (others=>'0');
               buff_t_data_m(15 downto 8) <= (others=>'0');
               buff_t_data_m(23 downto 16) <= (others=>'0');
               buff_t_data_m(31 downto 24) <= ligne2(1);
               buff_t_data_m(39 downto 32) <= ligne2(0);
               buff_t_data_m(47 downto 40) <= (others=>'0');
               buff_t_data_m(55 downto 48) <= ligne1(1);
               buff_t_data_m(63 downto 56) <= ligne1(0);
               buff_t_data_m(71 downto 64) <= (others=>'0');
          elsif lineCnt = FRAME_X-1 then 
              buff_t_data_m(7 downto 0) <= (others=>'0');
              buff_t_data_m(15 downto 8) <= (others=>'0');
              buff_t_data_m(23 downto 16) <= (others=>'0');
              buff_t_data_m(31 downto 24) <= (others=>'0');
              buff_t_data_m(39 downto 32) <= ligne2(lineCnt);
              buff_t_data_m(47 downto 40) <= ligne2(lineCnt - 1);
              buff_t_data_m(55 downto 48) <= (others=>'0');
              buff_t_data_m(63 downto 56) <= ligne1(lineCnt);
              buff_t_data_m(71 downto 64) <= ligne1(lineCnt - 1);         
         else
              buff_t_data_m(7 downto 0) <= (others=>'0');
              buff_t_data_m(15 downto 8) <= (others=>'0');
              buff_t_data_m(23 downto 16) <= (others=>'0');
              buff_t_data_m(31 downto 24) <= ligne2(lineCnt + 1);
              buff_t_data_m(39 downto 32) <= ligne2(lineCnt);
              buff_t_data_m(47 downto 40) <= ligne2(lineCnt - 1);
              buff_t_data_m(55 downto 48) <= ligne1(lineCnt + 1);
              buff_t_data_m(63 downto 56) <= ligne1(lineCnt);
              buff_t_data_m(71 downto 64) <= ligne1(lineCnt - 1);  
          end if;     
       else              
          if lineCnt = 0 then
                  buff_t_data_m(7 downto 0) <= ligne3(0);
                  buff_t_data_m(15 downto 8) <= ligne3(1);
                  buff_t_data_m(23 downto 16) <= (others=>'0'); 
                  buff_t_data_m(31 downto 24) <= ligne2(0);
                  buff_t_data_m(39 downto 32) <= ligne2(1);
                  buff_t_data_m(47 downto 40) <= (others=>'0'); 
                  buff_t_data_m(55 downto 48) <= ligne1(0);
                  buff_t_data_m(63 downto 56) <= ligne1(1);
                  buff_t_data_m(71 downto 64) <= (others=>'0');                
          
          elsif lineCnt = FRAME_X - 1 then
                  buff_t_data_m(7 downto 0) <= (others=>'0'); 
                  buff_t_data_m(15 downto 8) <= ligne3(lineCnt - 1);
                  buff_t_data_m(23 downto 16) <= ligne3(lineCnt);
                  buff_t_data_m(31 downto 24) <= (others=>'0'); 
                  buff_t_data_m(39 downto 32) <= ligne2(lineCnt - 1);
                  buff_t_data_m(47 downto 40) <= ligne2(lineCnt);
                  buff_t_data_m(55 downto 48) <= (others=>'0'); 
                  buff_t_data_m(63 downto 56) <= ligne1(lineCnt - 1);
                  buff_t_data_m(71 downto 64) <= ligne1(lineCnt);
                  
          else --Cas général
                  buff_t_data_m(7 downto 0) <= ligne3(lineCnt+1);
                  buff_t_data_m(15 downto 8) <= ligne3(lineCnt);
                  buff_t_data_m(23 downto 16) <= ligne3(lineCnt-1);
                  buff_t_data_m(31 downto 24) <= ligne2(lineCnt+1);
                  buff_t_data_m(39 downto 32) <= ligne2(lineCnt);
                  buff_t_data_m(47 downto 40) <= ligne2(lineCnt-1);
                  buff_t_data_m(55 downto 48) <= ligne1(lineCnt + 1);
                  buff_t_data_m(63 downto 56) <= ligne1(lineCnt);
                  buff_t_data_m(71 downto 64) <= ligne1(lineCnt - 1);
          end if;
         end if;

                        
     when RECEIVE => 
     if rowCnt = FRAME_Y -1 and lineCnt = FRAME_X - 1 then
        rowCnt <= 0;
        lineCnt <= 0;    
     else
        if lineCnt = FRAME_X - 1 then
            rowCnt <= rowCnt + 1;
            ligne2 <= copie3;
            ligne3 <= copie4;
            ligne1 <= copie2;
            ligne4 <= (others=>(others =>'0'));
            lineCnt <= 0;
        else 
             ligne4(lineCnt) <= t_data_in;
             lineCnt <= lineCnt + 1;
             copie2 := ligne2;
             copie3 := ligne3;
             copie4 := ligne4;
       end if;
     end if;
        
 end case;

end process;


--buff_sof_out <= sof_in;
--buff_eol_out <= eol_in;

end Behavioral;

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
use IEEE.NUMERIC_STD.ALL;
Use Ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity E0WithSRL is
Port ( cipherstream : out std_logic;
       rst : in std_logic;
       clk : in std_logic);
    
end E0WithSRL;

architecture Behavioral of E0WithSRL is
    signal ct: std_logic_vector(1 downto 0) := "00";
    signal ct_next : std_logic_vector(1 downto 0) := "00";
    signal yt : std_logic_vector(2 downto 0) :="000";
    signal st_next : std_logic_vector(1 downto 0):="00";
    signal lfsr1_out : std_logic;
    signal lfsr2_out : std_logic;
    signal lfsr3_out : std_logic;
    signal lfsr4_out : std_logic;
    signal T2input : std_logic_vector(1 downto 0):="00";
    signal T2out : std_logic_vector(1 downto 0);
    signal T1out : std_logic_vector(1 downto 0) :="00";
    signal stinput : std_logic_vector(2 downto 0):="000";
    
    component LFSR1SRL is
    Port ( clk : in std_logic;
        rst : in std_logic;
           output : out std_logic);
    end component;
    
    component LFSR2SRL is
    Port ( clk : in std_logic;
        rst : in std_logic;
           output : out std_logic);
    end component;
    
    component LFSR3SRL is
    Port ( clk : in std_logic;
        rst : in std_logic;
           output : out std_logic);
    end component;
    
    component LFSR4SRL is
    Port ( clk : in std_logic;
        rst : in std_logic;
           output : out std_logic);
    end component;
    
    component T1 is
    Port ( input : in std_logic_vector(1 downto 0);
           output : out std_logic_vector(1 downto 0));
    end component;
    
    component T2 is
    Port ( input : in std_logic_vector(1 downto 0);
           output : out std_logic_vector(1 downto 0));
    end component;
    
    component divide2 is
    Port ( input : in std_logic_vector(2 downto 0);
           output : out std_logic_vector(1 downto 0));
    end component;
    
    component Shift is 
    Port( input : in std_logic_vector(1 downto 0);
           output : out std_logic_vector(1 downto 0);
           clk : in STD_LOGIC);
    end component;



    
begin
	lfsr1_ent : LFSR1SRL
        port map(
            clk=>clk,
            rst=>rst,
            output=>lfsr1_out
        );
        
        lfsr2_ent : LFSR2SRL
        port map(
            clk=>clk,
            rst=>rst,
            output=>lfsr2_out
        );
        
        lfsr3_ent : LFSR3SRL
        port map(
            clk=>clk,
            rst=>rst,
            output=>lfsr3_out
        );
        
        lfsr4_ent : LFSR4SRL
        port map(
            clk=>clk,
            rst=>rst,
            output=>lfsr4_out
        );
        
        T1_ent : T1
        port map(
            input=> ct,
            output => T1out
        );
        
        T2_ent : T2
        port map(
            input => T2input,
            output => T2out
        );
        
        Divide_ent : divide2
        port map(
            input => stinput,
            output => st_next
        );
        
        
    processE0 : process(rst,clk)
    begin
        if(rst = '0' and rising_edge(clk)) then
            T2input <= ct;
            ct <= ct_next;
        end if;
     end process;
     yt <= (("00"&lfsr1_out) + ("00"&lfsr2_out) + ("00"&lfsr3_out) + ("00"&lfsr4_out));
     stinput <= std_logic_vector(yt + "0"&ct);
        
     ct_next <= st_next xor T2out xor T1out;
     cipherstream <= lfsr1_out xor lfsr2_out xor lfsr3_out xor lfsr4_out xor ct(0);
end Behavioral;

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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity LFSR1SRL is
    Port ( clk : in std_logic;
        rst : in std_logic;
           output : out std_logic);
end LFSR1SRL;

architecture Behavioral of LFSR1SRL is
signal feedback : std_logic := '1';
signal state0 : std_logic :='1';
signal state8 : std_logic;
signal state12 : std_logic;
signal state20 : std_logic;
signal state25 : std_logic;


begin
SRL16E_inst1 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state8,
    A0=>'0',
    A1=>'1',
    A2=>'1',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>feedback
);

SRL16E_inst2 : SRL16E
generic map(INIT=>X"1568")
port map(
    Q=>state12,
    A0=>'1',
    A1=>'1',
    A2=>'0',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>state8
);

SRL16E_inst3 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state20,
    A0=>'1',
    A1=>'1',
    A2=>'1',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>state12
);

SRL16E_inst4 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state25,
    A0=>'0',
    A1=>'0',
    A2=>'1',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>state20
);

update_process : process(clk)
begin
if(rising_edge(clk)) then 
    state0 <= feedback;
    feedback <= state25 xor state20 xor state12 xor state8 xor state0;

    
end if;
end process;
output<= state25;
end Behavioral;

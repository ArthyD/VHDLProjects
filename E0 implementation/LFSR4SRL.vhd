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

entity LFSR4SRL is
    Port ( clk : in std_logic;
        rst : in std_logic;
           output : out std_logic);
end LFSR4SRL;

architecture Behavioral of LFSR4SRL is
signal feedback : std_logic := '1';
signal state0 : std_logic := '1';
signal state4 : std_logic;
signal state28 : std_logic;
signal state36 : std_logic;
signal state39 : std_logic;

begin
SRL16E_inst1 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state4,
    A0=>'0',
    A1=>'1',
    A2=>'0',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>feedback
);

SRLC32E_inst1 : SRLC32E
generic map(INIT=>X"1568ffff")
port map(
    Q=>state28,
    A=>"10111",
    CE=>'1',
    CLK=>clk,
    D=>state4
);

SRL16E_inst2 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state36,
    A0=>'1',
    A1=>'1',
    A2=>'1',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>state28
);

SRL16E_inst3 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state39,
    A0=>'0',
    A1=>'0',
    A2=>'1',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>state36
);



update_process : process(clk)
begin
if(rising_edge(clk)) then 
    state0 <= feedback;
    feedback <= state39 xor state36 xor state28 xor state4 xor state0;

    
end if;
end process;
output<= state39;


end Behavioral;

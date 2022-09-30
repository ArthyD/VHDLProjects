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

entity LFSR2SRL is
    Port ( clk : in std_logic;
        rst : in std_logic;
           output : out std_logic);
end LFSR2SRL;

architecture Behavioral of LFSR2SRL is

signal feedback : std_logic := '1';
signal state0 : std_logic := '1';
signal state12 : std_logic;
signal state16 : std_logic;
signal state24 : std_logic;
signal state31 : std_logic;


begin
SRL16E_inst1 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state12,
    A0=>'0',
    A1=>'1',
    A2=>'0',
    A3=>'1',
    CE=>'1',
    CLK=>clk,
    D=>feedback
);

SRL16E_inst2 : SRL16E
generic map(INIT=>X"1568")
port map(
    Q=>state16,
    A0=>'1',
    A1=>'1',
    A2=>'0',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>state12
);

SRL16E_inst3 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state24,
    A0=>'1',
    A1=>'1',
    A2=>'1',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>state16
);

SRL16E_inst4 : SRL16E
generic map(INIT=>X"ab12")
port map(
    Q=>state31,
    A0=>'0',
    A1=>'1',
    A2=>'1',
    A3=>'0',
    CE=>'1',
    CLK=>clk,
    D=>state24
);



update_process : process(clk)
begin
if(rising_edge(clk)) then 
    state0 <= feedback;
    feedback <= state31 xor state24 xor state16 xor state12 xor state0;

    
end if;
end process;
output<= state31;


end Behavioral;

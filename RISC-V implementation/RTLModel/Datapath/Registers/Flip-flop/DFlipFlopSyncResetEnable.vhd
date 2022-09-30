----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2022 03:42:53 PM
-- Design Name: 
-- Module Name: DFlipFlopSyncResetEnable - RTL
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

entity DFlipFlopSyncResetEnable is
    port(
        d: in bit;
        clk, rst, enable: in bit;
        q: out bit
    );
end DFlipFlopSyncResetEnable;

architecture RTL of DFlipFlopSyncResetEnable is

begin
    process
    begin
        wait until clk = '1';  -- is there a difference between "wait until clk='1'" and "clk='1' and clk'event"?
        if rst = '1' then
            q <= '0';
        else
            if enable = '1' then
                q <= d;
            end if;
        end if;
    end process;
end RTL;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2022 03:42:02 PM
-- Design Name: 
-- Module Name: DFlipFlopAsyncReset - RTL
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

entity DFlipFlopAsyncReset is
    port(
        d: in bit;
        clk, rst: in bit;
        q: out bit
    );
end DFlipFlopAsyncReset;

architecture RTL of DFlipFlopAsyncReset is
begin
    process (clk, rst)
    begin
        if rst = '1' then
            q <= '0';
        elsif clk = '1' and clk'event then
            q <= d;
        end if;
    end process;
end RTL;

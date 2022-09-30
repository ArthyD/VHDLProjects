----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2022 03:33:07 PM
-- Design Name: 
-- Module Name: RegisterAsyncReset - RTL
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

entity RegisterAsyncReset is
    generic(
        register_size: integer := 31
    );
    port(
        d_in: in bit_vector(register_size downto 0);
        rst, clk, enable: in bit;
        q_out: out bit_vector(register_size downto 0)
    );
end RegisterAsyncReset;

architecture RTL of RegisterAsyncReset is
begin
    process(rst, clk)
    begin
        if rst = '1' then
            q_out <= (others => '0');
        elsif clk = '1' and clk'event then
            if enable = '1' then
                q_out <= d_in;
            end if;
        end if;
    end process;
end RTL;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2022 03:44:22 PM
-- Design Name: 
-- Module Name: RegisterSyncReset - RTL
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

entity RegisterSyncReset is
    generic(
        register_size: integer := 31
    );
    port(
        d_in :in bit_vector(register_size downto 0);
        clk, rst, enable: in bit;
        q_out :out bit_vector(register_size downto 0)
    );
end RegisterSyncReset;

architecture RTL of RegisterSyncReset is
begin
    process
    begin
        wait until clk = '1';
        if rst = '1' then
            q_out <= (others => '0');
        else
            if enable = '1' then
                q_out <= d_in;
            end if;
        end if;
    end process;
end RTL;

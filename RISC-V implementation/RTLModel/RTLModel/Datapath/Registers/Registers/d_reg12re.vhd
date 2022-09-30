----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2022 10:33:46 PM
-- Design Name: 
-- Module Name: d_reg12re - RTL
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
use work.cpu_defs_pack.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity d_reg12re is
    port(
        d_in :in data_type;
        clk, rst, enable: in bit;
        q_out :out data_type
    );
end d_reg12re;

architecture RTL of d_reg12re is
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


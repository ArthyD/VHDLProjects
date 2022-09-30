----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/22/2022 12:24:55 AM
-- Design Name: 
-- Module Name: d_reg12re_tb - Behavioral
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

entity d_reg12re_tb is
end d_reg12re_tb;

architecture Behavioral of d_reg12re_tb is
component d_reg12re is
    port(
        d_in: in data_type;
        rst, clk, enable: in bit;
        q_out: out data_type
    );
    end component;
    
    signal d_in_tb, q_out_tb: data_type;
    signal rst_tb, clk_tb, enable_tb: bit;
begin
    uut: d_reg12re
    port map (
        d_in => d_in_tb, rst => rst_tb, clk => clk_tb, enable => enable_tb, q_out => q_out_tb
    );
    
    process begin
        clk_tb <= '0';
        rst_tb <= '0';
        enable_tb <= '0';
        d_in_tb <= (d_in_tb'range => '1');

        wait for 1 ns;
        assert not (q_out_tb = d_in_tb) report "(1) d_in was written to q_out (no clk event, no enable)" severity error;
        
        clk_tb <= '1';
        wait for 1 ns;
        assert not (q_out_tb = d_in_tb) report "(2) d_in was written to q_out (clk event, no enable)" severity error;
        
        clk_tb <= '0';
        wait for 1 ns;
        enable_tb <= '1';
        clk_tb <= '1';
        wait for 1 ns;
        assert (q_out_tb = d_in_tb) report "(3) d_in was not written to q_out (clk event, enable)" severity error;
        
        -- reset without clk event (unsuccessful)
        clk_tb <= '0';
        wait for 1 ns;
        rst_tb <= '1';
        wait for 1 ns;
        assert (q_out_tb = d_in_tb) report "(4) rst flag does reset register asynchronously" severity error;
        
        -- reset with clk event (successful)
        clk_tb <= '1';
        rst_tb <= '1';
        wait for 1 ns;
        assert (q_out_tb = (q_out_tb'range => '0')) report "(5) rst flag does not reset register synchronously" severity error;
    end process;
end Behavioral;
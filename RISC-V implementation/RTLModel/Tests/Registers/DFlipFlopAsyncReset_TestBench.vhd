----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2022 01:15:56 PM
-- Design Name: 
-- Module Name: DFlipFlopAsyncReset_TestBench - Behavioral
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

entity DFlipFlopAsyncReset_TestBench is
end DFlipFlopAsyncReset_TestBench;

architecture Behavioral of DFlipFlopAsyncReset_TestBench is
    component DFlipFlopAsyncReset is
        port(
            d: in bit;
            clk, rst: in bit;
            q: out bit
        );
    end component;
    signal d_tb, q_tb, clk_tb, rst_tb: bit;
begin
    uut: DFlipFlopAsyncReset
    port map (
        d => d_tb, q => q_tb, clk => clk_tb, rst => rst_tb
    );
    
    process begin
        clk_tb <= '0';
        rst_tb <= '0';
        d_tb <= '1';
        
        wait for 1 ns;
        assert not (q_tb = d_tb) report "(1) d was written to q (no clk event)" severity error;
        
        clk_tb <= '1';
        wait for 1 ns;
        assert (q_tb = d_tb) report "(2) d was not written to q (clk event)" severity error;
        
        clk_tb <= '0';
        wait for 1 ns;
        d_tb <= '0';
        clk_tb <= '1';
        wait for 1 ns;
        assert (q_tb = d_tb) report "(2) d was not written to q (clk event)" severity error;
        
        clk_tb <= '0';
        wait for 1 ns;
        d_tb <= '1';
        clk_tb <= '1';
        wait for 1 ns;
        assert (q_tb = d_tb) report "(2) d was not written to q (clk event)" severity error;
        
        clk_tb <= '0';
        wait for 1 ns;
        rst_tb <= '1';
        wait for 1 ns;
        assert (q_tb = '0') report "(3) rst flag does not work" severity error;
    end process;
end Behavioral;

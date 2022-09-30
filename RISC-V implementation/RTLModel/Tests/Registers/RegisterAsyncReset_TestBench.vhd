----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/16/2022 08:01:17 PM
-- Design Name: 
-- Module Name: RegisterAsyncReset_TestBench - Behavioral
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

entity RegisterAsyncReset_TestBench is
end RegisterAsyncReset_TestBench;


architecture Behavioral of RegisterAsyncReset_TestBench is
    component RegisterAsyncReset is
    generic(
        register_size: integer
    );
    port(
        d_in: in bit_vector(register_size downto 0);
        rst, clk, enable: in bit;
        q_out: out bit_vector(register_size downto 0)
    );
    end component;
    
    shared variable register_size_tb: integer := 8;
    signal d_in_tb, q_out_tb: bit_vector(register_size_tb downto 0) := (others => '0');
    signal rst_tb, clk_tb, enable_tb: bit;
begin
    uut: RegisterAsyncReset
    generic map (
        register_size => register_size_tb
    )
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
        
        clk_tb <= '0';
        wait for 1 ns;
        rst_tb <= '1';
        wait for 1 ns;
        assert (q_out_tb = (q_out_tb'range => '0')) report "(4) rst flag does not reset register" severity error;
    end process;
end Behavioral;

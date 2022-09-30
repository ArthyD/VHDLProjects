----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2022 11:58:10 PM
-- Design Name: 
-- Module Name: register_file_tb - Behavioral
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

entity register_file_tb is
end register_file_tb;

architecture Behavioral of register_file_tb is
    component register_file is
        port(
            data_in: in data_type;
            clk, rst: in bit;
            enable: in bit;
            sel_in: in bit_vector(1 downto 0);
            sel_out_a, sel_out_b, sel_out_c: in bit_vector(1 downto 0);
            data_out_a, data_out_b, data_out_c: out data_type
        );
    end component;

    signal clk_tb, rst_tb, enable_tb: bit;
    signal sel_in_tb, sel_out_a_tb, sel_out_b_tb, sel_out_c_tb, sel_out_d_tb: bit_vector(1 downto 0);
    signal data_in_tb, data_out_a_tb, data_out_b_tb, data_out_c_tb: data_type;
begin
    uut: register_file 
    port map (
        data_in => data_in_tb,
        clk => clk_tb, rst => rst_tb, 
        enable => enable_tb,
        sel_in => sel_in_tb,
        sel_out_a => sel_out_a_tb, sel_out_b => sel_out_b_tb, sel_out_c => sel_out_c_tb,
        data_out_a => data_out_a_tb, data_out_b => data_out_b_tb, data_out_c => data_out_c_tb
    );
    
    process
    begin
        clk_tb <= '0'; 
        rst_tb <= '0';
        enable_tb <= '0';
        data_in_tb <= (others => '1');
        
        -- test that everything was resetted properly
        wait for 1 ns;
        assert (data_out_a_tb = (data_out_a_tb'range => '0')) report "data_out_a from previous iteration is not deleted properly." severity warning;
        assert (data_out_b_tb = (data_out_b_tb'range => '0')) report "data_out_b from previous iteration is not deleted properly." severity warning;
        assert (data_out_c_tb = (data_out_c_tb'range => '0')) report "data_out_c from previous iteration is not deleted properly." severity warning;

        enable_tb <= '1';

        -- test that sel_in uses correct register by selecting setting sel_out_a to respective value of sel_in
        -- and asserting that data_out_a resembles register sel_in.
        sel_in_tb <= "00";
        wait for 1 ns; -- we have to wait here because the demux needs to update first before we can start the actual clock cycle..
        sel_out_a_tb <= "00";
        data_in_tb <= x"AAAA_AAAA";
        clk_tb <= '1';
        wait for 1 ns;
        assert (data_out_a_tb = data_in_tb) report "writing to register_a has failed" severity error;
        assert (data_out_b_tb = x"AAAA_AAAA") report "passively writing to output b has failed" severity error;
        assert (data_out_c_tb = x"AAAA_AAAA") report "passively writing to output c has failed" severity error;
        
        clk_tb <= '0';
        wait for 1 ns;
        sel_in_tb <= "01";
        wait for 1 ns;
        sel_out_a_tb <= "01";
        data_in_tb <= x"BBBB_BBBB";
        clk_tb <= '1';
        wait for 1 ns;
        assert (data_out_a_tb = data_in_tb) report "writing to register_b has failed" severity error;
        assert (data_out_b_tb = x"AAAA_AAAA") report "erroneously updated register a or passively writing to output b has failed" severity error;
        assert (data_out_c_tb = x"AAAA_AAAA") report "erroneously updated register a or passively writing to output c has failed" severity error;

        clk_tb <= '0';
        wait for 1 ns;
        sel_in_tb <= "10";
        wait for 1 ns;
        sel_out_a_tb <= "10";
        data_in_tb <= x"CCCC_CCCC";
        clk_tb <= '1';
        wait for 1 ns;
        assert (data_out_a_tb = data_in_tb) report "writing to register_c has failed" severity error;
        assert (data_out_b_tb = x"AAAA_AAAA") report "erroneously updated register a or passively writing to output b has failed" severity error;
        assert (data_out_c_tb = x"AAAA_AAAA") report "erroneously updated register a or passively writing to output c has failed" severity error;
        
        clk_tb <= '0';
        wait for 1 ns;
        sel_in_tb <= "11";
        wait for 1 ns;
        sel_out_a_tb <= "11";
        data_in_tb <= x"DDDD_DDDD";
        clk_tb <= '1';
        wait for 1 ns;
        assert (data_out_a_tb = data_in_tb) report "writing to register_d has failed" severity error;
        assert (data_out_b_tb = x"AAAA_AAAA") report "erroneously updated register a or passively writing to output b has failed" severity error;
        assert (data_out_c_tb = x"AAAA_AAAA") report "erroneously updated register a or passively writing to output c has failed" severity error;
        
        -- reset for next round
        clk_tb <= '0';
        wait for 1 ns;
        rst_tb <= '1';
        enable_tb <= '1';
        clk_tb <= '1';
        wait for 1 ns;
    end process;

end Behavioral;

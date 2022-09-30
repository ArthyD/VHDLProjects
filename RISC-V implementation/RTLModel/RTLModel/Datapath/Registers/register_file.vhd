----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/21/2022 03:05:41 PM
-- Design Name: 
-- Module Name: register_file - RTL
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity register_file is
    port(
        data_in: in data_type;
        clk, rst: in std_logic;
        enable: in std_logic;
        sel_in: in bit_vector(1 downto 0);
        sel_out_a, sel_out_b, sel_out_c: in bit_vector(1 downto 0);
        data_out_a, data_out_b, data_out_c: out data_type
    );
end register_file;

architecture RTL of register_file is
component d_reg12re is
    port(
        d_in: in data_type;
        clk, rst, enable: in bit;
        q_out: out data_type
    );
end component;

component demux1_1x4 is
    port( 
        d_in: in bit;
        select_input: in bit_vector(1 downto 0);
        d_out_a, d_out_b, d_out_c, d_out_d: out bit
    );
end component;

component mux32_4x1 is
    port(
        select_input: in bit_vector(1 downto 0);
        d_in_a, d_in_b, d_in_c, d_in_d: in data_type;
        d_out: out data_type 
    );
end component;

signal register_output_a, register_output_b, register_output_c, register_output_d: data_type;
signal enable_register_a, enable_register_b, enable_register_c, enable_register_d: bit;

begin
	registera: d_reg12re port map(d_in => data_in, rst => rst, enable => enable_register_a, clk => clk, q_out => register_output_a);
	registerb: d_reg12re port map(d_in => data_in, rst => rst, enable => enable_register_b, clk => clk, q_out => register_output_b);
	registerc: d_reg12re port map(d_in => data_in, rst => rst, enable => enable_register_c, clk => clk, q_out => register_output_c);
	registerd: d_reg12re port map(d_in => data_in, rst => rst, enable => enable_register_d, clk => clk, q_out => register_output_d);
	
    demux: demux1_1x4 
    port map(
        d_in => enable,
        select_input => sel_in, 
        d_out_a => enable_register_a, d_out_b => enable_register_b, d_out_c => enable_register_c, d_out_d => enable_register_d
    );
	
	muxa: mux32_4x1 
	port map(
	   select_input => sel_out_a,
	   d_in_a => register_output_a, d_in_b => register_output_b, d_in_c => register_output_c, d_in_d => register_output_d,
	   d_out => data_out_a
	);
    muxb: mux32_4x1 
    port map(
	   select_input => sel_out_b,
	   d_in_a => register_output_a, d_in_b => register_output_b, d_in_c => register_output_c, d_in_d => register_output_d,
	   d_out => data_out_b
	);
    muxc: mux32_4x1
    port map(
	   select_input => sel_out_c,
	   d_in_a => register_output_a, d_in_b => register_output_b, d_in_c => register_output_c, d_in_d => register_output_d,
	   d_out => data_out_c
	);
end RTL;



----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 28/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------
library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;

entity CPU is
    Port(
        clk            :       in std_logic;
        rst            :       in std_logic
    );
end CPU;

architecture RTL of CPU is
    -- Signals of controler --
    signal data_to_write : data_type;
    signal w_en : std_logic;
    signal w_addr : addr_type;
    signal w_mode : std_logic_vector(1 downto 0);
    signal r_en : std_logic;
    signal r_addr : addr_type;
    signal r_mode : std_logic_vector(1 downto 0);
    signal sel_in : bit_vector(1 downto 0);
    signal sel_out_a : bit_vector(1 downto 0);
    signal sel_out_b : bit_vector(1 downto 0);
    signal sel_out_c : bit_vector(1 downto 0);
    signal data_in : data_type;
    signal en_registers : std_logic;
    signal opcode : opcode_type; 
    signal en_calc : std_logic;
    -- Signals of memory --
    signal w_rdy : std_logic;
    signal r_rdy : std_logic;
    signal r_data : data_type;
    -- Sigals of datapath --
    signal data_out_a : data_type;
    signal data_out_b : data_type;
    signal data_out_c : data_type;  
    -- Signals of input --
    signal input_data : data_type;
    begin
        -- Controler --
        controler: entity work.full_controler(RTL)
        port map(
            -- Inputs --
            memory_data => r_data,
            input_data => input_data,
            reg_data_a => data_out_a,
            reg_data_b => data_out_b,
            reg_data_c => data_out_c,
            clk => clk,
            rst => rst,
            -- Outputs for memory --
            data_to_write => data_to_write,
            w_en => w_en,
            w_addr => w_addr,
            w_mode => w_mode,
            r_en => r_en,
            r_addr => r_addr,
            r_mode => r_mode,
            -- Outputs for register file --
            sel_in => sel_in,
            sel_out_a => sel_out_a,
            sel_out_b => sel_out_b,
            sel_out_c => sel_out_c,
            data_in => data_in,
            en_registers => en_registers,
            -- Outputs for ALU --
            opcode => opcode,
            en_calc => en_calc
        );
        -- Datapath --
        datapath: entity work.datapath(RTL)
        port map(
            clk => clk,
            rst => rst,
            -- Input from controler --
            sel_in => sel_in,
            sel_out_a => sel_out_a,
            sel_out_b => sel_out_b,
            sel_out_c => sel_out_c,
            data_in => data_in,
            en_registers => en_registers,
            opcode => opcode,
            en_calc => en_calc,
            -- Output --
            data_out_a => data_out_a,
            data_out_b => data_out_b,
            data_out_c => data_out_c 
        );
        -- Memory --
        memory: entity work.memory(RTL)
        port map(
            w_addr => w_addr,
            w_en => w_en,
            w_rdy => w_rdy,
            w_data => data_to_write,
            w_mode => w_mode,
            r_rdy => r_rdy,
            r_data => r_data,
            r_addr => r_addr,
            r_en => r_en,
            r_mode => r_mode,
            CLK => clk,
            RST => rst
        );
end RTL;
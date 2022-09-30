----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 26/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;

entity full_controler is
    Port(
        -- Inputs --
        memory_data    :       in data_type;
        input_data     :       in data_type;
        reg_data_a     :       in data_type;
        reg_data_b     :       in data_type;
        reg_data_c     :       in data_type;
        clk            :       in std_logic;
        rst            :       in std_logic;
        -- Outputs for memory --
        data_to_write  :       out data_type;
        w_en           :       out std_logic;
        w_addr         :       out addr_type;
        w_mode         :       out std_logic_vector(1 downto 0);
        r_en           :       out std_logic;
        r_addr         :       out addr_type;
        r_mode         :       out std_logic_vector(1 downto 0);
        -- Outputs for register file --
        sel_in         :       out bit_vector(1 downto 0);
        sel_out_a      :       out bit_vector(1 downto 0);
        sel_out_b      :       out bit_vector(1 downto 0);
        sel_out_c      :       out bit_vector(1 downto 0);
        data_in        :       out data_type;
        en_registers   :       out std_logic;
        -- Outputs for ALU --
        opcode         :       out opcode_type; 
        en_calc        :       out std_logic    
    );
end full_controler;

architecture RTL of full_controler is
    -- signals out of controler --
    signal cmd_calc : std_logic;
    signal calc_on_PC : std_logic;
    signal en_PC : std_logic := '0';
    signal en_addr : std_logic := '0';
    signal en_w_mem : std_logic := '0';
    signal en_r_mem : std_logic := '0';
    signal en_instr : std_logic := '0';
    signal mem_access_mux : std_logic_vector(1 downto 0) := "00";
    signal mux_instr : std_logic := '0';
    signal mux_PC : std_logic := '0';
    signal mem_access_type : std_logic_vector(1 downto 0) := "00";
    signal imm : bit_vector(11 downto 0);
    -- signals out of instruction controler --
    signal instruction : data_type;
    -- signals out of address controler --
    signal address : addr_type;
    -- signals out of PC increment --
    signal pc_incr : addr_type;
    -- signals out of PC controler --
    signal pc : addr_type;

    begin
    -- Instruction controler --
    InstrcC: entity work.instruction_controler(RTL)
    port map(
        memory_instruction => memory_data,
        input_instruction => input_data,
        enable => en_instr,
        instruction => instruction
    );
    -- Datapath input controler --
    DatapathInputC: entity work.datapath_input_controler(RTL)
    port map(
        cmd_calc => cmd_calc,
        calc_on_PC => calc_on_PC,
        pc => pc,
        imm => imm,
        output => data_in
    );
    -- Address controler --
    AddressC: entity work.address_controler(RTL)
    port map(
        register_content => reg_data_a,
        enable => en_addr,
        address => address
    );
    -- PC controler --
    PCC: entity work.PC_controler(RTL)
    port map(
        reg1_content => reg_data_a,
        reg2_content => reg_data_b,
        opcode => opcode,
        pc_incr => pc_incr,
        imm => imm,
        pc => pc
    );
    -- PC increment --
    PCincrement: entity work.increment_PC(RTL)
    port map(
        pc => pc,
        pc_incr => pc_incr
    );
    -- Memory interface --
    MemoryInterface: entity work.memory_interface(RTL)
    port map(
       pc => pc,
       addr => address,
       reg_content => reg_data_a,
       reg_content_to_write => reg_data_a,
       en_w_mem => en_w_mem,
       en_r_mem => en_r_mem,
       mem_access_mux => mem_access_mux,
       mem_access_type => mem_access_type,
       data_to_write => data_to_write,
       w_en => w_en,
       w_addr => w_addr,
       w_mode => w_mode,
       r_en => r_en,
       r_addr => r_addr,
       r_mode => r_mode
    );
    -- Controler -- 
    Controler: entity work.controler(RTL)
    port map(
        instruction => instruction,
        clk => clk,
        rst => rst,
        opcode => opcode,
        sel_in => sel_in,
        sel_out_a => sel_out_a,
        sel_out_b => sel_out_b,
        sel_out_c => sel_out_c,
        imm => imm,
        cmd_calc => cmd_calc,
        calc_on_PC => calc_on_pc,
        en_calc => en_calc,
        en_registers => en_registers,
        en_PC => en_PC,
        en_addr => en_addr,
        en_w_mem => en_w_mem,
        en_r_mem => en_r_mem,
        en_instr => en_instr,
        mem_access_mux => mem_access_mux,
        mux_instr => mux_instr,
        mux_PC => mux_PC,
        mem_access_type => mem_access_type
    );
end RTL;
----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 25/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;

entity controler is 
    Port(
        instruction    :       in      data_type;
        clk            :       in      std_logic;
        rst            :       in      std_logic;
        -- Output for regsisters and ALU --
        opcode         :       out     opcode_type;
        sel_in         :       out     bit_vector(1 downto 0);
        sel_out_a      :       out     bit_vector(1 downto 0);
        sel_out_b      :       out     bit_vector(1 downto 0);
        sel_out_c      :       out     bit_vector(1 downto 0);
        -- Imm output --
        imm            :       out     bit_vector(11 downto 0);
        -- Calculation output --
        cmd_calc       :       buffer  std_logic;
        calc_on_PC     :       buffer  std_logic;
        -- Output of FSM --
        en_calc         :       out    std_logic := '0';
        en_registers    :       out    std_logic := '0';
        en_PC           :       out    std_logic := '0';
        en_addr         :       out    std_logic := '0';
        en_w_mem        :       out    std_logic := '0';
        en_r_mem        :       out    std_logic := '0';
        en_instr        :       out    std_logic := '0';
        mem_access_mux  :       out    std_logic_vector(1 downto 0) := "00";
        mux_instr       :       out    std_logic := '0';
        mux_PC          :       out    std_logic := '0';
        mem_access_type :       out    std_logic_vector(1 downto 0) := "00"
    );
end controler;

architecture RTL of controler is
    signal op_w_mem : std_logic;
    signal op_r_mem : std_logic;
    signal mem_word : std_logic;
    signal mem_hword : std_logic;
    signal mem_byte : std_logic;
    signal access_PC : std_logic;
    signal access_addr : std_logic;
    signal access_reg : std_logic;

    begin 
    ID: entity work.instruction_decoder(Behavioral)
    port map(
        instruction => instruction,
        -- Output for regsisters and ALU --
        opcode => opcode,
        sel_in => sel_in,
        sel_out_a => sel_out_a,
        sel_out_b => sel_out_b,
        sel_out_c => sel_out_c,
        -- Output for FSM input --
        cmd_calc => cmd_calc,
        calc_on_PC => calc_on_PC,
        op_w_mem => op_w_mem,
        op_r_mem => op_r_mem,
        mem_word => mem_word,
        mem_hword => mem_hword,
        mem_byte => mem_byte,
        -- Imm output --
        imm => imm   
    );

    fsm: entity work.fsm(Behavioral)
    port map(
        cmd_calc => cmd_calc,
        calc_on_PC => calc_on_PC,
        op_w_mem => op_w_mem,
        op_r_mem => op_r_mem,
        mem_word => mem_word,
        mem_hword => mem_hword,
        mem_byte => mem_byte,
        access_PC => access_PC,
        access_addr => access_addr,
        access_reg => access_reg,
        clk => clk,
        rst => rst,
        -- Output of FSM --
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
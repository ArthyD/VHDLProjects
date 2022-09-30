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

entity datapath is
    Port(
        clk            :       in std_logic;
        rst            :       in std_logic;
        -- Input from controler --
        sel_in         :       in bit_vector(1 downto 0);
        sel_out_a      :       in bit_vector(1 downto 0);
        sel_out_b      :       in bit_vector(1 downto 0);
        sel_out_c      :       in bit_vector(1 downto 0);
        data_in        :       in data_type;
        en_registers   :       in std_logic;
        opcode         :       in opcode_type; 
        en_calc        :       in std_logic;  
        -- Output --
        data_out_a     :       buffer data_type;
        data_out_b     :       buffer data_type;
        data_out_c     :       buffer data_type 
    );
end datapath;

architecture RTL of datapath is
    signal entry_of_registers : data_type;
    signal output_of_ALU : data_type;
    begin
        -- ALU --
        ALU: entity work.ALU(Behavioral)
        port map(
            operand1 => data_out_a,
            operand2 => data_out_b,
            operation => opcode,
            result => output_of_ALU
        );
        -- Register file --
        Registers: entity work.register_file(RTL)
        port map(
            data_in => entry_of_registers,
            clk => clk, 
            rst => rst,
            enable => en_registers,
            sel_in => sel_in,
            sel_out_a => sel_out_a, 
            sel_out_b => sel_out_b, 
            sel_out_c => sel_out_c,
            data_out_a => data_out_a, 
            data_out_b => data_out_b, 
            data_out_c => data_out_c
        );

        process_datapath : process(clk) begin
            if en_calc = '1' then
                entry_of_registers <= output_of_ALU;
            else
                entry_of_registers <= data_in;
            end if;
        end process;
end RTL;
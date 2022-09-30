----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 24/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;

entity instruction_decoder is
    Port (
            instruction    :       in      data_type;
            -- Output for regsisters and ALU --
            opcode         :       out     opcode_type;
            sel_in         :       out     bit_vector(1 downto 0);
            sel_out_a      :       out     bit_vector(1 downto 0);
            sel_out_b      :       out     bit_vector(1 downto 0);
            sel_out_c      :       out     bit_vector(1 downto 0);
            -- Output for FSM input --
            cmd_calc       :       out     std_logic := '0';
            calc_on_PC     :       out     std_logic := '0';
            op_w_mem       :       out     std_logic := '0';
            op_r_mem       :       out     std_logic := '0';
            mem_word       :       out     std_logic := '0';
            mem_hword      :       out     std_logic := '0';
            mem_byte       :       out     std_logic := '0';
            -- Imm output --
            imm            :       out     bit_vector(11 downto 0)    
    );
end instruction_decoder;

architecture Behavioral of instruction_decoder is
signal rs1, rd, rs2 : reg_addr_type;
signal opcode_tmp : opcode_type ;
begin
    opcode_tmp <= instruction(6 downto 0);
    opcode <= opcode_tmp;
    decoding_process : process(instruction) begin
        cmd_calc    <='0';
        calc_on_PC  <='0';
        op_w_mem    <='0';
        op_r_mem    <='0';
        mem_word    <='0';
        mem_hword   <='0';
        mem_byte    <='0';
        case(opcode_tmp) is
        -- Load Instruction --
            when code_lb|code_lbu|code_lh|code_lhu|code_lw => rs1 <= instruction(19 downto 15);
                rd <= instruction(11 downto 7);
                imm <= instruction(31 downto 20);
                op_r_mem <= '1';
                if opcode_tmp = code_lb or opcode_tmp = code_lbu then 
                    mem_byte <= '1';
                elsif opcode_tmp = code_lh or opcode_tmp = code_lhu then
                    mem_hword <= '1';
                elsif opcode_tmp = code_lw then
                    mem_word <= '1';
                end if;
        -- Store Instruction --
            when code_sb|code_sh|code_w => rs1 <= instruction(19 downto 15);
                rs2 <= instruction(24 downto 20);
                imm <= instruction(31 downto 25) & instruction(11 downto 7);
                op_w_mem <= '1';
                if opcode_tmp = code_sb then 
                    mem_byte <= '1';
                elsif opcode_tmp = code_sh then
                    mem_hword <= '1';
                elsif opcode_tmp = code_w then
                    mem_word <= '1';
                end if;
        -- Shift Instruction --
            when code_sll|code_srl|code_sra|code_slli|code_srli|code_srai => rd <= instruction(11 downto 7);
                rs1 <=  instruction(19 downto 15);
                rs2 <=  instruction(24 downto 20);
                cmd_calc <= '1';
        -- Logical Instruction --
            when code_xor|code_or|code_and|code_xori|code_ori|code_andi => rd <= instruction(11 downto 7);
                rs1 <= instruction(19 downto 15);
                imm <= instruction(31 downto 20);
                cmd_calc <= '1';
        -- Arithmetic Instruction --
            when code_add|code_sub|code_addi => rd <= instruction(11 downto 7);
                rs1 <= instruction(19 downto 15);
                imm <= instruction(31 downto 20);
                cmd_calc <= '1';
        -- Compare Instruction --
            when code_slt|code_sltu|code_slti|code_sltiu => rd <= instruction(11 downto 7);
                rs1 <= instruction(19 downto 15);
                imm <= instruction(31 downto 20);
        -- Jump Instruction --
            when code_jal|code_jalr => rd <= instruction(11 downto 7);
                imm <= instruction(31 downto 20);
                calc_on_PC <= '1';
        -- Branch Instruction --
            when code_beq|code_bne|code_blt|code_bge|code_bltu|code_bgeu => rs1 <= instruction(19 downto 15);
                rs2 <= instruction(24 downto 20);
                imm <= instruction(31 downto 25) & instruction(11 downto 7);
                calc_on_PC <= '1';
        -- Special arithmetic move instruction --
            when code_lui|code_auipc => rd <= instruction(11 downto 7);
                calc_on_PC <= '1';
            when others => null;
        end case;
        sel_in <= rd(1 downto 0);
        sel_out_a <= rs1(1 downto 0);
        sel_out_b <= rs2(1 downto 0);
   end process;
end Behavioral;

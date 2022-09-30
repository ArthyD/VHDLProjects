----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 19/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


package cpu_defs_pack is
    -- DEFINITION OF TYPES --
    constant bus_width : natural := 32;
    constant data_width : natural := bus_width;
    constant addr_width : natural := 16;

    constant reg_addr_width : natural := 5;
    constant opcode_width : natural := 7;

    subtype data_type is
        bit_vector(data_width-1 downto 0);

    subtype addr_type is
        bit_vector(addr_width-1 downto 0);

    subtype reg_addr_type is
        bit_vector(reg_addr_width-1 downto 0);

    subtype opcode_type is
        bit_vector(opcode_width-1 downto 0);

    type reg_type is array(integer range 0 to 2**reg_addr_width-1) of data_type;

    type mem_type is array(integer range 0 to 2**addr_width-1) of data_type;
    
    -- Loads instruction --
    constant code_lb : opcode_type :=  "0000000";
    constant code_lbu : opcode_type := "0000001";
    constant code_lh : opcode_type :=  "0000010";
    constant code_lhu : opcode_type := "0000011";
    constant code_lw : opcode_type :=  "0000100";
    -- Store instruction --
    constant code_sb : opcode_type := "0000101";
    constant code_sh : opcode_type := "0000110";
    constant code_w : opcode_type :=  "0000111";
    -- Arithmetic instruction --
    constant code_add : opcode_type := "0001000";
    constant code_sub : opcode_type := "0001001";
    constant code_addi : opcode_type := "0001010";
    -- Special arithmetic load move --
    constant code_lui : opcode_type := "0001011";
    constant code_auipc : opcode_type := "0001100";
    -- Logic instructions --
    constant code_xor : opcode_type := "0001101";
    constant code_or : opcode_type := "0001111";
    constant code_and : opcode_type := "0010000";
    constant code_xori : opcode_type := "0010001";
    constant code_ori : opcode_type :=  "0010010";
    constant code_andi : opcode_type := "0010011";
    -- Shift instruction --
    constant code_sll : opcode_type := "0010100";
    constant code_srl : opcode_type := "0010101";
    constant code_sra : opcode_type := "0010110";
    constant code_slli : opcode_type := "0010111";
    constant code_srli : opcode_type := "0011000";
    constant code_srai : opcode_type := "0011001";
    -- Compare instruction --
    constant code_slt : opcode_type := "0011010";
    constant code_sltu : opcode_type := "0011011";
    constant code_slti : opcode_type := "0011100";
    constant code_sltiu : opcode_type := "0011101";
    -- Branch instruction --
    constant code_beq : opcode_type := "0011110";
    constant code_bne : opcode_type := "0011111";
    constant code_blt : opcode_type := "0100000";
    constant code_bge : opcode_type := "0100001";
    constant code_bltu : opcode_type := "0100010";
    constant code_bgeu : opcode_type := "0100011";
    -- Jump instruction --
    constant code_jal : opcode_type := "0100100";
    constant code_jalr : opcode_type := "0100101";

end cpu_defs_pack;

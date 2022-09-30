----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 06/06/2022
-- Project Name: CPU Functional model

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


package cpu_defs_pack is

    -- DEFINITION OF TYPES --
    constant bus_width : natural := 12;
    constant data_width : natural := bus_width;
    constant addr_width : natural := bus_width;

    constant reg_addr_width : natural := 2;
    constant opcode_width : natural := 6;

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

    -- DEFINITION OF OPCODE --
    constant code_nop : opcode_type := "000000";
    constant code_stop : opcode_type := "000001";
    -- Register instruction --
    constant code_ldc : opcode_type := "100000";
    constant code_ldd : opcode_type := "100001";
    constant code_ldr : opcode_type := "100010";
    constant code_std : opcode_type := "100011";
    constant code_str : opcode_type := "100100";
    -- Jump instruction --
    constant code_jmp : opcode_type := "110000";
    constant code_jz : opcode_type := "110001";
    constant code_jc : opcode_type := "110010";
    constant code_jn : opcode_type := "110011";
    constant code_jo : opcode_type := "110100";
    constant code_jnz : opcode_type := "110101";
    constant code_jnn : opcode_type := "110111";
    constant code_jno : opcode_type := "111000";
    constant code_jnc : opcode_type := "110110";
    -- Logic and arithmetic instruction --
    constant code_not : opcode_type := "000110";
    constant code_and : opcode_type := "000111";
    constant code_add : opcode_type := "000010";
    constant code_addc : opcode_type := "000011";
    constant code_subc : opcode_type := "000101";
    constant code_sub : opcode_type := "000100";
    constant code_or : opcode_type := "001000";
    constant code_xor : opcode_type := "001001";
    constant code_srl : opcode_type := "001110";
    constant code_sll : opcode_type := "001101";
    constant code_sra : opcode_type := "001111";
    constant code_slt : opcode_type := "010011";
    constant code_sltu : opcode_type := "010010";
    -- load and store PC instructions --
    constant code_ldpc : opcode_type := "100111";
    constant code_stpc : opcode_type := "101000";
    -- In and Out instructions --
    constant code_in : opcode_type := "100101";
    constant code_out : opcode_type := "100110";


    -- DEFINITION OF MNEMONIC CODE FOR TRACE --
    constant mnemonic_nop : string( 1 to 3 ) := "nop";
    constant mnemonic_stop: string( 1 to 4 ) := "stop";
    -- Register instruction --
    constant mnemonic_ldc : string( 1 to 3 ) := "ldc";
    constant mnemonic_ldd : string( 1 to 3 ) := "ldd";
    constant mnemonic_ldr : string( 1 to 3 ) := "ldr";
    constant mnemonic_std : string( 1 to 3 ) := "std";
    constant mnemonic_str : string( 1 to 3 ) := "str";
    -- Jump instruction --
    constant mnemonic_jmp : string( 1 to 3 ) := "jmp";
    constant mnemonic_jz : string( 1 to 2 ) := "jz";
    constant mnemonic_jc : string( 1 to 2 ) := "jc";
    constant mnemonic_jn : string( 1 to 2 ) := "jn";
    constant mnemonic_jo : string( 1 to 2 ) := "jo";
    constant mnemonic_jnz : string( 1 to 3 ) := "jnz";
    constant mnemonic_jno : string( 1 to 3 ) := "jno";
    constant mnemonic_jnn : string( 1 to 3 ) := "jnn";
    constant mnemonic_jnc : string( 1 to 3 ) := "jnc";
    -- Logic and arithmetic instruction --
    constant mnemonic_not : string( 1 to 3 ) := "not";
    constant mnemonic_and : string( 1 to 3 ) := "and";
    constant mnemonic_add : string( 1 to 3 ) := "add";
    constant mnemonic_addc : string( 1 to 4 ) := "addc";
    constant mnemonic_sub : string( 1 to 3 ) := "sub";
    constant mnemonic_subc : string( 1 to 4 ) := "subc";
    constant mnemonic_or : string( 1 to 2 ) := "or";
    constant mnemonic_xor : string( 1 to 3 ) := "xor";
    constant mnemonic_srl : string( 1 to 3 ) := "srl";
    constant mnemonic_sll : string( 1 to 3 ) := "sll";
    constant mnemonic_sra : string( 1 to 3 ) := "sra";
    constant mnemonic_slt : string( 1 to 3 ) := "slt";
    constant mnemonic_sltu : string( 1 to 4 ) := "sltu";
    -- load and store PC instructions --
    constant mnemonic_ldpc: string( 1 to 4 ) := "ldpc";
    constant mnemonic_stpc: string( 1 to 4 ) := "stpc";
    -- In and Out instructions --
    constant mnemonic_in: string( 1 to 2 ) := "in";
    constant mnemonic_out: string( 1 to 3 ) := "out";

    -- FUNCTIONS AND PROCEDURES --
    function get (
        constant Memory : in mem_type;
        constant addr : in addr_type )
        return data_type;
    procedure set (
        variable Memory : inout mem_type;
        constant addr : in addr_type;
        constant data : in data_type );

end cpu_defs_pack;


package body cpu_defs_pack is
    function get (
        constant Memory : in mem_type;
        constant addr : in addr_type ) return data_type is
        begin
            return Memory(to_integer(unsigned(to_stdlogicvector(addr))));
    end get;

    procedure set (
        variable Memory : inout mem_type;
        constant addr : in addr_type;
        constant data : in data_type ) is
        begin
            Memory(to_integer(unsigned(to_stdlogicvector(addr)))) := data;
    end set;

end cpu_defs_pack;

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
library work;
use work.bit_vector_natural_pack.all;
use work.cpu_defs_pack.all;


entity Test is
end Test;

architecture bit_vector_natural_pack_test of Test is
begin
    process
        constant test_bit_vector: bit_vector := "11001100"; -- 0b11001100 is dec(204)
        constant test_data_width: natural := 8; -- 0b11001100 are 8 bits
        constant test_integer: integer := 204; -- dec(204) is 0b1100110
        variable converted_integer : integer;
        variable converted_bit_vector : bit_vector;
        begin
        converted_integer  := bit_vector2natural(test_bit_vector);
        converted_bit_vector := natural2bit_vector(test_integer, test_data_width);

        assert test_bit_vector = converted_bit_vector;
        assert test_integer = converted_integer;
    end process;
end architecture;

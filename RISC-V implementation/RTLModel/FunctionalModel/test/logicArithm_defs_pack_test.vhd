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
use work.logicArithm_defs_pack.all;


entity Test is
end Test;

architecture logicArithm_defs_pack_test of Test is
begin
    process
        variable test_vector: bit_vector := "11110000";
        begin
        test_vector := "NOT"(test_vector);
        assert test_vector = "00001111";

        test_vector := test_vector AND "11000011";
        assert test_vector = "00000011";

        test_vector := INC(test_vector);
        assert test_vector = "00000100";

    end process;
end architecture;

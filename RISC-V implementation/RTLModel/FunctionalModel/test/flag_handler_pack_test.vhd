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
use work.flag_handler_pack.all;
use work.cpu_defs_pack.all;


entity Test is
end Test;

architecture flag_handler_pack_test of Test is
    begin
        process
        variable Zero, Negative, Overflow: bit := '0';
        constant Data:  data_type := "111111111111";
        begin
        Set_Flags_Load(Data, Zero, Negative, Overflow);

        assert Zero = '0' and Negative = '1' and Overflow = '0';

    end process;
end architecture;

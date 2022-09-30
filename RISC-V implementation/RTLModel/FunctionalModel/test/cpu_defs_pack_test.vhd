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
use work.cpu_defs_pack.all;


entity Test is
end Test;

architecture cpu_defs_pack_test of Test is
begin
    process

    variable Memory: mem_type := (others => (others => '1'));
    constant addr: addr_type := (others => '0');
    constant addr2: addr_type := "000000000001";
    begin
    assert get(Memory, addr) = "111111111111"; -- every get returns 2**12-1 bit vector
    assert get(Memory, addr2) = "111111111111"; -- every get returns 2**12-1 bit vector

    set(Memory, addr, "100000000000"); -- setting value of one address to 2**11 bit vector

    assert get(Memory, addr) = "100000000000"; -- validate with get that address was correctly set
    assert get(Memory, addr2) = "111111111111"; -- validate that no other address was affected

    end process;
end architecture;

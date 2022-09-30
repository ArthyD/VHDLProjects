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

package bit_vector_natural_pack is
    function bit_vector2natural(constant A: bit_vector)
        return integer;
    
    function natural2bit_vector(constant A :integer;
     constant data_width : natural)
        return bit_vector;
    
end bit_vector_natural_pack;
    
package body bit_vector_natural_pack is
    function bit_vector2natural(constant A: bit_vector)
        return integer is
        begin
            return to_integer(unsigned(to_stdlogicvector(A)));
    end bit_vector2natural;

    function natural2bit_vector(constant A :integer;
    constant data_width : natural)
        return bit_vector is
        begin
            return bit_vector(to_unsigned(A, data_width));
    end natural2bit_vector;
end bit_vector_natural_pack;
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
    

package flag_handler_pack is
    procedure Set_Flags_Load(
        constant Data: in data_type;
        variable Zero,Negative,Overflow : inout bit);
        
    procedure Set_Flags_Logic(
        constant Data: in data_type;
        variable Zero,Negative,Overflow : inout bit);
        
end flag_handler_pack;

package body flag_handler_pack is
    procedure Set_Flags_Load(
        constant Data: in data_type;
        variable Zero,Negative,Overflow : inout bit) is
            variable C_TMP : bit := '0';
            variable N_TMP : bit;
            variable R_TMP : data_type;
            variable T : integer range 0 to 3;
            constant zero_v: data_type := (others => '0');
        begin
            for i in Data'reverse_range loop``
                T := bit'pos(Data(i))+ bit'pos(C_TMP);
                R_TMP(i) := bit'val(T mod 2);
                C_TMP := bit'val(T / 2);
            end loop;
            
            T := bit'pos(Data(Data'length-1))+bit'pos(C_TMP);
            N_TMP := bit'val(T mod 2);
            Overflow := R_TMP( data_width-1 ) XOR N_TMP;
            Negative := N_TMP;
            
            Zero := bit'val(boolean'pos(R_TMP = zero_v));
    end Set_Flags_Load;

    procedure Set_Flags_Logic(
        constant Data: in data_type;
        variable Zero,Negative,Overflow : inout bit) is
            variable C_TMP : bit := '0';
            variable N_TMP : bit;
            variable R_TMP : data_type;
            variable T : integer range 0 to 3;
            constant zero_v: data_type := (others => '0');
            begin
                for i in Data'reverse_range loop``
                    T := bit'pos(Data(i))+ bit'pos(C_TMP);
                    R_TMP(i) := bit'val(T mod 2);
                    C_TMP := bit'val(T / 2);
                end loop;
                
                T := bit'pos(Data(Data'length-1))+bit'pos(C_TMP);
                N_TMP := bit'val(T mod 2);
                Overflow := R_TMP( data_width-1 ) XOR N_TMP;
                Negative := N_TMP;
                
                Zero := bit'val(boolean'pos(R_TMP = zero_v));
    end Set_Flags_Logic;


end flag_handler_pack;


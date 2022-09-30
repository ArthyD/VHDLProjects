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
use work.cpu_defs_pack.all;

entity memory is
    Port ( 
        w_addr       : in    addr_type;
        w_en         : in    STD_LOGIC;
        w_rdy        : out   STD_LOGIC;
        w_data       : in    data_type;
        w_mode       : in    STD_LOGIC_VECTOR (1 downto 0);
        r_rdy        : out   STD_LOGIC;
        r_data       : out   data_type;
        r_addr       : in    addr_type;
        r_en         : in    STD_LOGIC;
        r_mode       : in    STD_LOGIC_VECTOR (1 downto 0);
        CLK          : in    STD_LOGIC;
        RST          : in    STD_LOGIC
    );
end memory;

architecture RTL of memory is

begin

process(CLK, RST)


variable mem : mem_type;
variable tmp_addr : integer;

begin

    if RST = '1' then
        mem := (others => (others => '0'));
        tmp_addr := 0;
        w_rdy <= '0';
        r_rdy <= '0';
        r_data <= (others => '0');
    elsif CLK = '1' and CLK' event then
        if w_en = '1' then
            w_rdy <= '1';
            tmp_addr := to_integer(unsigned(w_addr(15 downto 2)));
            case w_mode is 
            when "01" => -- byte access
                case w_addr(1 downto 0) is
                when "00" => mem(tmp_addr)(7 downto 0) := w_data(7 downto 0);
                when "01" => mem(tmp_addr)(15 downto 8) := w_data(7 downto 0);
                when "10" => mem(tmp_addr)(23 downto 16) := w_data(7 downto 0);
                when "11" => mem(tmp_addr)(31 downto 24) := w_data(7 downto 0);
                when others => null;
                end case;
            when "10" => --half word access
				assert w_addr(0) = '0';
				if w_addr(1) = '1' then
					mem(tmp_addr) (15 downto 0) := w_data (15 downto 0);
				else
					mem(tmp_addr) (31 downto 16) := w_data (15 downto 0);
				end if;
			when "11" => -- word access
			mem(tmp_addr)  := w_data;
			when "00" => null;
			when others => null;
			end case;
		end if;
		-- read access
        if r_en = '1' then
            r_rdy <= '1';
            tmp_addr := to_integer(unsigned(r_addr(15 downto 2)));
            case r_mode is
            when "01" => -- byte write
                case w_addr(1 downto 0) is
                when "00" => r_data(7 downto 0) <= mem(tmp_addr)(7 downto 0);
                when "01" => r_data(7 downto 0) <= mem(tmp_addr)(15 downto 8);
                when "10" => r_data(7 downto 0) <= mem(tmp_addr)(23 downto 16);
                when "11" => r_data(7 downto 0) <= mem(tmp_addr)(31 downto 24);
                when others => null;
                end case;
            when "10" => --half word write
				assert w_addr(0) = '0';
				if r_addr(1) = '1' then
					r_data (15 downto 0) <= mem(tmp_addr) (15 downto 0);
				else
					r_data (15 downto 0) <= mem(tmp_addr) (31 downto 16);
				end if;
			when "11" => -- word write
                r_data  <= mem(tmp_addr);
            when "00" => null;
            when others => null;
			end case;
		end if;
	end if;
end process;          
             
                
    
             
end RTL;

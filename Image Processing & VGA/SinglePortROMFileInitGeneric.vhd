-------------------------------------------------------------------------------
-- Generic Single Port ROM initialized with a specified file 
--

Library ieee;
Use ieee.std_logic_1164.All;
Use ieee.numeric_std.All;
Use std.textio.All;

Entity SinglePortROMFileInitGeneric Is
	Generic (
		G_MemoryWidth  : Integer;  
		G_MemoryDepth  : Integer;  
		G_AddressWidth : Integer;  
		G_InitFileName : String    
	);
	Port (
		I_clk : In std_logic;
		I_en    : In std_logic;
		I_addr  : In std_logic_vector(G_AddressWidth - 1 Downto 0);
		O_dout  : Out std_logic_vector(G_MemoryWidth - 1 Downto 0)
	);
End SinglePortROMFileInitGeneric;

Architecture rtl Of SinglePortROMFileInitGeneric Is

type ramtype is array (G_MemoryDepth-1 downto 0) of std_logic_vector (G_MemoryWidth-1 downto 0);          -- 2D Array Declaration for RAM signal


impure function initramfromfile (ramfilename : in string) return ramtype is
file ramfile	: text is in ramfilename;
variable ramfileline : line;
variable ram_name	: ramtype;
variable bitvec : bit_vector(G_MemoryWidth-1 downto 0);
begin
    --for i in ramtype'range loop
    for i in 0 to G_MemoryDepth-1 loop
        readline (ramfile, ramfileline);
        read (ramfileline, bitvec);
        ram_name(i) := to_stdlogicvector(bitvec);
		exit when endfile (ramfile);
    end loop;
    return ram_name;
end function;

Signal RAM : RamType := InitRamFromFile(G_InitFileName);

Begin
-- pragma synthesis_off
	assert (not( G_MemoryDepth > 2**G_AddressWidth)) 
	report "bad value for G_MemoryDepth or G_AddressWidth" 
	severity error;
-- pragma synthesis_on

	Process (I_clk)
	Begin
		If I_clk'EVENT and I_clk = '1' Then
			If I_en = '1' Then
				O_dout <= RAM(to_integer(unsigned(I_addr))); ---- uncomment to implement on BLOCK RAM
			End If; 
		End If;
	End Process;
 
	-- O_dout <= RAM(to_integer(unsigned(I_addr))); ---- uncomment to implement on LUT
End rtl;


-- The following is an instantiation template
--
--
-- Component Declaration
--component SinglePortROMFileInitGeneric is
-- generic (
--          G_MemoryWidth  : Integer;
--          G_MemoryDepth  : Integer;
--          G_AddressWidth : Integer;
--          G_InitFileName : String  
--          );
--port (
--	    I_clk : In std_logic;
--		I_en    : In std_logic;
--		I_addr  : In std_logic_vector(G_AddressWidth - 1 Downto 0);
--		O_dout  : Out std_logic_vector(G_MemoryWidth - 1 Downto 0)
--      );
--end component;

-- Instantiation
--<your_instance_name> : SinglePortROMFileInitGeneric
-- generic map (
--      G_MemoryWidth => 8,
--      G_MemoryDepth => 10000,
--      G_AddressWidth => 14,
--      G_InitFileName => "SobelMemIn.txt" 
--      )
-- port map (
--      I_clk  => clk,
--      I_en     => en,
--      I_addr   => addr,
--      O_dout   => dout
--      );

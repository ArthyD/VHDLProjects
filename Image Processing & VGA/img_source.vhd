library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity img_source is
	generic(
	    PART : integer := 0;
		X_DIM  : integer := 320;
		Y_DIM  : integer := 128;
		FRAME_X : integer := -- ### COMPLETE HERE ###
		FRAME_Y : integer := -- ### COMPLETE HERE ###
	);
    port ( clk     : in std_logic;
           rst_n   : in std_logic;
           data    : out std_logic_vector (23 downto 0);
           t_valid : out std_logic;
           t_ready : in std_logic;
           sof     : out std_logic; -- t_user
           eol     : out std_logic);-- t_last
end img_source;

architecture Behavioral of img_source is

    constant FRAME_SIZE : integer := FRAME_X*FRAME_Y;

	type t_state is -- ### COMPLETE HERE ###
	signal current_state : t_state;
	
	signal lineCnt  : integer range 0 to FRAME_X;
	signal frameCnt : integer range 0 to FRAME_SIZE;
	
	-- Component Declaration
    component SinglePortROMFileInitGeneric is
     generic (
              G_MemoryWidth  : Integer;
              G_MemoryDepth  : Integer;
              G_AddressWidth : Integer;
              G_InitFileName : String  
              );
    port (
            I_clk : In std_logic;
            I_en    : In std_logic;
            I_addr  : In std_logic_vector(G_AddressWidth - 1 Downto 0);
            O_dout  : Out std_logic_vector(G_MemoryWidth - 1 Downto 0)
          );
    end component;
    
    signal en       : std_logic;
    signal addr_slv : std_logic_vector(15 downto 0);
    signal addr_int : integer range 0 to 40959;
    signal rom_out  : std_logic_vector(23 downto 0);
    
    signal rowCnt  : integer;
    signal eol_int : std_logic;

begin

    gen_part_0 : if PART = 0 generate
    begin
        process(lineCnt,rom_out,frameCnt)
        begin
            if lineCnt > 2 and lineCnt < X_DIM+2 and frameCnt < FRAME_X*Y_DIM then
                data <= rom_out(7 downto 4) & rom_out(7 downto 4) & rom_out(15 downto 12) & rom_out(15 downto 12) & rom_out(23 downto 20) & rom_out(23 downto 20);
            else
                data <= x"000000";
            end if;
        end process;
    end generate gen_part_0;

    gen_part_1 : if PART = 1 generate
    begin
        process(lineCnt,rom_out,frameCnt)
        begin
            if lineCnt > 2 and lineCnt < X_DIM+2 and frameCnt < FRAME_X*Y_DIM then
                data <= rom_out(7 downto 0) & rom_out(15 downto 8) & rom_out(23 downto 16);
            else
                data <= x"000000";
            end if;
        end process;
    end generate gen_part_1;

    pr_ram_ctrl : process(clk)
    begin
        if clk'event and clk = '1' then
            if rst_n = '0' then
                addr_int <= 0;
                rowCnt <= 0;
            else
                if  frameCnt < FRAME_X*Y_DIM then
                    if eol_int = '1' then
                        rowCnt <= rowCnt + 1;
                    end if;
                    
                    if lineCnt < X_DIM then
						-- ######################################################
						-- ### COMPLETE : Rewrite to avoid the multiplication ###
						-- ######################################################
                        addr_int <= rowCnt*X_DIM + lineCnt;
                    end if;
                else
                    rowCnt <= 0;
                    addr_int <= 0;
                end if;
            end if;
        end if;
    end process pr_ram_ctrl;
    en <= '1';
    addr_slv <= std_logic_vector(to_unsigned(addr_int,16));

    pr_axi_ctrl : process(clk)
    begin
        if clk'event and clk = '1' then
            if rst_n = '0' then
                current_state <= IDLE;
                lineCnt       <= 0;
                frameCnt      <= 0;
                t_valid       <= '0';
                sof           <= '0';
                eol_int       <= '0';
            else
				-- #####################
				-- ### COMPLETE HERE ###
				-- #####################
            end if;
        end if;
    end process;
    eol <= eol_int;
    
    -- Instantiation
    img_rom : SinglePortROMFileInitGeneric
    generic map (G_MemoryWidth => 24, G_MemoryDepth => 40960, G_AddressWidth => 16, G_InitFileName => "../../../../src/coin_320x128.txt")
    port map (I_clk => clk, I_en => en, I_addr => addr_slv, O_dout => rom_out);

end Behavioral;

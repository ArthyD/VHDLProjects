----------------------------------------------------------------------------------
-- TUM VHDL Assignment
-- Arthur Docquois, Maelys Chevrier, Timothée Carel, Roman Canals
--
-- Create Date: 24/07/2022
-- Project Name: CPU RTL model

----------------------------------------------------------------------------------


library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;

entity test_fsm is
--  Port ( );
end test_fsm;

architecture Behavioral of test_fsm is

    

signal clk_s: STD_LOGIC:='0';
signal clk : std_logic := '0';
signal state_counter_s: integer :=0;
signal start_counting_s: STD_LOGIC:='0';
signal rst : std_logic := '0';
constant period: time :=20ns;
signal cmd_calc : std_logic :='0';
signal calc_on_PC : std_logic := '0';
signal op_w_mem  : std_logic := '0';
signal op_r_mem :  std_logic := '0';
signal mem_word  : std_logic := '0';
signal mem_hword : std_logic :='0';
signal mem_byte : std_logic :='0';
signal access_PC : std_logic := '0';
signal access_addr : std_logic := '0';
signal access_reg : std_logic := '0';
-- Output of FSM --
signal en_calc : std_logic := '0';
signal en_registers : std_logic := '0';
signal en_PC : std_logic := '0';
signal en_addr : std_logic := '0';
signal en_w_mem : std_logic := '0';
signal en_r_mem : std_logic := '0';
signal en_instr : std_logic := '0';
signal mem_access_mux : std_logic_vector(1 downto 0) := "00";
signal mux_instr : std_logic := '0';
signal mux_PC : std_logic := '0';
signal mem_access_type : std_logic_vector(1 downto 0) := "00";
    
begin
    fsm: entity work.fsm(Behavioral)
    port map(
        cmd_calc => cmd_calc,
        calc_on_PC => calc_on_PC,
        op_w_mem => op_w_mem,
        op_r_mem => op_r_mem,
        mem_word => mem_word,
        mem_hword => mem_hword,
        mem_byte => mem_byte,
        access_PC => access_PC,
        access_addr => access_addr,
        access_reg => access_reg,
        clk => clk_s,
        rst => rst,
        -- Output of FSM --
        en_calc => en_calc,
        en_registers => en_registers,
        en_PC => en_PC,
        en_addr => en_addr,
        en_w_mem => en_w_mem,
        en_r_mem => en_r_mem,
        en_instr => en_instr,
        mem_access_mux => mem_access_mux,
        mux_instr => mux_instr,
        mux_PC => mux_PC,
        mem_access_type => mem_access_type
    );
     --generate clock signal
    clk<=clk_s;
    clk_s<= not clk after period/2;
    
    proc_initialization: process
    begin
        access_PC <= '1';
        wait for 10*period;
        cmd_calc <='1';
        op_r_mem <= '1';
        mem_word <= '1';
        wait for 10*period;
        cmd_calc <= '0';
        op_r_mem <= '0';
        mem_word <= '0';
        wait for 10*period;
        access_PC <= '0';
        calc_on_PC <= '1';
        access_reg <= '1';
        wait for 10*period;
        calc_on_PC <= '0';
        access_reg <= '0';
        access_PC <= '1';
        wait for 10*period;
        cmd_calc <='1';
        op_w_mem <= '1';
        mem_hword <= '1';
        wait for 10*period;
        cmd_calc <='0';
        op_w_mem <= '0';
        mem_hword <= '0';
        
    end process;
    


end Behavioral;

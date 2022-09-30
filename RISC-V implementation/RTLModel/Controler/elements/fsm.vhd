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
use IEEE.NUMERIC_STD.ALL;
use work.cpu_defs_pack.all;


entity FSM is
    Port (
        -- Output of decoder --
        cmd_calc        :       in     std_logic;
        calc_on_PC      :       in     std_logic;
        op_w_mem        :       in     std_logic;
        op_r_mem        :       in     std_logic;
        mem_word        :       in     std_logic;
        mem_hword       :       in     std_logic;
        mem_byte        :       in     std_logic;
        access_PC       :       in     std_logic;
        access_addr     :       in     std_logic;
        access_reg      :       in     std_logic;
        clk             :       in     std_logic;
        rst             :       in     std_logic;
        -- Output of FSM --
        en_calc         :       out    std_logic := '0';
        en_registers    :       out    std_logic := '0';
        en_PC           :       out    std_logic := '0';
        en_addr         :       out    std_logic := '0';
        en_w_mem        :       out    std_logic := '0';
        en_r_mem        :       out    std_logic := '0';
        en_instr        :       out    std_logic := '0';
        mem_access_mux  :       out    std_logic_vector(1 downto 0) := "00";
        mux_instr       :       out    std_logic := '0';
        mux_PC          :       out    std_logic := '0';
        mem_access_type :       out    std_logic_vector(1 downto 0) := "00"
    );
end FSM;

architecture Behavioral of FSM is
type state_type is (FETCH_STATE, EXECUTION_STATE, MEMORY_STATE);
signal current_state : state_type := FETCH_STATE;
signal next_state : state_type := FETCH_STATE;
begin
    process_next_state: process(current_state,cmd_calc,calc_on_PC,op_w_mem,op_r_mem,mem_word,mem_hword,mem_byte) begin
        case current_state is
            when FETCH_STATE => next_state <= EXECUTION_STATE;
            when MEMORY_STATE => next_state <= FETCH_STATE;
            when EXECUTION_STATE => 
                if op_w_mem = '1' or op_r_mem = '1' then
                    next_state <= MEMORY_STATE;
                else
                    next_state <= FETCH_STATE;
                end if;
        end case;
    end process;

    process_state: process(clk) begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= FETCH_STATE;
            else
                current_state <= next_state;
            end if;
        end if;
    end process; 

    -- Moore architecture --
    process_output: process(current_state) begin
        en_calc         <= '0';
        en_registers    <= '0';
        en_PC           <= '0';
        en_addr         <= '0';
        en_w_mem        <= '0';
        en_r_mem        <= '0';
        en_instr        <= '0';
        mem_access_mux  <= "00";
        mux_instr       <= '0';
        mux_PC          <= '0'; -- Result come from incr
        mem_access_type <= "00";
        case(current_state) is
            when FETCH_STATE => 
                mux_instr <= '0'; -- instr come from memory
                en_instr <= '1';
                en_r_mem <= '1';
                if access_PC = '1' then
                    en_PC <= '1';
                    mem_access_mux <= "01";
                elsif access_addr = '1' then
                    en_addr <= '1';
                    mem_access_mux <= "10";
                elsif access_reg = '1' then
                    en_registers <= '1';
                    mem_access_mux <= "11";    
                end if ;
            when EXECUTION_STATE =>
                if cmd_calc ='1' then
                    en_calc <= '1';
                    en_registers <= '1';
                elsif calc_on_PC = '1' then
                    en_PC <= '1';
                    en_calc <= '1';
                    en_registers <= '1';
                    mux_PC <= '1'; -- Result come from register
                end if;
            when MEMORY_STATE =>
                if mem_word = '1' then
                    mem_access_type <= "11";
                elsif mem_hword = '1' then
                    mem_access_type <= "10";
                elsif mem_byte = '1' then
                    mem_access_type <= "01";
                end if;
                if op_w_mem = '1' then
                    en_w_mem <= '1';
                elsif op_r_mem = '1' then
                    en_r_mem <= '1';
                end if;
            end case;
    end process;

end Behavioral;
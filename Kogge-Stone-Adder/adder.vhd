library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
Generic (
        input_width : integer := 64
);
Port (
        a       :       in      STD_LOGIC_VECTOR(input_width-1 downto 0);
        b       :       in      STD_LOGIC_VECTOR(input_width-1 downto 0);
	neg_b	:	in	STD_LOGIC;
        s       :       out	STD_LOGIC_VECTOR(input_width-1 downto 0)
);
attribute dont_touch : string;
attribute dont_touch of adder : entity is "true";
end adder;

--------------------------------------------- Kogge Stone Adder design -----------------------------------------------------
architecture Behavioral of adder is

signal a_int, b_int, s_int, P_preprocessing, G_preprocessing, P_temp1, G_temp1, P_temp2, G_temp2, P_temp3, G_temp3, P_temp4, G_temp4, P_temp5, G_temp5 : std_logic_vector(input_width-1 downto 0) := (others => '0');
begin

negate_b: process(all)
begin
	if neg_b = '1' then
		b_int <= not(b);
	else
		b_int <= b;
	end if;
end process;


a_int <= a;
-- Preprocessing --
preprocessing : for i in 0 to input_width - 1 generate
ha_i : entity work.half_adder(Behavioral)
port map (
    a => a_int(i),
    b => b_int(i),
    P => P_preprocessing(i),
    G => G_preprocessing(i)
);
end generate preprocessing;

-- Processing --
--Stage 1
P_temp1(0)<= P_preprocessing(0);
G_temp1(0)<= G_preprocessing(0);
stage1: for i in 1 to input_width -1 generate
st1_i: entity work.processing_elem(Behavioral)
port map(
    Pi => P_preprocessing(i),
    Pj => P_preprocessing(i-1),
    Gi => G_preprocessing(i),
    Gj => G_preprocessing(i-1),
    P => P_temp1(i),
    G => G_temp1(i)
);
end generate stage1;

--other stages
inter_stage12: for i in 0 to 1 generate
    P_temp2(i)<= P_temp1(i);
    G_temp2(i)<= G_temp1(i);
end generate;

stage2: for i in 2 to input_width -1 generate
st2_i: entity work.processing_elem(Behavioral)
port map(
    Pi => P_temp1(i),
    Pj => P_temp1(i-2),
    Gi => G_temp1(i),
    Gj => G_temp1(i-2),
    P => P_temp2(i),
    G => G_temp2(i)
);
end generate stage2;

inter_stage23: for i in 0 to 3 generate
    P_temp3(i)<= P_temp2(i);
    G_temp3(i)<= G_temp2(i);
end generate;

stage3: for i in 4 to input_width -1 generate
st3_i: entity work.processing_elem(Behavioral)
port map(
    Pi => P_temp2(i),
    Pj => P_temp2(i-4),
    Gi => G_temp2(i),
    Gj => G_temp2(i-4),
    P => P_temp3(i),
    G => G_temp3(i)
);
end generate stage3;   
   
inter_stage34: for i in 0 to 15 generate
    P_temp4(i)<= P_temp3(i);
    G_temp4(i)<= G_temp3(i);
end generate;

stage4: for i in 8 to input_width -1 generate
st4_i: entity work.processing_elem(Behavioral)
port map(
    Pi => P_temp3(i),
    Pj => P_temp3(i-8),
    Gi => G_temp3(i),
    Gj => G_temp3(i-8),
    P => P_temp4(i),
    G => G_temp4(i)
); 
end generate stage4;

inter_stage45: for i in 0 to 31 generate
    P_temp5(i)<= P_temp4(i);
    G_temp5(i)<= G_temp4(i);
end generate;


stage5: for i in 16 to input_width -1 generate
st5_i: entity work.processing_elem(Behavioral)
port map(
    Pi => P_temp4(i),
    Pj => P_temp4(i-16),
    Gi => G_temp4(i),
    Gj => G_temp4(i-16),
    P => P_temp5(i),
    G => G_temp5(i)
);  
end generate stage5; 


-- Postprocessing --
s_int(0) <= P_preprocessing(0);
postrocessing: for i in 1 to input_width -1 generate
    s_int(i) <= P_preprocessing(i) xor G_temp5(i-1);
end generate postrocessing;
s <= s_int;

end Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3 is
port(
	CK,LPB,RPB: in std_logic;
	CK_select: in std_logic_vector(3 downto 0);
	SW_RES: in std_logic;
	Hex5,Hex4,Hex3,Hex2,Hex1,Hex0: out std_logic_vector(7 downto 0);
	LED: out std_logic_vector(9 downto 0)
);
end lab3;

architecture lab3_arc of lab3 is
	type state_type is (stop, Rserve, Lserve, Rmov, Lmov);
	signal PS,NS: state_type;
	signal tally_inc,lscore_inc,rscore_inc,lwin_inc, rwin_inc, serve_side, CLK, CK_0, CK_1, CK_2, CK_3, CK_4: std_logic;
	signal bp: std_logic_vector(7 downto 0);
	signal tally, freq, Rscore, Lscore, Rwin,Lwin: std_logic_vector(3 downto 0) := "0000";
	signal win_disp : std_logic;
	
	component Seg7
	port (
		A: in std_logic_vector(3 downto 0);
		O: out std_logic_vector(6 downto 0)
	);
	end component;
	
	component encoder4x2
	port (
		A: in std_logic_vector(3 downto 0);
		O: out std_logic_vector(1 downto 0)
	);
	end component;
	
	component win2hex is
	port (
		A: in std_logic;
		D0, D1: in std_logic_vector(3 downto 0);
		O0, O1: out std_logic_vector(6 downto 0)
	);
	end component;
begin
	LED(8 downto 1) <= bp;
	LED(9) <= not(LPB);
	LED(0) <= not(RPB);
	
	lfc: process(CK)
	variable ck_div: unsigned(27 downto 0);
	begin
		if(rising_edge(CK)) then
			ck_div := ck_div+1;			
		end if;
		CK_0 <= ck_div(27);
		CK_1 <= ck_div(24);
		CK_2 <= ck_div(23);
		CK_3 <= ck_div(22);
		CK_4 <= ck_div(21);
	end process lfc;
		
	with CK_select select
	CLK <= CK_2 when "0010",
			 CK_3 when "0100",
			 CK_4 when "1000",
			 CK_1 when others;
			 
	clk_encode: encoder4x2
	port MAP(
		A => CK_select,
		O => freq(1 downto 0)
	);
	
	Hex5(7) <= CLK;
	freq_hex: Seg7
	port MAP(
		A => std_logic_vector(unsigned(freq)+1),
		O => Hex5(6 downto 0)
	);
	
	tally_hex: Seg7
	port MAP(
		A => tally,
		O => Hex4(6 downto 0)
	);
	
	Lscore_hex: Seg7
	port MAP(
		A => Lscore,
		O => Hex3(6 downto 0)
	);
	
	Rscore_hex: Seg7
	port MAP(
		A => Rscore,
		O => Hex2(6 downto 0)
	);
	
	win: win2hex
	port MAP(
		A => win_disp,-- in std_logic_vector(1 downto 0);
		D0 => Rwin,
		D1 => Lwin,--in std_logic_vector(3 downto 0);
		O0 => Hex1(6 downto 0) ,
		O1 => Hex0(6 downto 0)-- out std_logic_vector(6 downto 0)
	);
	
	
	sync: process(CK,CLK,PS)
	begin
		if(rising_edge(CK)) then
			PS <= NS;
			
			if(PS = stop) then
				tally <= "0000";
			end if;
			if(tally_inc = '1') then
				tally <= std_logic_vector(unsigned(tally)+1);
			end if;
			if(lscore_inc = '1') then
				Rscore <= std_logic_vector(unsigned(Rscore)+1);
			end if;
			if((unsigned(Rscore) = 2) and (unsigned(Rscore) > unsigned(Lscore))) then
				Rwin <= std_logic_vector(unsigned(Rwin)+1);
				Rscore <= "0000";
				Lscore <= "0000";
				win_disp <= '0';
			elsif((unsigned(Lscore) = 2) and (unsigned(Lscore) > unsigned(Rscore))) then
				Lwin <= std_logic_vector(unsigned(Lwin)+1);
				Lscore <= "0000";
				Rscore <= "0000";
				win_disp <= '1';
			else
				win_disp <= CK_0;
			end if;
			
			
			if(rscore_inc = '1') then
				Lscore <= std_logic_vector(unsigned(Lscore)+1);
			end if;

		end if;
		
		if(rising_edge(CLK)) then
			if(SW_RES = '1') then
				bp <= "00000001";
			end if;
			case PS is 
				when stop => 
					if(serve_side = '0') then
							bp <= "00000001";
					else
							bp <= "10000000";
					end if;	
				when Rserve => 
					bp <= "00000001";
				when Lserve => 
					bp <= "10000000";
				when Rmov =>
					bp <= bp(6 downto 0) & '0';
				when Lmov => 
					bp <= '0' & bp(7 downto 1); 
			
			end case;
		end if;
	end process sync;
	
	comb: process(NS,RPB,LPB,bp)
		variable prev_serve_side: std_logic;
	begin
		tally_inc <= '0';
		rscore_inc <= '0';
		lscore_inc <= '0';
		if(SW_RES = '1') then
			NS <= stop;
			serve_side <= '0';
		end if;
		
		case PS is		
			when stop => 
				prev_serve_side := serve_side;
				if(serve_side = '0') then 
					if(RPB = '0' and LPB = '1' and bp = "00000001") then
						NS <= Rserve;
					else
						NS <= stop;
					end if;
				else
					if(LPB = '0' and RPB = '1' and bp = "10000000") then
						NS <= Lserve;
					else
						NS <= stop;
					end if;
				end if;
				
			when Rserve =>
				if(RPB = '1') then
					NS <= Rmov;
				else
					NS <= Rserve;
				end if;
				
			when Lserve => 
				if(LPB = '1') then
					NS <= Lmov;
				else
					NS <= Lserve;
				end if;
			
			when Rmov => 
				if (LPB = '0' and bp = "10000000") then
					tally_inc <= '1';
					NS <= Lserve;
				elsif ((LPB = '0') or (bp = "00000000")) then
					lscore_inc <= '1';
					serve_side <= not(prev_serve_side);
					NS <= stop;
				else
					NS <= Rmov;
				end if;
			
			when Lmov =>
				if (RPB = '0' and bp = "00000001") then
					tally_inc <= '1';
					NS <= Rserve;
				elsif ((RPB = '0') or (bp = "00000000")) then
					rscore_inc <= '1';
					serve_side <= not(prev_serve_side);
					NS <= stop;
				else 
					NS <= Lmov;
				end if;
			
			when others =>
				NS <= stop;
				serve_side <= '1';
				
		end case;
	
	end process comb;
	
end lab3_arc;

library ieee;
use ieee.std_logic_1164.all;

entity Seg7 is
port (
	A: in std_logic_vector(3 downto 0);
	O: out std_logic_vector(6 downto 0)
);
end Seg7;
architecture Seg7_arc of Seg7 is
begin
with A select
		O <= "1000000" when "0000",-- 0
				"1001111" when "0001",-- 1
				"0100100" when "0010",-- 2
				"0110000" when "0011",-- 3
				"0011001" when "0100",-- 4
				"0010010" when "0101",-- 5
				"0000010" when "0110",-- 6
				"1001100" when "0111",-- 7
				"0000000" when "1000", -- 8
				"0011000" when "1001", -- 9
				"0001000" when "1010", -- A
				"0000011" when "1011", -- b
				"1000110" when "1100", -- C
				"0100001" when "1101", -- d
				"0000110" when "1110", -- E
				"0001110" when "1111", -- F
				"1111111" when others;-- turn off all LEDs
end Seg7_arc;

library ieee;
use ieee.std_logic_1164.all;

entity encoder4x2 is
port (
	A: in std_logic_vector(3 downto 0);
	O: out std_logic_vector(1 downto 0)
);
end encoder4x2;
architecture encoder4x2_arc of encoder4x2 is
begin
with A select
		O <=  "01" when "0010",-- 1
				"10" when "0100",-- 2
				"11" when "1000",-- 3
				"00" when others; -- 0 
end encoder4x2_arc;

library ieee;
use ieee.std_logic_1164.all;

entity win2hex is
port (
	A: in std_logic;
	D0, D1: in std_logic_vector(3 downto 0);
	O0, O1: out std_logic_vector(6 downto 0)
);
end win2hex;
architecture win2hex_arc of win2hex is
	component Seg7
	port (
		A: in std_logic_vector(3 downto 0);
		O: out std_logic_vector(6 downto 0)
	);
	end component;
	signal RScore, LScore: std_logic_vector(6 downto 0);
begin
	Rhex: Seg7
	port MAP(
		A => D0,
		O => RScore
	);
	Lhex: Seg7
	port MAP(
		A => D1,
		O => LScore
	);
with A select
		O0 <= "0101111" when '0',
				"1000111" when '1';
with A select
		O1 <= RScore when '0',
				LScore when '1';
end win2hex_arc;


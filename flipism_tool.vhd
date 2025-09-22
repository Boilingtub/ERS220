library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab2 is 
port (
	RO, RES, LD  : in std_logic;
	SW_state: in std_logic_vector(1 downto 0);
	SW_game: in std_logic_vector(2 downto 0);
	SW_comb: in std_logic;
	SW_lfc: in std_logic;
	LED: out std_logic_vector(9 downto 0);
	Hex5,Hex4,Hex3,Hex2,Hex1,Hex0 : out std_logic_vector(6 downto 0)
);
end lab2;
-- tac = Toss-a-coin , rps = Rock-paper-scissors, rad = roll-a-dice, nog = no-game
architecture lab2_arc of lab2 is
	-- type state_type is (ST_nog,ST_tac,ST_rps,ST_rad);
	-- signal Prev_State,New_State : state_type;
	signal Prev_state, Next_state: std_logic_vector(1 downto 0);
	
	signal RO_LFC: std_logic;
	signal CLK: std_logic;
	signal clk_div: unsigned(24 downto 0);
	
	signal Update: std_logic;
	
	constant ST_nog: std_logic_vector(1 downto 0) := "00";
	constant ST_tac: std_logic_vector(1 downto 0) := "01";
	constant ST_rps: std_logic_vector(1 downto 0) := "10";
	constant ST_rad: std_logic_vector(1 downto 0) := "11";
	constant win : std_logic_vector(6 downto 0) := "0110110";
	constant lose: std_logic_vector(6 downto 0) := "1000111";
	constant heads: std_logic_vector(6 downto 0) := "0001001";
	constant tails: std_logic_vector(6 downto 0) := "0000111";
	constant rock: std_logic_vector(6 downto 0) := "0101111";
	constant paper: std_logic_vector(6 downto 0) := "0001100";
	constant scissor: std_logic_vector(6 downto 0) := "0010010";
	constant fowl: std_logic_vector(6 downto 0) := "0001110";
	
	signal f_Tac: std_logic;
	signal tac_win: std_logic;
	signal Tac_win_Hex: std_logic_vector(6 downto 0);
	signal Tac_hum_Hex: std_logic_vector(6 downto 0);
	signal Tac_cpu_Hex: std_logic_vector(6 downto 0);
	
	signal f_Rps: std_logic_vector(3 downto 0);
	signal rps_win: std_logic;
	signal Rps_tie, Rps_cpu_fowl, Rps_hum_fowl: std_logic;
	signal Rps_win_Hex: std_logic_vector(6 downto 0);
	signal Rps_cpu_Hex: std_logic_vector(6 downto 0);
	signal Rps_hum_Hex: std_logic_vector(6 downto 0);
	
	signal f_Rad: std_logic_vector(6 downto 0);
	signal rad_win: std_logic;
	signal Rad_win_Hex: std_logic_vector(6 downto 0);
	signal Rad_hum_Hex: std_logic_vector(6 downto 0);
	signal Rad_cpu_Hex: std_logic_vector(6 downto 0);
	
	signal LD_Prev_State: std_logic;
	signal LDd : std_logic;
	signal f_win: std_logic;
	signal prev_f_win: std_logic;
	signal score: std_logic_vector(7 downto 0);
	
	signal comb_excl_win: std_logic;

	signal Q,S : std_logic_vector(7 downto 0);

	component soft_debounce is
	port (
		A: in std_logic;
		clk : in std_logic;
		O : out std_logic
	);
	end component;
	
	component fowl_detect
	port (
		A: in std_logic_vector(2 downto 0);
		O: out std_logic
	);
	end component;
	
	component mux3t1
	port (
		A: in std_logic_vector(2 downto 0);
		O: out std_logic
	);
	end component;
	
	component mux1t7
	port (
		D0,D1: in std_logic_vector(6 downto 0);
		A: in std_logic;
		O: out std_logic_vector(6 downto 0)
	);
	end component;
	
	component mux3t7
	port (
		D0,D1,D2,D3,D4,D5,D6,D7: in std_logic_vector(6 downto 0);
		A: in std_logic_vector(2 downto 0);
		O: out std_logic_vector(6 downto 0)
	);
	end component;
	
	component decoder2t4
	port (
		A: in std_logic_vector(1 downto 0);
		O: out std_logic_vector(3 downto 0)
	);
	end component;
	
	component Seg7
	port (
		A: in std_logic_vector(2 downto 0);
		O: out std_logic_vector(6 downto 0)
	);
	end component;
	
	component Seg2F
	port (
		A: in std_logic_vector(7 downto 0);
		O0: out std_logic_vector(6 downto 0);
		O1: out std_logic_vector(6 downto 0)
	);
	end component;
	
begin
	ld_soft_debounce: soft_debounce
	port MAP	(
		A => LD,
		clk => RO,
		O => LDd
	);
	
	tac_mux: mux3t1
	port MAP (
		A => Q(7 downto 5),
		O => f_Tac
	);
	
	tac_win <= not(f_Tac xor SW_game(2));
	tac_win_mux: mux1t7
	port MAP (
		D0 => lose,
		D1 => win,
		A => tac_win, 
		O => Tac_win_Hex
	);	
	
	tac_cpu_mux: mux1t7
	port MAP(
		D0 => tails,
		D1 => heads,
		A => f_Tac,
		O => Tac_cpu_Hex
	);
	
	tac_hum_mux: mux1t7
	port MAP ( 
		D0 => tails,
		D1 => heads,
		A => SW_game(2), 
		O => Tac_hum_Hex
	);	
	
	rps_decoder: decoder2t4
	port MAP (
		A => Q(4 downto 3),
		O => f_Rps
	);
	
	rps_hum_fowl_detect: fowl_detect
	port MAP(
		A => SW_game(2 downto 0),
		O => Rps_hum_fowl
	);
	
	rps_cpu_fowl_detect: fowl_detect
	port MAP(
		A => f_Rps(2 downto 0),
		O => Rps_cpu_fowl
	);
	
	Rps_tie <= 	(f_Rps(2) and SW_game(2) and not(Rps_hum_fowl)) or 
										(f_Rps(1) and SW_game(1) and not(Rps_hum_fowl)) or 
										(f_Rps(0) and SW_game(0) and not(Rps_hum_fowl)) or 
										(Rps_hum_fowl and Rps_cpu_fowl);
	rps_win <= not(Rps_hum_fowl) and (Rps_cpu_fowl or 
					(	
						(f_Rps(2) and SW_game(1)) or
						(f_Rps(1) and SW_game(0)) or
						(f_Rps(0) and SW_game(2))
					)
				);
	
	rps_win_mux: mux1t7
	port MAP(
		D0 => lose,
		D1 => win,
		A =>  rps_win,
		O => Rps_win_Hex
	);

	rps_hum_mux: mux3t7
	port MAP(
		D0 => "1111111",--000
		D1 => scissor,--001
		D2 => paper,--010
		D3 => fowl,--011
		D4 => rock,--100
		D5 => fowl,--101
		D6 => fowl,--110
		D7 => fowl,--111
		A => SW_game(2 downto 0),
		O => Rps_hum_Hex
	);
	
	rps_cpu_mux: mux3t7
	port MAP(
		D0 => "1111111",--000
		D1 => scissor,--001
		D2 => paper,--010
		D3 => fowl,--011
		D4 => rock,--100
		D5 => fowl,--101
		D6 => fowl,--110
		D7 => fowl,--111
		A => f_Rps(2 downto 0),
		O => Rps_cpu_Hex
	);
	
	rad_win <= (
			not(Rad_hum_Hex(0) xor Rad_cpu_Hex(0)) and
			not(Rad_hum_Hex(1) xor Rad_cpu_Hex(1)) and
			not(Rad_hum_Hex(2) xor Rad_cpu_Hex(2)) and
			not(Rad_hum_Hex(3) xor Rad_cpu_Hex(3)) and
			not(Rad_hum_Hex(4) xor Rad_cpu_Hex(4)) and
			not(Rad_hum_Hex(5) xor Rad_cpu_Hex(5)) and
			not(Rad_hum_Hex(6) xor Rad_cpu_Hex(6))
		);
	rad_win_mux: mux1t7
	port MAP(
		D0 => lose,
		D1 => win,
		A => rad_win,
		O => Rad_win_Hex
	);
	
	rad_hum_mux: Seg7
	port MAP(
		A => SW_game(2 downto 0),
		O => Rad_hum_Hex
	);
	
	rad_cpu_mux: Seg7
	port Map(
		A => Q(2 downto 0),
		O => Rad_cpu_Hex
	);
	
	score_seg2F: Seg2F
	port MAP(
		A => score,
		O0 => Hex0,
		O1 => Hex1
	);
				 
	lfc: process(RO)
	begin
		if(rising_edge(RO)) then
			clk_div <= clk_div + 1;
		end if;
	end process lfc;
	RO_LFC <= clk_div(24);
	LED(0) <= CLK;
	
	with SW_lfc select
	CLK <= RO when '0',
			RO_LFC when '1',
			RO when others;
	
	sync: process(CLK,RES)
	begin	
		if (RES = '1') then
			LED(9 downto 1) <= "000000000";
			Hex5 <= "1111111";
			Hex4 <= "1111111";
			Hex3 <= "1111111";
			Hex2 <= "1111111";
			Prev_State <= ST_nog;
			S <= "11111111";
			score <= "00000000";
		elsif (rising_edge(CLK)) then
				Prev_state <= Next_state;
				S <= S(6 downto 0) & ( S(5) xor S(4) );				
				if(LDd = '0' and  LD_Prev_State = '1') then
					-- LED <= '0' & '0' & Q(7 downto 0);
					if(SW_comb = '0') then
						case Prev_state is
							when ST_tac => 
								LED(9) <= f_Tac;
								Hex5 <= Tac_hum_Hex;
								Hex4 <= Tac_cpu_Hex;
								Hex3 <= Tac_win_Hex;		
							
							when ST_rps =>
								LED(9 downto 7) <= f_Rps(2 downto 0);
								Hex5 <= Rps_hum_Hex;
								Hex4 <= Rps_cpu_Hex;
								if(Rps_tie = '0') then
									Hex3 <= Rps_win_Hex;
								else
									Hex3 <= tails; -- means "tie" (same symbol as tails)
								end if;
								
							when ST_rad =>
								Hex5 <= Rad_hum_Hex;
								Hex4 <= Rad_cpu_Hex;
								Hex3 <= Rad_win_Hex;
								
							when others =>	
						end case;
						
						if (f_win = '1') then
							score <= std_logic_vector(unsigned(score)+1);
						end if;
						
					else
						LED(6) <= f_Tac;
						LED(9 downto 7) <= f_Rps(2 downto 0);
						Hex5 <= Rad_cpu_Hex;
						if(comb_excl_win = '1') then
							Hex3 <= win;
						else
							Hex3 <= lose;
						end if;	
					end if;
				end if;
				LD_Prev_State <= LDd;
				prev_f_win <= f_win;
		end if;	
	end process sync;

	comb: process(RES, Prev_state, Next_state)
	begin				
		if( RES = '1') then
			Next_state <= ST_nog;
		elsif (SW_comb = '0') then
			case Prev_State is
				when ST_nog =>
					f_win <= '0';
					Update <= '0';
					if (LDd = '1' and LD_Prev_State = '0') then
						Q <= S;
						Next_state <= SW_state;
					else
						Next_state <= ST_nog;
					end if;
					
				when ST_tac =>
					if(LDd = '0' and LD_Prev_State = '1') then
						Update <= '1';
						f_win <= tac_win;
						Next_state <= ST_nog;
					else 
						f_win <= '0';
						Update <= '0';
						Next_state <= ST_tac;
					end if;
								
				when ST_rps => 
					if(LDd = '0'and LD_Prev_State = '1') then
						Update <= '1';
						f_win <= rps_win;
						Next_state <= ST_nog;
					else
						f_win <= '0';
						Update <= '0';
						Next_state <= ST_rps;
					end if;
					
				when ST_rad => 
					if (LDd = '0' and LD_Prev_State = '1') then
						Update <= '1';
						f_win <= rad_win;
						Next_state <= ST_nog;
					else
						f_win <= '0';
						Update <= '0';
						Next_state <= ST_rad;
					end if;
						
				when others => 
					Next_state <= ST_nog;
			end case;
		else
			if(LDd = '0' and LD_Prev_State = '1') then
				Q <= S;
				comb_excl_win <= (f_Tac and Rps_Tie) or (f_Tac and rps_win and not(Rps_Tie));
			end if;
		end if;
	end process comb;
	
end lab2_arc;

library ieee;
use ieee.std_logic_1164.all;

entity fowl_detect is
port (
	A: in std_logic_vector(2 downto 0);
	O: out std_logic
);
end fowl_detect;
architecture fowl_detect_arc of fowl_detect is
begin
	O <= (A(0) and A(1)) or
		  (A(0) and A(2)) or
		  (A(1) and A(2)) or
		  (not(A(0)) and not(A(1)) and not(A(2)));
end fowl_detect_arc;

library ieee;
use ieee.std_logic_1164.all;

entity mux1t7 is
port (
	D0,D1: in std_logic_vector(6 downto 0);
	A: in std_logic;
	O: out std_logic_vector(6 downto 0)
);
end mux1t7;
architecture mux1t7_arc of mux1t7 is
begin
	with A select
		O <= D0 when '0',
			  D1 when '1',
			  "1111111" when others;
end mux1t7_arc;

library ieee;
use ieee.std_logic_1164.all;

entity mux3t7 is
port (
	D0,D1,D2,D3,D4,D5,D6,D7: in std_logic_vector(6 downto 0);
	A: in std_logic_vector(2 downto 0);
	O: out std_logic_vector(6 downto 0)
);
end mux3t7;
architecture mux3t7_arc of mux3t7 is
begin
	with A select
		O <= D0 when "000",
			  D1 when "001",
			  D2 when "010",
			  D3 when "011",
			  D4 when "100",
			  D5 when "101",
			  D6 when "110",
			  D7 when "111",
			  "1111111" when others;
end mux3t7_arc;


library ieee;
use ieee.std_logic_1164.all;

entity mux3t1 is
port (
	
	A: in std_logic_vector(2 downto 0);
	O: out std_logic
);
end mux3t1;
architecture mux3t1_arc of mux3t1 is
begin
	with A select
		O <= '1' when "001",
			  '1' when "011",
			  '1' when "101",
			  '1' when "111",
			  '0' when others;
end mux3t1_arc;



library ieee;
use ieee.std_logic_1164.all;

entity decoder2t4 is
port (
	A: in std_logic_vector(1 downto 0);
	O: out std_logic_vector(3 downto 0)
);
end decoder2t4;
architecture decoder2t4_arc of decoder2t4 is
begin
	with A select
		O <= "0001" when "00",
			  "0010" when "01",
			  "0100" when "10",
			  "1000" when "11",
			  "0000" when others;
end decoder2t4_arc;


library ieee;
use ieee.std_logic_1164.all;

entity Seg7 is
port (
	A: in std_logic_vector(2 downto 0);
	O: out std_logic_vector(6 downto 0)
);
end Seg7;
architecture Seg7_arc of Seg7 is
begin
	with A select
		O <=  "1000000" when "000",-- 0
				"1001111" when "001",-- 1
				"0100100" when "010",-- 2
				"0110000" when "011",-- 3
				"0011001" when "100",-- 4
				"0010010" when "101",-- 5
				"0000010" when "110",-- 6
				"1001100" when "111",-- 7
				"1111111" when others;-- turn off all LEDs
end Seg7_arc;

library ieee;
use ieee.std_logic_1164.all;

entity Seg2F is
port (
	A: in std_logic_vector(7 downto 0);
	O0,O1: out std_logic_vector(6 downto 0)
);
end Seg2F;
architecture Seg2F_arc of Seg2F is
signal A0,A1: std_logic_vector(3 downto 0);
begin
	A0 <= A(3 downto 0);
	A1 <= A(7 downto 4);
	with A0 select
		O0 <= "1000000" when "0000",-- 0
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
	with A1 select
		O1 <= "1000000" when "0000",-- 0
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
end Seg2F_arc;


library ieee;
use ieee.std_logic_1164.all;

entity soft_debounce is
port (
	A: in std_logic;
	clk : in std_logic;
	O : out std_logic);
end soft_debounce;
architecture soft_debounce_arc of soft_debounce is
signal O1, O2, O3: std_logic;
begin
	process(CLK)
		begin
			if (rising_edge(CLK)) then
				O1 <= A;
				O2 <= O1;
				O3 <= O2;
			end if;
end process;
O <= O1 and O2 and O3;
end soft_debounce_arc;
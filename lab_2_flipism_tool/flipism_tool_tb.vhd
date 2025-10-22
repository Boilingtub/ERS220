library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipism_tool_tb is
end flipism_tool_tb;

architecture flipism_tool_tb_arc of flipism_tool_tb is
	component flipism_tool
		port (
			RO, RES, LD  : in std_logic;
			SW_state: in std_logic_vector(1 downto 0);
			SW_game: in std_logic_vector(2 downto 0);
			SW_bo3: in std_logic;
			LED: out std_logic_vector(9 downto 0);
			Hex5,Hex4,Hex3,Hex2,Hex1,Hex0 : out std_logic_vector(6 downto 0)
		);
	end component;

	component decoder2t4
	port (
		A: in std_logic_vector(1 downto 0);
		O: out std_logic_vector(3 downto 0)
	);
	end component;

	component mux3t1
	port (
		A: in std_logic_vector(2 downto 0);
		O: out std_logic
	);
	end component;

	component Seg7
	port (
		A: in std_logic_vector(2 downto 0);
		O: out std_logic_vector(6 downto 0)
	);
	end component;

	component fowl_detect
	port (
		A: in std_logic_vector(2 downto 0);
		O: out std_logic
	);
	end component;

	signal RO,RES,LD : std_logic;
	signal SW_state: std_logic_vector(1 downto 0);
	signal SW_game: std_logic_vector(2 downto 0);
	signal SW_bo3: std_logic;
	signal LED: std_logic_vector(9 downto 0);
	signal Hex5,Hex4,Hex3,Hex2,Hex1,Hex0: std_logic_vector(6 downto 0);
	signal Q : std_logic_vector(7 downto 0);

	signal tac_win, Rps_tie, rps_win, rad_win, Rps_hum_fowl, Rps_cpu_fowl: std_logic;
	signal f_Tac: std_logic;
	signal f_Rps: std_logic_vector(3 downto 0);
	signal Rad_hum_Hex, Rad_cpu_Hex: std_logic_vector(6 downto 0); 
	


begin
	tac_mux: mux3t1
	port MAP (
		A => Q(7 downto 5),
		O => f_Tac
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
	

	tac_win <= not(f_Tac xor SW_game(2));
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

	rad_win <= (
		not(Rad_hum_Hex(0) xor Rad_cpu_Hex(0)) and
		not(Rad_hum_Hex(1) xor Rad_cpu_Hex(1)) and
		not(Rad_hum_Hex(2) xor Rad_cpu_Hex(2)) and
		not(Rad_hum_Hex(3) xor Rad_cpu_Hex(3)) and
		not(Rad_hum_Hex(4) xor Rad_cpu_Hex(4)) and
		not(Rad_hum_Hex(5) xor Rad_cpu_Hex(5)) and
		not(Rad_hum_Hex(6) xor Rad_cpu_Hex(6))
	);

	dut: flipism_tool
	port map (
		RO => RO,
		RES => RES,
		LD => LD,
		SW_state => SW_state,
		SW_game => SW_game,
		SW_bo3 => SW_bo3,
		LED => LED,
		Hex5 => Hex5,
		Hex4 => Hex4,
		Hex3 => Hex3,
		Hex2 => Hex2,
    	Hex1 => Hex1,
		Hex0 => Hex0
	);

	process
    variable  v_RO: std_logic_vector(0 downto 0);
	begin
    v_RO := "0";
    for repeat in 1 to 2400
      loop
        RO <= v_RO(0);
        wait for 1 ns;
        v_RO := std_logic_vector(unsigned(v_RO)+1);
      end loop;
    wait;
	end process;

	process
    variable  v_RES: std_logic_vector(0 downto 0);
	begin
    v_RES := "0";
    for repeat in 1 to 4
      loop
        RES <= v_RES(0);
        wait for 500 ns;
        v_RES := std_logic_vector(unsigned(v_RES)+1);
      end loop;
    wait;
	end process;

  process 
    variable v_LD: std_logic_vector(0 downto 0);
	variable v_Q: std_logic_vector(7 downto 0);
  begin
    v_LD := "0";
	v_Q := "00000000";
    for repeat in 1 to 400
      loop 
        LD <= v_LD(0);
		Q <= v_Q;
        wait for 5 ns;
        v_LD := std_logic_vector(unsigned(v_LD)+1);
		v_Q := std_logic_vector(unsigned(v_Q)+1);
      end loop;
      wait;
  end process;

  process 
    variable v_SW_state: std_logic_vector(1 downto 0);
  begin
    v_SW_state := "00";
    for repeat in 1 to 25 
      loop 
        SW_state <= v_SW_state(1 downto 0);
        wait for 80 ns;
        v_SW_state := std_logic_vector(unsigned(v_SW_state)+1);
      end loop;
      wait;
  end process;

  process 
    variable v_SW_game: std_logic_vector(2 downto 0);
  begin
    v_SW_game := "000";
    for repeat in 1 to 200
      loop 
        SW_game <= v_SW_game(2 downto 0);
        wait for 10 ns;
        v_SW_game := std_logic_vector(unsigned(v_SW_game)+1);
      end loop;
      wait;
  end process;

  process 
    variable v_SW_bo3: std_logic_vector(0 downto 0);
  begin
    v_SW_bo3 := "0";
    for repeat in 1 to 2
      loop 
        SW_bo3 <= v_SW_bo3(0);
        wait for 2000 ns;
        v_SW_bo3 := std_logic_vector(unsigned(v_SW_bo3)+1);
      end loop;
      wait;
  end process;

end flipism_tool_tb_arc;

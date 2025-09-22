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

	signal RO,RES,LD : std_logic;
	signal SW_state: std_logic_vector(1 downto 0);
	signal SW_game: std_logic_vector(2 downto 0);
	signal SW_bo3: std_logic;
	signal LED: std_logic_vector(9 downto 0);
	signal Hex5,Hex4,Hex3,Hex2,Hex1,Hex0: std_logic_vector(6 downto 0);


begin
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
    for repeat in 1 to 2000
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
  begin
    v_LD := "0";
    for repeat in 1 to 400
      loop 
        LD <= v_LD(0);
        wait for 5 ns;
        v_LD := std_logic_vector(unsigned(v_LD)+1);
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

end flipism_tool_tb_arc;

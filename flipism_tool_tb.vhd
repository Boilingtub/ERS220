library ieee;
use ieee.std_logic_1164.all;

entity flipism_tool_tb is
end flipism_tool_tb;

architecture flipism_tool_tb_arc of flipism_tool_tb is
	component flipism_tool
		port (
			RO, RES, LD : in std_logic;
			Tac, Rck, Ppr, Scr, Lose: out std_logic;
			Rad : out std_logic_vector(6 downto 0)
		);
	end component;

	signal RO,RES,LD,Tac,Rck,Ppr,Scr,Lose : std_logic;
	signal Rad: std_logic_vector(6 downto 0);

begin
	dut: flipism_tool
	port map (
		RO => RO,
		RES => RES,
		LD => LD,
		Tac => Tac,
		Rck => Rck,
		Ppr => Ppr,
		Scr => Scr,
		Lose => Lose,
		Rad => Rad
	);

	process
	begin
		
	end process;
end flipism_tool_tb_arc;
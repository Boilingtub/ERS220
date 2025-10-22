library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3_comb_tb is
end lab3_comb_tb;

architecture lab3_comb_tb_arc of lab3_comb_tb is
signal sS,sN   :  std_logic_vector(2 downto 0);
signal sLPB,sRPB,sD,sDn : std_logic;

component lab3_comb
port (
	S : in std_logic_vector(2 downto 0);
	N : out std_logic_vector(2 downto 0);
	LPB,RPB,D : in std_logic;
	Dn : out std_logic
);
end component;

begin

	dut: lab3_comb
	port map (
		S => sS,
		N => sN,
		LPB => sLPB,
		RPB => sRPB,
		D => sD,
		Dn => sDn
	);

process 
variable varW : std_logic_vector(5 downto 0);
begin
varW := "000000";
for repeat in 1 to 64
	loop 
		sS <= varW(5 downto 3);
		sD <= varW(2);
		sLPB <= varW(1);
		sRPB <= varW(0);
		wait for 1 ns;
		varW := std_logic_vector(unsigned(varW) + 1);
	end loop;
	wait;
end process;

end lab3_comb_tb_arc;
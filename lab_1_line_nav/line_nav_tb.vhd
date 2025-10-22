library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity line_nav_tb is
end line_nav_tb;

architecture line_nav_tb_arch of line_nav_tb is
signal 	W   :  std_logic;
signal	X   :  std_logic;
signal 	Y   :  std_logic;
signal 	Z   :  std_logic;
signal  S   :  std_logic;
signal  Tl  :  std_logic;
signal  Tr  :  std_logic;
signal  C   :  std_logic;
signal  St  :  std_logic;
signal  F   :  std_logic;

component line_nav 
port (
	W, X, Y, Z: in std_logic;
	S, Tl, Tr, C, St, F : out std_logic
);
end component;

begin
	dut: line_nav
	port map (
		W => W,
		X => X,
		Y => Y,
		Z => Z,
		S => S,
		Tl => Tl,
		Tr => Tr,
		C => C,
		St => St,
		F => F
	);

process
variable varW : std_logic_vector(0 downto 0);
begin
varW := "0";
for repeat in 1 to 2
	loop 
		W <= varW(0);
		wait for 800 ns;
		varW := std_logic_vector(unsigned(varW) + 1);
	end loop;
	wait;
end process;

process
variable varX : std_logic_vector(0 downto 0);
begin
varX := "0";
for repeat in 1 to 4
	loop 
		X <= varX(0);
		wait for 400 ns;
		varX := std_logic_vector(unsigned(varX) + 1);
	end loop;
	wait;
end process;

process
variable varY : std_logic_vector(0 downto 0);
begin
varY := "0";
for repeat in 1 to 8
	loop 
		Y <= varY(0);
		wait for 200 ns;
		varY := std_logic_vector(unsigned(varY) + 1);
	end loop;
	wait;
end process;

process
variable varZ : std_logic_vector(0 downto 0);
begin
varZ := "0";
for repeat in 1 to 16
	loop 
		Z <= varZ(0);
		wait for 100 ns;
		varZ := std_logic_vector(unsigned(varZ) + 1);
	end loop;
	wait;
end process;

end line_nav_tb_arch;

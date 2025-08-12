library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity line_nav is
port (
	s1, s2, s3, s4 : in std_logic;
	S, Tl, Tr, C, St, F : out std_logic
);
end line_nav;

architecture line_nav_arch of line_nav is
begin
	S <= not(s2 and s3);
	Tl <= not((s1 or s2) and not(s3) and not(s4));
	Tr <= not((s3 or s4) and not(s1) and not(s2));
	St <= not(not(s1 or s2 or s3 or s4) or (not(s3) and s4 and (s2 or s1)) or (s1 and not(s2) and s3));
	F <= not((s1 and s3 and not(s4)) or (s4 and(s1 xor s2)) or (s2 and not(s3) and s4));
	C <= not(s1 and s2 and s3 and s4);
end line_nav_arch;

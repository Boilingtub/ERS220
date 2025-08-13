library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity line_nav is
port (
	W : in std_logic; -- s1
	X : in std_logic; -- s2
	Y : in std_logic;-- s3
	Z : in std_logic; -- s4
	S, Tl, Tr, C, St, F : out std_logic
);
end line_nav;

architecture line_nav_arch of line_nav is
begin
	S <= not( X and Y );
	Tl <= not( (W or X) and not(Y) and not(Z) );
	Tr <= not( (Y or Z) and not(W) and not(X) );
	St <= not( not(W or X or Y or Z) or ( not(Y) and Z and (W or X)) or (W and not(X) and Y) );
	F <= not( (W and Y and not(Z)) or (Z and (W xor X) ) or (X and not(Y) and Z) );
	C <= not( W and X and Y and Z );
end line_nav_arch;

-- Pin Layout:
-- C .... PIN_C17
-- F .... PIN_D15
-- S .... PIN_C14
-- St ... PIN_C16
-- Tl ... PIN_D17
-- Tr ... PIN_E15
-- W .... PIN_C12
-- X .... PIN_D12
-- Y .... PIN_C11
-- Z .... PIN_C10